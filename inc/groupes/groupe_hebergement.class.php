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
class GroupeHebergement extends Groupe {

  public function display ($v) {
    global $base;
    echo '<tr class="tr_ed_secteur tr_ed_secteur_hebergement impair">';
    echo '<td>Adresse</td>';
    echo '<td><input type="text" size="30" name="ed_hebergement_adresse" value="'.$v['grp_hebergement_adresse'].'"'.($this->disabled ? ' disabled' : '').'></input>';
    echo '</tr>';
    echo '<tr class="tr_ed_secteur tr_ed_secteur_hebergement pair">';
    echo '<td>CP / Ville</td>';
    echo '<td><input type="text" size="5" name="ed_hebergement_cp" value="'.$v['grp_hebergement_cp'].'"'.($this->disabled ? ' disabled' : '').'></input> <input type="text" size="23" name="ed_hebergement_ville" value="'.$v['grp_hebergement_ville'].'"'.($this->disabled ? ' disabled' : '').'></input>';
    echo '</tr>';

    echo '<tr class="tr_ed_secteur tr_ed_secteur_hebergement impair">';
    $this->displayContactEdition ('hebergement', $v);
    echo '</tr>';

    echo '<tr class="tr_ed_secteur tr_ed_secteur_hebergement pair">';
    $this->displayTypeEdition ('hebergement', $v);
    echo '</tr>';

    $this->displayInfoChoix ('hebergement', 'impair', $v);
  }

  public function champs () {
    return array ('grp_hebergement_adresse' => 'ed_hebergement_adresse', 
		  'grp_hebergement_cp'      => 'ed_hebergement_cp', 
		  'grp_hebergement_ville'   => 'ed_hebergement_ville',
		  'grp_hebergement_contact'   => 'ed_hebergement_contact',
		  'grp_hebergement_type'   => 'ed_hebergement_type'
		  );
  }

  public function update ($grp_id, $v) {
    global $base;
    $base->groupe_hebergement_update ($_SESSION['token'], $grp_id, 
				      $v['ed_hebergement_adresse'], 
				      $v['ed_hebergement_cp'], 
				      $v['ed_hebergement_ville'], 
				      $v['ed_hebergement_contact'],
				      $v['ed_hebergement_type']
				      );
    $base->groupe_info_secteur_save ($_SESSION['token'], $grp_id, 'hebergement', $v['ed_hebergement_champ']);
  }
}
