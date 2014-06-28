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
require ('inc/enums.inc.php');
global $nlines, $count, $docs, $p, $droit_modif;
$nlines = 15;
$p = isset ($_GET['p']) ? $_GET['p'] : 1;

$grps_prise_en_charge = $base->utilisateur_groupe_liste($_SESSION['token']);
if (count ($grps_prise_en_charge) == 1 && !isset ($_GET['rech_grp_id'])) {
  $_GET['rech_grp_id'] = $grps_prise_en_charge[0]['grp_id'];
}

if (isset ($per_id)) {
  $droit_modif = $sousmenu['sme_droit_modif'];
  echo '<div id="dlg"></div><div id="dlg2"></div>';
  $count1 = $base->document_document_liste ($_SESSION['token'], $dos_id, $per_id, 
					    NULL, NULL,
					    NULL, NULL,
					    $base->count());
  $count = $count1[0]['count'];
  $docs = $base->document_document_liste ($_SESSION['token'], $dos_id, $per_id, 
					  NULL, NULL,
					  NULL, NULL,
					  $base->order('doc_titre'),
					  $base->limit ($nlines, ($p-1)*$nlines));    
} else {
  $droit_modif = $tsm['tsm_droit_modif'];
    $count1 = $base->document_document_liste ($_SESSION['token'], $dos_id, NULL, 
					      $_GET['documents_date_debut'],
					      $_GET['documents_date_fin'],
					      $_GET['rech_grp_id'], $_GET['rech_per_id'],
					      $base->count());
    $count = $count1[0]['count'];
    $docs = $base->document_document_liste ($_SESSION['token'], $dos_id, NULL,
					    $_GET['documents_date_debut'],
					    $_GET['documents_date_fin'],
					    $_GET['rech_grp_id'], $_GET['rech_per_id'],
					    $base->order('doc_titre'),
					    $base->limit ($nlines, ($p-1)*$nlines));
}
?>
<script type="text/javascript" src="/jquery/participantselect/jquery.participantselect.js"></script>
<link href="/jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready (function () {
    $(".docedit").click (on_docedit_click);
    $("#doc_ajoute").click (on_doc_ajoute_click);
    $("#documents_filtres").buttonset ();
    $("#documents_filtres input").click (function () { $("#options").submit(); });

    $(".filtre_usager").click (on_filtre_usager_click);
    $(".filtre_usager span").click (function () { return false; });
    $("#filtre_usager_ajoute").click (on_filtre_usager_ajoute_click);
});

function on_filtre_usager_click () {
    $(this).remove ();
    $("#options").submit ();
}
function on_filtre_usager_ajoute_click () {
    $("#dlg").participantSelect ({
	title: "Sélection d'un usager",
	url: '/ajax/personne_cherche.php',
	type: ['usager'],
	return: function (id, type, nom) {
	    $("#filtre_usagers").append ('<span class="filtre_usager"><span>'+nom+'</span><input type="hidden" name="rech_per_id[]" value="'+id+'"></input></span>');
	    $("#options").submit ();
	}
    });
}


function on_docedit_click () {
    var doc_id = $(this).attr('id').substr (4);
    $("#dlg").hide().load ('/dlgs/editdoc.php?dos='+$("#dos_id").val()+'&doc='+doc_id+'&tsm_id='+$("#tsm_id").val()+'&sme_id='+$("#sme_id").val(), function () {
	$("#dlg").dialog ({
	    modal: true,
	    width: 'auto',
	    autoResize: true,
	    resizable: false,
	    title: "Édition document"
	});
	color_rows ();
    });
}

function on_doc_ajoute_click () {
  var args = '';
  if ($("#per_id").val()) {
    args = '&per_id='+$("#per_id").val();
  }
  args += '&tsm_id='+$("#tsm_id").val();
  args += '&sme_id='+$("#sme_id").val();
  $("#dlg").hide().load ('/dlgs/editdoc.php?dos='+$("#dos_id").val()+args, function () {
	$("#dlg").dialog ({
	    modal: true,
	    width: 'auto',
	    autoResize: true,
	    resizable: false,
	    title: "Ajout d'un document"
	});
	if (!$(".secteur_event_ro").length) {
	  on_doc_secteur_ajoute_click ();
	}
	color_rows ();
    });
}
</script>
<input type="hidden" id="dos_id" value="<?= $dos_id ?>"></input>
<input type="hidden" id="tsm_id" value="<?= $tsm['tsm_id'] ?>"></input>
<input type="hidden" id="sme_id" value="<?= $sousmenu['sme_id'] ?>"></input>
<?php
    if($tsm['tsm_id']!=''){
?>
<form id="options" method="GET" action="/">
    <fieldset>
        <legend>Recherche</legend>
    <input type="hidden" name="tsm" value="<?php echo $_GET['tsm'] ?>" />
    <div class="choix_vue" id="filtre">
        <div id="documents_filtres">
        <?php
            $usager_sel = isset ($_GET['documents_filtre']) && $_GET['documents_filtre'] == 'usager' ? ' checked' : '';
            $groupe_sel = $usager_sel ? '' : ' checked';
        ?>
            <input id="documents_filtre_groupe" type="radio" name="documents_filtre" value="groupe"<?php echo $groupe_sel;?>><label for="documents_filtre_groupe">Groupe</label>
            <input id="documents_filtre_usager" type="radio" name="documents_filtre" value="usager"<?php echo $usager_sel; ?>><label for="documents_filtre_usager">Usagers</label>
        </div>
        <fieldset>
        <?php
            if ($groupe_sel) {
        ?>
        <h3>Usagers du groupe</h3>
        <select name="rech_grp_id">
            <option value="">(tous groupes)</option><?php echo liste_groupes ()?>
        </select>
        <?php
            } else {
                // rech_per_id
        ?>
        <h3>Usagers</h3>
        <div id="filtre_usagers">
        <?php        
            if (isset ($_GET['rech_per_id']) && count ($_GET['rech_per_id'])) {
                foreach ($_GET['rech_per_id'] as $rech_per_id) {
		  $nom = $base->personne_get_libelle ($_SESSION['token'], $rech_per_id);
        ?>
            <span class="filtre_usager">
                <span><?php echo $nom;?></span>
                <input type="hidden" name="rech_per_id[]" value="<?php echo $rech_per_id ?>"/>
            </span>
        <?php
                }
            }
        ?>
        </div>
            <span id="filtre_usager_ajoute">Ajouter un usager</span>
        <?php
            }
        ?>
        </fieldset>
    </div>
    <div class="choix_vue" id="periode">
        <h2>Période</h2>
        <?php 
            $document_debut = isset ($_GET['documents_date_debut']) ? $_GET['documents_date_debut'] : '';
            $document_fin = isset ($_GET['documents_date_fin']) ? $_GET['documents_date_fin'] : '';
        ?>
        <h3>Du </h3>        
        <input name="documents_date_debut" type="text" size="10" class="datepicker" value="<?php echo $document_debut; ?>" />
        <br/>
        <h3>Au </h3>
        <input name="documents_date_fin" type="text" size="10" class="datepicker" value="<?php echo $document_fin; ?>" />
    </div>      
    <div class="choix_vue maj">
        <input type="submit" name="recherchego" value="Mettre à jour" />
    </div>
    </fieldset>
</form>
<?php
    }
?>
<br />
<table class="tabledocs" width="100%">
    <tr>
        <th>Titre</th>
        <th>Statut</th>
        <th>Usagers</th>
        <th>Type</th>
        <th>Limite<br/>obtention</th>
        <th>Réalisation</th>
        <th>Validité</th>
        <th>Responsable</th>
        <th>&nbsp;</th>
    </tr>
  <?= affiche_docs (); ?>
<tr><td class="navigtd" align="center" colspan="9">
  <div class="navigdiv">
  <?php affiche_navigation (); ?>
  </div>
</td></tr>
  <?php if ($droit_modif) {?>
<tr><td colspan="9" align="center"><input type="button" style="margin-top: 10px" id="doc_ajoute" value="Ajouter un document"></input></td></tr>
   <?php } ?>
</table>

<?php
function affiche_docs () {  
  global $docs, $doc_statut, $base, $droit_modif;
  if (count ($docs)) {
    $parite = 0;
    foreach ($docs as $doc) {
      $type = $base->document_document_type_get ($_SESSION['token'], $doc['dty_id']);
      $responsable = $base->personne_get_libelle ($_SESSION['token'], $doc['per_id_responsable']);
      echo '<tr class="'.($parite % 2 ? 'pair' : 'impair').'">';
      if ($doc['doc_statut'] == 3 && $doc['doc_fichier']) {
	echo '<td><a target="_blank" href="/doc_fichiers/'.$doc['doc_id'].'/'.$doc['doc_fichier'].'"><img src="/Images/icons/trombone.png"></img></a>'.$doc['doc_titre'].'</td>';
      } else {
	echo '<td>'.$doc['doc_titre'].'</td>';
      }
      echo '<td>'.$doc_statut[$doc['doc_statut']].'</td>';
      echo '<td>';
      $usagers = $base->document_document_usager_liste ($_SESSION['token'], $doc['doc_id']);
      if (count ($usagers)) {
	echo '<ul class="listeusagers">';
	foreach ($usagers as $usager) {
	  echo '<li><span class="lienpersonne" id="lienpersonne_usager_'.$usager['per_id_usager'].'">'.$base->personne_get_libelle($_SESSION['token'], $usager['per_id_usager']).'</span></li>';
	}
	echo '</ul>';
      }
      echo '</td>';
      echo '<td>'.$type['dty_nom'].'</td>';
      echo '<td>'.$doc['doc_date_obtention'].'</td>';
      echo '<td>'.$doc['doc_date_realisation'].'</td>';
      echo '<td>'.$doc['doc_date_validite'].'</td>';
      echo '<td><span class="lienpersonne" id="lienpersonne_personnel_'.$doc['per_id_responsable'].'">'.$responsable.'</span></td>';
      echo '<td><span class="docedit" id="doc_'.$doc['doc_id'].'">'.($droit_modif ? 'Éditer' : 'Détails').'</span></td>';
      $parite++;
    }
  } else {
    echo '<tr class="impair"><td align="center" colspan="9"><i>Aucun document enregistré</i></td></tr>';
  }
}

function affiche_navigation () {
  global $p, $docs, $nlines, $count;
  $npages = ceil($count / $nlines);
  if ($npages < 1)
      $npages = 1;
  
  $imagesPath = '/Images/navig';
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
  
}

function link_page ($p) {
  global $per_id;
  if ($per_id) {
    return '/edit.php'.'?'.http_build_query (array_merge (array ('sme' => $_GET['sme'],
								 'ent' => $_GET['ent'],
								 'per' => $_GET['per']),
							  array ('col' => $_GET['col'],
								 'sort' => $_GET['sort'],
								 'p' => $p
								 )));
  } else {
    return '/'.'?'.http_build_query (array_merge (array ('tsm' => $_GET['tsm']),
						  array ('col' => $_GET['col'],
							 'sort' => $_GET['sort'],
							 'p' => $p
							 )));
  }  
}

function sup_col_gauche () {
}

function liste_groupes () {
  global $base, $dos_id, $grps_prise_en_charge;

  $ret = "";
  $ret .= '<optgroup label="Groupes de prise en charge">';
  /*  if (count ($grps_prise_en_charge) == 1 && !isset ($_GET['rech_grp_id'])) {
    $_GET['rech_grp_id'] = $grps_prise_en_charge[0]['grp_id'];
    }*/
  foreach ($grps_prise_en_charge as $grp_pec) {
    $selected = isset ($_GET['rech_grp_id']) && $grp_pec['grp_id'] == $_GET['rech_grp_id'] ? ' selected' : '';
    $ret .= '<option value="'.$grp_pec['grp_id'].'"'.$selected.'>'.$grp_pec['grp_nom'].'</option>';    
  }
  $ret .= '</optgroup>';

  $grps = $base->document_documents_groupe_liste ($_SESSION['token'], $dos_id);
  $etas = array();  
  foreach ($grps as $grp) {
    $etas[$grp['eta_id']] = $grp['eta_nom'];
  }
  //  $ret = '';
  if (count ($etas) > 1) {
    
    // Affiche d'abord l'étab de l'utilisateur
    $ancien_eta = 0;
    foreach ($grps as $grp) {
      if ($grp['eta_id'] == $_SESSION['eta_id']) {
	if (!$ancien_eta) {
	  $ret .= '<optgroup label="'.$grp['eta_nom'].'">';
	  $ancien_eta = $grp['eta_id'];
	}
	$selected = isset ($_GET['rech_grp_id']) && $grp['grp_id'] == $_GET['rech_grp_id'] ? ' selected' : '';
	$ret .= '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
      }
    }

    // Affiche tous les autres étabs
    foreach ($grps as $grp) {
      if ($grp['eta_id'] == $_SESSION['eta_id'])
	continue;
      if ($grp['eta_id'] != $ancien_eta) {
	if ($ancien_eta) {
	  $ret .= '</optgroup>';
	}
	$ret .= '<optgroup label="'.$grp['eta_nom'].'">';	
      }
      $ancien_eta = $grp['eta_id'];
      $selected = (isset ($_GET['rech_grp_id']) && $grp['grp_id'] == $_GET['rech_grp_id']) ? ' selected' : '';
      $ret .= '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
    }
  } else {  
    foreach ($grps as $grp) {
      $selected = $grp['grp_id'] == $_GET['rech_grp_id'] ? ' selected' : '';
      $ret .= '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
    }
  }
  return $ret;
}
?>
