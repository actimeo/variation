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
// TODO : afficher types docs non utilisés par étab ???
if (!$_SESSION['uti_config'])
  exit;

function affiche_types () {
  global $base;
  $cats = $base->events_events_categorie_list ($_SESSION['token']);
  $secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  echo '<table class="t1" width="100%"><tr><th></th>';
  foreach ($cats as $cat) {
    echo '<th>'.$cat['eca_nom'].'</th>';
  }
  echo '<th>Documents</th>';
  echo '</tr>';
  $impair = false;
  foreach ($secteurs as $secteur) {
    $impair = !$impair;
    echo '<tr class="'.($impair ? 'impair' : 'pair').'"><th>'.$secteur['sec_nom'].'</th>';    
    foreach ($cats as $cat) {
      $etys = $base->events_event_type_list ($_SESSION['token'], $cat['eca_id'], array ($secteur['sec_id']), $_SESSION['eta_id']);
      $ety_noms = array ();
      if (count ($etys)) {
	foreach ($etys as $ety) {
	  $ety_noms[] = '- '.$ety['ety_intitule'];
	}
      }
      
      if (isset ($_REQUEST['tous_etys'])) {
	$all_etys = $base->events_event_type_list ($_SESSION['token'], $cat['eca_id'], array ($secteur['sec_id']), NULL);
	if (count ($all_etys)) {
	  foreach ($all_etys as $ety) {
	    $found = false;
	    foreach ($etys as $e) {
	      if ($e['ety_id'] == $ety['ety_id']) {
		$found = true;
		break;
	      }	    
	    }
	    if (!$found)
	      $ety_noms[] = '<i><small>- '.$ety['ety_intitule'].'</small></i>';
	  }
	}
      }
      echo '<td>';
      echo implode ('<br>', $ety_noms);
      echo '</td>';
    }
    $docs = $base->document_document_type_liste_par_sec_ids ($_SESSION['token'], array ($secteur['sec_id']), $_SESSION['eta_id'], $base->order('dty_nom'));
    echo '<td>';
    $doc_noms = array ();
    if (count ($docs)) {
      foreach ($docs as $doc) {
	$doc_noms[] = '- '.$doc['dty_nom'];
      }
    }

    if (isset ($_REQUEST['tous_etys'])) {
      $all_docs = $base->document_document_type_liste_par_sec_ids ($_SESSION['token'], array ($secteur['sec_id']), NULL);
      if (count ($all_docs)) {
	foreach ($all_docs as $doc) {
	  $found = false;
	  foreach ($docs as $d) {
	    if ($d['dty_id'] == $doc['dty_id']) {
	      $found = true;
	      break;
	    }	    
	  }
	  if (!$found)
	    $doc_noms[] = '<i><small>- '.$doc['dty_nom'].'</small></i>';
	}
      }
    }
    
    echo implode ('<br>', $doc_noms);
    echo '</td>';
    echo '</tr>';
  }
  echo '</table>';
}
?>
<h1>Vue d'ensemble</h1>
<form method="POST" action="<?= $_SERVER['REQUEST_URI'] ?>">
<input type="checkbox" name="tous_etys" id="tous_etys"<?php if (isset ($_REQUEST['tous_etys'])) echo 'checked'; ?>></input><label for="tous_etys">Afficher les types non sélectionnés par l'établissement</label> <input type="submit" value="OK"></input>
</form>
<?php affiche_types (); ?>