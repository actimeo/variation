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
$ents = $base->meta_entite_liste ($_SESSION['token']);

function liste_portails () {
  global $base;
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  foreach ($cats as $cat) {
    echo '<optgroup label="'.$cat['cat_nom'].'">';
    $pors = $base->meta_portail_liste ($_SESSION['token'], $cat['cat_id']);
    foreach ($pors as $por) {
      $selected = $_REQUEST['por'] == $por['por_id'] ? ' selected' : '';
      echo '<option value="'.$por['por_id'].'"'.$selected.'>'.$por['por_libelle'].'</option>';
    }
    echo '</optgroup>';
  }
}

function liste_droits () {
  global $base, $ents;
  if (!isset ($_REQUEST['por']) || !$_REQUEST['por'])
    return;
  echo '<div style="text-align: right"><input type="submit" name="enreg" value="Enregistrer"></input></div>';
  $portail = $base->meta_portail_infos ($_SESSION['token'], $_REQUEST['por']);
  $dajs = $base->droit_ajout_entite_portail_liste_par_portail ($_SESSION['token'], $portail['por_id']);
  foreach ($dajs as $daj) {
    $portail['por_droit_ajout_'.$daj['ent_code']] = $daj['daj_droit'];
  }
  foreach ($ents as $ent) {
    echo '<span style="margin-right: 20px"><input type="checkbox" name="droit_ajout_'.$ent['ent_code'].'" id="droit_ajout_'.$ent['ent_code'].'"'.($portail['por_droit_ajout_'.$ent['ent_code']] ? ' checked': '').'></input><label for="droit_ajout_'.$ent['ent_code'].'">Ajout '.$ent['ent_libelle'].'</label></span> ';
  }

  echo '<table class="t1" width="100%">';
  echo '<tr><th colspan="4">Menu principal</th></tr>';
  $toms = $base->meta_topmenu_liste ($_SESSION['token'], $_REQUEST['por']);
  foreach ($toms as $tom) {
    echo '<tr class="pair"><td colspan="4"><strong>'.$tom['tom_libelle'].'</strong></td></tr>';
    $tsms = $base->meta_topsousmenu_liste ($_SESSION['token'], $tom['tom_id']);
    foreach ($tsms as $tsm) {
      echo '<tr class="impair"><td width="200">'.$tsm['tsm_libelle'].'</td>';
      echo '<td width="80">'.$tsm['tsm_type'].'</td>';
      switch ($tsm['tsm_type']) {
      case 'event':
      case 'documents':
	echo '<td>';

	echo '<input type="hidden" name="tsm_droit_modif['.$tsm['tsm_id'].']" value="off"></input>';
	echo '<input type="checkbox" name="tsm_droit_modif['.$tsm['tsm_id'].']" id="droit_modif_tsm_'.$tsm['tsm_id'].'"'.($tsm['tsm_droit_modif'] ? ' checked' : '').'></input> <label for="droit_modif_tsm_'.$tsm['tsm_id'].'">Ajout/Modification</label></td>';

	echo '<input type="hidden" name="tsm_droit_suppression['.$tsm['tsm_id'].']" value="off"></input>';
	echo '<td><input type="checkbox" name="tsm_droit_suppression['.$tsm['tsm_id'].']" id="droit_suppr_tsm_'.$tsm['tsm_id'].'"'.($tsm['tsm_droit_suppression'] ? ' checked' : '').'></input> <label for="droit_suppr_tsm_'.$tsm['tsm_id'].'">Suppression</label></td>';
	break;
      case 'groupe':
      case 'liste':
	echo '<td colspan="2"></td>';
      }
      echo '</tr>';
    }
  }
  foreach ($ents as $ent) {
    echo '<tr><th colspan="4">Menu '.$ent['ent_libelle'].'</th></tr>';
    $mens = $base->meta_menu_liste ($_SESSION['token'], $_REQUEST['por'], $ent['ent_code']);
    foreach ($mens as $men) {
      echo '<tr class="pair"><td colspan="4"><strong>'.$men['men_libelle'].'</strong></td></tr>';
      $smes = $base->meta_sousmenu_liste ($_SESSION['token'], $men['men_id']);
      foreach ($smes as $sme) {
	echo '<tr class="impair"><td width="200">'.$sme['sme_libelle'].'</td>';
	echo '<td width="80">'.($sme['sme_type'] ? $sme['sme_type'] : 'champs').'</td>';      
	switch ($sme['sme_type']) {
	case 'event':
	case 'documents':
	  echo '<td>';

	  echo '<input type="hidden" name="sme_droit_modif['.$sme['sme_id'].']" value="off"></input>';
	  echo '<input type="checkbox" name="sme_droit_modif['.$sme['sme_id'].']" id="droit_modif_sme_'.$sme['sme_id'].'"'.($sme['sme_droit_modif'] ? ' checked' : '').'></input> <label for="droit_modif_sme_'.$sme['sme_id'].'">Ajout/Modification</label></td>';

	  echo '<input type="hidden" name="sme_droit_suppression['.$sme['sme_id'].']" value="off"></input>';
	  echo '<td><input type="checkbox" name="sme_droit_suppression['.$sme['sme_id'].']" id="droit_suppr_sme_'.$sme['sme_id'].'"'.($sme['sme_droit_suppression'] ? ' checked' : '').'></input> <label for="droit_suppr_sme_'.$sme['sme_id'].'">Suppression</label></td>';
	  break;
	case '':
	  echo '<td>';
	  echo '<input type="hidden" name="sme_droit_modif['.$sme['sme_id'].']" value="off"></input>';
	  echo '<input type="checkbox" name="sme_droit_modif['.$sme['sme_id'].']" id="droit_modif_sme_'.$sme['sme_id'].'"'.($sme['sme_droit_modif'] ? ' checked' : '').'></input> <label for="droit_modif_sme_'.$sme['sme_id'].'">Modification</label></td>';
	  echo '<td></td>';
	  break;
	}
	echo '</tr>';
      }
    }
  }
  echo '</table>';
  echo '<div style="text-align: right"><input type="submit" name="enreg" value="Enregistrer"></input></div>';
}
?>

<h1>Fiches</h1>
<?php
if (isset ($_POST['enreg'])) {
  foreach ($_POST['tsm_droit_modif'] as $tsm_id => $v) {
    $base->meta_topsousmenu_set_droit_modif ($_SESSION['token'], $tsm_id, $v == 'on');
  }
  foreach ($_POST['tsm_droit_suppression'] as $tsm_id => $v) {
    $base->meta_topsousmenu_set_droit_suppression ($_SESSION['token'], $tsm_id, $v == 'on');
  }
  foreach ($_POST['sme_droit_modif'] as $sme_id => $v) {
    $base->meta_sousmenu_set_droit_modif ($_SESSION['token'], $sme_id, $v == 'on');
  }
  foreach ($_POST['sme_droit_suppression'] as $sme_id => $v) {
    $base->meta_sousmenu_set_droit_suppression ($_SESSION['token'], $sme_id, $v == 'on');
  }
  foreach ($ents as $ent) {
    $base->droit_ajout_entite_portail_set ($_SESSION['token'], $ent['ent_code'], $_REQUEST['por'], 
					   isset ($_POST['droit_ajout_'.$ent['ent_code']]) && $_POST['droit_ajout_'.$ent['ent_code']] == 'on');
    //  $base->meta_portail_set_droit_ajout_usager ($_REQUEST['por'], isset ($_POST['droit_ajout_usager']) && $_POST['droit_ajout_usager'] == 'on');
  }
}
?>

<form method="POST" action="<?= $_SERVER['REQUEST_URI'] ?>">
  <select name="por">
    <option value="">Sélectionner un portail</option>
  <?php liste_portails (); ?>
  </select>
  <input type="submit" value="OK"></input>

<?php liste_droits (); ?>

</form>
