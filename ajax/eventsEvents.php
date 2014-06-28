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
// Ce script peut être soit appelé directement par le plugin fullcalendar, 
// soit inclus par scripts/events.php pour la vue liste,
// soit par l'application Android
$fromAndroid = false;

if (isset ($_GET['fromCal'])) {
  header('Cache-Control: no-cache, must-revalidate');
  header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
  header('Content-type: application/json');

  require ('../inc/config.inc.php');
  require ('../inc/common.inc.php');
  require ('../inc/pgprocedures.class.php');
  $start = $_GET['start'];
  $end = $_GET['end'];
  $code = $_GET['code'];
  $per_id = isset ($_GET['per_id']) ? $_GET['per_id'] : '';
  $grp_id = $_GET['grp_id'];
  $per_ids = isset ($_GET['per_ids']) ? $_GET['per_ids'] : '';
  $affiche_echeances = ($_GET['affiche_echeances'] == 'true');

  $startDate = date ("d/m/Y", $start);
  $endDate = date ("d/m/Y", $end);
  $today = date ("U");
  $events = array ();
  
  $base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
} else if ($_GET['fromAndroid']) {
  $fromAndroid = true;
  $affiche_echeances = true;
  header('Cache-Control: no-cache, must-revalidate');
  header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
  header('Content-type: text/xml');

  require ('../inc/config.inc.php');
  require ('../inc/common.inc.php');
  require ('../inc/pgprocedures.class.php');
  require 'funcs.xmlentities.php';
  $base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);  

  if (isset ($_GET['year'])) {
    $year = $_GET['year'];
    $month = $_GET['month'];  // 0-index
    $start = mktime (0, 0, 0, $month+1, 1, $year);
    $end = mktime (0, 0, 0, $month+2, 1, $year)-1;
  } else {
    $start = $_GET['date'];
    $end = $start + 60*60*24-1;
  }

  $tsm_id = $_GET['prm_tsm_id'];
  $token = $_GET['prm_token'];
  $_SESSION['token'] = $token;
  $tsm = $base->meta_topsousmenu_get ($token, $tsm_id);
  $evs = $base->events_events_get ($token, $tsm['tsm_type_id']);
  $code = $evs['evs_code'];
  $per_id = isset ($_GET['per_id']) ? $_GET['per_id'] : '';
  $grp_id = $_GET['grp_id'];
  $per_ids = isset ($_GET['per_ids']) ? $_GET['per_ids'] : '';
  //  $affiche_echeances = ($_GET['affiche_echeances'] == 'true');

  $startDate = date ("d/m/Y", $start);
  $endDate = date ("d/m/Y", $end);
  $today = date ("U");
  $events = array ();
  
} else {
}

$tmp_ecas = $base->events_events_categorie_list ($_SESSION['token']);
$ecas = array ();
foreach ($tmp_ecas as $eca) {
  $ecas[$eca['eca_id']] = $eca;
}
$evs = $base->events_events_get_par_code ($_SESSION['token'], $code);

// Evenements
$eves = $base->events_event_liste ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);
if (count ($eves)) {
  foreach ($eves as $eve) {
    if ($ecas[$eve['eca_id']]['eca_code'] == 'depenses') {    
      $titre = $eve['eve_intitule'];
      if ($eve['eve__depenses_montant']) 
	$titre .= ' '.str_replace ('.', ',', $eve['eve__depenses_montant'])."€";
    } else {
      $titre = $eve['eve_intitule'];
    }
    $description = "";
    // Heures
    if (date ('H:i', $eve['eve_debut']) != '00:00') {
      $description .= date ('H:i', $eve['eve_debut']);
      if ($eve['eve_fin']) {
	$description.= ' - '.date ('H:i', $eve['eve_fin']);
      }
      $description .= "<br>";
    }
    // Participants
    $participants = $base->events_event_personne_list ($_SESSION['token'], $eve['eve_id']);
    $parts = array ();
    $liste_usagers = array ();
    if (count ($participants)) {
      foreach ($participants as $part) {
	$parts[] = $base->personne_get_libelle ($_SESSION['token'], $part['per_id']);
	$personne = $base->personne_get ($_SESSION['token'], $part['per_id']);
	if ($personne['ent_code'] == 'usager')
	  $liste_usagers[] = substr ($base->personne_info_varchar_get ($_SESSION['token'], $part['per_id'], 'prenom'), 0, 1).'. '.$base->personne_info_varchar_get ($_SESSION['token'], $part['per_id'], 'nom');
      }
      $description .= implode (', ', $parts)."<br>";
    }
    // Ressources
    $ressources = $base->events_event_ressource_list ($_SESSION['token'], $eve['eve_id']);
    if (count ($ressources)) {
      $ress = array ();
      foreach ($ressources as $ressource) {
	$ress[] = $ressource['res_nom'];
      }
      $description .= implode ($ress)."<br>";
    }
    
    $desc = $base->events_event_memo_get ($_SESSION['token'], $eve['eve_id'], "description");
    if (strlen ($desc) > 200) {
      $wsp = strpos ($desc, ' ', 200);
      $desc = substr ($desc, 0, $wsp)."&hellip;";
    }
    $description .= $desc.'<br>';
    
    $listusagers = count ($liste_usagers) < 12 ? implode (', ', $liste_usagers) : count($liste_usagers).' usagers';
    if ($fromAndroid) {
      $events[] = array ("title" => $titre,
			 "description" => $listusagers,
			 'eve_id' => $eve['eve_id'],
			 "start" => $eve['eve_debut'],
			 "end" => $eve['eve_fin']
			 );
    } else {
      $events[] = array ("title" => $titre."\n".$listusagers,
			 "allDay" => $eve['eve_journee'],
			 "start" => $eve['eve_debut'],
			 "end" => $eve['eve_fin'],
			 "description" => $description,
			 'eve_id' => $eve['eve_id'],
			 "backgroundColor" => "#3D84CC",
			 "borderColor" => "#3D84CC",
			 'icone' => str_replace ('%d', '24', $eve['sec_icone'])
			 );
    }
  }
}

if ($affiche_echeances) {
  // Début de groupe
  $eves = $base->events_groupe_liste_debut ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);
  foreach ($eves as $eve) {
    if ($fromAndroid) {
      $events[] = array ("title" => $eve['grp_nom'].' (début)',
			 "description" => $eve['prenom'].' '.$eve['nom'],
			 'per_id' => $eve['per_id'],
			 "start" => $eve['valeur'],
			 "end" => $eve['valeur'],
			 );
    } else {

      $events[] = array ("title" => ($per_id ? '' : $eve['prenom'].' '.$eve['nom'].", ").$eve['grp_nom'].' (début)',
			 "allDay" => true,
			 "start" => $eve['valeur'],
			 "end" => $eve['valeur'],
			 "description" => $eve['grp_nom'].' (début)',
			 'per_id' => $eve['per_id'],
			 'titreTab' => $base->personne_get_libelle($_SESSION['token'], $eve['per_id']),
			 "backgroundColor" => "#bbb",
			 "borderColor" => "#bbb",
			 'icone' => str_replace ('%d', '24', $eve['sec_icone'])
			 );
    }
  }

  // Fin de groupe
  $eves = $base->events_groupe_liste_fin ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);
  foreach ($eves as $eve) {
    if ($fromAndroid) {
      $events[] = array ("title" => $eve['grp_nom'].' (fin)',
			 "description" => $eve['prenom'].' '.$eve['nom'],
			 'per_id' => $eve['per_id'],
			 "start" => $eve['valeur'],
			 "end" => $eve['valeur'],
			 );
    } else {
      $events[] = array ("title" => ($per_id ? '' : $eve['prenom'].' '.$eve['nom'].", ").$eve['grp_nom'].' (fin)',
			 "allDay" => true,
			 "start" => $eve['valeur'],
			 "end" => $eve['valeur'],
			 "description" => $eve['grp_nom'].' (fin)',
			 'per_id' => $eve['per_id'],
			 'titreTab' => $base->personne_get_libelle($_SESSION['token'], $eve['per_id']),
			 "backgroundColor" => "#bbb",
			 "borderColor" => "#bbb",
			 'icone' => str_replace ('%d', '24', $eve['sec_icone'])
			 );
    }
  }
}

// Echeances
$eves = $base->events_echeance_liste ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);
foreach ($eves as $eve) {  
  if ($fromAndroid) {
    $events[] = array ("title" => ($eve['inf_libelle_complet'] ? $eve['inf_libelle_complet'] : $eve['inf_libelle']),
		       "description" => $base->personne_get_libelle($_SESSION['token'], $eve['per_id']),
		       'per_id' => $eve['per_id'],
		       "start" => $eve['d'],
		       "end" => $eve['d'],
		       );
  } else {
    $events[] = array ("title" => ($per_id ? '' : $eve['prenom'].' '.$eve['nom'].', ').($eve['inf_libelle_complet'] ? $eve['inf_libelle_complet'] : $eve['inf_libelle']),
		       "allDay" => true,
		       "start" => $eve['d'],
		       "end" => $eve['d'],
		       "description" => $eve['inf_libelle_complet'] ? $eve['inf_libelle_complet'] : $eve['inf_libelle'],
		       "per_id" => $eve['per_id'],
		       'titreTab' => $base->personne_get_libelle($_SESSION['token'], $eve['per_id']),
		       "icone" => $eve['inf__date_echeance_icone'],
		       "backgroundColor" => "#777",
		       "borderColor" => "#777");
  }
}


  // Limite obtention documents
$eves = $base->events_document_liste_obtention ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);

  foreach ($eves as $eve) {
    if ($fromAndroid) {
      $events[] = array ("title" => $eve['doc_titre'].' (limite obtention)',
			 "description" => $eve['usagers'],
			 'doc_id' => $eve['doc_id'],
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 );
    } else {
      $events[] = array ("title" => $eve['doc_titre'].' (limite obtention)'.($per_id ? '' : ", ".$eve['usagers']),
			 "allDay" => true,
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 "description" => $eve['doc_description'],
			 "doc_id" => $eve['doc_id'],
			 "icone" => str_replace ('%d', '24', $eve['doc_icone']),
			 "backgroundColor" => "#777",
			 "borderColor" => "#777");
    }
  }

  // Réalisation documents
$eves = $base->events_document_liste_realisation ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);

  foreach ($eves as $eve) {  
    if ($fromAndroid) {
      $events[] = array ("title" => $eve['doc_titre'].' (réalisé)',
			 "description" => $eve['usagers'],
			 'doc_id' => $eve['doc_id'],
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 );
    } else {
      $events[] = array ("title" => $eve['doc_titre'].' (réalisé)'.($per_id ? '' : ", ".$eve['usagers']),
			 "allDay" => true,
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 "description" => $eve['doc_description'],
			 "doc_id" => $eve['doc_id'],
			 "icone" => str_replace ('%d', '24', $eve['doc_icone']),
			 "backgroundColor" => "#777",
			 "borderColor" => "#777");
    }
  }

  // Limite validité documents
$eves = $base->events_document_liste_validite ($_SESSION['token'], $evs['evs_id'], $per_id, $startDate, $endDate, $grp_id, $per_ids);

  foreach ($eves as $eve) {  
    if ($fromAndroid) {
      $events[] = array ("title" => $eve['doc_titre'].' (limite validité)',
			 "description" => $eve['usagers'],
			 'doc_id' => $eve['doc_id'],
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 );
    } else {
      $events[] = array ("title" => $eve['doc_titre'].' (limite validité)'.($per_id ? '' : ", ".$eve['usagers']),
			 "allDay" => true,
			 "start" => $eve['d'],
			 "end" => $eve['d'],
			 "description" => $eve['doc_description'],
			 "doc_id" => $eve['doc_id'],
			 "icone" => str_replace ('%d', '24', $eve['doc_icone']),
			 "backgroundColor" => "#777",
			 "borderColor" => "#777");
    }
  }

if (isset ($_GET['fromCal'])) {
  echo json_encode ($events);

} else if (isset ($_GET['fromAndroid'])) {
  if ($_GET['year']) {
    // Retourne la liste des jours du mois (par ordre croissant) ayant au moins un evenement
    foreach ($events as $event) {
      $start = $event['start'];
      $end = $event['end'];
      if (!$end)
	$end = $start;
      $p = $start;
      while ($p <= $end && date('M', $p) == date('M', $start)) {
	$ret[date('d', $p)] = true;
	$p += 60*60*24;
      }
    }
    ksort ($ret);
    echo '<?xml version="1.0" encoding="utf-8"?>';
    echo '<results>';
    foreach ($ret as $re => $nil) {
      echo '<result><day>'.$re.'</day></result>';
    }
    echo '</results>';
  } else {
    // Retourne les événements d'un jour
    echo '<?xml version="1.0" encoding="utf-8"?>';
    echo '<results>';
    foreach ($events as $event) {
      echo '<result>';
      echo '<title>'.xmlentities ($event['title']).'</title>';
      echo '<description>'.xmlentities ($event['description']).'</description>';
      echo '<eve_id>'.$event['eve_id'].'</eve_id>';
      echo '<per_id>'.$event['per_id'].'</per_id>';
      echo '<doc_id>'.$event['doc_id'].'</doc_id>';
      echo '</result>';
    }
    echo '</results>';
    
  }
}
?>
