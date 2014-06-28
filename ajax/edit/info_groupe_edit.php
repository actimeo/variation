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
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');

require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/enums.inc.php');
require ('../../inc/localise.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$ing_id = $_POST['ing_id'];
$ing = $base->meta_info_groupe_get($_SESSION['token'], $ing_id);
$cycle = $ing['ing__groupe_cycle'];

$info = $base->meta_info_get ($_SESSION['token'], $ing['inf_id']);
$type = $info['inf__groupe_type'];
$secteur1 = $base->meta_secteur_get_par_code ($_SESSION['token'], $type);
$soustype = $info['inf__groupe_soustype'];
$etas = $base->etablissement_liste ($_SESSION['token'], NULL, $type, $base->order('cat_id'), $base->order ('eta_nom'));
$etas = filtre_etas ($etas, $type, $soustype);
$grps = $base->groupe_filtre ($_SESSION['token'], $type, NULL, NULL, NULL, $base->order ('grp_nom'));


if (isset ($_POST['peg_id'])) {
  $peg_id = $_POST['peg_id'];
  $peg = $base->personne_groupe_info ($_SESSION['token'], $peg_id);
} else if (isset ($_POST['per_id'])) {
  $per_id = $_POST['per_id'];
  $peg = NULL;
}
?>
<script type="text/javascript" src="/jquery/grpadd/jquery.grpadd.js"></script>
<!--link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" /-->
<script type="text/javascript">
$(document).ready (function () {
    $("#editdlg .datepicker").datepicker ({
	showOn: "button",
	buttonImage: "/Images/datepicker.png",
	buttonImageOnly: true,
	showButtonPanel: true,
	changeYear: true,
	showWeek: true,
	gotoCurrent: true
    });
    $("#peg_save").button({icons: {primary:'ui-icon-disk'}}).click (on_peg_save_click);
    $("#peg_eta_id").change (function () {
	var eta_id = $(this).val();
	$.getJSON ("/ajax/etablissement_get.php", { prm_token: $("#token").val(), prm_eta_id: eta_id, output: 'json2' }, function (ret) {
	    if (ret.cat_id) {
	      $("#grp_ajout").hide();
	    } else {
	      $("#grp_ajout").show();
	    }
	  });
	    
	$.post ('/ajax/edit/groupe_liste.php', {
	    prm_secteur: $("#sec_code").val(),
	    prm_soustype: $("#soustype").val(),
	    prm_eta_id: eta_id
	}, function (data) {
	    var soustype = $("#soustype").val();
	    $("#peg_grp_id").empty();
	    if (data) {
	      $.each (data, function (idx, val) {
		  $("#peg_grp_id").append ('<option value="'+val.grp_id+'">'+val.grp_nom+'</option>');
		});
	    }
	});
    });
    $("#eta_ajout").click (on_eta_ajout_click);
    $("#grp_ajout").click (on_grp_ajout_click);
});

function on_peg_save_click () {
    var per_id = $("#per_id").val();
    var inf_id = $("#inf_id").val();
    var peg_id = $("#peg_id").val();    
    if (!$("#peg_grp_id").val()) {
      alert ('Vous devez renseigner le champ '+$("#label_groupe").text());
      return;
    }
    if ($("#peg_a_cycle").val() != 'off' && !$("#peg_cycle_statut").val()) {
      alert ('Vous devez renseigner un statut');
      return;
    }
    if (peg_id) {
	$.post('/ajax/edit/personne_groupe_update.php', {
	  prm_token: $("#token").val(),
	    prm_peg_id: peg_id,
	    prm_grp_id: $("#peg_grp_id").val(),
	    prm_debut: $("#peg_debut").val(),
	    prm_fin: $("#peg_fin").val(),
	    prm_notes: $("#peg_notes").val(),
	    prm_cycle_statut: $("#peg_cycle_statut").val(),
	    prm_cycle_date_demande: $("#peg_cycle_date_demande").val(),
	    prm_cycle_date_demande_renouvellement: $("#peg_cycle_date_demande_renouvellement").val(),
	    prm__hebergement_chambre: $("#peg__hebergement_chambre").val(),
	    prm__decideur_financeur: $("#peg__decideur_financeur").val()
	}, function () {
	    location.reload ();	    
	});
    }
    else if (per_id) {
	$.post('/ajax/edit/personne_groupe_ajoute.php', {
	  prm_token: $("#token").val(),
	    prm_per_id: per_id,
	    prm_grp_id: $("#peg_grp_id").val(),
	    prm_debut: $("#peg_debut").val(),
	    prm_fin: $("#peg_fin").val(),
	    prm_notes: $("#peg_notes").val(),
	    prm_cycle_statut: $("#peg_cycle_statut").val(),
	    prm_cycle_date_demande: $("#peg_cycle_date_demande").val(),
	    prm_cycle_date_demande_renouvellement: $("#peg_cycle_date_demande_renouvellement").val(),
	    prm__hebergement_chambre: $("#peg__hebergement_chambre").val(),
	    prm__decideur_financeur: $("#peg__decideur_financeur").val()
	}, function () {
	    location.reload ();    
	});
    }
}

function on_eta_ajout_click () {
  $("#dlg").load('/dlgs/nouveletab.php?s=<?= $secteur1['sec_id'] ?>', function () {
      $("#dlg_ed_erreur_intitule").hide ();
      $("#dlg_ed_intitule").focus ();
      $("#dlg").dialog({
	modal: true,
	    width: 'auto',
	    title: 'Nouvel établissement',
	    buttons: {
	    "Créer" : on_creer_click
	      }
	});
      //      $("#dlg").dialog({ width: 'auto' });
    });  
}
function on_creer_click () {
    var intitule = $("#dlg_ed_intitule").val();
    if (intitule.length == 0) {
	$("#dlg_ed_erreur_intitule").show ();
	return;
    }
    var secteurs = new Array ();
    $("#dlg_ed_secteurs input:checked").each (function () {
	var id = $(this).attr('id');
	secteurs.push (id.substr (15));
    });
    $.post('/ajax/etablissement_new.php', { prm_intitule: intitule, prm_secteurs: secteurs},
	   function (new_grp_id) {
	     $("#peg_eta_id").append ('<option value="'+new_grp_id+'">'+intitule+'</option>');
	     $("#peg_eta_id").val (new_grp_id);
	     $("#dlg").dialog ('close');
	   });
}

function on_grp_ajout_click () {
  var eta_id = $("#peg_eta_id").val();
  if (eta_id <= 0) {
    alert ("Vous devez d'abord renseigner le champ "+$("#label_etab").text());
    return;
  }
  $("#dlg").grpAdd ({ 
    title: 'Ajout '+$("#label_groupe").text(), 
	eta_id: eta_id, 
	inf_id: $("#inf_id").val(),
	secteur: <?= $secteur1['sec_id'] ?>,
	return: function (new_grp_id, new_nom) {
	  $("#peg_grp_id").append('<option value="'+new_grp_id+'">'+new_nom+'</option>');
	  $("#peg_grp_id").val (new_grp_id);
        }
    });
}
</script>
<div id="dlg"></div>
<input type="hidden" id="sec_code" value="<?= $type ?>"></input>
<input type="hidden" id="soustype" value="<?= $soustype ?>"></input>
<input type="hidden" id="peg_id" value="<?= $peg_id ?>"></input>
<input type="hidden" id="per_id" value="<?= $per_id ?>"></input>
<input type="hidden" id="inf_id" value="<?= $info['inf_id'] ?>"></input>

<?php 
if (!localise_par_code_secteur ('info_groupe_date_debut', $type)
    && !localise_par_code_secteur ('info_groupe_date_fin', $type)) {
  echo 'Erreur : Les traductions de date_debut et date_fin ne doivent pas être vides ensemble.';
  exit;
}
?>

<table width="100%" class="editgroupe">
  <tr><th colspan="4">Général</th></tr>
  <tr>
  <td id="label_etab" width="100"><?= localise_par_code_secteur ('info_groupe_etablissement', $type) ?></td>
    <td colspan="3"><?php liste_etabs ($etas, $peg) ?> <span id="eta_ajout">Ajouter</span></td>
  </tr>
  <tr>
    <td id="label_groupe"><?= localise_par_code_secteur ('info_groupe_groupe', $type) ?></td>
    <td colspan="3"><?php liste_groupes ($grps, $peg) ?> <span id="grp_ajout">Ajouter</span></td>
  </tr>

  <tr>
<?php if (localise_par_code_secteur ('info_groupe_date_debut', $type)) { ?>
    <td><?= localise_par_code_secteur ('info_groupe_date_debut', $type) ?></td>
    <td><input id="peg_debut" type="text" size="10" maxlength="10" class="datepicker" value="<?php echo $peg['peg_debut'] ?>"></input></td>
<?php } else {?>
    <input type="hidden" id="peg_debut" value=""></input>
<?php } ?>

<?php if (localise_par_code_secteur ('info_groupe_date_fin', $type)) { ?>
    <td><?= localise_par_code_secteur ('info_groupe_date_fin', $type) ?></td>
    <td><input id="peg_fin" type="text" size="10" maxlength="10" class="datepicker" value="<?php echo $peg['peg_fin'] ?>"></input></td>
<?php } else {?>
    <input type="hidden" id="peg_fin" value=""></input>
<?php } ?>
  </tr>

<?php if ($cycle) { ?>
  <tr><th colspan="4">Cycle</th></tr>
  <tr>
    <td>Statut</td>
    <td>
      <select id="peg_cycle_statut">
	<?= liste_statuts ($cycle_statuts, $peg['peg_cycle_statut']) ?>
      </select>
    </td>
  </tr>
  <tr>
<?php if (localise_par_code_secteur ('info_groupe_date_demande', $type)) { ?>
    <td><?= localise_par_code_secteur ('info_groupe_date_demande', $type) ?></td>
    <td>
      <input type="text" id="peg_cycle_date_demande" size="10" maxlength="10" class="datepicker" value="<?= $peg['peg_cycle_date_demande'] ?>"></input>
    </td>
<?php } else {?>
    <input type="hidden" id="peg_cycle_date_demande" value=""></input>
<?php } ?>

<?php if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) { ?>
    <td><?= localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type) ?></td>
    <td>
      <input type="text" id="peg_cycle_date_demande_renouvellement" size="10" maxlength="10" class="datepicker" value="<?= $peg['peg_cycle_date_demande_renouvellement'] ?>"></input>
    </td>
<?php } else {?>
    <input type="hidden" id="peg_cycle_date_demande_renouvellement" value=""></input>
<?php } ?>
  </tr>
<?php } else {?>
<input type="hidden" id="peg_a_cycle" value="off"></input>
<input type="hidden" id="peg_cycle_statut" value=""></input>
<input type="hidden" id="peg_cycle_date_demande" value=""></input>
<input type="hidden" id="peg_cycle_date_demande_renouvellement" value=""></input>
<?php } ?>

<?php if ($type == 'hebergement') { ?>
  <tr><th colspan="4">Hébergement</th></tr>
  <tr>
    <td>Chambre</td>
    <td colspan="3"><input type="text" id="peg__hebergement_chambre" value="<?= $peg['peg__hebergement_chambre'] ?>"></input></td>
<?php } else {?>
<input type="hidden" id="peg__hebergement_chambre" value=""></input>
<?php } ?>

<?php if ($type == 'decideur') { ?>
  <tr><th colspan="4">Décision de prise en charge</th></tr>
  <tr>
    <td>Financeur</td>
    <td colspan="3"><select id="peg__decideur_financeur"><?= liste_financeurs ($peg['peg__decideur_financeur']); ?></select></td>
<?php } else {?>
<input type="hidden" id="peg__decideur_financeur" value=""></input>
<?php } ?>

  <tr><th colspan="4">Notes</th></tr>
  <tr>
    <td colspan="4">
      <textarea cols="80" rows="5" id="peg_notes"><?= $peg['peg_notes'] ?></textarea>
    </td>
  </tr>
</table>

<div style="padding-top: 10px; text-align: center"><button id="peg_save">
<?php if ($peg_id) {
  echo 'Mettre à jour';
} else {
  echo 'Enregistrer';
} ?>
</button></div>

<?php
function liste_etabs ($etas, $peg) {
  echo '<select id="peg_eta_id"><option value=""></option>';
  if (count ($etas)) {
    foreach ($etas as $eta) {
      if ($peg)
	$selected = $eta['eta_id'] == $peg['eta_id'] ? ' selected' : '';
      else
	$selected = $eta['eta_id'] == $_SESSION['eta_id'] ? ' selected' : '';
      echo '<option value="'.$eta['eta_id'].'"'.$selected.'>'.$eta['eta_nom'].'</option>';
    }
  }
  echo '</select>';
}

function liste_groupes ($grps, $peg) {
  echo '<select id="peg_grp_id">';
  if (count ($grps)) {
    foreach ($grps as $grp) {
      if ($peg && $grp['eta_id'] != $peg['eta_id'])
        continue;
      if (!$peg && $grp['eta_id'] != $_SESSION['eta_id'])
        continue;
      $selected = $grp['grp_id'] == $peg['grp_id'] ? ' selected' : '';
      echo '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
    }
  }
  echo '</select>';
}

function liste_statuts ($statuts, $peg_cycle_statut) {
  echo $peg_cycle_statut;
  echo '<option value=""></option>';
  foreach ($statuts as $k => $statut) {
    $selected = $k == $peg_cycle_statut ? ' selected' : '';
    echo '<option value="'.$k.'"'.$selected.'>'.$statut.'</option>';
  }
}

function liste_financeurs ($eta_id) {
  global $base;
  $secteur_financeur = $base->meta_secteur_get_par_code ($_SESSION['token'], 'financeur');
  $financeurs = $base->etablissement_dans_secteur_liste ($_SESSION['token'], false, $secteur_financeur['sec_id']);
  echo '<option value="">Choisissez un financeur</option>';
  foreach ($financeurs as $financeur) {
    $selected = $financeur['eta_id'] == $eta_id ? ' selected' : '';
    echo '<option value="'.$financeur['eta_id'].'"'.$selected.'>'.$financeur['eta_nom'].'</option>';
  }
}
?>
