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
$doc_id = $_GET['prm_doc_id'];

require '../inc/config.inc.php';
require '../inc/common.inc.php';
require '../inc/enums.inc.php';
require '../inc/pgprocedures.class.php';
require 'funcs.xmlentities.php';

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$document = $base->document_document_get ($token, $doc_id);

$doc_usagers = $base->document_document_usager_liste ($token, $document['doc_id']);
$usagers = array ();
foreach ($doc_usagers as $doc_usager) {
  $per = $base->personne_get ($token, $doc_usager['per_id_usager']);
  $usagers[] = array ('per_id' => $doc_usager['per_id_usager'],
		      'nom' => $base->personne_get_libelle ($token, $doc_usager['per_id_usager']),
		      'ent_code' => $per['ent_code']);
}
$document['usagers'] = $usagers; //implode (', ', array_map (function ($e) { global $base, $token; return $base->personne_get_libelle($token, $e['per_id_usager']); }, $doc_usagers));

$document['statut_libelle'] = $doc_statut[$document['doc_statut']];

$type = $base->document_document_type_get($token, $document['dty_id']);
$document['type'] = $type['dty_nom'];

$per = $base->personne_get ($token, $document['per_id_responsable']);
$document['responsable'] = array ('per_id' => $document['per_id_responsable'],
				  'nom' => $base->personne_get_libelle ($token, $document['per_id_responsable']),
				  'ent_code' => $per['ent_code']);

$document['createur'] = $base->utilisateur_prenon_nom ($token, $document['uti_id_creation']);

$secteurs = $base->document_document_secteur_liste_details ($token, $doc_id);
$document['secteurs'] = implode (', ', array_map (function ($e) { return $e['sec_nom']; }, $secteurs));

$results = array ($document);

header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');

$xml = new SimpleXMLElement("<?xml version=\"1.0\"?><results></results>");
array_to_xml('results', $results, $xml);
echo $xml->asXML();
?>
