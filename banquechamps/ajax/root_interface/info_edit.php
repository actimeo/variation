<?php
require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$info = $base->meta_info_get ($_GET['id']);
$ina_aide = $base->meta_info_aide_get ($info['inf_id']);

$types = $base->meta_infos_type_liste ();
foreach ($types as $type) {
  $thetypes[$type['int_code']] = $type;
  /*  if ($type['int_id'] == $info['int_id']) {
    $thetype = $type;
    break;
    }*/
}

$selections = $base->meta_selection_liste ();
$secteurs = $base->meta_secteur_liste ();
$entites = $base->meta_entite_liste ();
?>
<script type="text/javascript">
var inf_id_edited = <?= $_GET['id'] ?>;
var types = new Array();
$(".champ_type").hide ();
$(".type_<?= $info['int_id'] ?>").show ();
$(document).ready (function () {
    $.getJSON('ajax/meta_infos_type_liste.php?output=json', {}, function (data) {
	$.each (data, function (idx, val) {
	    types[val.int_id] = val;
	});
    });
    $("#int_id").change (on_int_id_change);
    $("#inf_libelle").change (on_inf_libelle_change);
    $("#inf_code").change (on_inf_code_change);
    $("#inf_enregistrer").click (on_inf_enregistrer_click);
    $("#inf__selection_code").change (on_inf__selection_code_change);
    $("#inf__selection_code_edit").click (on_inf__selection_code_edit_click);
    $("#inf__groupe_type").change (on_inf__groupe_type_change);
    $("#inf__date_echeance").click (on_inf__date_echeance_click);

    on_inf__date_echeance_click ();
})

function on_int_id_change () {
    var type = $(this).val();
    $(".champ_type").hide ();
    $(".type_"+type).show ();
    if (types[type].int_multiple) {
	$("#inf_multiple").removeAttr('disabled');
    } else {
	$("#inf_multiple").removeAttr('checked');
	$("#inf_multiple").attr('disabled', 'disabled');
    }
    if (types[type].int_historique) {
	$("#inf_historique").removeAttr('disabled');
    } else {
	$("#inf_historique").removeAttr('checked');
	$("#inf_historique").attr('disabled', 'disabled');
    }
}

function on_inf_libelle_change () {
    if ($("#inf_code").val() == '') {
	$.post('ajax/pour_code.php', { str: $(this).val() }, function (data) {	
	    $("#inf_code").val ($(data).find('results').text());
	});
    }
}

function on_inf_code_change () {
    var exp = new RegExp ('[^a-z0-9_]', 'g');
    $("#inf_code").val ($("#inf_code").val().replace (exp, ''));
}

function on_inf_enregistrer_click () {
    $.post('ajax/root_interface/info_edit_save.php', {
	inf_id: inf_id_edited ,
	int_id: $("#int_id").val(),
	inf_code: $("#inf_code").val(),
	inf_libelle: $("#inf_libelle").val(),
	inf_libelle_complet: $("#inf_libelle_complet").val(),
	ina_aide: $("#ina_aide").val(),
	inf__textelong_nblignes: $("#inf__textelong_nblignes").val(),
	inf__selection_code: $("#inf__selection_code").val(),
	inf_etendu: $("#inf_etendu").attr('checked'),
	inf_historique: $("#inf_historique").attr('checked'),
	inf_multiple: $("#inf_multiple").attr('checked'),
	inf__groupe_type: $("#inf__groupe_type").val(),
	inf__groupe_soustype: $("#inf__groupe_soustype").val(),
	inf__contact_filtre: $("#inf__contact_filtre").val(),
	inf__metier_secteur: $("#inf__metier_secteur").val(),
	inf__contact_secteur: $("#inf__contact_secteur").val(),
	inf__etablissement_interne: $("#inf__etablissement_interne").attr('checked'),
	inf__date_echeance: $("#inf__date_echeance").attr('checked'),
	inf__date_echeance_icone: $("#inf__date_echeance_icone").val(),
	inf__date_echeance_secteur: $("#inf__date_echeance_secteur").val(),
	inf__etablissement_secteur: $("#inf__etablissement_secteur").val(),
	dirid: $("#dirid").val()
    }, function (data) {
	if (data == 'ERR') {
	    alert("Erreur d'enregistrement. Vérifiez que le code n'est pas déjà utilisé.");
	} else {
	    $("#dlg").dialog ('close');
	    $("#listechamps").jstree('refresh', -1);
	}
    });
}

function on_inf__selection_code_change () {
    if ($(this).val () == '...') {
	$("#dlg2").load ("ajax/root_interface/selection_edit.php?id=0");
	$("#dlg2").dialog ({
	    width: 'auto',
	    resizable: false,
	    modal: true,
	    title:"Ajouter une sélection"
	});
    }
}

function on_inf__selection_code_edit_click () {    
    if ($("#inf__selection_code").val () != '...' && $("#inf__selection_code").val () != '') {    
	$("#dlg2").load ("ajax/root_interface/selection_edit.php?id="+$("#inf__selection_code").val ());
	$("#dlg2").dialog ({
	    width: 'auto',
	    resizable: false,
	    modal: true,
	    title:"Editer une sélection"
	});
    }
}

function on_inf__groupe_type_change () {
    $.post("ajax/meta_secteur_type_liste_par_code.php", { 
	prm_sec_code: $(this).val(),
	output: 'json'}, function (data) {
	    $("#inf__groupe_soustype").empty();
	    $("#inf__groupe_soustype").append('<option value=""></option>');
	    $.each (data, function (idx, val) {
		$("#inf__groupe_soustype").append('<option value="'+val.set_id+'">'+val.set_nom+'</option>');
	    });
	});   
}

function on_inf__date_echeance_click () {
    if ($("#inf__date_echeance").is (':checked')) {
	$(".tr_date_echeance_plus").show();
    } else {
	$(".tr_date_echeance_plus").hide();
    }
}
</script>
<input type="hidden" id="dirid" value="<?= $_GET['dirid'] ?>"></input>
<table width="100%" cellpadding="5">
  <tr>
    <td width="70">Type&nbsp;:</td><td><select id="int_id"> <?= liste_types ($types, $info['int_id']); ?></select></td>
  </tr>
  <tr>
    <td>Libellé&nbsp;:</td><td><input type="text" id="inf_libelle" size="30" value="<?= $info['inf_libelle'] ?>"></input></td>
  </tr>
  <tr>
    <td>Libellé complet&nbsp;:</td><td><input type="text" id="inf_libelle_complet" size="30" value="<?= $info['inf_libelle_complet'] ?>"></input></td>
  </tr>
  <tr>
    <td>Code&nbsp;:</td><td><input type="text" id="inf_code" size="30" value="<?= $info['inf_code'] ?>" <?= $_GET['id'] != 0 ? 'disabled' : '' ?>></input></td>
  </tr>
  <tr>
    <td>Aide&nbsp;:</td><td><textarea id="ina_aide" cols="50" rows="9"><?= $ina_aide ?></textarea></td>
  </tr>
  <tr>
    <td></td><td>
      <input type="checkbox" id="inf_etendu" <?= $info['inf_etendu'] ? "checked" :"" ?>></input><label for="inf_etendu">Etendu</label>
      <input type="checkbox" id="inf_historique" <?= $info['inf_historique'] ? "checked" :"" ?>></input><label for="inf_historique">Historique</label>
      <input type="checkbox" id="inf_multiple" <?= $info['inf_multiple'] ? "checked" :"" ?>></input><label for="inf_multiple">Multiple</label>
    </td>
  </tr>
  <tr class="champ_type type_<?= $thetypes['textelong']['int_id'] ?>">
    <td>Nb lignes&nbsp;:</td><td><input type="text" size="3" id="inf__textelong_nblignes" value="<?= $info['inf__textelong_nblignes'] ?>"></input></td>
  </tr>

  <tr class="champ_type type_<?= $thetypes['selection']['int_id'] ?>">
    <td>Sélection&nbsp;:</td><td><select id="inf__selection_code"><option value=""></option><option value="...">Nouveau ...</option><?= liste_selections ($selections, $info['inf__selection_code'])?></select> <button id="inf__selection_code_edit">éditer</button></td>
  </tr>

  <tr class="champ_type type_<?= $thetypes['groupe']['int_id'] ?>">
    <td>Secteur&nbsp;:</td><td><select id="inf__groupe_type"><option value=""></option><?= liste_secteurs ($secteurs, $info['inf__groupe_type']) ?></select></td>
  </tr>
  <tr class="champ_type type_<?= $thetypes['groupe']['int_id'] ?>">
  <td>Type&nbsp;:</td><td><select id="inf__groupe_soustype"><?= liste_secteur_types ($info['inf__groupe_type'], $info['inf__groupe_soustype']); ?></select></td>
  </tr>
  
  <tr class="champ_type type_<?= $thetypes['contact']['int_id'] ?>">
    <td>Vers&nbsp;:</td><td><select id="inf__contact_filtre"><?= liste_entites ($entites, $info['inf__contact_filtre']) ?></select></td>
  </tr>
  <tr class="champ_type type_<?= $thetypes['contact']['int_id'] ?>">
    <td>Filtre&nbsp;:</td><td><select id="inf__contact_secteur"><?= liste_secteurs ($secteurs, $info['inf__contact_secteur']) ?></select></td>
  </tr>
  
  <tr class="champ_type type_<?= $thetypes['metier']['int_id'] ?>">
    <td>Filtre&nbsp;:</td><td><select id="inf__metier_secteur"><?= liste_entites ($entites, $info['inf__metier_secteur']) ?></select></td>
  </tr>

  <tr class="champ_type type_<?= $thetypes['etablissement']['int_id'] ?>">
    <td></td><td><input type="checkbox" id="inf__etablissement_interne" <?= $info['inf__etablissement_interne'] ? "checked" :"" ?>></input><label for="inf__etablissement_interne">Etablissement (coché) ou Partenaire (non coché)</label></td>
  </tr>
  <tr class="champ_type type_<?= $thetypes['etablissement']['int_id'] ?>">
    <td>Filtre&nbsp;:</td><td><select id="inf__etablissement_secteur"><option value=""></option><?= liste_secteurs ($secteurs, $info['inf__etablissement_secteur']) ?></select></td>
  </tr>

  <tr class="champ_type type_<?= $thetypes['date']['int_id'] ?>">
    <td></td><td><input type="checkbox" id="inf__date_echeance" <?= $info['inf__date_echeance'] ? "checked" :"" ?>></input><label for="inf__date_echeance">Échéance</label></td>
  </tr>

  <tr class="tr_date_echeance_plus champ_type type_<?= $thetypes['date']['int_id'] ?>">
    <td>Icône&nbsp;:</td><td><input type="text" size="30" id="inf__date_echeance_icone" value="<?= $info['inf__date_echeance_icone'] ?>"></input></td>
  </tr>

  <tr class="tr_date_echeance_plus champ_type type_<?= $thetypes['date']['int_id'] ?>">
    <td>Secteur&nbsp;:</td><td><select id="inf__date_echeance_secteur"><option value=""></option><?= liste_secteurs ($secteurs, $info['inf__date_echeance_secteur']) ?></select></td>
  </tr>

  <tr>
    <td colspan="2" align="center"><button id="inf_enregistrer">Enregistrer</button></td>
  </tr>
</table>


<?php
function liste_types ($types, $id) {
  echo '<option value=""></option>';
  foreach ($types as $type) {
    $selected = ($type['int_id'] == $id) ? " selected" : "";
    echo '<option value="'.$type['int_id'].'"'.$selected.'>'.$type['int_libelle'].'</option>';
  }
}

function liste_selections ($selections, $id) {
  foreach ($selections as $selection) {
    $selected = ($selection['sel_id'] == $id) ? " selected" : "";
    echo '<option value="'.$selection['sel_id'].'"'.$selected.'>'.$selection['sel_libelle'].'</option>';
  }
}

function liste_secteurs ($secteurs, $code) {
  foreach ($secteurs as $secteur) {
    $selected = ($secteur['sec_code'] == $code) ? " selected" : "";
    echo '<option value="'.$secteur['sec_code'].'"'.$selected.'>'.$secteur['sec_nom'].'</option>';
  }  
}

function liste_secteur_types ($secteur, $set_id) {
  global $base;
  $types = $base->meta_secteur_type_liste_par_code ($secteur);
  echo '<option value=""></option>';
  if (count ($types)) {
    foreach ($types as $type) {
      $selected = $type['set_id'] == $set_id ? ' selected' : '';
      echo '<option value="'.$type['set_id'].'"'.$selected.'>'.$type['set_nom'].'</option>';
    }
  }
}

function liste_entites ($entites, $code) {
  foreach ($entites as $entite) {
    $selected = ($entite['ent_code'] == $code) ? " selected" : "";
    echo '<option value="'.$entite['ent_code'].'"'.$selected.'>'.$entite['ent_libelle'].'</option>';
  }  
}
?>
