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
$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
foreach ($secteurs as $secteur) {
  require_once ('groupe_'.$secteur['sec_code'].'.class.php');
}
class Groupe {
  var $disabled = false;
  function display ($v) {}

  function displayInfoChoix ($secteur, $parite, $grp) {
    global $base;
    $eta = $base->etablissement_get ($_SESSION['token'], $_SESSION['eta_id']);
    $infs = $base->meta_info_liste_champs_par_secteur_categorie ($_SESSION['token'], $eta['cat_id'], $secteur); 
    $gis = $base->groupe_info_secteur_get ($_SESSION['token'], $grp['grp_id'], $secteur);    
    $val = $gis[0]['inf_id'];
    echo '<tr class="tr_ed_secteur tr_ed_secteur_'.$secteur.' '.$parite.'">';
    echo '<td>Champ d\'affectation associé</td><td><select name="ed_'.$secteur.'_champ"'.($this->disabled ? ' disabled' : '').'><option value=""></option>';
    foreach ($infs as $inf) {
      $selected = $val == $inf['inf_id'] ? ' selected' : '';
      echo '<option value="'.$inf['inf_id'].'"'.$selected.'>'.$inf['inf_libelle'].'</option>';
    }
    echo '</select>';
    echo '</td>';
    echo '</tr>';
  }

  function champs () { return array (); }
  function update ($grp_id, $v) {}

  function setDisabled () { $this->disabled = true; }

  function displayContactEdition ($secteur, $v) {
    global $base;
    echo '<td>Contact</td>';
    echo '<td><select name="ed_'.$secteur.'_contact"'.($this->disabled ? ' disabled' : '').'>';
    $contacts = $base->personne_contact_liste ($_SESSION['token'], NULL, $secteur, $v['eta_id']);
    echo '<option value="">Sélectionner un contact</option>';
    if (count ($contacts)) {
      foreach ($contacts as $contact) {
	$selected = ($contact['per_id'] == $v['grp_'.$secteur.'_contact']) ? ' selected' : '';
	echo '<option value="'.$contact['per_id'].'"'.$selected.'>'.$contact['libelle'].'</option>';
      }
    }
    echo '</select></td>';

  }

  function displayTypeEdition ($secteur, $v) {
    global $base;
    $types = $base->meta_secteur_type_liste_par_code ($_SESSION['token'], $secteur);
    echo '<td>Public concerné</td>';
    echo '<td><select name="ed_'.$secteur.'_type"'.($this->disabled ? ' disabled' : '').'>';
    echo '<option value="">Sélectionner un public concerné</option>';
    if (count ($types)) {
      foreach ($types as $type) {
	$selected = ($type['set_id'] == $v['grp_'.$secteur.'_type']) ? ' selected' : '';
	echo '<option value="'.$type['set_id'].'"'.$selected.'>'.$type['set_nom'].'</option>';
      }
    }
    echo '</select></td>';
  }
}
?>
