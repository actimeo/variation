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
  $codes_secteurs[$s['sec_id']] = $s['sec_code'];
}

$etas = $base->etablissement_liste ($token, true, null);
$eta_ids = array ();
if (count ($etas)) {
  foreach ($etas as $eta) {
    $eta_ids[] = $eta['eta_id'];
  }
}

$filename = 'types_documents.csv';
$f = fopen ($filename, 'r');

$entete = fgetcsv ($f, 0, "\t");

while ( ($tmp = fgetcsv ($f, 0, "\t")) !== FALSE) {
  $ligne = array ();
  foreach ($entete as $k => $v) {
    $ligne[$v] = $tmp[$k];
  }
  $secs = array ();
  foreach ($codes_secteurs as $sec_id => $sec_code) {
    if ($ligne[$sec_code]) {
      $secs[] = $sec_id;
    }
  }
  if (empty ($secs))
    $secs = null;
  $dty_id = $base->document_document_type_ajoute ($token, $ligne['type_document']);
  if ($secs) {
    foreach ($secs as $sec) {
      $base->document_document_type_secteur_ajoute ($token, $dty_id, $sec);
    }
  }
  if (count ($eta_ids)) {
    foreach ($eta_ids as $eta_id) {
      $base->document_document_type_etablissement_set ($token, $dty_id, $eta_id, true);
    }
  }
}

$base->commit ();

function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
