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
class GroupePrise_en_charge extends Groupe {
  public function display ($v) {
    global $base;
    echo '<tr class="tr_ed_secteur tr_ed_secteur_prise_en_charge impair">';
    $this->displayContactEdition ('prise_en_charge', $v);
    echo '</tr>';

    echo '<tr class="tr_ed_secteur tr_ed_secteur_prise_en_charge pair">';
    $this->displayTypeEdition ('prise_en_charge', $v);
    echo '</tr>';

    $this->displayInfoChoix ('prise_en_charge', 'impair', $v);
  }

  public function champs () {
    return array ('grp_prise_en_charge_contact' => 'ed_prise_en_charge_contact',
		  'grp_prise_en_charge_type' => 'ed_prise_en_charge_type'
		  );

  }

  public function update ($grp_id, $v) {
    global $base;
    $base->groupe_prise_en_charge_update ($_SESSION['token'], $grp_id, 
					  $v['ed_prise_en_charge_contact'],
					  $v['ed_prise_en_charge_type']
					  );
    $base->groupe_info_secteur_save ($_SESSION['token'], $grp_id, 'prise_en_charge', $v['ed_prise_en_charge_champ']);
  }  
}
