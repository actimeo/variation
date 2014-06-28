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
$dos_id = $_GET['prm_dos_id'];
$offset = $_GET['prm_offset'];
$limit = $_GET['prm_limit'];

require '../inc/config.inc.php';
require '../inc/common.inc.php';
require '../inc/enums.inc.php';
require '../inc/pgprocedures.class.php';
require 'funcs.xmlentities.php';

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$documents = $base->document_document_liste ($token, $dos_id, NULL, NULL, NULL, NULL, NULL, $base->order('doc_titre'), $base->limit ($limit, $offset));
foreach ($documents as &$doc) {
  $doc_usagers = $base->document_document_usager_liste ($token, $doc['doc_id']);
  $usagers = array ();
  foreach ($doc_usagers as $doc_usager) {
    $per = $base->personne_get ($token, $doc_usager['per_id_usager']);
    $usagers[] = array ('per_id' => $doc_usager['per_id_usager'],
			'nom' => $base->personne_get_libelle ($token, $doc_usager['per_id_usager']),
			'ent_code' => $per['ent_code']);
  }
  $doc['usagers'] = $usagers; 

  $doc['statut_libelle'] = $doc_statut[$doc['doc_statut']];
  $type = $base->document_document_type_get($token, $doc['dty_id']);
  $doc['type'] = $type['dty_nom'];
}

$results = $documents;


header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');

$xml = new SimpleXMLElement("<?xml version=\"1.0\"?><results></results>");
array_to_xml('results', $results, $xml);
echo $xml->asXML();

?>
