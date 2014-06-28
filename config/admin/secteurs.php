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

if (!$_SESSION['uti_config'])
  exit;

if (isset ($_POST['ed_enreg'])) {
  $base->secteur_infos_update ($_SESSION['token'], $_GET['sec'], $_POST['ed_editable'] == 'on');
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;  
}

if (isset ($_GET['sec'])) {
  $secteur = $base->meta_secteur_get ($_SESSION['token'], $_GET['sec']);
  $secteur_infos = $base->secteur_infos_get ($_SESSION['token'], $_GET['sec']);
  $ed_editable_checked = $secteur_infos['sec_editable'] ? ' checked' : '';
  $types = $base->meta_secteur_type_liste ($_SESSION['token'], $_GET['sec']);
 }
?>
<script type="text/javascript">
$(document).ready (function () {
    $(".set_rename").click (on_set_rename_click);
    $(".set_delete").click (on_set_delete_click);
    $("#set_add").click (on_set_add_click);
});

function on_set_rename_click () {
    var ancien = $(this).prev(".set_name").text();
    var nom = prompt ("Nouveau nom du type : ", ancien);
    if (nom) {
	$.post('/ajax/admin/set_rename.php', { set: $(this).attr('id'), nom: nom }, function () {
	    $("form").submit ();
	});
    }
}

function on_set_delete_click () {
    $.post('/ajax/admin/set_delete.php', { set: $(this).attr('id') }, function () {
	$("form").submit ();
    });
}

function on_set_add_click () {
    var nom = prompt ("Nom du nouveau type : ");
    if (nom) {
	$.post('/ajax/admin/set_add.php', { sec: $("#sec_id").val(), nom: nom }, function () {
	    $("form").submit ();
	});
    }    
}
</script>
<h1><?= $titre ?></h1>
<table width="470" class="t1" style="float: left">
  <tr><th><?= $soustitre ?></th></tr>
   <?= liste_secteurs (); ?>
</table>

<?php if (isset ($_GET['sec'])) { ?>
<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<input type="hidden" id="sec_id" value="<?= $_GET['sec'] ?>"></input>
<table class="t1" width="370" style="margin-left: 480px">

  <tr><th colspan="2">Éditer</th></tr>

  <tr class="impair">
    <td width="75"><?= $soustitre ?></td>
    <td><?= $secteur['sec_nom'] ?></td>
  </tr>

  <tr class="pair">
    <td>Publics concernés</td>
   <td><?= edite_types (); ?></td>
  </tr>

  <tr class="impair"><td colspan="2">
    <input type="checkbox" id="ed_editable" name="ed_editable"<?= $ed_editable_checked ?>></input><label for="ed_editable">Rendre éditables les groupes internes de cette thématique</label>
  </td></tr>

  <tr><td class="navigtd" align="right" colspan="2">
    <button name="ed_enreg" type="submit">Mettre à jour</button>
  </td></tr>
</table>
</form>
<?php } ?>
<div style="clear: both"></div>

<?php
function liste_secteurs () {
  global $base, $est_prise_en_charge;
  $impair = true;
  $secteurs = $base->meta_secteur_liste ($_SESSION['token'], $est_prise_en_charge);
  foreach ($secteurs as $secteur) {
    echo '<tr class="'.($impair ? 'impair' : 'pair').'"><td><a href="'.lien_edit_secteur ($secteur['sec_id']).'">'.$secteur['sec_nom'].'</a></td></tr>';
    $impair = !$impair;
  }
}

function lien_edit_secteur ($sec_id) {
  return '/admin.php?sec='.$sec_id;
}

function edite_types () {
  global $types;
  echo '<ul class="set_liste">';
  if (count ($types)) {
    foreach ($types as $type) {
      echo '<li><span class="set_name">'.$type['set_nom'].'</span>';
      echo ' <span class="set_rename smallbutton" id="set_rename_'.$type['set_id'].'">renommer</span>';
      echo ' <span class="set_delete smallbutton" id="set_delete_'.$type['set_id'].'">supprimer</span>';
      echo '</li>';
    }
  }
  echo '<li><span class="smallbutton" id="set_add">Ajouter un public</span></li>';
  echo '</ul>';
}
?>
