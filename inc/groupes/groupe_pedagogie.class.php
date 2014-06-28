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
class GroupePedagogie extends Groupe {
  public function display ($v) {
    global $base;
    /*
    echo '<tr class="tr_ed_secteur tr_ed_secteur_pedagogie impair">';
    echo '<td>Type</td>';
    echo '<td><select name="ed_pedagogie_type"'.($this->disabled ? ' disabled' : '').'>';
    $sel = $base->meta_selection_infos_par_code ('formation_type');
    $types = $base->meta_selection_entree_liste_par_code ('formation_type');
    echo '<option value="">'.$sel['sel_info'].'</option>';
    foreach ($types as $type) {
      $selected = ($type['sen_id'] == $v['grp_pedagogie_type']) ? ' selected' : '';
      echo '<option value="'.$type['sen_id'].'"'.$selected.'>'.$type['sen_libelle'].'</option>';
    }
    echo '</select></td>';
    echo '</tr>';
    */
    echo '<tr class="tr_ed_secteur tr_ed_secteur_pedagogie pair">';
    echo '<td>Niveau</td>';
    echo '<td><select name="ed_pedagogie_niveau"'.($this->disabled ? ' disabled' : '').'>';
    $sel = $base->meta_selection_infos_par_code ($_SESSION['token'], 'formation_niveau');
    $types = $base->meta_selection_entree_liste_par_code ($_SESSION['token'], 'formation_niveau');
    echo '<option value="">'.$sel['sel_info'].'</option>';
    foreach ($types as $type) {
      $selected = ($type['sen_id'] == $v['grp_pedagogie_niveau']) ? ' selected' : '';
      echo '<option value="'.$type['sen_id'].'"'.$selected.'>'.$type['sen_libelle'].'</option>';
    }
    echo '</select></td>';
    echo '</tr>';

    echo '<tr class="tr_ed_secteur tr_ed_secteur_pedagogie pair">';
    $this->displayContactEdition ('pedagogie', $v);
    echo '</tr>';

    echo '<tr class="tr_ed_secteur tr_ed_secteur_pedagogie impair">';
    $this->displayTypeEdition ('pedagogie', $v);
    echo '</tr>';

    $this->displayInfoChoix ('pedagogie', 'pair', $v);
  }

  public function champs () {
    return array ('grp_pedagogie_type' => 'ed_pedagogie_type',
		  'grp_pedagogie_niveau' => 'ed_pedagogie_niveau',
		  'grp_pedagogie_contact' => 'ed_pedagogie_contact',
		  );
  }

  public function update ($grp_id, $v) {
    global $base;
    $base->groupe_pedagogie_update ($_SESSION['token'], $grp_id, 
				    $v['ed_pedagogie_type'], 
				    $v['ed_pedagogie_niveau'], 
				    $v['ed_pedagogie_contact']);
    $base->groupe_info_secteur_save ($_SESSION['token'], $grp_id, 'pedagogie', $v['ed_pedagogie_champ']);
  }
}
