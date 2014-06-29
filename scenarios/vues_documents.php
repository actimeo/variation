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
if ($argc < 2) { 
  usage();
  exit;
}
require ('../inc/config.inc.php');
require ('../inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$base->startTransaction ();

$uti_infos = $base->utilisateur_login2 ('variation', $argv[1]);
if (!count ($uti_infos)) {
  usage();
  exit;
}
$uti_id_variation = $uti_infos[0]['uti_id'];
$token = $uti_infos[0]['tok_token'];

/* On récupère quelques infos génériques */
$secteurs = $base->meta_secteur_liste ($token, NULL);
$codes_secteurs = array();
foreach ($secteurs as $s) {
  $codes_secteurs[] = $s['sec_code'];
}

$groupes = array ('administration' => array ('nom' => 'Administration',
					     'secteurs' => array ('prise_en_charge', 
								  'decideur')),
		  'vie_quotidienne' => array ('nom' => 'Vie quotidienne',
					      'secteurs' => array ('culture', 
								   'divertissement', 
								   'sport',
								   'aide_a_la_personne',
								   'hebergement',
								   'restauration',
								   'social',
								   'entretien',
								   'transport',
								   'equipement_personnel')));

/* 1 thématique */
foreach ($secteurs as $secteur) {
  $dos_id = $base->document_documents_save ($token, null, 'documents_'.$secteur['sec_code'], 'Documents '.$secteur['sec_nom'], null);
  $base->document_documents_secteurs_set ($token, $dos_id, array ($secteur['sec_code']));
}

/* toutes thématiques */
$dos_id = $base->document_documents_save ($token, null, 'documents_toutes_thematiques', 'Documents (toutes thématiques)', null);
$base->document_documents_secteurs_set ($token, $dos_id, $codes_secteurs);

/* groupe de thématiques */
foreach ($groupes as $groupe_code => $groupe) {
  $dos_id = $base->document_documents_save ($token, null, 'documents_'.$groupe_code, 'Documents '.$groupe['nom'], null);
  $base->document_documents_secteurs_set ($token, $dos_id, $groupe['secteurs']);
}

$base->commit ();
function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
