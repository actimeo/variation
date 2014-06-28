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
// Dialogue d'édition d'un événement
require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');

$code = $_GET['code'];
$eve_id = $_GET['eve'];

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$evs = $base->events_events_get_par_code ($_SESSION['token'], $code);
$themes_evs = $base->events_secteur_events_liste ($_SESSION['token'], $evs['evs_id'], $_SESSION['eta_id']);
$categories_evs = $base->events_categorie_events_liste ($_SESSION['token'], $evs['evs_id']);
$ecas = $base->events_events_categorie_list ($_SESSION['token']);

// Calcul des droits, provenant de tsm ou de sme
$tsm_id = $_GET['tsm_id'];
$sme_id = $_GET['sme_id'];
if ($tsm_id) {
  $tsm = $base->meta_topsousmenu_get ($_SESSION['token'], $tsm_id);
  $droit_modif = $tsm['tsm_droit_modif'];
  $droit_suppression = $tsm['tsm_droit_suppression'];
} else if ($sme_id) {
  $sme = $base->meta_sousmenu_infos ($_SESSION['token'], $sme_id);
  $droit_modif = $sme['sme_droit_modif'];
  $droit_suppression = $sme['sme_droit_suppression'];
}

if ($eve_id) {
  $eve = $base->events_event_get ($_SESSION['token'], $eve_id);
  $allday = $eve['eve_journee'];
  $attime = $eve['eve_ponctuel'];
  $uti_creation = $base->utilisateur_get ($_SESSION['token'], $eve['uti_id_creation']);
  $nom_createur = $base->personne_get_libelle ($_SESSION['token'], $uti_creation['per_id']);
  $ety = $base->events_event_type_get ($_SESSION['token'], $eve['ety_id']);
  $participants = $base->events_event_personne_list ($_SESSION['token'], $eve_id);
  $ressources = $base->events_event_ressource_list ($_SESSION['token'], $eve_id);
  $description = $base->events_event_memo_get ($_SESSION['token'], $eve_id, 'description');
  $bilan = $base->events_event_memo_get ($_SESSION['token'], $eve_id, 'bilan');
  $themes = $base->events_secteur_event_liste ($_SESSION['token'], $eve_id);
  $sec_ids = array ();
  foreach ($themes as $theme) {
    $sec_ids[] = $theme['sec_id'];
  }
  if ($evs['ety_id']) {
    $etys = array ($base->events_event_type_get ($_SESSION['token'], $evs['ety_id']));
  } else {
    if (count ($categories_evs) > 1) {
      $etys = $base->events_event_type_list_all ($_SESSION['token'], $sec_ids, $_SESSION['eta_id']);
    } else {
      $etys = $base->events_event_type_list ($_SESSION['token'], $categories_evs[0]['eca_id'], $sec_ids, $_SESSION['eta_id']);
    }
  }
  // On corrige les erreurs sur les dates ( provenant de rev <= 628)
  if ($eve_id && !$allday && !$attime && $eve['eve_debut'] == $eve['eve_fin']) {
    $attime = true;
  }
  if ($eve_id && !$allday && !$attime && $eve['eve_fin'] == '') {
    $attime = true;
  }

} else {
  $allday = isset ($_GET['allday']) && ($_GET['allday'] == 'true');
  $attime = $_GET['end'] - $_GET['start'] == 1800;
  $eve['eve_debut'] = date ('d/m/Y H:i', $_GET['start']);
  if (isset ($_GET['end'])) {
    $eve['eve_fin'] = date ('d/m/Y H:i', $_GET['end']);
  }
  if (count ($categories_evs) == 1) {
    $eca_id_defaut = $categories_evs[0]['eca_id'];
  }
  $uti_creation = $base->utilisateur_get ($_SESSION['token'], $_SESSION['uti_id']);
  $nom_createur = $base->personne_get_libelle ($_SESSION['token'], $uti_creation['per_id']);

  if (count ($categories_evs) == 1 && (count ($themes_evs) == 1)) {
    $secs = array();
    if (count ($themes_evs) == 1) 
      $secs[] = $themes_evs[0]['sec_id'];
    if ($evs['ety_id']) {
      $etys = array ($base->events_event_type_get ($_SESSION['token'], $evs['ety_id']));
    } else {
      $etys = $base->events_event_type_list ($_SESSION['token'], $eca_id_defaut, $secs, $_SESSION['eta_id'], $base->order('eca_id'));
    }
  } else {
    //    $etys = array ();
    $sec_ids = array ();
    foreach ($themes_evs as $theme) {
      $sec_ids[] = $theme['sec_id'];
    }
    if ($evs['ety_id']) {
      $etys = array ($base->events_event_type_get ($_SESSION['token'], $evs['ety_id']));
    } else {
      if (count ($categories_evs) > 1) {
	$etys = $base->events_event_type_list_all ($_SESSION['token'], $sec_ids, $_SESSION['eta_id']);
      } else {
	$etys = $base->events_event_type_list ($_SESSION['token'], $categories_evs[0]['eca_id'], $sec_ids, $_SESSION['eta_id']);
      }
    }
  }
}
$entites = $base->meta_entite_liste ($_SESSION['token']);
?>
<script type="text/javascript">
$(document).ready (function () {
    $("#editeventtabs").tabs ();
    $(".participant").click (on_participant_click);
    $(".participant > nobr > span").click (function () { return false; } ); // Stop propagation
    $(".ajout_participant").click (on_ajout_participant_click);

    $(".ressource").click (on_ressource_click);
    $(".ressource > nobr > span").click (function () { return false; } ); // Stop propagation
    $("#ajout_ressource").click (on_ajout_ressource_click);

    $("#all_day").click (on_all_day_click);
    $("#at_time").click (on_at_time_click);

    $(".datetimepicker").datetimepicker ({
      showOn: "button",
	  buttonImage: "/Images/datepicker.png",
	  buttonImageOnly: true,
	  showButtonPanel: true,
	  changeYear: true,
	  showWeek: true,
	  gotoCurrent: true,
	  yearRange: "c-64:c+10"	  
    });
    $(".supp_eca_id").hide();
    $(".supp_eca_id_"+$("#eca_id").val()).show();
    $("#eca_id").change (on_eca_id_change);
    $("#ety_id").change (on_ety_id_change);
    $("#event_enregistrer").button ({ icons: {primary:'ui-icon-disk'}}).click (on_event_enregistrer_click);
    $("#event_supprimer").button ({ icons: {primary:'ui-icon-close'}}).click (on_event_supprimer_click);

    $(".secteur_event").click (on_secteur_event_click);
    //    $(".secteur_event_nodel").unbind('click');
    $(".secteur_event > nobr > span").click (function () { return false; } ); // Stop propagation
    $("#ajout_secteur_event_theme").click (on_ajout_secteur_event_theme_click);

    if ($("#all_day").is(':checked')) {
      on_all_day_click ();
    } else if ($("#at_time").is(':checked')) {
      on_at_time_click ();
    }
});

function on_participant_click (e) {
    if (confirm ('Vous allez supprimer ce participant pour cet événement. Continuer ?')) {
	$(this).remove ();
    }
}

function on_ajout_participant_click () {
  var the_type = $(this).attr('id').substr (18);
  $("#participantdlg").remove();
  $("body").append('<div id="participantdlg"></div>');
    $("#participantdlg").participantSelect ({
      title: "Sélection d'un participant",
	  url: '/ajax/personne_cherche.php',
	  type: [the_type],
	  ajout: false,
	  multi: true,
	  return: function (per_type, pers) { // Fonction pour choix multiple
	  $(pers).each (function () {
	      $("#participants-"+per_type).append (' <span id="participant_'+this.id+'" class="participant"><nobr><span>'+this.text+'</span></nobr></span>');
	    });
	  $("#participants-"+per_type+" > .participant").unbind('click').click (on_participant_click);
	  $("#participants-"+per_type+" > .participant > nobr > span").unbind('click').click (function () { return false; } ); // Stop propagation
	}
      });
}

function on_ressource_click (e) {
    if (confirm ('Vous allez supprimer cette ressource pour cet événement. Continuer ?')) {
	$(this).remove ();
    }
}

function on_ajout_ressource_click () {
  if (!$(".secteur_event").length && !$(".secteur_event_ro").length) {
	alert ('Aucune ressource disponible. Vous devez spécifier au moins une thématique.');
    }
    $("#ressourcedlg").ressourceSelect ({
	url: '/ajax/ressource_list.php',
	return: function (res_id, res_nom) {
	    $(".ressources").append(' <span class="ressource" id="ressource-'+res_id+'"><nobr><span>'+res_nom+'</span></nobr></span>');
	    $(".ressources .ressource").unbind('click').click (on_ressource_click);
	    $(".ressources .ressource > nobr > span").click (function () { return false; } ); // Stop propagation
	}
    });
}

function on_all_day_click () {
  if ($("#all_day").is(':checked')) {
    $("#at_time_div").hide();
    $("#eve_debut").val ($("#eve_debut").val().substr (0, 10));
    $("#eve_debut").datetimepicker('destroy');
    $("#eve_debut").datepicker ({
      showOn: "button",
	  buttonImage: "/Images/datepicker.png",
	  buttonImageOnly: true,
	  showButtonPanel: true,
	  changeYear: true,
	  showWeek: true,
	  gotoCurrent: true,
	  yearRange: "c-64:c+10"
    });
    $("#eve_fin").val ($("#eve_fin").val().substr (0, 10));
    $("#eve_fin").datetimepicker('destroy');
    $("#eve_fin").datepicker ({
      showOn: "button",
	  buttonImage: "/Images/datepicker.png",
	  buttonImageOnly: true,
	  showButtonPanel: true,
	  changeYear: true,
	  showWeek: true,
	  gotoCurrent: true,
	  yearRange: "c-64:c+10"
    });
  } else {
    $("#at_time_div").show();
    if ($("#eve_debut").val().length) {
      $("#eve_debut").val ($("#eve_debut").val()+' 00:00');
    }
    $("#eve_debut").datepicker('destroy');
    $("#eve_debut").datetimepicker ({
	showOn: "button",
	buttonImage: "/Images/datepicker.png",
	buttonImageOnly: true,
	showButtonPanel: true,
	changeYear: true,
	showWeek: true,
	  gotoCurrent: true,
	yearRange: "c-64:c+10"

    });
    if ($("#eve_fin").val().length) {
      $("#eve_fin").val ($("#eve_fin").val()+' 00:00');
    }
    $("#eve_fin").datepicker('destroy');
    $("#eve_fin").datetimepicker ({
	showOn: "button",
	buttonImage: "/Images/datepicker.png",
	buttonImageOnly: true,
	showButtonPanel: true,
	changeYear: true,
	showWeek: true,
	  gotoCurrent: true,
	yearRange: "c-64:c+10"

    });
  }
}

function on_at_time_click () {
  if ($("#at_time").is(':checked')) {
    $("#all_day_div").hide();
    $("#debut_td").hide();
    $("#fin_td1").hide();
    $("#fin_td2").hide();
  } else {
    $("#all_day_div").show();
    $("#debut_td").show();
    $("#fin_td1").show();
    $("#fin_td2").show();
  }
}

function on_eca_id_change () {
  recharge_types ();
  $(".supp_eca_id").hide();
  $(".supp_eca_id_"+$("#eca_id").val()).show();
}

function on_ety_id_change () {
  var ety_id = $(this).val();
  $.getJSON ('/ajax/edit/events_event_type_get.php', { prm_token: $("#token").val(), prm_ety_id: ety_id, output: 'json2' }, function (data) {
      if (!data.ety_intitule_individuel && $("#eve_intitule").val() == '') {
	$("#eve_intitule").val (data.ety_intitule);
      }
      $(".supp_eca_id").hide();
      $(".supp_eca_id_"+data.eca_id).show();
    });
}

function recharge_types () {
  var sec_ids = new Array ();
  $(".secteur_event").each (function () {
      sec_ids.push ($(this).attr('id').substr (14));
    });
  $(".secteur_event_ro").each (function () {
      sec_ids.push ($(this).attr('id').substr (14));
    });
  <?php if (count ($categories_evs) == 1) {
    echo "  $.getJSON('/ajax/edit/events_event_type_list.php', { prm_token: $(\"#token\").val(), prm_eca_id: ".$categories_evs[0]['eca_id'].", prm_sec_ids: sec_ids, prm_eta_id: $(\"#eta_id\").val(), output: 'json' }, function (data) {
";  
} else {
    echo "  $.getJSON('/ajax/edit/events_event_type_list_all.php', { prm_token: $(\"#token\").val(), prm_sec_ids: sec_ids, prm_eta_id: $(\"#eta_id\").val(), output: 'json' }, function (data) {
";
  }
?>
      $("#ety_id").empty();
      $("#ety_id").append ('<option value=""></option>');
      var ancien_eca = 0;
      $.each (data, function (idx, val) {
	  if (val.eca_id != ancien_eca) {
	    if (ancien_eca != 0) {
	      $("#ety_id").append ('</optgroup>');
	    }
	    ancien_eca = val.eca_id;
	    $("#ety_id").append ('<optgroup label="'+val.eca_nom+'">');
	  }
	  $("#ety_id").append ('<option value="'+val.ety_id+'">'+val.ety_intitule+'</option>');
	});
      $("#ety_id").append ('</optgroup>');
    });  
}

function on_event_enregistrer_click () {
    if (!$("#eve_intitule").val().length) {
	alert ('Vous devez spécifier un intitulé');
	return;
    }
    if (!$("#ety_id").val().length) {
	alert ('Vous devez spécifier un type');
	return;
    }
    if (!$(".secteur_event").length && !$(".secteur_event_ro").length) {
	alert ('Vous devez ajouter au moins une thématique');
	return;	
    }
    var per_ids = new Array();
    $(".participants .participant").each (function () {
	 per_ids.push ($(this).attr('id').substr (12));
     });
    if (!$("#participants-usager .participant").length) {
      alert ('Vous devez ajouter au moins un usager');
      return;
    }
    var res_ids = new Array ();
    $(".ressources .ressource").each (function () {
	res_ids.push ($(this).attr('id').substr (10));
    });
    if (!res_ids.length)
	res_ids.push(null);
    var sec_ids = new Array ();
    $(".secteur_event").each (function () {
	sec_ids.push ($(this).attr('id').substr (14));
    });
    $(".secteur_event_ro").each (function () {
	sec_ids.push ($(this).attr('id').substr (14));
    });
    var tmp_debut = $("#eve_debut").val();
    var tmp_fin = $("#eve_fin").val();
    if ($("#all_day").is(":checked")) {
      if (tmp_debut.length == 10)
	tmp_debut += ' 00:00';
      if (tmp_fin.length == 10)
	tmp_fin += ' 00:00';
    }
    $.post ('/ajax/edit/events_event_save_all.php', {
      prm_token: $("#token").val(),
	prm_eve_id: $("#eve_id").val (),
	prm_intitule: $("#eve_intitule").val (),
	prm_ety_id: $("#ety_id").val (),
	prm_journee: $("#all_day").is(":checked") ? 1 : 0,
	prm_ponctuel: $("#at_time").is(":checked") ? 1 : 0,
	prm_debut: tmp_debut+':00',
	prm_fin: tmp_fin+':00',
	prm__depenses_montant: $("#eve__depenses_montant").val (),
	prm_description: $("#eve_description").val(),
	prm_bilan: $("#eve_bilan").val(),
	prm_per_ids: per_ids,
	prm_res_ids: res_ids,
	prm_sec_ids: sec_ids
    }, function (data) {
	$("#dlg").dialog ('destroy');
	$("#calendar").fullCalendar ('refetchEvents');
    });        
}

function on_event_supprimer_click () {
    if (confirm ('Vous allez définitivement supprimer cet événement. Continuer ?')) {
      $.post ('/ajax/edit/events_event_supprime.php', { prm_token: $("#token").val(), prm_eve_id: $("#eve_id").val() }, function () {
	    $("#dlg").dialog ('destroy');
	    $("#calendar").fullCalendar ('refetchEvents');	    
	});
    }
}

function on_secteur_event_click (e) {
    if (confirm ('Vous allez supprimer cette thématique pour cet événement. Continuer ?')) {
	$(this).remove ();
	recharge_types ();
    }
}

function on_ajout_secteur_event_theme_click () {
  var url = '/ajax/events_secteur_events_liste.php?prm_token='+$("#token").val()+'&prm_evs_id='+$("#evs_id").val()+'&prm_eta_id='+$("#eta_id").val()+'&output=json';
    $("#secteurselectdlg").secteurSelect ({
	'title': "Sélection d'une thématique",
	'url': url,
	'return': function (sec_id, sec_nom) {
	    $("#secteur_event_list_themes").append (' <span id="secteur_event_'+sec_id+'" class="secteur_event"><nobr><span>'+sec_nom+'</span></nobr></span>');
	    $(".secteur_event").unbind('click').click (on_secteur_event_click);
	    $(".secteur_event > nobr > span").unbind('click').click (function () { return false; } ); // Stop propagation
	    recharge_types ();
	}
    });
}
</script>
<script type="text/javascript" src="/jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/jquery/participantselect/jquery.participantselect.js"></script>
<link href="/jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/jquery/ressourceselect/jquery.ressourceselect.js"></script>
<link href="/jquery/ressourceselect/jquery.ressourceselect.css" rel="stylesheet" type="text/css" />
<input type="hidden" id="eve_id" value="<?= $eve_id ?>"></input>
<input type="hidden" id="evs_id" value="<?= $evs['evs_id'] ?>"></input>
<input type="hidden" id="uti_id" value="<?= $_SESSION['uti_id'] ?>"></input>
<input type="hidden" id="eta_id" value="<?= $_SESSION['eta_id'] ?>"></input>
<div id="editeventtabs">
  <ul>
    <li><a href="#editeventtab1">Général</a></li>
    <li><a href="#editeventtab3">Objet</a></li>
    <li><a href="#editeventtab2a">Réservations</a></li>
    <li><a href="#editeventtab4">Compte-rendu</a></li>
  <li><a href="#editeventtab5">(+)</a></li>
  </ul>
  
  <div id="editeventtab1">
    <table class="tabledlg">

<?php 
  affiche_categorie (); 
affiche_themes ();
affiche_types ();
?>
      <tr>
	<th><label for="eve_intitule">Intitulé : </label></th>
	<td colspan="4">
  <input type="text" id="eve_intitule" size="50" value="<?php affiche_intitule (); ?>"<?php if (!$droit_modif) { echo ' disabled'; } ?>></input>
	</td>
      </tr>

	<tr>
          <th rowspan="2">Date&nbsp;:</th>
          <td colspan="4">
  <span id="all_day_div"><input type="checkbox" id="all_day"<?php if ($allday) { echo ' checked'; } ?>></input><label for="all_day">Toute la journée</label></span>
            <span id="at_time_div"><input type="checkbox" id="at_time"<?php if ($attime) { echo ' checked'; } ?>></input><label for="at_time">Ponctuel</label></span>
          </td>
      <tr>
  <td id="debut_td"><label for="eve_debut">Début&nbsp;:</label></td>
  <td><input type="text" id="eve_debut" size="14" <?php if ($droit_modif) { echo 'class="datetimepicker"'; } ?> value="<?= substr ($eve['eve_debut'], 0, 16) ?>"<?php if (!$droit_modif) { echo ' disabled'; } ?>></input></td>
<td id="fin_td1"><label for="eve_fin">Fin&nbsp;:</label></td>
        <td id="fin_td2"><input type="text" id="eve_fin" size="14" <?php if ($droit_modif) { echo 'class="datetimepicker"'; } ?> value="<?= substr ($eve['eve_fin'], 0, 16) ?>"<?php if (!$droit_modif) { echo ' disabled'; } ?>></input></td>
      </tr>

      <tr class="supp_eca_id_2 supp_eca_id">
	<th><label for="eve__depenses_montant">Montant : </label></th>
	<td colspan="4"><input type="text" id="eve__depenses_montant" size="6" value="<?= $eve['eve__depenses_montant'] ?>"<?php if (!$droit_modif) { echo ' disabled'; } ?>></input> &euro;
      </tr>

      <tr>
      <th>Participants&nbsp;: </th>
      <td colspan="4">
  <?= liste_participants (); ?>
  </td></tr>
  </table>
  </div>

  <div id="editeventtab3">
  <textarea id="eve_description" cols="77" rows="13"<?php if (!$droit_modif) { echo ' disabled'; } ?>><?= $description ?></textarea>
  </div>

  <div id="editeventtab2a">
  <?= liste_ressources (); ?>
  <?php if ($droit_modif) { ?>
  <span id="ajout_ressource">Ajouter une réservation</span>
  <?php } ?>
  </div>

  <div id="editeventtab4">
  <textarea id="eve_bilan" cols="77" rows="13"<?php if (!$droit_modif) { echo ' disabled'; } ?>><?= $bilan ?></textarea>
  </div>

  <div id="editeventtab5">
    <table class="tabledlg">
      <tr>
  <th width="80">Création&nbsp;: </th>
	<td colspan="3">
<?php
  if ($eve['eve_date_creation']) { 
    echo 'le '.substr ($eve['eve_date_creation'], 0, 16);
  }
  echo 'par '.$nom_createur; 
?>
	</td>
      </tr>
      <tr>
	<th width="80">Dernière<br>modification&nbsp;: </th>
	<td colspan="3">

	</td>
      </tr>
  <?php  if (count ($categories_evs) == 1) : ?>
      <tr>
	<th>Catégorie</th>
	<td colspan="3">
  <?= $categories_evs[0]['eca_nom'] ?>
	</td>
      </tr>  
  <?php endif; ?>
  <?php  if (count ($themes_evs) == 1) : ?>
      <tr>
	<th>Thématique</th>
	<td colspan="3">
  <?= $themes_evs[0]['sec_nom'] ?>
	</td>
      </tr>  
  <?php endif; ?>
  <?php  if ($evs['ety_id']) : ?>
      <tr>
	<th>Type</th>
	<td colspan="3">
  <?= $etys[0]['ety_intitule'] ?>
	</td>
      </tr>  
  <?php endif; ?>
    </table>
  </div>


</div>
<div style="text-align: center; padding: 15px">
<?php 
if ($_SESSION['uti_id'] == $eve['uti_id_creation']) { 
  if ($droit_modif) {
    echo '<button id="event_enregistrer">Mettre à jour</button>';
  }
  if ($droit_suppression) { 
    echo '<button id="event_supprimer">Supprimer</button>';
  }
} else {
  if ($droit_modif) {
    echo '<button id="event_enregistrer">Enregistrer</button>';
  }
}
?>
</div>
<div id="secteurselectdlg"></div>
<div id="ressourcedlg"></div>
<?php
function affiche_categorie () {
  global $categories_evs, $droit_modif;
   if (count ($categories_evs) == 1) {
     echo '<input type="hidden" id="eca_id" value="'.$categories_evs[0]['eca_id'].'"></input>';
     return;
   }
}

function liste_categories () {
  global $categories_evs, $eve;
  if (count ($categories_evs) > 1)
    echo '<option value=""></option>';
  foreach ($categories_evs as $eca) {
    $selected = $eca['eca_id'] == $eve['eca_id'] ? ' selected' : '';
    echo '<option value="'.$eca['eca_id'].'"'.$selected.'>'.$eca['eca_nom'].'</option>';
  }
}

function affiche_themes () {
  global $themes_evs;
  $cls = count ($themes_evs) > 1 ? '' : ' style="display: none"';
  echo '<tr'.$cls.'>';
  echo '<th>Thématiques :</th>';
  echo '<td colspan="4">';
  liste_themes ();
  echo '</td></tr>';
}

function affiche_types () {
  global $etys, $droit_modif, $evs;
  $cls = $evs['ety_id'] ? ' style="display: none"' : '';
  echo '<tr'.$cls.'>';
  echo '<th><label for="eca_id">Type : </label></th>';
  echo '<td colspan="4"><select id="ety_id"'.($droit_modif ? '' : ' disabled').'>';
  liste_types ();
  echo '</select></td>';
  echo '</tr>';
}

function liste_types () {
  global $etys, $ety, $eca_id_defaut, $categories_evs;
  if (count ($etys) > 1)
    echo '<option value=""></option>';
  $ancien_eca = 0;
  foreach ($etys as $et) {
    $selected = $et['ety_id'] == $ety['ety_id'] ? ' selected' : '';
    if ($et['eca_id'] != $ancien_eca) {
      if ($ancien_eca) {
	echo '</optgroup>';
      }
      $ancien_eca = $et['eca_id'];      
      foreach ($categories_evs as $cevs) {
	if ($cevs['eca_id'] == $et['eca_id']) {
	  echo '<optgroup label="'.$cevs['eca_nom'].'">';
	  break;
	}
      }
    }
    echo '<option value="'.$et['ety_id'].'"'.$selected.'>'.$et['ety_intitule'].'</option>';
  }
  echo '</optgroup>';
}

function liste_participants () {
  global $base, $participants, $entites, $droit_modif;
  $classe = $droit_modif ? 'participant' : 'participant_ro';
  foreach ($entites as $entite) {
    $found = false;
    $str = '<div style="margin: 10px 0"><span class="participants" id="participants-'.$entite['ent_code'].'">'.$entite['ent_libelle'].' : ';
    if (count ($participants)) {
      foreach ($participants as $participant) {
	$per_id = $participant['per_id'];
	$personne = $base->personne_get ($_SESSION['token'], $per_id);
	if ($personne['ent_code'] == $entite['ent_code']) {
	  $found = true;
	  $str .= ' <span id="participant_'.$per_id.'" class="'.$classe.'"><nobr><span>'.$base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'prenom').' '.$base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'nom').'</span></nobr></span>';
	}
      }
    } else {
      // Si on crée une event depuis une fiche 
      if (isset ($_GET['per_id'])) {
	$per_id = $_GET['per_id'];
	$personne = $base->personne_get ($_SESSION['token'], $per_id);
	if ($entite['ent_code'] == $personne['ent_code'])
	  $str .= ' <span id="participant_'.$_GET['per_id'].'" class="'.$classe.'"><nobr><span>'.$base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'prenom').' '.$base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'nom').'</span></nobr></span>';
      }
    }
    $str .= '</span>';
    if (true || $found)
      echo $str;
    if ($droit_modif)
      echo '<span class="ajout_participant" id="ajout_participant_'.$entite['ent_code'].'">Ajouter</span>';
    echo '</div>';
  }
}

function liste_ressources () {
  global $base, $ressources, $droit_modif;
  $classe = $droit_modif ? 'ressource' : 'ressource_ro';
  $str = '<div class="ressources">';
  if (count ($ressources)) {
    foreach ($ressources as $ressource) {
      $res_id = $ressource['res_id'];
      $str .= ' <span id="ressource_'.$res_id.'" class="'.$classe.'"><nobr><span>'.$ressource['res_nom'].'</span></nobr></span>';
    }
  }
  $str .= '</div>';
  echo $str;
}

function liste_themes () {
  global $base, $themes, $themes_evs, $droit_modif;
  echo '<span id="secteur_event_list_themes">';
  $s = $themes;
  $classe = 'secteur_event';
  if (count ($themes_evs) == 1) {
    $s = $themes_evs;
    $classe = 'secteur_event_ro';
  }
  if (!$droit_modif) {
    $classe = 'secteur_event_ro';
  }
  foreach ($s as $secteur) {    
    echo ' <span id="secteur_event_'.$secteur['sec_id'].'" class="'.$classe.'"><nobr><span>'.$secteur['sec_nom'].'</span></nobr></span>';
  }
  echo '</span>';
  if ($droit_modif && count ($themes_evs) > 1) {
    echo ' <span id="ajout_secteur_event_theme"><nobr>Ajouter une thématique</nobr></span>';
  }
}

function affiche_intitule () {
  global $doc, $eve, $etys;
  if (!$doc && count ($etys) == 1 && !$etys[0]['ety_intitule_individuel']) {
    echo $etys[0]['ety_intitule'];
  } else {
    echo $eve['eve_intitule'];
  }
}
?>
