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
$entites = $base->meta_entite_liste ($token);
$ent_id = array ();
foreach ($entites as $entite) {
  $ent_id[$entite['ent_code']] = $entite['ent_id'];
}

$infos = $base->meta_info_liste ($token, NULL, false, NULL);
$inf = array ();
foreach ($infos as $info) {
  $inf[$info['inf_code']] = $info;
}

$infos_types = $base->meta_infos_type_liste ($token);
$int_code = array ();
foreach ($infos_types as $infos_type) {
  $int_code[$infos_type['int_id']] = $infos_type['int_code'];
}

$filename = 'vues_listes.xml';
$xml = simplexml_load_file ($filename);
$xml_listes = $xml->liste;
if (count ($xml_listes)) {
  foreach ($xml_listes as $xml_liste) {
    $lis_id = $base->liste_liste_create ($token, 
					 (string)$xml_liste->nom, 
					 (string)$xml_liste->code, 
					 $ent_id[(string)$xml_liste->entite], 
					 (string)$xml_liste->inverse == 'true',
					 (string)$xml_liste->pagination_tout == 'true');
    $xml_champs = $xml_liste->champs->champ;
    if (count ($xml_champs)) {
      $cha_ordre = 0;
      foreach ($xml_champs as $xml_champ) {
	if (!isset ($inf[(string)$xml_champ->inf_code])) {
	  echo 'Champ non trouvé : '.$xml_champ->inf_code."\n";
	  echo 'Arrêt'."\n";
	  exit;
	}
	$cha_id = $base->liste_champ_add ($token, 
					  $lis_id, 
					  $inf[(string)$xml_champ->inf_code]['inf_id'],
					  (string)$cha_ordre);
	$base->liste_champ_set_libelle ($token, $cha_id, (string)$xml_champ->libelle);
	$base->liste_champ_set_filtrer ($token, $cha_id, (string)$xml_champ->filtrer == 'true');
	$base->liste_champ_set_verrouiller ($token, $cha_id, (string)$xml_champ->verrouiller == 'true');
	if (property_exists ($xml_champ, 'groupe_cycle')) {
	  $base->liste_champ_set_cycle ($token, $cha_id, (string)$xml_champ->groupe_cycle == 'true');
	}
	if (property_exists ($xml_champ, 'groupe_dernier')) {
	  $base->liste_champ_set_dernier ($token, $cha_id, (string)$xml_champ->groupe_dernier == 'true');
	}
	if (property_exists ($xml_champ, 'groupe_contact')) {
	  $base->liste_champ_set_contact ($token, $cha_id, (string)$xml_champ->groupe_contact == 'true');
	}
	if (property_exists ($xml_champ, 'famille_details')) {
	  $base->liste_champ_set_details ($token, $cha_id, (string)$xml_champ->famille_details == 'true');
	}
	if (property_exists ($xml_champ, 'contact_filtre_utilisateur')) {
	  $base->liste_champ_set_contact_filtre_utilisateur ($token, $cha_id, (string)$xml_champ->contact_filtre_utilisateur == 'true');
	}
	if (property_exists ($xml_champ, 'champs_supp')) {
	  $base->liste_champ_set_champs_supp ($token, $cha_id, (string)$xml_champ->champs_supp == 'true');
	}
	$cha_ordre ++;

	$type = $int_code[$inf[(string)$xml_champ->inf_code]['int_id']];
	$xml_defauts = $xml_champ->defauts->defaut;
	if (count ($xml_defauts)) {
	  foreach ($xml_defauts as $xml_defaut) {
	    switch ($type) {
	    case 'texte':
	      $base->liste_defaut_ajoute_texte ($token, $cha_id, (string)$xml_defaut);
	      break;
	    case 'selection':
	    case 'statut_usager':
	    case 'metier':
	      $base->liste_defaut_ajoute_selection ($token, $cha_id, (string)$xml_defaut);
	      break;
	    case 'groupe':
	      $base->liste_defaut_ajoute_groupe ($token, $cha_id, (string)$xml_defaut->eta, (string)$xml_defaut->grp);
	      break;
	    }
	  }
	}

	$xml_supps = $xml_champ->supps->supp;	
	if (count ($xml_supps)) {
	  $inf_ids = array ();
	  foreach ($xml_supps as $xml_supp) {
	    $inf_ids[] = $inf[(string)$xml_supp]['inf_id'];
	  }
	  $base->liste_supp_edit ($token, $cha_id, $inf_ids);
	}
      }
    }
  }
}

//exit;
$base->commit ();


function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
