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


$dirname = $argv[1];
$donename = $argv[2];

$dir = dir ($dirname);
if (!$dir) {
  echo $dirname.': erreur de lecture'."\n";
  exit (1);
}

if (!is_dir ($donename)) {
  echo 'Le répertoire de destination "'.$donename.'" n\'existe pas'."\n";
  exit (1);
}

// Connexion
$uti_infos = $base->utilisateur_login2 ($login, $password);
if (!count ($uti_infos)) {
  usage();
  exit;
}
$token = $uti_infos[0]['tok_token'];

// Liste des thématiques
$secs = $base->meta_secteur_liste ($token, NULL);
$thematiques = array ();
foreach ($secs as $sec) {
  $thematiques[trim ($sec['sec_nom'])] = $sec;
}

while (false !== ($theme = $dir->read())) {
  if ($theme[0] == '.')
    continue;

  // On crée le répertoire dans le répertoire de destination
  if (!$debug) {
    mkdir ($donename.'/'.$theme);
  }

  $verbeux && print ' - '.$theme."\n";
  if (!isset ($thematiques[trim ($theme)])) {
    warning ($theme.' : thématique non trouvée. On passe.');
    continue;
  } 
  $sec = $thematiques[trim ($theme)];
  // Liste des types de documents dans cette thématique
  $dtys = $base->document_document_type_liste_par_sec_ids ($token, array ($sec['sec_id']), null);
  $types = array ();
  foreach ($dtys as $dty) {
    $types[trim ($dty['dty_nom'])] = $dty;
  }

  $themedir = dir ($dirname.'/'.$theme);
  while (false !== ($type = $themedir->read())) {
    if ($type[0] == '.')
      continue;

    // On crée le répertoire dans le répertoire de destination
    if (!$debug) {
      mkdir ($donename.'/'.$theme.'/'.$type);
    }

    $verbeux && print '   - '.$type."\n";
    if (!isset ($types[trim ($type)])) {
      warning ($type.' : type de document non trouvé dans la thématique "'.$theme.'". On passe.');
      continue;
    } 
    $dty = $types[trim ($type)];

    $typedir = dir ($dirname.'/'.$theme.'/'.$type);
    while (false !== ($doc = $typedir->read())) {
      if ($doc[0] == '.')
	continue;
      $verbeux && print '     - '.$doc."\n";
   
      // On supprime l'extension (la partie après le dernier .)      
      $partsext = explode (".", $doc);
      array_pop ($partsext);
      $doc_sans_ext = implode (".", $partsext);
      // On découpe sur les +
      $parts = explode ('+', $doc_sans_ext);

      // On regarde s'il y a un indice
      // Si oui, on l'ignore
      $dernier = end($parts);
      if (is_numeric ($dernier)) {
	array_pop ($parts);
	$verbeux && print '       - Indice : '.$dernier."\n";
      }

      // On regarde s'il y a une date
      $date = null;
      $dernier = end ($parts);
      if (est_date ($dernier)) {
	$date = reformat_date ($dernier);
	array_pop ($parts);
	$verbeux && print '       - Date : '.$date."\n";
      }
      
      if (count ($parts) == 0 || count($parts) % 2 != 0) {
	warning ($doc." n'a pas le bon format.");
	continue;
      }
      $per_ids = array ();
      while (count ($parts)) {
	$nom = array_shift ($parts);
	$prenom = array_shift ($parts);
	$pers = $base->personne_cherche_exact ($token, $nom, $prenom, 'usager');
	if (count ($pers) != 1) {	  
	  warning($nom.' '.$prenom." : usager non trouvé");
	  continue 2;
	}
	$per_ids[] = $pers[0];
      }
      
      if (!$debug) {
	// - crée le document en BDD
	$doc_id = $base->document_document_save ($token, NULL, NULL, $dty['dty_id'], trim($type), 3, 
						 NULL, $date, NULL, NULL);      
	if (!$doc_id) {
	  warning ("Erreur lors de la création du document en BDD.");
	  continue;
	}
	$base->document_document_secteur_save ($token, $doc_id, array ($sec['sec_id']));
	$base->document_document_usager_save ($token, $doc_id, $per_ids);
	
	// Indique le nom du fichier en BDD
	$base->document_document_set_fichier ($token, $doc_id, $doc);
	
	// - copie le document dans doc_fichiers/
	mkdir ($dirbase.'/doc_fichiers/'.$doc_id);
	copy ($dirname.'/'.$theme.'/'.$type.'/'.$doc, $dirbase.'/doc_fichiers/'.$doc_id.'/'.$doc);
	
	
	// On déplace le fichier dans le répertoire destination
	rename ($dirname.'/'.$theme.'/'.$type.'/'.$doc, $donename.'/'.$theme.'/'.$type.'/'.$doc);
      }
      
      $verbeux && print '       - OK'."\n";
    }    
  }
}

function est_date ($str) {
  return preg_match ('|^\d{1,2}\.\d{1,2}\.\d{2}$|', $str) === 1;
}

function reformat_date ($str) {  
  $matches = array ();
  if (preg_match ('|^(\d{1,2})\.(\d{1,2})\.(\d{2})$|', $str, $matches) === 1) {
    return $matches[1].'/'.$matches[2].'/20'.$matches[3];
  }
}
		    
function usage ($err) {
  global $argv;
  echo $argv[0].' [-h] [-d] [-v] -u utilisateur -p "mot de passe" source destination'."\n";
  echo " -h : affiche cette aide.\n";
  echo " -d : mode debug - teste uniquement si l'arborescence et les noms de fichiers 
      sont corrects, n'importe pas réellement les documents.\n";
  echo " -v : verbeux - explique les opérations effectuées.\n";
  echo "\n";
  echo '"source" indique un répertoire contenant les documents à importer 
dans Variation. Les documents à importer sont à placer dans une arborescence. 
Le premier niveau de cette arboresence indique la thématique du document 
(à choisir parmi la liste des libellés des thématiques de l\'installation 
de Variation), le second niveau indique le type de document (à choisir parmi 
la liste des libellés des types associés à la thématique du niveau supérieur).
Ce dernier niveau contient les documents, nommés de la manière suivante :
nom+prénom[+nom+prénom]...[+date][+indice].extension, date au format jj-mm-aaaa.
Le document ainsi nommé sera affecté à la liste des usagers indiqués par les paires 
nom/prénom. Si une date est indiquée, elle sera utilisée comme date de réalisation.
Un indice peut être nécessaire si vous devez importer plusieurs documents pour les
mêmes usagers à la même date. Ajoutez dans ce cas un nombre quelconque en fin de nom
pour les différencier.'."\n";
  echo '"destination" indique un répertoire dans lequel seront déplacés les fichiers 
correctement intégrés dans la base. Les fichiers dont le format n\'est pas correct
se trouveront toujours dans le répertoire source à la fin de l\'opération.'."\n";
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
