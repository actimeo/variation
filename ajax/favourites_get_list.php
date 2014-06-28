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
$type = $_GET['prm_type'];
$ids = $_GET['id'];

require '../inc/config.inc.php';
require '../inc/common.inc.php';
require '../inc/enums.inc.php';
require '../inc/pgprocedures.class.php';
require 'funcs.xmlentities.php';

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$ret = array ();

switch ($type) {

case 'doc':
  foreach ($ids as $id) {
    $doc = $base->document_document_get ($token, $id);
    $doc_usagers = $base->document_document_usager_liste ($token, $id);
    $usagers = implode (', ', array_map (function ($e) { global $base, $token; return $base->personne_get_libelle($token, $e['per_id_usager']); }, $doc_usagers));
    $ret[] = array ('id' => $id,		    
		    'title' => $doc['doc_titre'],
		    'subtitle' => $usagers);
  }  
  break;

case 'eve':
  foreach ($ids as $id) {
    $event = $base->events_event_get ($token, $id);
    $pers = $base->events_event_personne_list ($token, $id);
    foreach ($pers as $per) {
      $personne = $base->personne_get ($token, $per['per_id']);
      $usagers = array ();
      if ($personne['ent_code'] == 'usager')
	$usagers[] = $base->personne_get_libelle ($token, $personne['per_id']);  
    }
    $noms = implode (', ', $usagers);
    $ret[] = array ('id' => $id,
		    'title' => $event['eve_intitule'],
		    'subtitle' => $noms);
  }
  break;

case 'user':
case 'staff':
case 'contact':
case 'family':
  foreach ($ids as $id) {
    $ret[] = array ('id' => $id,
		    'title' => $base->personne_get_libelle ($token, $id),
		    'subtitle' => '');
  }
}

$results = $ret;

header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');

$xml = new SimpleXMLElement("<?xml version=\"1.0\"?><results></results>");
array_to_xml('results', $results, $xml);
echo $xml->asXML();
?>
