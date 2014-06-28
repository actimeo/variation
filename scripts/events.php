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
<script type="text/javascript" src="/jquery/participantselect/jquery.participantselect.js"></script>
<link href="/jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready (function () {             
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
</script>
<?php if (isset ($_GET['events_vue']) && ($_GET['events_vue'] == 'liste' || $_GET['events_vue'] == 'bilan')) { ?>
<script type="text/javascript">
     $(document).ready (function () {             
         $("#events_vues").buttonset ();
         $("#events_vues input").click (function () { $("#options").submit(); });
         $("#events_filtres").buttonset ();
         $("#events_filtres input").click (function () { $("#options").submit(); });
	 $(".edevent").click (on_edevent_click);
	 $(".edusager").click (on_edusager_click);
	 $(".eddoc").click (on_eddoc_click);
     });

function on_edusager_click (ev) {
    var per_id = $(this).attr('id').substr (6);
    $.get('/ajax/personne_get_libelle.php', { prm_token: $("#token").val(), prm_per_id: per_id, output: 'json2' }, 
	  function (ret) {
	      on_lien_personne ('usager', per_id, ret, !ev.shiftKey);
	  });
}

function on_eddoc_click (ev) {
    var doc_id = $(this).attr('id').substr (6);
    $("#dlg").hide().load ('/dlgs/editdoc.php?doc='+doc_id, function () {
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

function on_edevent_click (ev) {  
    var eve_id = $(this).attr('id').substr (6);
    suppargs = '';
    var val_tsm_id = $("#tsm_id").val();
    var val_sme_id = $("#sme_id").val();
    suppargs += '&tsm_id='+val_tsm_id;    
    suppargs += '&sme_id='+val_sme_id;
    $("#dlg").hide().load ('/dlgs/editevent.php?code='+$("#evs_code").val()+'&eve='+eve_id+suppargs, function () {
	$("#dlg").dialog ({
	    modal: true,
	    width: 600,
	    autoResize: true,
	    resizable: false,
	    title: 'Édition évènement'
	});
    });
}
</script>
<?php } else { ?>
<link rel='stylesheet' type='text/css' href='fullcalendar/fullcalendar.css' />
<script type='text/javascript' src='fullcalendar/fullcalendar.js'></script>
<script type='text/javascript' src='jquery/qtip/qtip.min.js'></script>
<script type="text/javascript">
     $(document).ready (function () {
             
             $("#events_vues").buttonset ();
             $("#events_vues input").click (function () { $("#options").submit(); });

	     $("#events_filtres").buttonset ();
	     $("#events_filtres input").click (function () { $("#options").submit(); });

	     rech_per_ids = new Array ();
	     $("input[name='rech_per_id[]']").each (function () {
	       rech_per_ids.push ($(this).val());
	     });
	     $("#calendar").fullCalendar ({

		   header: {
		       left: 'prev,next today',
		       center: 'title',
		        right: 'month,agendaWeek,agendaDay'
		     },
		   defaultView: 'agendaWeek',
		     eventSources:[ {
			     url: '/ajax/eventsEvents.php',
			     data: {
			         fromCal: true,
				 code: $("#evs_code").val(),
				 per_id: $("#per_id").val(),
				 grp_id: $("#rech_grp_id").val(),
				 per_ids: rech_per_ids,
				 affiche_echeances: $("#affiche_echeances").is(":checked")
			     }
			 }    
			 ],

		     editable: false,

		     eventRender: function (event, element) {
		       if (event.description) {
		         element.qtip ({ content: event.description, 
			                 position: {
  					   corner: {
					     target: 'topMiddle',
					     tooltip: 'bottomMiddle'
					   }
					 },
					 style: {
					   name: 'light',
					   tip: "bottomMiddle"
					 }
			 })
		       }
		       if (event.icone) 
		         element.find('.fc-event-title').prepend ('<img align="top" style="float: left" src="'+event.icone+'"></img> ');
		 },

		 selectable: true,
		 select: function (startDate, endDate, allDay, jsEvent, view) {
		   var val_droit_modif = $("#droit_modif").val();
		   if (!val_droit_modif)
		     return;
		   var suppargs = '';
		   if ($("#per_id").val()) {
		     suppargs += '&per_id='+$("#per_id").val();
                   }
		   var val_tsm_id = $("#tsm_id").val();
		   var val_sme_id = $("#sme_id").val();
		   suppargs += '&tsm_id='+val_tsm_id;
		   suppargs += '&sme_id='+val_sme_id;
		       $("#dlg").load ('/dlgs/editevent.php?code='+$("#evs_code").val()+'&start='+startDate.getTime ()/1000+'&end='+endDate.getTime ()/1000+'&allday='+allDay+suppargs, function () {
		         $("#dlg").dialog ({
				 modal: true,
				 width: 600,
				 autoResize: true,
				 resizable: false,
				 title: 'Nouvel évènement'
			     });
			 if (!$(".secteur_event_ro").length) {
			   on_ajout_secteur_event_theme_click();
			 }
			 });

		 },

		 eventClick: function (event, ev) {
		   var suppargs = '';
		   var val_tsm_id = $("#tsm_id").val();
		   var val_sme_id = $("#sme_id").val();
		   suppargs += '&tsm_id='+val_tsm_id;
		   suppargs += '&sme_id='+val_sme_id;
			 if (event.eve_id) {
			     $("#dlg").hide().load ('/dlgs/editevent.php?code='+$("#evs_code").val()+'&eve='+event.eve_id+suppargs, function () {
			       $("#dlg").dialog ({
				     modal: true,
				     width: 600,
				     autoResize: true,
				     resizable: false,
				     title: 'Édition évènement'
		               });
			     });
			 }  else if (event.per_id) {
			     on_lien_personne ('usager', event.per_id, event.titreTab, !ev.shiftKey);
			 } else if (event.doc_id) {
			     $("#dlg").hide().load ('/dlgs/editdoc.php?doc='+event.doc_id, function () {
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
		     }
		 });		     
	 });
</script>
<?php } ?>
<?php
if (isset ($per_id)) {
  $droit_modif = $sousmenu['sme_droit_modif']; 
  echo '<script src="jquery/js/jquery.ui.datepicker-fr.js" type="text/javascript"></script>';
  echo '<script src="jquery/js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>';
  echo '<div id="dlg"></div><div id="dlg2"></div>';
  echo '<input type="hidden" id="per_id" value="'.$per_id.'"></input>';
  echo '<input type="hidden" id="sme_id" value="'.$sousmenu['sme_id'].'"></input>';
  echo '<input type="hidden" id="tsm_id" value=""></input>';
} else {
  $droit_modif = $tsm['tsm_droit_modif'];
  echo '<input type="hidden" id="sme_id" value=""></input>';
  echo '<input type="hidden" id="tsm_id" value="'.$tsm['tsm_id'].'"></input>';
}
echo '<input type="hidden" id="droit_modif" value="'.$droit_modif.'"></input>';
//echo $droit_modif.'/';
$evs = $base->events_events_get ($_SESSION['token'], $evs_id);
$events_cats = $base->events_categorie_events_liste ($_SESSION['token'], $evs_id);
$depenses = (count ($events_cats) == 1 && $events_cats[0]['eca_code'] == 'depenses');

// Choisit par défaut LE groupe de prise en charge si le seul accessible par l'utilisateur
$grps_prise_en_charge = $base->utilisateur_groupe_liste($_SESSION['token']);
if (!isset ($per_id) && count ($grps_prise_en_charge) == 1 && !isset ($_GET['rech_grp_id'])) {
  $_GET['rech_grp_id'] = $grps_prise_en_charge[0]['grp_id'];
}

if (isset ($_GET['events_vue']) && ($_GET['events_vue'] == 'liste' || $_GET['events_vue'] == 'bilan')) {
  if (!isset ($_GET['events_date_debut'])) {
    $_GET['events_date_debut'] = date ('d/m/Y');
  }
}
    if($_GET['tsm']!=''){
?>
<form id="options" method="GET" action="/">
    <input type="hidden" name="tsm" value="<?php echo $_GET['tsm'] ?>" />
    <fieldset class="events">
        <?php
            $liste_sel = isset ($_GET['events_vue']) && $_GET['events_vue'] == 'liste' ? ' checked' : '';
            $bilan_sel = isset ($_GET['events_vue']) && $_GET['events_vue'] == 'bilan' ? ' checked' : '';
            $grille_sel = ($liste_sel || $bilan_sel) ? '' : ' checked';
        ?>
        <legend>Recherche</legend> 
            <div class="choix_vue" id="filtre">
                <div id="events_filtres">
                    <?php
                    $usager_sel = isset ($_GET['events_filtre']) && $_GET['events_filtre'] == 'usager' ? ' checked' : '';
                    $groupe_sel = $usager_sel ? '' : ' checked';
                    ?>
                    <input id="events_filtre_groupe" type="radio" name="events_filtre" value="groupe" <?php echo $groupe_sel ?> /><label for="events_filtre_groupe">Groupe</label>
                    <input id="events_filtre_usager" type="radio" name="events_filtre" value="usager" <?php echo $usager_sel ?> /><label for="events_filtre_usager">Usagers</label>
                </div>
                <fieldset>
                <?php 
                    if ($groupe_sel) {
                ?>
                <h3>Usagers du groupe</h3>
                <select name="rech_grp_id">
                    <option value="">(tous groupes)</option><?php echo liste_groupes () ?>
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
                        <span><?php echo $nom ?></span>
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
            <?php
            if ($liste_sel || $bilan_sel) {
            ?>
            <div class="choix_vue" id="periode">
                <h2>Période</h2>
                <h3>Du </h3>
                <input name="events_date_debut" type="text" size="9" class="datepicker" value="<?php echo $_GET['events_date_debut'] ?>"/>
                <br />
                <h3>Au </h3>
                <input name="events_date_fin" type="text" size="9" class="datepicker" value="<?php echo $_GET['events_date_fin'] ?>"/>
            </div>
                <?php
                }
                ?>
            <?php
	    if ($liste_sel || $grille_sel) {
                $affiche_echeances = (isset ($_GET['affiche_echeances']) && $_GET['affiche_echeances'] == 'on') ? 'checked' :  '';
            ?>
            <div class="choix_vue">
                <h2>Option</h2>
                <input type="checkbox" id="affiche_echeances" name="affiche_echeances" <?php echo $affiche_echeances ?> />
                <label for="affiche_echeances" style="font-size: 9pt">Afficher début/fin</label>        
            </div> 
	 <?php } ?>
            <div class="choix_vue maj">
                <input type="submit" name="recherchego" value="Mettre à jour" />
            </div>
    </fieldset>
    <fieldset class="events">
        <legend>Type de vue</legend>
        <div class="choix_vue">
            <div id="events_vues"> 
                <p>
                    <input id="events_vue_grille" type="radio" name="events_vue" value="grille" <?php echo $grille_sel?>><label for="events_vue_grille">Agenda</label>
                    <input id="events_vue_liste" type="radio" name="events_vue" value="liste" <?php echo $liste_sel?>><label for="events_vue_liste">Liste</label>
                    <input id="events_vue_bilan" type="radio" name="events_vue" value="bilan" <?php echo $bilan_sel?>><label for="events_vue_bilan">Bilan</label>
                </p>
            </div>
        </div>
    </fieldset>
</form>
<?php
    }
?>
<br/>
<div id="calendar"></div>
<input type="hidden" id="evs_code" value="<?= urlencode ($evs['evs_code']) ?>"></input>
<input type="hidden" id="rech_grp_id" value="<?= isset ($_GET['rech_grp_id']) ? $_GET['rech_grp_id'] : '' ?>" />

<?php
if (isset ($_GET['events_vue']) && $_GET['events_vue'] == 'liste') {
  $nparpage = 20;
  if (!isset ($_GET['events_date_debut'])) {
    $_GET['events_date_debut'] = date ('d/m/Y');
  }
  $startDate = $_GET['events_date_debut'];
  $endDate = $_GET['events_date_fin'];
  $grp_id = $_GET['rech_grp_id'];
  $code = $evs['evs_code'];
  $per_ids = $_GET['rech_per_id'];
  $affiche_echeances = $_GET['affiche_echeances'] == 'on';
  include './ajax/eventsEvents.php';

  // Tri par date de début
  usort ($events, 'sort_by_start_date');

  //  print_r ($events);
  echo '<table  class="tableliste" width="100%"><tr>';
  echo '<th>Début</th>';
  echo '<th>Fin</th>';
  echo '<th>Catégorie > type (thématiques)</th>';
  echo '<th>Thème  >  Intitulé</th>';
  echo '<th>Participants<br/><i>Réservations</i></th>';
  $ncols = 3;
  if ($depenses) {
    echo '<th>Montant</th>';
    $ncols++;
  }
  echo '<th>&nbsp;</th>';
  echo '</tr>';
  $ecas = $base->events_events_categorie_list($_SESSION['token']);
  $eca = array ();
  foreach ($ecas as $ec) {
    $eca[$ec['eca_id']] = $ec['eca_nom'];
  }
  $total = 0;
  foreach ($events as $event) {
    if (isset ($event['eve_id'])) {
      $e = $base->events_event_get($_SESSION['token'], $event['eve_id']);
      $ee = $base->events_secteur_event_liste($_SESSION['token'], $event['eve_id']);
      $ety = $base->events_event_type_get ($_SESSION['token'], $e['ety_id']);
      $secs = $base->events_event_type_secteur_list ($_SESSION['token'], $e['ety_id']);
      $themes = implode (', ', array_map (function ($e) { return $e['sec_nom']; }, $secs));      
      echo '<tr class="event">';
      if ($e['eve_journee']) {
	echo '<td>'.substr ($e['eve_debut'], 0, 10).'</td>';
	echo '<td>'.substr ($e['eve_fin'], 0, 10).'</td>';
      } else if ($e['eve_ponctuel']) {
	echo '<td colspan="2">'.substr ($e['eve_debut'], 0, 10).'<br>'.substr ($e['eve_debut'], 11, 5).'</td>';
      } else {
	echo '<td>'.substr ($e['eve_debut'], 0, 10).'<br>'.substr ($e['eve_debut'], 11, 5).'</td>';
	echo '<td>'.substr ($e['eve_fin'], 0, 10).'<br>'.substr ($e['eve_fin'], 11, 5).'</td>';
      }
      echo '<td>'.$eca[$e['eca_id']].' > '.$ety['ety_intitule'].'<br>('.$themes.')</td>';
      echo '<td>'.$ee[0]['sec_nom'].'  >  '.$e['eve_intitule'].'</td>';
      $participants = $base->events_event_personne_list ($_SESSION['token'], $event['eve_id']);
      echo '<td>';
      $parts = array ();
      foreach ($participants as $p) {
	$parts[] = $base->personne_get_libelle ($_SESSION['token'], $p['per_id']);
      }
      echo implode (', ', $parts).' ('.count ($participants).' participant'.(count($participants) > 1 ? 's' : '').')';
      // Ressources
      $ressources = $base->events_event_ressource_list ($_SESSION['token'], $event['eve_id']);
      if (count ($ressources)) {
	$parts = array ();
	foreach ($ressources as $res) {
	  $parts[] = $res['res_nom'];
	  echo '<br><i>'.implode (', ', $parts).'</i>';
	}

      }
      echo '</td>';
      if ($depenses) {
	echo '<td align="right">'.sprintf ("%.2f", $e['eve__depenses_montant']).' &euro;</td>';
	$total += $e['eve__depenses_montant'];
      }
      echo '<td><span id="edeve_'.$event['eve_id'].'" class="cliquable edevent">Éditer</span></td>';
      echo '</tr>';      
    } else {
      $ed = isset ($event['per_id']) ? 'edusager' : 'eddoc';
      $id = isset ($event['per_id']) ? 'edper_'.$event['per_id'] : 'eddoc_'.$event['doc_id'];
      echo '<tr class="autrevent">';
      echo '<td colspan="2">'.date ('d/m/Y', $event['start']).'</td>';
      echo '<td colspan="'.$ncols.'" align="center">'.$event['title'].'</td>';
      echo '<td id="'.$id.'" class="cliquable '.$ed.'">Éditer</td>';
      echo '</tr>';
    }
  }
  if ($depenses) {
    echo '<tr><th colspan="'.($ncols+1).'" align="right">Total</th><th align="right">'.sprintf("%.2f", $total).' &euro;</th></tr>';
  }
  echo '</table>';
} ?>

<?php
if (isset ($_GET['events_vue']) && $_GET['events_vue'] == 'bilan') {
  if (!isset ($_GET['events_date_debut'])) {
    $_GET['events_date_debut'] = date ('d/m/Y');
  }
  $startDate = $_GET['events_date_debut'];
  $endDate = $_GET['events_date_fin'];
  $grp_id = $_GET['rech_grp_id'];
  $code = $evs['evs_code'];
  $per_ids = $_GET['rech_per_id'];

  $eves = $base->events_event_bilan ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);
  echo '<table  class="tableliste" width="100%" style="text-align: right""><tr><th>Catégorie > Type (thématiques)</th><th>Nombre</th><th>Heures</th><th>Journées</th>';
  foreach ($eves as $eve) {
    $secs = $base->events_event_type_secteur_list ($_SESSION['token'], $eve['ety_id']);
    $themes = implode (', ', array_map (function ($e) { return $e['sec_nom']; }, $secs));
    echo '<tr><td>'.$eve['eca_nom']." > ".$eve['ety_intitule'].' ('.$themes.')'.'</td><td>'.$eve['nombre'].'</td><td>'.$eve['duree_heures'].'</td><td>'.$eve['duree_jours'].'</td></tr>';
  }
  echo '</table>';
}
?>

<?php
function sort_by_start_date ($a, $b) {
  if ($a['start'] == $b['start'])
    return $a['end'] < $b['end'] ? -1 : 1;
  return $a['start'] < $b['start'] ? -1 : 1;
}

function liste_groupes () {
  global $base, $evs_id, $grps_prise_en_charge;
  //  $grps_prise_en_charge = $base->utilisateur_groupe_liste($_SESSION['token']);
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
  $grps = $base->events_groupe_liste ($_SESSION['token'], $evs_id);
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

function liste_usagers () {

}
?>
