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
 * Contient la liste des menus d'un portail contenant au moins une liste de personnes 
 */
class EventsPersonnesPOR extends Dav\Collection {
  private $porid;
  private $name;
  private $children;
  private $auth;
  private $base;

  function __construct ($auth, $base, $porid) {
    $this->auth = $auth;
    $this->base = $base;
    $this->porid = $porid;
    $this->children = NULL;
    $por = $this->base->meta_portail_infos ($this->auth->token, $porid);
    if ($por['por_id']) {
      $this->name = $por['por_libelle'];
    } else {
      $this->name = 'Inconnu'.$porid;
    }
  }

  function getChildren () {
    if ($this->children === NULL) {
      $toms = $this->base->meta_topmenu_events ($this->auth->token, $this->porid);
      $this->children = array ();
      foreach ($toms as $tom) {
	$this->children[] = new EventsPersonnesTOM ($this->auth, $this->base, $tom['tom_id']);
      }
    }
    return $this->children;
  }

  function getName () {
    return $this->name;
  }
}

?>
