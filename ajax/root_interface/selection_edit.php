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
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if ($_GET['id']) {
  $sel = $base->meta_selection_infos ($_SESSION['token'], $_GET['id']);
  $options = $base->meta_selection_entree_liste ($_SESSION['token'], $sel['sel_id']);
}
?>
<script type="text/javascript">
$(document).ready (function () {
    $("#sel_libelle").change (on_sel_libelle_change);
    $("#sel_code").change (on_sel_code_change);
    $("#listeoptions").sortable ();
    $(".sen_supprime").click (on_sen_supprime);
    $("#sen_nouvelle").click (on_sen_nouvelle_click);
    $("#sel_enregistrer").click (on_sel_enregistrer);
});

function on_sel_libelle_change () {
    if ($("#sel_code").val() == '') {
	$.post('/ajax/pour_code.php', { str: $(this).val() }, function (data) {	
	    $("#sel_code").val ($(data).find('results').text());
	});
    }
}

function on_sel_code_change () {
    var exp = new RegExp ('[^a-z0-9_]', 'g');
    $("#sel_code").val ($("#sel_code").val().replace (exp, ''));
}

function on_sen_supprime () {
    $(this).parent('li').remove ();
}

function on_sen_nouvelle_click () {
    var nom = prompt ("Texte de l'option");
    if (nom != null) {
	$("#listeoptions li:last-child").before ('<li><span class="sen_libelle">'+nom+'</span> <span class="sen_supprime">x</span></li>');
	$(".sen_supprime").unbind("click").click (on_sen_supprime);
    }
}

function on_sel_enregistrer () {
    var options = '';
    $("#listeoptions li").each (function () {
	if ($(this).attr('id') != undefined) {
	    options += ";" + $(this).attr('id');
	} else {
	    if ($(this).children('span').attr('id') == 'sen_nouvelle') {
	    } else {
		options += ";" + $(this).children('.sen_libelle').text().replace (';', ',');
	    }
	}	
    });
    options = options.substr (1);
    $.post ('/ajax/root_interface/selection_update.php', {
	sel_id: $("#sel_id").val(),
	sel_libelle: $("#sel_libelle").val(),
	sel_code: $("#sel_code").val(),
	sel_info: $("#sel_info").val(),
	options: options
    }, function (data) {
	if (data == 'ERR') {
	    alert("Erreur d'enregistrement. Vérifiez que le code n'est pas déjà utilisé.");
	} else {
	    $("#dlg2").dialog ('close');
	    if ($("#sel_id").val() == '') {
		var sel_id = data;
		$("#inf__selection_code").append ('<option value="'+sel_id+'" selected>'+$("#sel_libelle").val()+'</option>');
	    }
	}
    });
}
</script>
<input type="hidden" id="sel_id" value="<?= $sel['sel_id'] ?>"></input>
<table width="100%" cellpadding="5">
  <tr>
    <td width="60">Nom :</td><td><input type="text" size="30" id="sel_libelle" value="<?= $sel['sel_libelle'] ?>"></input></td>
  </tr>
  <tr>
    <td>Code :</td><td><input type="text" size="30" id="sel_code" value="<?= $sel['sel_code'] ?>" <?= $_GET['id'] ? "disabled" : "" ?>></input></td>
  </tr>
  <tr>
    <td>Info :</td><td><input type="text" size="40" id="sel_info" value="<?= $sel['sel_info'] ?>"></input></td>
  </tr>
  <tr>
    <td valign="top">Options :</td><td>
    <?= liste_options (); ?>
  </td>
  </tr>
  <tr><td colspan="2" align="center"><button id="sel_enregistrer">Enregistrer</button></td></tr>
</table>

<?php
function liste_options () {
  global $options;
  echo '<div id="divlisteoptions"><ul id="listeoptions">';
  if (count ($options)) {
    foreach ($options as $option) {
      echo '<li id="sen_'.$option['sen_id'].'"><span class="sen_libelle">'.$option['sen_libelle'].'</span> <span class="sen_supprime">x</span></li>';
    }
  }
  echo '<li><span id="sen_nouvelle">Nouvelle option...</span></li>';
  echo '</ul></div>';
}
?>
