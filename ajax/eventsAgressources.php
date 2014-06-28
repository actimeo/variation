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
$code = $_GET['code'];

$startDate = date ("d/m/Y", $start);
$endDate = date ("d/m/Y", $end);
$today = date ("U");
$events = array ();

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$agr = $base->events_agressources_get_par_code ($_SESSION['token'], $code);
// Evenements
$eves = $base->events_event_avec_ressource_liste ($_SESSION['token'], $startDate, $endDate, $agr['agr_id']);
$events = array ();
foreach ($eves as $eve) {
  $titre = $eve['res_nom'].' : '.$eve['eve_intitule'];
  $events[] = array ('title' => $titre,
		     'allDay' => $eve['eve_fin'] == null,
		     'start' => $eve['eve_debut'],
		     'end' => $eve['eve_fin']);
}
echo json_encode ($events);