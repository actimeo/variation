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

/**
 * 
 */
class ListesPersonnesTSM extends Dav\Collection {
  private $auth;
  private $base;
  private $tsmid;
  private $name;
  private $contents;

  function __construct ($auth, $base, $tsmid) {
    $this->base = $base;
    $this->auth = $auth;
    $this->tsmid = $tsmid;
    $this->children = NULL;
    $this->tsm = $this->base->meta_topsousmenu_get ($this->auth->token, $tsmid);
    if ($this->tsm['tsm_id']) {
      $this->name = $this->tsm['tsm_libelle'];
    } else {
      $this->name = 'Inconnu'.$tsmid;
    }
  }

  function getChildren () {
    //    $this->children[] = new ListesPersonnesTSMexportDebug ($this->auth, $this->base, $this->tsm['tsm_id']);
    $this->children[] = new ListesPersonnesTSMexportExcel1 ($this->auth, $this->base, $this->tsm['tsm_id']);
    return $this->children;
  }

  function getName () {
    return $this->name;
  }
}
?>
