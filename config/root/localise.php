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
include ("inc/pagination.php");

$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);

$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('localise_terme_liste_details', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Code', 'ter_code', 'lien_edit_terme', 'ter_id');
$pagination->addColumn ('Description');
$pagination->addColumn ('Valeur par défaut');
$pagination->setLines (15);

if (isset ($_GET['ter'])) {
  $ter_id = (int)$_GET['ter'];
  $terme = $base->localise_terme_get ($_SESSION['token'], $ter_id);
  $defaut = $base->localise_par_code_secteur ($_SESSION['token'], $terme['ter_code'], NULL);
}

if (isset ($_POST['ed_enreg'])) {
  if (intitule_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
}

function lien_edit_terme ($ter_id) {
  return array ('/admin.php', array ('ter' => $ter_id));
}

function intitule_save ($post) {
  global $base, $terme, $secteurs;
  $base->localise_terme_set ($_SESSION['token'], $terme['ter_id'], $post['ed_commentaire']);
  $base->localise_par_code_secteur_set ($_SESSION['token'], $terme['ter_code'], NULL, $post['ed_defaut']);
  foreach ($secteurs as $secteur) {
    if (isset ($post['ed_valeur_'.$secteur['sec_id']])) {
      $base->localise_par_code_secteur_set ($_SESSION['token'], $terme['ter_code'], $secteur['sec_code'], $post['ed_valeur_'.$secteur['sec_id']]);
    } else if (isset ($post['cb_par_defaut_'.$secteur['sec_id']])) {
      $base->localise_par_code_secteur_supprime ($_SESSION['token'], $terme['ter_code'], $secteur['sec_code']);
    } else {
      echo 'ERREUR';
      exit;
    }
  }
  return true;
}

?>
<script type="text/javascript">
  $(document).ready (function () {
      $(".cb_par_defaut").click (function () {
	  var sec_id = $(this).attr('id').substr(14);
	  if ($(this).is(':checked')) {
	    $("#ed_valeur_"+sec_id).val('');
	    $("#ed_valeur_"+sec_id).attr('disabled', 'disabled');
	  } else {
	    $("#ed_valeur_"+sec_id).removeAttr('disabled');
	  }
	});
    });
</script>
<h1>Intitulés</h1>

<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('ter_code', 'ter_commentaire', 'defaut')); ?>
  <tr><td colspan="3" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php if (isset ($_GET['ter'])) { ?>
<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
  <tr class="pair">
    <td>Code</td>
    <td><?= $terme['ter_code'] ?></td>
  </tr>
  <tr class="impair">
    <td>Description</td>
    <td><textarea name="ed_commentaire" rows="3" cols="30"><?= $terme['ter_commentaire'] ?></textarea></td>
  </tr>
  <tr class="pair">
    <td>Valeur par défaut</td>
    <td><input type="text" name="ed_defaut" value="<?= $defaut ?>"></input></td>
  </tr>

<?php
  $i=0;
foreach ($secteurs as $secteur) {
  $val = $base->localise_par_code_secteur ($_SESSION['token'], $terme['ter_code'], $secteur['sec_code']);
  $cb_defaut_checked = ($val == $defaut) ? ' checked' : '';
  echo '<tr class="'.($i%2 ? 'impair' : 'pair').'">';
  echo '<td>Valeur pour<br><b>'.$secteur['sec_nom'].'</b></td>';
  echo '<td>';
  echo '<input type="checkbox"'.$cb_defaut_checked.' class="cb_par_defaut" id="cb_par_defaut_'.$secteur['sec_id'].'" name="cb_par_defaut_'.$secteur['sec_id'].'"></input><label for="cb_par_defaut_'.$secteur['sec_id'].'">Valeur par défaut</label><br/>';
  echo '<input type="text" id="ed_valeur_'.$secteur['sec_id'].'" name="ed_valeur_'.$secteur['sec_id'].'"';
  if (!$cb_defaut_checked) {
    echo ' value="'.$val.'"';
  } else {
    echo ' disabled';
  }
  echo '></input>';
  echo '</td></tr>';
  $i++;
}
?>

  <tr><td class="navigtd" align="right" colspan="2">
    <button name="ed_enreg" type="submit">Mettre à jour</button>
  </td></tr>
</table>
</form>
<?php } ?>
