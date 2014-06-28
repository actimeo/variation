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
$token = $_GET['prm_token'];
$eve_id = $_GET['prm_eve_id'];

require '../inc/config.inc.php';
require '../inc/common.inc.php';
require '../inc/enums.inc.php';
require '../inc/pgprocedures.class.php';
require 'funcs.xmlentities.php';

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$event = $base->events_event_get ($token, $eve_id);
$ety = $base->events_event_type_get ($token, $event['ety_id']);
$event['type'] = $ety['ety_intitule'];
$event['description'] = $base->events_event_memo_get ($token, $eve_id, 'description');
$event['bilan'] = $base->events_event_memo_get ($token, $eve_id, 'bilan');

$pers = $base->events_event_personne_list ($token, $eve_id);
$personnes = array ('usagers' => array(),
		    'personnels' => array(),
		    'contacts' => array(),
		    'familles' => array());
foreach ($pers as $per) {
  $personne = $base->personne_get ($token, $per['per_id']);
  $libelle = $base->personne_get_libelle ($token, $per['per_id']);  
  $personnes[$personne['ent_code']."s"][] = array ('per_id' => $per['per_id'],
						   'nom' => $libelle,
						   'ent_code' => $personne['ent_code']);
}
foreach ($personnes as $k => $nil) {
  $event[$k] = $personnes[$k];
}

$resources = $base->events_event_ressource_list ($token, $eve_id);
$res = array ();
foreach ($resources as $resource) {
  $res[] = $resource['res_nom'];
}
$event['ressources'] = implode (', ', $res);

$results = array ('result' => $event);

header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');
$xml = new SimpleXMLElement("<?xml version=\"1.0\"?><results></results>");
array_to_xml('results', $results, $xml);
echo $xml->asXML();

?>
