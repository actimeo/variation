#! /usr/bin/php
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
require '../inc/config.inc.php';
require '../inc/pgprocedures.class.php';
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$options = getopt ('hdvu:p:');

$verbeux = false;
$debug = false;

if (isset ($options['h'])) {
  usage (0);
}

if (isset ($options['d'])) {
  $debug = true;
  array_shift ($argv);
}

if (isset ($options['v'])) {
  $verbeux = true;
  array_shift ($argv);
}

if (!isset ($options['u'])) {
  usage(1);
} else {
  $login = $options['u'];
  array_shift ($argv);
  array_shift ($argv);
}

if (!isset ($options['p'])) {
  usage(1);
} else {
  $password = $options['p'];
  array_shift ($argv);
  array_shift ($argv);
}

if (!isset ($argv[2])) {
  usage (1);
}

$csvname = $argv[1];
$docdirname = $argv[2];

// Connexion
$uti_infos = $base->utilisateur_login2 ($login, $password);
if (!count ($uti_infos)) {
  usage(1);
  exit;
}
$token = $uti_infos[0]['tok_token'];

// Liste des thématiques
$secs = $base->meta_secteur_liste ($token, NULL);
$thematiques = array ();
foreach ($secs as $sec) {
  $thematiques[trim ($sec['sec_code'])] = $sec;
}

$csv = fopen ($csvname, 'r');
fgetcsv ($csv);
while (false !== ($ligne = fgetcsv ($csv))) {
  $titre = $ligne[0];
  $fichier = $ligne[1];
  $date_realisation = $ligne[2];
  $date_validite = $ligne[3];
  $statut = $ligne[4];
  $type = $ligne[5];
  $thematique = $ligne[6];
  $nom = $ligne[7];
  $prenom = $ligne[8];

  $verbeux && print $titre."\n";

  if (!isset ($thematiques[trim ($thematique)])) {
    warning ($thematique.' : thématique non trouvée. On passe.');
    continue;
  } 

  $sec = $thematiques[trim ($thematique)];
  // Liste des types de documents dans cette thématique
  $dtys = $base->document_document_type_liste_par_sec_ids ($token, array ($sec['sec_id']), null);
  $types = array ();
  foreach ($dtys as $dty) {
    $types[trim ($dty['dty_nom'])] = $dty;
  }
  if (!isset ($types[trim ($type)])) {
    warning ($type.' : type de document non trouvé dans la thématique "'.$thematique.'". On passe.');
    continue;
  } 
  
  if (!file_exists ($docdirname.'/'.$fichier)) {
    warning ($fichier.' : fichier non trouvé. On passe.');
    continue;
  }
  $dty = $types[trim ($type)];

  $pers = $base->personne_cherche ($token, $nom, $prenom);
  if (count ($pers) != 1) {
    warning ($nom.' '.$prenom.' non trouvé. On passe.');
    continue;
  }
  $per_id = $pers[0]['per_id'];

  if (!$debug) {
    // - crée le document en BDD
    $doc_id = $base->document_document_save ($token, NULL, NULL, $dty['dty_id'], trim($titre), $statut, 
					     NULL, $date_realisation, $date_validite, NULL);      
    if (!$doc_id) {
      warning ("Erreur lors de la création du document en BDD.");
      continue;
    }
    $base->document_document_secteur_save ($token, $doc_id, array ($sec['sec_id']));
    $base->document_document_usager_save ($token, $doc_id, array ($per_id));
    
    // Indique le nom du fichier en BDD
    $base->document_document_set_fichier ($token, $doc_id, $fichier);
    
    // - copie le document dans doc_fichiers/
    mkdir ($dirbase.'/doc_fichiers/'.$doc_id);
    copy ($docdirname.'/'.$fichier, $dirbase.'/doc_fichiers/'.$doc_id.'/'.$fichier);
  }
}
		    
function usage ($err) {
  global $argv;
  echo $argv[0].' [-h] [-d] [-v] -u utilisateur -p "mot de passe" "fichier csv" "répertoire docs"'."\n";
  echo " -h : affiche cette aide.\n";
  echo " -d : mode debug - teste uniquement si le fichier d'import est correct, 
n'importe pas réellement les documents.\n";
  echo " -v : verbeux - explique les opérations effectuées.\n";
  echo "\n";
  echo "Après l'import des documents, vous devrez modifier le propriétaire 
des répertoires et des fichiers dans doc_fichiers pour mettre www-data:www-data
(ou tout autre utilisateur unix exécutant le serveur web).\n";
  echo "\n\n";
  exit ($err);
}

function warning ($str) {
  echo "[Attention] ".$str."\n";
}
?>
