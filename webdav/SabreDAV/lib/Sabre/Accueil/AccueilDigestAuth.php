<?php
/*
This file is part of Variation.

Variation is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Variation is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Variation.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
Ce fichier fait partie de Variation.

Variation est un logiciel libre ; vous pouvez le redistribuer ou le modifier 
suivant les termes de la GNU Affero General Public License telle que publiée 
par la Free Software Foundation ; soit la version 3 de la licence, soit 
(à votre gré) toute version ultérieure.

Variation est distribué dans l'espoir qu'il sera utile, 
mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de 
QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la 
GNU Affero General Public License pour plus de détails.

Vous devez avoir reçu une copie de la GNU Affero General Public License 
en même temps que Variation ; si ce n'est pas le cas, 
consultez <http://www.gnu.org/licenses>.
--------------------------------------------------------------------------------
Copyright (c) 2014 Kavarna SARL
*/
?>
<?php

namespace Sabre\Accueil;
use Sabre\DAV;
use Sabre\HTTP;

class AccueilDigestAuth extends Dav\Auth\Backend\AbstractDigest {
  public $token;
  private $base;
  //  private $token;
  function __construct ($base) {
    $this->base = $base;
  }
  
  public function getDigestHash ($realm, $username) {
    return $this->base->utilisateur_get_digest_hash ($username);
  }  
  
  public function authenticate (DAV\Server $server, $realm) {
    $digest = new HTTP\DigestAuth();

    // Hooking up request and response objects
    $digest->setHTTPRequest($server->httpRequest);
    $digest->setHTTPResponse($server->httpResponse);

    $digest->setRealm($realm);
    $digest->init();

    $username = $digest->getUsername();

        // No username was given
    if (!$username) {
      $digest->requireLogin();
      throw new DAV\Exception\NotAuthenticated('No digest authentication headers were found');
    }

    $hash = $this->getDigestHash($realm, $username);

    $ret = $digest->getValidationString (); // Attention, rajouter cette fonction dans HTTP\DigestAuth
    $str = $ret['part'];
    $result = $this->base->utilisateur_login_digest ($username, $str, $ret['response']);
    /*    if (md5($hash.":".$str) == $ret['response']) {*/
    if ($result) {
      $this->token = $result;
      global $_SESSION;
      $_SESSION['token'] = $this->token;
      $this->currentUser = $username;
      return true;
    } else {
      $digest->requireLogin();
      throw new DAV\Exception\NotAuthenticated('Incorrect username');
    }
  }
}

?>