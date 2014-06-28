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
namespace Sabre\Accueil;
use Sabre\DAV;

/**
 * 
 */

class EventsPersonnesTSMexportExcel extends Dav\File  {
  private $auth;
  private $base;
  private $tsmid;
  private $name;
  private $type;
  private $from;
  private $to;
  private $contents;
  private $data;

  private $multsep = ';';

  function __construct ($auth, $base, $tsmid, $name, $type, $from, $to) {
    $this->auth = $auth;
    $this->base = $base;
    $this->tsmid = $tsmid;
    $this->name = $name;
    $this->type = $type;
    $this->from = $from;
    $this->to = $to;    
    $this->contents = NULL;
    $this->data = NULL;
  }

  private static function sort_by_start_date ($a, $b) {
    if ($a['eve_debut'] == $b['eve_debut'])
      return $a['eve_fin'] < $b['eve_fin'] ? -1 : 1;
    return $a['eve_debut'] < $b['eve_debut'] ? -1 : 1;
  }

  function getData () {
    if ($this->type == 'liste') {
      $topsousmenu = $this->base->meta_topsousmenu_get ($this->auth->token, $this->tsmid);
      $evs_id = $topsousmenu['tsm_type_id'];
      $startDate = date ('d/m/Y', strtotime ($this->from));
      $endDate = date ('d/m/Y', strtotime ($this->to));      
      $ecas = $this->base->events_events_categorie_list($this->auth->token);
      $eca = array ();
      foreach ($ecas as $ec) {
	$eca[$ec['eca_id']] = $ec['eca_nom'];
      }

      $eves = $this->base->events_event_liste ($this->auth->token, $evs_id, NULL, $startDate, $endDate, NULL, NULL);
      usort ($eves, array ($this, 'sort_by_start_date'));

      if (count ($eves)) {
	foreach ($eves as $event) {
	  $e = $this->base->events_event_get($this->auth->token, $event['eve_id']);
	  $ee = $this->base->events_secteur_event_liste($this->auth->token, $event['eve_id']);
	  $ety = $this->base->events_event_type_get ($this->auth->token, $e['ety_id']);
	  $secs = $this->base->events_event_type_secteur_list ($this->auth->token, $e['ety_id']);
	  $themes = implode (', ', array_map (function ($e) { return $e['sec_nom']; }, $secs));      	  
	  $ligne = array ();
	  if ($e['eve_journee']) {
	    $ligne[] = substr ($e['eve_debut'], 0, 10);
	    $ligne[] = substr ($e['eve_fin'], 0, 10);
	  } else {
	    $ligne[] = $e['eve_debut'];
	    $ligne[] = $e['eve_fin'];
	  }

	  $ligne[] = $eca[$e['eca_id']];
	  $ligne[] = $ety['ety_intitule'];
	  $ligne[] = $themes;
	  $ligne[] = $ee[0]['sec_nom'];
	  $ligne[] = $e['eve_intitule'];

	  $participants = $this->base->events_event_personne_list ($this->auth->token, $event['eve_id']);
	  $parts = array ();
	  foreach ($participants as $p) {
	    $parts[] = $this->base->personne_get_libelle ($this->auth->token, $p['per_id']);
	  }
	  $ligne[] = implode (', ', $parts).' ('.count ($participants).' participant'.(count($participants) > 1 ? 's' : '').')';

	  $ressources = $this->base->events_event_ressource_list ($this->auth->token, $event['eve_id']);
	  if (count ($ressources)) {
	    $parts = array ();
	    foreach ($ressources as $res) {
	      $parts[] = $res['res_nom'];
	      $ligne[] = implode (', ', $parts);
	    }
	  }
	  
	  $this->data[] = $ligne;
	}
      }
    }
  }

  function get () {
    if ($this->contents === NULL) {
      $this->getData ();
      $excel = new ExcelExport ();
      
      // TODO: entete
      $excel->addLine (array ('Début', 'Fin', 'Catégorie', 'Type', 'Thématiques', 'Thèmatique', 'Intitulé', 'Participants', 'Réservations'));
      foreach ($this->data as $d) {
	$excel->addLine ($d);
      }

      $this->contents = $excel->getContents ();
      //$this->contents = print_r ($this->infos, true);
    }
    return $this->contents;
  }

  function getSize () {    
    if (!$this->contents) {
      $this->get ();
    }
    return strlen ($this->contents);
  }    

  function getName () {
    return $this->name.".csv";
  }
}
?>
