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
// Dialogue d'édition d'un document
require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/enums.inc.php');
require ('../inc/pgprocedures.class.php');

$doc_id = $_GET['doc'];
$dos_id = $_GET['dos'];

// per_id est passé en argument lors de l'ajout d'un document 
// à partir d'une fiche usager (per_id = per_id_usager)

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if ($doc_id) {
  $doc = $base->document_document_get ($_SESSION['token'], $doc_id);
}

$dos = $base->document_documents_get ($_SESSION['token'], $dos_id);
$secteurs_dos = $base->document_documents_secteur_liste_details_etab ($_SESSION['token'], $dos_id, $_SESSION['eta_id']);
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

?>
<script type="text/javascript" src="/jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/uploader.js"></script>
<script type="text/javascript" src="/js/all.js"></script>
<script type="text/javascript">
$(document).ready (function () {
    $(".doc_statut").hide ();
    $(".doc_statut_"+$("#doc_statut").val()).show ();
    $("#doc_statut").change (on_doc_statut_change);
    $(".doc_responsable").click (on_doc_responsable_click);
    $(".doc_responsable span").click (function () { return false; });
    $(".secteur_event").click (on_secteur_event_click);
    $(".secteur_event span").click (function () { return false; });
    $("#doc_secteur_ajoute").click (on_doc_secteur_ajoute_click);
    $(".doc_usager").click (on_doc_usager_click);
    $(".doc_usager span").click (function () { return false; });
    $("#doc_usager_ajoute").click (on_doc_usager_ajoute_click);
    $("#doc_save").click (on_doc_save_click);
    $("#doc_supprimer").click (on_doc_supprimer_click);
    $("#doc_fichier").click (on_doc_fichier_click);
    $("#doc_fichier span a").click (function (e) { e.stopPropagation (); });
    $("#doc_save").button ({icons: {primary:'ui-icon-disk'}});
    $("#doc_supprimer").button ({icons: {primary:'ui-icon-close'}});
});

function color_rows () {
    $(".tabledlg tr:visible").removeClass("even"); 
    $(".tabledlg tr:visible").removeClass("odd"); 
    $(".tabledlg tr:visible:even").addClass("even"); 
    $(".tabledlg tr:visible:odd").addClass("odd");
}

function on_doc_statut_change () {
    $(".doc_statut").hide ();
    $(".doc_statut_"+$("#doc_statut").val()).show ();    
    color_rows ();
}

function on_doc_responsable_click () {
    $("#dlg2").participantSelect ({
	url: '/ajax/personne_cherche.php',
	title: 'Sélection du responsable',
	type: [ 'personnel' ],
	return: function (id, type, nom) {
	    $(".doc_responsable").attr('id', 'per_id_responsable_'+id);
	    $(".doc_responsable span").html (nom);
	}
    });
}

function on_secteur_event_click () {
    if (confirm ('Vous allez supprimer cette thématique pour ce document. Continuer ?')) {
	$(this).remove ();
	affiche_types();
    }
}

function on_doc_secteur_ajoute_click () {
    $("#dlg2").secteurSelect ({
      'title': 'Sélection d\'un thème',
	  'url': '/ajax/document_documents_secteur_liste_details_etab.php?prm_token='+$("#token").val()+'&prm_dos_id='+$("#dos_id").val()+'&prm_eta_id='+$("#eta_id").val()+'&output=json',
	'return': function (id, nom) {
	    $("#doc_secteurs").append ('<span class="secteur_event" id="doc_sec_'+id+'"><nobr><span>'+nom+'</span></nobr></span>');
	    $(".secteur_event").unbind('click').click (on_secteur_event_click);
	    $(".secteur_event span").unbind('click').click (function () { return false; });
	    affiche_types();
	}
    });
}

function affiche_types () {
    var dty = $("#dty_id").val();
    var sec_ids = new Array ();
    $(".secteur_event").each (function () {
	sec_ids.push ($(this).attr('id').substr (8));	
    });
    $("#dty_id")
	.empty()
	.append ('<option value=""></option>');
    if (sec_ids.length) {
      $.getJSON('/ajax/document_document_type_liste_par_sec_ids.php', { prm_token: $("#token").val(), prm_sec_ids: sec_ids, prm_eta_id: $("#eta_id").val(), output: 'json' }, function (data) {
	    $.each (data, function (idx, val) {
		if (val.dty_id == dty)
		    $("#dty_id").append ('<option selected value="'+val.dty_id+'">'+val.dty_nom+'</option>');
		else
		    $("#dty_id").append ('<option value="'+val.dty_id+'">'+val.dty_nom+'</option>');
	    });
	});
    }
}

function on_doc_usager_click () {
    if (confirm ('Vous allez supprimer cet usager pour ce document. Continuer ?')) {
	$(this).remove ();
    }
}

function on_doc_usager_ajoute_click () {
    $("#dlg2").participantSelect ({
	'title': "Sélection d'un usager",
	'url': '/ajax/personne_cherche.php',
	type: [ 'usager' ],
	  multi: true,
	  'return': function (per_type, pers) {
	  $(pers).each (function () {
	    $("#doc_usagers").append ('<span class="doc_usager" id="doc_per_'+this.id+'"><nobr><span>'+this.text+'</span></nobr></span> ');
	    $(".doc_usager").click (on_doc_usager_click);
	    $(".doc_usager span").click (function () { return false; });
	    });
	}
      });
}

function on_doc_save_click () {
    if (!$("#doc_titre").val().length) {
	alert ('Vous devez indiquer un titre');
	return;	
    }
    if (!$(".doc_usager").length) {
	alert ('Vous devez ajouter au moins un usager');
	return;
    }
    if (!$(".secteur_event").length && !$(".secteur_event_ro").length) {
	alert ('Vous devez ajouter au moins une thématique');
	return;
    }
    $.post('/ajax/edit/document_document_save.php', {
        prm_token: $("#token").val(),
	prm_doc_id: $("#doc_id").val(),
	prm_per_id_responsable: $(".doc_responsable").attr('id').substr (19),
	prm_dty_id: $("#dty_id").val(),
	prm_titre: $("#doc_titre").val(),
	prm_statut: $("#doc_statut").val(),
	prm_date_obtention: $("#doc_date_obtention").val(),
	prm_date_realisation: $("#doc_date_realisation").val(),
	prm_date_validite: $("#doc_date_validite").val(),
	  prm_description: $("#doc_description").val()
    }, function (data) {
	var new_doc_id = $(data).find('results').text();
	var per_ids = new Array ();
	$(".doc_usager").each (function () {
	    per_ids.push ($(this).attr('id').substr (8));
	});
	$.getJSON ('/ajax/edit/document_document_usager_save.php', {
	  prm_token: $("#token").val(),
	    prm_doc_id: new_doc_id,
	    prm_per_ids: per_ids
	}, function () {
	    var sec_ids = new Array ();
	    $(".secteur_event").each (function () {
		sec_ids.push ($(this).attr('id').substr (8));	
	    });
	    $(".secteur_event_ro").each (function () {
		sec_ids.push ($(this).attr('id').substr (8));	
	    });
	    $.getJSON ('/ajax/edit/document_document_secteur_save.php', {
	      prm_token: $("#token").val(),
		prm_doc_id: new_doc_id,
		prm_sec_ids: sec_ids
	    }, function () {
		if ($("#doc_fichier_upload").length > 0 && $("#doc_fichier_upload").val()) {
		    var up = new uploader ($("#doc_fichier_upload").get(0), {
			url: '/ajax/edit/postDocFichier.php?doc_id='+new_doc_id,
			progress: function (ev) { $("#progress").html(Math.floor((ev.loaded/ev.total)*100)+'%'); $("#progress").css('width',$("#progress").html()); },
			error: function (ev) {},
			  success: function (ev) {  location.reload (); }
		    });
		    $("#progress").show();
		    up.send ();
		} else {
		  location.reload ();
		}
	    });	    
	});
    });
}

function on_doc_supprimer_click () {
    if (confirm ('Vous allez définitivement supprimer ce document. Continuer ?')) {
      $.getJSON('/ajax/edit/document_document_supprime.php', { prm_token: $("#token").val(), prm_doc_id: $("#doc_id").val() }, function () {
	    location.reload ();
	});
    }
}

function on_doc_fichier_click () {
    if (confirm ('Vous allez définitivement supprimer ce fichier. Continuer ?')) {
      $.getJSON ('/ajax/edit/document_document_set_fichier.php', { prm_token: $("#token").val(), prm_doc_id: $("#doc_id").val(), prm_fichier: '' },
		   function () {
		       $("#div_doc_fichier").html ('<input type="file" name="doc_fichier_upload" id="doc_fichier_upload"></input><br/><span id="progress" id="progress" style="display: none">0%</span>');
		   });
    }
}
</script>
<input type="hidden" id="doc_id" value="<?= $doc['doc_id'] ?>"></input>
<input type="hidden" id="uti_id" value="<?= $_SESSION['uti_id'] ?>"></input>
<input type="hidden" id="eta_id" value="<?= $_SESSION['eta_id'] ?>"></input>
<table class="tabledlg">
<tr>
<th>Thèmes&nbsp;: </th>
<td><?= affiche_secteurs (); ?></td>
</tr>
<tr>
<th>Type&nbsp;: </th>
<td><select id="dty_id" <?php echo $droit_modif ? '' : ' disabled'; ?>><?= affiche_type ($doc['dty_id']); ?></select></td>
</tr>
<tr>
<th>Intitulé&nbsp;: </th>
<td><input type="text" size="40" id="doc_titre" value="<?= $doc['doc_titre'] ?>" <?php echo $droit_modif ? '' : ' disabled'; ?>></input></td>
</tr>
<tr>
<th>Usagers&nbsp;: </th>
<td><span id="doc_usagers"><?= affiche_usagers () ?></span>
  <?php if ($droit_modif) { ?>
<span id="doc_usager_ajoute">Ajouter un usager</span>
   <?php } ?>
</td>
</tr>
<tr>
<th>Responsable&nbsp;: </th>
<td><span id="per_id_responsable_<?= $doc['per_id_responsable'] ?>" class="<?php echo $droit_modif ? 'doc_responsable' : 'doc_responsable_ro' ?>"><span><?= affiche_responsable (); ?></span></span></td>
</tr>
<tr>
<th>Statut&nbsp;: </th>
<td><select id="doc_statut" <?php echo $droit_modif ? '' : ' disabled'; ?>><?= liste_statuts ($doc['doc_statut']) ?></select></td>
</tr>
<tr class="doc_statut doc_statut_3">
<th>Pièce jointe&nbsp;: </th>
<td>
<?php affiche_fichier (); ?>
</td>
</tr>
<tr class="doc_statut doc_statut_1 doc_statut_2">
<th>Date limite d'obtention&nbsp;: </th>
<td><input type="text" size="8" <?php if ($droit_modif) { echo 'class="datepicker"'; } ?> id="doc_date_obtention" value="<?= $doc['doc_date_obtention'] ?>" <?php echo $droit_modif ? '' : ' disabled'; ?>></input></td>
</tr>
<tr class="doc_statut doc_statut_3">
<th>Date de réalisation&nbsp;: </th>
<td><input type="text" size="8" <?php if ($droit_modif) { echo 'class="datepicker"'; } ?> id="doc_date_realisation" value="<?= $doc['doc_date_realisation'] ?>" <?php echo $droit_modif ? '' : ' disabled'; ?>></input></td>
</tr>
<tr class="doc_statut doc_statut_3">
<th>Date limite de validité&nbsp;: </th>
<td><input type="text" size="8" <?php if ($droit_modif) { echo 'class="datepicker"'; } ?>  id="doc_date_validite" value="<?= $doc['doc_date_validite'] ?>" <?php echo $droit_modif ? '' : ' disabled'; ?>></input></td>
</tr>
<tr>
<th>Nota Bene&nbsp;: </th>
<td><span class="doc_description"><textarea id="doc_description" cols="40" rows="5" <?php echo $droit_modif ? '' : ' disabled'; ?>><?= $doc['doc_description'] ?></textarea></td>
</tr>
<?php 
if ($doc_id) {
echo '<tr><th>Création&nbsp;:</th><td>';
if ($doc['doc_date_creation']) {
  echo 'le '.substr ($doc['doc_date_creation'], 0, 16);
}
if ($doc['uti_id_creation']) {
  $uti_creation = $base->utilisateur_get ($_SESSION['token'], $doc['uti_id_creation']);
  $nom_createur = $base->personne_get_libelle ($_SESSION['token'], $uti_creation['per_id']);
  echo ' par '.$nom_createur;
}
echo '</td></tr>';
echo '<tr><th>Dernière modification&nbsp;:</th><td>';
echo '</td></tr>';
}
?>
<tr><td colspan="2" align="center">
<?php 
if ($doc_id) { 
  if ($droit_modif) {
    echo '<button id="doc_save">Mettre à jour</button>';
  }
  if ($droit_suppression) {
    echo '<button id="doc_supprimer">Supprimer</button>';
  }
} else { 
  echo '<button id="doc_save">Enregistrer</button>';
}
?>
</td></tr>
</table>

<?php
function liste_statuts ($val) {
  global $doc_statut;
  foreach ($doc_statut as $k => $v) {
    $selected = $val == $k ? 'selected': '';
    echo '<option value="'.$k.'"'.$selected.'>'.$v.'</option>';
  }
}

function affiche_responsable () {
  global $doc, $base;
  $responsable = $base->personne_get_libelle ($_SESSION['token'], $doc['per_id_responsable']);
  echo $responsable;
}

function affiche_secteurs () {
  global $doc, $base, $secteurs_dos, $droit_modif;
  $secteurs = $base->document_document_secteur_liste_details ($_SESSION['token'], $doc['doc_id']);
  $s = $secteurs;
  $classe = 'secteur_event';
  if (count ($secteurs_dos) == 1) {
    $s = $secteurs_dos;
    $classe = 'secteur_event_ro';
  }
  if (!$droit_modif) {
    $classe = 'secteur_event_ro';
  }

  echo '<span id="doc_secteurs">';
  if (count ($s)) {
    foreach ($s as $secteur) {
      echo '<span class="'.$classe.'" id="doc_sec_'.$secteur['sec_id'].'"><nobr><span>'.$secteur['sec_nom'].'</span></nobr></span> ';
    }
  }
  echo '</span>';
  if ($droit_modif && count ($secteurs_dos) > 1) {
    echo ' <span id="doc_secteur_ajoute">Ajouter une thématique</span>';
  }
}

function affiche_type ($val) {
  global $doc, $base, $secteurs_dos;
  if ($doc) {
    $dtys = $base->document_document_type_liste ($_SESSION['token'], $doc['doc_id'], $_SESSION['eta_id']);
  } else {
    if (count ($secteurs_dos) == 1) {
      $dtys = $base->document_document_type_liste_par_sec_ids ($_SESSION['token'], array ($secteurs_dos[0]['sec_id']), $_SESSION['eta_id']);
    }
  }
  echo '<option value=""></option>';
  foreach ($dtys as $dty) {
    $selected = $dty['dty_id'] == $val ? ' selected' : '';
    echo '<option value="'.$dty['dty_id'].'"'.$selected.'>'.$dty['dty_nom'].'</option>';    
  }
}

function affiche_usagers () {
  global $doc, $base, $droit_modif;
  $classe = $droit_modif ? 'doc_usager' : 'doc_usager_ro';
  if (!$doc['doc_id'] && $_GET['per_id']) {
    $libelle = $base->personne_get_libelle ($_SESSION['token'], $_GET['per_id']);
    echo '<span class="'.$classe.'" id="doc_per_'.$_GET['per_id'].'"><nobr><span>'.$libelle.'</span></nobr></span> ';
  } else {
    $usagers = $base->document_document_usager_liste ($_SESSION['token'], $doc['doc_id']);
    if (count ($usagers)) {
      foreach ($usagers as $usager) {
        $libelle = $base->personne_get_libelle ($_SESSION['token'], $usager['per_id_usager']);
        echo '<span class="'.$classe.'" id="doc_per_'.$usager['per_id_usager'].'"><nobr><span>'.$libelle.'</span></nobr></span> ';
     }
    }
  }
}

function affiche_fichier () {
  global $doc, $droit_modif;
  echo '<div id="div_doc_fichier">';
  if ($doc['doc_fichier']) {
    echo '<span id="'.($droit_modif ? 'doc_fichier' : 'doc_fichier_ro').'"><span><a target="_blank" href="/doc_fichiers/'.$doc['doc_id'].'/'.$doc['doc_fichier'].'">'.$doc['doc_fichier'].'</a></span></span>';
  } else if ($droit_modif) {
    echo '<input type="file" name="doc_fichier_upload" id="doc_fichier_upload"></input><br/><span id="progress" id="progress" style="display: none">0%</span>';
  }
  echo '</div>';
}
?>
