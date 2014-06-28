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
header('Content-type: application/json');

require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');
$start = $_GET['start'];
$end = $_GET['end'];
$cal_id = $_GET['id'];

$startDate = date ("d/m/Y", $start);
$endDate = date ("d/m/Y", $end);
$today = date ("U");
$events = array ();

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$cal = $base->calendrier_calendrier_get ($cal_id);
$echs = $base->calendrier_echeance_liste ($cal['cal_id']);
$evs = array ();
foreach ($echs as $ech) {
  $inf_id = $ech['inf_id'];
  $grp_id = $ech['grp_id'];
  if ($inf_id) {
    $info = $base->meta_info_get ($_SESSION['token'], $inf_id);
    $evs = $base->calendrier_liste_echeances_infos ($inf_id, $startDate, $endDate);
    foreach ($evs as $ev) {  
      $events[] = array ("title" => $ev['prenom'].' '.$ev['nom'],
			 "allDay" => true,
			 "start" => $ev['valeur'],
			 "end" => $ev['valeur'],
			 "className" => "eventType1",
			 "description" => $info['inf_libelle_complet'],
			 "per_id" => $ev['per_id']);
    }
  } else if ($grp_id) {
    $groupe = $base->groupe_get ($_SESSION['token'], $grp_id);
    $evs = $base->calendrier_liste_echeances_groupes ($grp_id, $startDate, $endDate);
    foreach ($evs as $ev) {  
      $events[] = array ("title" => $ev['prenom'].' '.$ev['nom'],
			 "allDay" => true,
			 "start" => $ev['valeur'],
			 "end" => $ev['valeur'],
			 "className" => "eventType1",
			 "description" => $groupe['grp_nom'],
			 "per_id" => $ev['per_id']);
    }    
  }
}

echo json_encode ($events);
		   
?>
