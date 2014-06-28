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
$etys_tous = $base->events_event_type_list ($_SESSION['token'], $_POST['eca_id'], $_POST['sec_id'] ? array ($_POST['sec_id']) : NULL, NULL);
$secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
?>
<script type="text/javascript" src="/jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
  $(document).ready (function () {
      $(".secteur_event").click (on_secteur_event_click);
      $(".secteur_event > nobr > span").click (function () { return false; } ); // Stop propagation
      $(".ajout_theme").click (on_ajout_theme_click);
      $(".ety_intitule_individuel").click (on_ety_intitule_individuel_click);
      $("#ajout_type").click (on_ajout_type_click);
      $(".ety_del").click (on_ety_del_click);
      $(".ety_mod").click (on_ety_mod_click);
    });

function on_secteur_event_click () {
  if (!confirm ("Vous allez supprimer une thématique pour ce type. Continuer ?")) 
    return;
  var ety_sec = $(this).attr('id').substr (14);
  var parts = ety_sec.split('_');
  var ety = parts[0];
  var sec = parts[1];
  $.get('/ajax/edit/events_event_type_secteur_supprime.php', { prm_token: $("#token").val(), prm_ety_id: ety, prm_sec_id: sec }, function () {
      $("form").submit ();
    });
}

function on_ajout_theme_click () {
  var ety = $(this).attr('id').substr (12);
  var url = '/ajax/meta_secteur_liste.php?prm_token='+$("#token").val()+'&prm_est_prise_en_charge=null&output=json2';

    $("#secteurselectdlg").secteurSelect ({
	'title': "Sélection d'une thématique",
	'url': url,
	'return': function (sec_id, sec_nom) {
	  $.get('/ajax/edit/events_event_type_secteur_ajoute.php', { prm_token: $("#token").val(), prm_ety_id: ety, prm_sec_id: sec_id }, function () {
	      $("form").submit ();	      
	    });
	}
    });
  
}

function on_ety_intitule_individuel_click () {
  var ch = $(this).is(':checked');
  var ety = $(this).attr('id').substr (24);
  $.get ('/ajax/edit/events_event_type_set_intitule_individuel.php', { prm_token: $("#token").val(), prm_ety_id: ety, prm_intitule_individuel: ch ? 1 : 0}, function () {
      $("form").submit ();
    });
}

function on_ajout_type_click () {
  var nom = prompt("Intitulé du type :");
  if (nom) {
    $.get ('/ajax/edit/events_event_type_ajoute.php', { prm_token: $("#token").val(), prm_eca_id: $("#eca_id").val(), prm_intitule: nom }, function () {
	$("form").submit ();
      });	  
  }
}

function on_ety_del_click () {
  var ety = $(this).attr('id').substr (8);
  if (confirm ("Vous allez supprimer un type. Voulez-vous continuer ?")) {
    $.get ('/ajax/edit/events_event_type_supprime.php', { prm_token: $("#token").val(), prm_ety_id: ety }, function () {
	$("form").submit ();
      });
  }
}

function on_ety_mod_click () {
  var ety = $(this).attr('id').substr (8);
  var nom = prompt ("Nouvel intitulé du type :");
  if (nom) {
    $.get ('/ajax/edit/events_event_type_set_intitule.php', { prm_token: $("#token").val(), prm_ety_id: ety, prm_intitule: nom}, function () {
	$("form").submit ();
      });    
  }
}
</script>
<h1>Types d'événements</h1>
<form method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">

<select name="eca_id" id="eca_id">
<option value="">(sélectionner une catégorie)</option>
<?php liste_categories ($_POST['eca_id']); ?>
</select>

<select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_POST['sec_id']); ?>
</select>
<button type="submit">OK</button>

<?php if ($_POST['eca_id']) { ?>
<table class="t1" width="100%">
<tr><th width="250">Type</th><th width="50">Intitulé<br/>individuel</th><th>Thématiques</th></tr>
<?php affiche_types (); ?>
</table>

<div style="text-align: center"><input type="button" id="ajout_type" value="Ajouter un type"></input></div>
<?php } ?>
</form>

<div id="secteurselectdlg"></div>

<?php
function liste_categories ($eca_id) {
  global $base;
  $ecas = $base->events_events_categorie_list ($_SESSION['token']);
  foreach ($ecas as $eca) {
    $selected = $eca['eca_id'] == $eca_id ? ' selected' : '';
    echo '<option value="'.$eca['eca_id'].'"'.$selected.'>'.$eca['eca_nom'].'</option>';
  }
}

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
  global $etys_tous, $base;
  $impair = true;
  foreach ($etys_tous as $ety) {
    $secs = $base->events_event_type_secteur_list ($_SESSION['token'], $ety['ety_id'], $base->order ('sec_nom'));
    $sec_noms = array ();
    foreach ($secs as $sec) {
      $sec_noms[] = $sec['sec_nom'];
    }
    echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
    echo '<td>'.$ety['ety_intitule'].'<span class="ety_del" id="ety_del_'.$ety['ety_id'].'"></span><span class="ety_mod" id="ety_mod_'.$ety['ety_id'].'"></span></td>';
    echo '<td align="center"><input type="checkbox" class="ety_intitule_individuel" id="ety_intitule_individuel_'.$ety['ety_id'].'"'.($ety['ety_intitule_individuel'] ? ' checked' : '').'></input></td>';
    echo '<td>';
    $secs = $base->events_event_type_secteur_list ($_SESSION['token'], $ety['ety_id'], $base->order ('sec_nom'));
    foreach ($secs as $sec) {
      echo '<span id="secteur_event_'.$ety['ety_id'].'_'.$sec['sec_id'].'" class="secteur_event"><nobr><span>'.$sec['sec_nom'].'</span></nobr></span> ';
    }
    echo '<span id="ajout_theme_'.$ety['ety_id'].'" class="ajout_theme"><nobr>+</nobr></span>';
    echo '</td>';
    echo '</tr>';
    $impair = !$impair;
  }
}

?>
