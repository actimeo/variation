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
$dtys_tous = $base->document_document_type_liste_par_sec_ids ($_SESSION['token'], $_POST['sec_id'] ? array ($_POST['sec_id']) : NULL, NULL, $base->order('dty_nom'));
$secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
?>
<script type="text/javascript" src="/jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
  $(document).ready (function () {
      $(".secteur_event").click (on_secteur_event_click);
      $(".secteur_event > nobr > span").click (function () { return false; } ); // Stop propagation
      $(".ajout_theme").click (on_ajout_theme_click);
      $("#ajout_type").click (on_ajout_type_click);
      $(".dty_del").click (on_dty_del_click);
      $(".dty_mod").click (on_dty_mod_click);
    });

function on_secteur_event_click () {
  if (!confirm ("Vous allez supprimer une thématique pour ce type. Continuer ?")) 
    return;
  var dty_sec = $(this).attr('id').substr (14);
  var parts = dty_sec.split('_');
  var dty = parts[0];
  var sec = parts[1];
  $.get('/ajax/edit/document_document_type_secteur_supprime.php', { prm_token: $("#token").val(), prm_dty_id: dty, prm_sec_id: sec }, function () {
      $("form").submit ();
    });
}

function on_ajout_theme_click () {
  var dty = $(this).attr('id').substr (12);
  var url = '/ajax/meta_secteur_liste.php?prm_token='+$("#token").val()+'&prm_est_prise_en_charge=null&output=json2';

    $("#secteurselectdlg").secteurSelect ({
	'title': "Sélection d'une thématique",
	'url': url,
	'return': function (sec_id, sec_nom) {
	  $.get('/ajax/edit/document_document_type_secteur_ajoute.php', { prm_token: $("#token").val(), prm_dty_id: dty, prm_sec_id: sec_id }, function () {
	      $("form").submit ();	      
	    });
	}
    });
  
}

function on_ajout_type_click () {
  var nom = prompt("Intitulé du type :");
  if (nom) {
    $.get ('/ajax/edit/document_document_type_ajoute.php', { prm_token: $("#token").val(), prm_nom: nom }, function () {
	$("form").submit ();
      });	  
  }
}

function on_dty_del_click () {
  var dty = $(this).attr('id').substr (8);
  if (confirm ("Vous allez supprimer un type. Voulez-vous continuer ?")) {
    $.get ('/ajax/edit/document_document_type_supprime.php', { prm_token: $("#token").val(), prm_dty_id: dty }, function () {
	$("form").submit ();
      });
  }
}

function on_dty_mod_click () {
  var dty = $(this).attr('id').substr (8);
  var nom = prompt ("Nouvel intitulé du type :");
  if (nom) {
    $.get ('/ajax/edit/document_document_type_set_nom.php', { prm_token: $("#token").val(), prm_dty_id: dty, prm_nom: nom}, function () {
	$("form").submit ();
      });    
  }
}
</script>
<h1>Types de documents</h1>
<form method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">

<select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_POST['sec_id']); ?>
</select>
<button type="submit">OK</button>

<table class="t1" width="100%">
<tr><th width="250">Type</th><th>Thématiques</th></tr>
<?php affiche_types (); ?>
</table>

<div style="text-align: center"><input type="button" id="ajout_type" value="Ajouter un type"></input></div>
</form>

<div id="secteurselectdlg"></div>

<?php
function liste_secteurs ($sec_id) {
  global $base;
  $secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  foreach ($secs as $sec) {
    $selected = $sec['sec_id'] == $sec_id ? ' selected' : '';
    echo '<option value="'.$sec['sec_id'].'"'.$selected.'>'.$sec['sec_nom'].'</option>';
  }
}

function liste_secteurs_entete () {
  global $secs;
  foreach ($secs as $sec) {
    echo '<th>'.$sec['sec_nom'].'</th>';
  }
}

function affiche_types () {
  global $dtys_tous, $base;
  $impair = true;
  foreach ($dtys_tous as $dty) {
    $secs = $base->document_document_type_secteur_list ($_SESSION['token'], $dty['dty_id'], $base->order ('sec_nom'));
    $sec_noms = array ();
    foreach ($secs as $sec) {
      $sec_noms[] = $sec['sec_nom'];
    }
    echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
    echo '<td>'.$dty['dty_nom'].'<span class="dty_del" id="dty_del_'.$dty['dty_id'].'"></span><span class="dty_mod" id="dty_mod_'.$dty['dty_id'].'"></span></td>';
    echo '<td>';
    foreach ($secs as $sec) {
      echo '<span id="secteur_event_'.$dty['dty_id'].'_'.$sec['sec_id'].'" class="secteur_event"><nobr><span>'.$sec['sec_nom'].'</span></nobr></span> ';
    }
    echo '<span id="ajout_theme_'.$dty['dty_id'].'" class="ajout_theme"><nobr>+</nobr></span>';
    echo '</td>';
    echo '</tr>';
    $impair = !$impair;
  }
}

?>
