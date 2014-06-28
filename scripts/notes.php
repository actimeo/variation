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
define ('NPAGES', 10);

if (isset ($_REQUEST['go'])) {
  $_SESSION['grp'] = $_REQUEST['grp'];
  $_SESSION['tripar'] = $_REQUEST['tripar'];
  header('Location: '.$_SERVER['REQUEST_URI']);
  exit;
} 

?>

<script type="text/javascript" src="/jquery/participantselect/jquery.participantselect.js"></script>
<link href="/jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
   $(document).ready (function () {
       $("#not_usager_add").change (on_not_usager_add_change);
       $(".not_usager > nobr > span").click (function () { return false; }); // stop propagation
       $(".not_usager").click (on_not_usager_click);

       $("#not_dest_add").change (on_not_dest_add_change);
       $(".not_dest > nobr > span").click (function () { return false; }); // stop propagation
       $(".not_dest").click (on_not_dest_click);

       $("#not_destaction_add").change (on_not_destaction_add_change);
       $(".not_destaction > nobr > span").click (function () { return false; }); // stop propagation
       $(".not_destaction").click (on_not_destaction_click);

       $("#not_desttheme_add").change (on_not_desttheme_add_change);
       $(".not_desttheme > nobr > span").click (function () { return false; }); // stop propagation
       $(".not_desttheme").click (on_not_desttheme_click);

       $("#envoi_note").click (on_envoi_note_click);
       $(".note_del")
	 .button ({ icons: { primary: "ui-icon-close" }, text: false })
	 .click (on_note_del_click);
       $(".note_fw")
	 .button({ icons: { primary: "ui-icon-arrowthick-1-e" }, text: false })
	 .click (on_note_fw_click);

       $("#btn_newnote")
	 .button({ icons: { primary: 'ui-icon-plusthick' }})
	 .click (function () {
	     $(this).hide ();
	     $(".newnote").slideDown();
	   });
     });

function on_not_usager_add_change () {
  var per_id = $(this).val();
  var per_libelle = $("#not_usager_add option:selected").text();
  if (!per_id.length) {
    return;
  }  else if (per_id == 'autre') {
  <?php if ($per_id) { ?>
  $("#editdlg").participantSelect ({
      <?php } else { ?>
  $("#dlg").participantSelect ({
    <?php } ?>
      url: '/ajax/personne_cherche.php',
	  title: 'Sélection d\'un usager',
	  type: ['usager'],
	  multi: true,
    return: function (per_type, pers) {
      $(pers).each (function () {
	  if (!$("#usagers_list #usager_"+this.id).length) {
	    $("#usagers_list select").before ('<span class="not_usager" id="usager_'+this.id+'"><nobr><span>'+this.text+'</span></nobr></span> ');
	    $("#usager_"+this.id+" > nobr > span").click (function () { return false; }); // stop propagation
	    $("#usager_"+this.id+"").click (on_not_usager_click);
	  }	  
	});
    }
    });
  }  else if (per_id == 'tous') {
    $("#not_usager_add option").each (function (idx, opt) {
	var theid = $(opt).val();
	if (!$("#usagers_list #usager_"+theid).length) {
	  var thelibelle = $(opt).text();
	  if (theid.length && theid != 'autre' && theid != 'tous') {
	    $("#usagers_list select").before ('<span class="not_usager" id="usager_'+theid+'"><nobr><span>'+thelibelle+'</span></nobr></span> ');
	    $("#usager_"+theid+" > nobr > span").click (function () { return false; }); // stop propagation
	    $("#usager_"+theid+"").click (on_not_usager_click);
	  }
	}
      });
  } else {
    if (!$("#usagers_list #usager_"+per_id).length) {
      $("#usagers_list select").before ('<span class="not_usager" id="usager_'+per_id+'"><nobr><span>'+per_libelle+'</span></nobr></span> ');
      $("#usager_"+per_id+" > nobr > span").click (function () { return false; }); // stop propagation
      $("#usager_"+per_id+"").click (on_not_usager_click);
    }
  } 
  $("#not_usager_add").val ("");
}

function on_not_usager_click () {
  $(this).remove ();
}


function on_not_dest_add_change () {
  var per_id = $(this).val();
  var per_libelle = $("#not_dest_add option:selected").text();
  if (!per_id.length) {
    return;
  }  else if (per_id == 'autre') {
  <?php if ($per_id) { ?>
  $("#editdlg").participantSelect ({
      <?php } else { ?>
  $("#dlg").participantSelect ({
    <?php } ?>
      url: '/ajax/personne_cherche.php',
	  title: 'Sélection d\'un destinataire',
	  type: ['personnel'],
	  return: function (id, type, nom) {
	  if (!$("#dests_list #dest_"+id).length) {
	    $("#dests_list select").before ('<span class="not_dest" id="dest_'+id+'"><nobr><span>'+nom+'</span></nobr></span> ');
	    $("#dest_"+id+" > nobr > span").click (function () { return false; }); // stop propagation
	    $("#dest_"+id+"").click (on_not_dest_click);
	  }	  
	}
      });
  } else {
    if (!$("#dests_list #dest_"+per_id).length && !$("#dests_list #destaction_"+per_id).length) {
      $("#dests_list select").before ('<span class="not_dest" id="dest_'+per_id+'"><nobr><span>'+per_libelle+'</span></nobr></span> ');
      $("#dest_"+per_id+" > nobr > span").click (function () { return false; }); // stop propagation
      $("#dest_"+per_id+"").click (on_not_dest_click);
    }
  } 
  $("#not_dest_add").val ("");
}

function on_not_dest_click () {
  $(this).remove ();
}

function on_not_destaction_add_change () {
  var per_id = $(this).val();
  var per_libelle = $("#not_destaction_add option:selected").text();
  if (!per_id.length) {
    return;
  }  else if (per_id == 'autre') {
  <?php if ($per_id) { ?>
  $("#editdlg").participantSelect ({
      <?php } else { ?>
  $("#dlg").participantSelect ({
    <?php } ?>
      url: '/ajax/personne_cherche.php',
	  title: 'Sélection d\'un destinataire',
	  type: ['personnel'],
	  return: function (id, type, nom) {
	  if (!$("#destsaction_list #destaction_"+id).length) {
	    $("#destsaction_list select").before ('<span class="not_destaction" id="destaction_'+id+'"><nobr><span>'+nom+'</span></nobr></span> ');
	    $("#destaction_"+id+" > nobr > span").click (function () { return false; }); // stop propagation
	    $("#destaction_"+id+"").click (on_not_destaction_click);
	  }	  
	}
      });
  } else {
    if (!$("#destsaction_list #destaction_"+per_id).length && !$("#dests_list #dest_"+per_id).length) {
      $("#destsaction_list select").before ('<span class="not_destaction" id="destaction_'+per_id+'"><nobr><span>'+per_libelle+'</span></nobr></span> ');
      $("#destaction_"+per_id+" > nobr > span").click (function () { return false; }); // stop propagation
      $("#destaction_"+per_id+"").click (on_not_destaction_click);
    }
  } 
  $("#not_destaction_add").val ("");
}

function on_not_destaction_click () {
  $(this).remove ();
}

function on_not_desttheme_add_change () {
  var the_id = $(this).val();
  var the_nom = $("#not_desttheme_add option:selected").text();
  if (!the_id.length) {
    return;
  } else {
    if (!$("#deststheme_list #desttheme_"+the_id).length) {
      $("#deststheme_list select").before ('<span class="not_desttheme" id="desttheme_'+the_id+'"><nobr><span>'+the_nom+'</span></nobr></span> ');
      $("#desttheme_"+the_id+" > nobr > span").click (function () { return false; }); // stop propagation
      $("#desttheme_"+the_id+"").click (on_not_desttheme_click);
    }
  } 
  $("#not_desttheme_add").val ("");
}

function on_not_desttheme_click () {
  $(this).remove ();
}

function on_envoi_note_click () {
  var objet = $("#not_objet").val ();
  var date_evenement = $("#not_date_evenement").val ()+':00';
  var texte = $("#not_texte").val ();
  if (!texte.length) {
    alert ("Vous devez saisir un texte pour la note.");
    return;
  }
  if (!date_evenement.length) {
    alert ("Vous devez saisir une date pour la note.");
    return;
  }
  var usagers = new Array ();
  var dests = new Array ();
  var destsaction = new Array ();
  var deststheme = new Array ();
  var groupes = new Array ();
  $(".not_usager").each (function (idx, obj) {
      usagers.push ($(obj).attr('id').substr (7));
    });
  $(".not_dest").each (function (idx, obj) {
      dests.push ($(obj).attr('id').substr (5));
    });
  $(".not_destaction").each (function (idx, obj) {
      destsaction.push ($(obj).attr('id').substr (11));
    });
  $(".not_desttheme").each (function (idx, obj) {
      deststheme.push ($(obj).attr('id').substr (10));
    });

  if (!usagers.length) {
    alert ("Vous devez saisir au moins un usager.");
    return;
    //    usagers = '';
  }
  if (!dests.length)
    dests = '';
  if (!destsaction.length)
    destsaction = '';
  if (!deststheme.length)
    deststheme = '';
  if (!groupes.length)
    groupes = '';
  $.post ('/ajax/edit/notes_note_ajoute.php',  { 
	prm_token: $("#token").val(),
	prm_date_evenement: date_evenement,
	prm_objet: objet, 
	prm_texte: texte,
	prm_eta_id_auteur: $("#eta_id").val(),
	prm_usagers: usagers,
	prm_dests: dests,
	prm_destsaction: destsaction,
	prm_deststheme: deststheme,
	prm_groupes: groupes
	}, function () { 
      location.reload ();
      //      $("#form_envoi_note").submit ();
    });
}

function on_note_del_click () {
  var b = $(this);
  if (confirm ('Vous allez définitivement supprimer cette note. Voulez-vous continuer ?')) {
    $.post ('/ajax/edit/notes_note_supprime.php', { prm_token: $("#token").val(), prm_not_id: $(this).attr('id').substr (9) }, function () {
	b.parent('td').parent('tr').remove ();
      });
  }
}

function on_note_fw_click () {
  var notid = $(this).attr('id').substr (8);
  <?php if ($per_id) { ?>
  $("#editdlg").participantSelect ({
      <?php } else { ?>
  $("#dlg").participantSelect ({
    <?php } ?>
    url: '/ajax/personne_cherche.php',
	title: 'Sélection d\'un destinataire',
	  type: ['personnel'],
	  return: function (id, type, nom) {
	$.post('/ajax/edit/notes_note_destinataire_ajoute_forward_pour_info.php', 
	       { prm_token: $("#token").val(), prm_not_id: notid, prm_per_id: id }, function () {
		 location.reload ();
	       });
      }
    });  
}
</script>
<?php
    echo '<input type="hidden" id="uti_id" value="'.$_SESSION['uti_id'].'"></input>';
    echo '<input type="hidden" id="eta_id" value="'.$_SESSION['eta_id'].'"></input>';
  affiche_mesnotes ();

function link_page ($p) {
  parse_str($_SERVER['QUERY_STRING'], $aargs);
  $aargs['p'] = $p;
  return $_SERVER['STRING_NAME'].'?'.http_build_query ($aargs);
}

function affiche_mesnotes () {
  global $base, $per_id, $tsm, $sousmenu;
  // Formulaire de saisie
  echo '<button type="button" id="btn_newnote">Ajouter une note</button>';
  echo '<br />';
  echo '<br />';
  echo '<div class="newnote">';
  echo '<form id="form_envoi_note" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
  echo '<fieldset><legend>Nouvelle note</legend>';
  echo '<table width="100%"><tr><td valign="top">';
  echo '<fieldset id="usagers_list"><legend>Usagers</legend>';
  if ($per_id) {
    echo '<span class="not_usager" id="usager_'.$per_id.'"><nobr><span>'.$base->personne_get_libelle ($_SESSION['token'], $per_id).'</span></nobr></span> ';
  }
  echo '<select id="not_usager_add"><option value="">Ajouter ...</option>';
  $usagers = $base->utilisateur_usagers_liste ($_SESSION['token'], $grp_choisi, true, $base->order('libelle'));  
  echo '<option value="tous">Tous</option>';
  foreach ($usagers as $usager) {
    echo '<option value="'.$usager['per_id'].'">'.$usager['libelle'].'</option>';
  }
  echo '<option value="autre">Autre ...</option>';
  echo '</select>';
  echo '</fieldset>';
  echo '</td>';
  echo '<td valign="top">';
  echo '<fieldset><label for="not_date_evenement">Date événement : </label>';  
  echo '<input type="text" id="not_date_evenement" name="not_date_evenement" size="15" class="datetimepicker" value="'.date ('d/m/Y H:i').'"></input>';
  echo '<br><label for="not_objet">Objet (facultatif) : </label><br>';
  echo '<input type="text" id="not_objet" name="not_objet" size="40"></input>';
  echo '<br>Texte de la note :<br><textarea id="not_texte" name="not_texte" rows="3" style="width: 100%; resize: none"></textarea>';
  
  echo '</fieldset></td>';
  echo '<td valign="top">';
  echo '<fieldset id="dests_list"><legend>Destinataires pour information</legend>';
  echo '<select id="not_dest_add"><option value="">Ajouter ...</option>';
  $dests = $base->note_destinataire_derniers_par_utilisateur ($_SESSION['token']);
  foreach ($dests as $dest) {
    echo '<option value="'.$dest['per_id'].'">'.$dest['libelle'].'</option>';
  }
  echo '<option value="autre">Autre ...</option>';
  echo '</select>';
  echo '</fieldset>';

  echo '<fieldset id="destsaction_list"><legend>Destinataires pour action</legend>';
  echo '<select id="not_destaction_add"><option value="">Ajouter ...</option>';
  foreach ($dests as $dest) {
    echo '<option value="'.$dest['per_id'].'">'.$dest['libelle'].'</option>';
  }
  echo '<option value="autre">Autre ...</option>';
  echo '</select>';
  echo '</fieldset>';

  $themes = $base->notes_theme_liste_details ($_SESSION['token'], $_SESSION['por_id'], $base->order('the_nom'));
  echo '<fieldset id="deststheme_list"><legend>Boîtes thématiques</legend>';
  echo '<select id="not_desttheme_add"><option value="">Ajouter ...</option>';  
  foreach ($themes as $theme) {
    echo '<option value="'.$theme['the_id'].'">'.$theme['the_nom'].'</option>';
  }
  echo '</select><br/>';
  if ($per_id) {
    $nos = $base->notes_notes_get ($_SESSION['token'], $sousmenu['sme_type_id']);
  } else {
    $nos = $base->notes_notes_get ($_SESSION['token'], $tsm['tsm_type_id']);
  }
  if ($nos['the_id']) {
    $the = $base->notes_theme_get($_SESSION['token'], $nos['the_id']);
    echo '<span class="not_desttheme" id="desttheme_'.$nos['the_id'].'"><nobr><span>'.$the['the_nom'].'</span></nobr></span> ';
  }
  echo '</fieldset>';
  echo '<br><div style="text-align: center; margin-top: 10px"><input type="button" name="envoi_note" id="envoi_note" value="Enregistrer la note"></input>';

  echo '</td></tr></table>';
  echo '</fieldset>';
  echo "</form>";
  echo '</div>';
  echo '<br />';
  echo '<form method="post" action="'.$_SERVER['REQUEST_URI'].'">';
  echo '<fieldset><legend>Recherche</legend>';
  // Page de pagination
  $p = isset ($_GET['p']) ? $_GET['p'] : '1';
  if ($per_id) {
    $nnotes = $base->notes_note_usager_liste ($_SESSION['token'], $per_id, $sousmenu['sme_type_id'], $base->count());
    $notes = $base->notes_note_usager_liste ($_SESSION['token'], $per_id, $sousmenu['sme_type_id'], $base->order ($_SESSION['tripar'] ? $_SESSION['tripar'] : 'not_date_evenement', 'DESC'), $base->limit (NPAGES, ($p-1)*NPAGES));
  } else {
    $grps = $base->utilisateur_groupe_liste ($_SESSION['token']);
    $grp_choisi = $_SESSION['grp'];
    echo 'Groupe : <select name="grp"><option value=""></option>';
    foreach ($grps as $grp) {
      $selected = $grp['grp_id'] == $grp_choisi ? ' selected' : '';
      echo '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
    }
    echo '</select>';
    $nnotes = $base->notes_note_mesnotes ($_SESSION['token'], $grp_choisi, $tsm['tsm_type_id'], $base->count ());
    $notes = $base->notes_note_mesnotes ($_SESSION['token'], $grp_choisi, $tsm['tsm_type_id'], $base->order ($_SESSION['tripar'] ? $_SESSION['tripar'] : 'not_date_evenement', 'DESC'), $base->limit (NPAGES, ($p-1)*NPAGES));
  }

  echo ' Tri par : <select name="tripar"><option value="not_date_evenement"'.($_SESSION['tripar'] == 'not_date_evenement' ? ' selected': '').'>Date de l\'événement</option><option value="not_date_saisie""'.($_SESSION['tripar'] == 'not_date_saisie' ? ' selected': '').'>Date de soumission</option></select>';
  echo '<input type="submit" name="go" value="OK"></input>';
  echo '</fieldset>';
  echo '</form><br/>';

  echo '<table width="100%" class="t1"><tr><th width="150">Date<br>Expéditeur</th><th width="150">Usagers</th><th>Note</th><th width="150">Destinataires</th><th width="30"></th></tr>';
  $impair = true;
  foreach ($notes as $note) {
    $auteur = $base->utilisateur_prenon_nom ($_SESSION['token'], $note['uti_id_auteur']);    
    $usagers = $base->note_usagers_liste ($_SESSION['token'], $note['not_id']);
    $destinataires = $base->note_destinataires_liste ($_SESSION['token'], $note['not_id']);
    echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
    echo '<td>'.substr ($note['not_date_evenement'], 0, 16).'<br>'.$auteur.'</td>';
    echo '<td>';
    foreach ($usagers as $usager) {
      echo '<span class="lienpersonne" id="lienpersonne_usager_'.$usager['per_id'].'">'.$usager['libelle'].'</span><br>';
    }
    echo '</td>';
    echo '<td>';
    if ($note['not_objet']) {
      echo '<strong>'.$note['not_objet'].'</strong><br>';
    }
    echo '<pre>'.wordwrap ($note['not_texte']).'</pre>';
    echo '</td>';
    echo '<td>';
    foreach ($destinataires as $destinataire) {
      if ($destinataire['nde_supprime']) {
	echo '<s>';
      } else if (($destinataire['nde_pour_action'] && !$destinataire['nde_action_faite']) || 
		 ($destinataire['nde_pour_information'] && !$destinataire['nde_information_lue'])) {
	echo '<b>';
      }
      echo $destinataire['libelle'].' ';
      if ($destinataire['nde_pour_action']) {
	echo '(A)';
      } else if ($destinataire['nde_pour_information']) {
	echo '(I)';
      }
      if ($destinataire['nde_supprime']) {
	echo '</s>';
      } else if (($destinataire['nde_pour_action'] && !$destinataire['nde_action_faite']) || 
		 ($destinataire['nde_pour_information'] && !$destinataire['nde_information_lue'])) {
	echo '</b>';
      }
      echo '<br>';
    }
    echo '</td>';
    echo '<td>';
    echo '<button type="button" id="note_del_'.$note['not_id'].'" class="note_del">Supprimer</button>';
    echo '<button type="button" id="note_fw_'.$note['not_id'].'" class="note_fw">Faire suivre pour information</button>';
    echo '</td>';
    echo '</tr>';
    $impair = !$impair;
  }
  echo '<tr><td class="navigtd" align="center" colspan="5">';
  // Affiche pagination
  $imagesPath = '/Images/navig';
  $nnotes = $nnotes[0]['count'];
  $npages = max (1, ceil($nnotes / NPAGES));
  echo '<div class="navigdiv">';
  if ($p == 1) {
    echo '<img src="'.$imagesPath.'/FirstOff.gif"></img> ';
    echo '<img src="'.$imagesPath.'/PrevOff.gif"></img> ';
  } else {
    echo '<a href="'.link_page (1).'"><img src="'.$imagesPath.'/First.gif"></img></a> ';
    echo '<a href="'.link_page ($p-1).'"><img src="'.$imagesPath.'/Prev.gif"></img></a> ';
  }
  echo '<span class="navign">'.$p." de ".$npages."</span>";
  if ($p == $npages) {
    echo ' <img src="'.$imagesPath.'/NextOff.gif"></img>';
    echo ' <img src="'.$imagesPath.'/LastOff.gif"></img>';
  } else {
    echo ' <a href="'.link_page ($p+1).'"><img src="'.$imagesPath.'/Next.gif"></img></a>';
    echo ' <a href="'.link_page ($npages).'"><img src="'.$imagesPath.'/Last.gif"></img></a>';
  }
  echo '</div>';    
  echo '</td></tr>';
  echo '</table>';

}
?>
