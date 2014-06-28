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
 * Pour un utilisateur connecté, contient soit 
 *  - la liste des portails si l'utilisateur a accès à plusieurs portails, soit
 *  - la liste des menus contenant au moins une liste de personnes d'un certain type (usager, personnel, etc)
 */
class ListesPersonnes extends DAV\Collection {
  private $auth;
  private $children;

  function __construct($auth, $base, $ent_code) {
    $this->auth = $auth;
    $this->children = NULL;
    $this->base = $base;
    $this->ent_code = $ent_code;
  }

  function getChildren() {
    if ($this->children === NULL) {
      $this->children = array ();
      $por_ids = $this->base->utilisateur_portail_liste ($this->auth->getCurrentUser ());
      if (count ($por_ids) == 1) {
	$toms = $this->base->meta_topmenu_liste_contenant_type ($this->auth->token, $por_ids[0], $this->ent_code);
	foreach ($toms as $tom) {
	  $this->children[] = new ListesPersonnesTOM ($this->auth, $this->base, $tom['tom_id'], $this->ent_code);
	}
      } else {
	foreach ($por_ids as $por_id) {
	  $this->children[] = new ListesPersonnesPOR ($this->auth, $this->base, $por_id, $this->ent_code);
	}
      }
    }
    return $this->children;
  }

  function getName() {
    return "Listes d'usagers";
  }
}

?>
