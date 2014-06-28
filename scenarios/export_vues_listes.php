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
$secteurs = $base->meta_secteur_liste ($token, NULL, $base->order('sec_code'));

$entites = $base->meta_entite_liste ($token);
$ent_code = array ();
foreach ($entites as $entite) {
  $ent_code[$entite['ent_id']] = $entite['ent_code'];
}

$infos = $base->meta_info_liste ($token, NULL, false, NULL);
$inf = array ();
foreach ($infos as $info) {
  $inf[$info['inf_id']] = $info;
}

$infos_types = $base->meta_infos_type_liste ($token);
$int_code = array ();
foreach ($infos_types as $infos_type) {
  $int_code[$infos_type['int_id']] = $infos_type['int_code'];
}

$xml = new SimpleXMLElement ('<listes></listes>');
$listes = $base->liste_liste_all ($token);
foreach ($listes as $liste) {
  $xml_liste = $xml->addChild ('liste');
  $xml_liste->addChild ('code', $liste['lis_code']);
  $xml_liste->addChild ('nom', $liste['lis_nom']);
  $xml_liste->addChild ('entite', $ent_code[$liste['ent_id']]);
  $xml_liste->addChild ('inverse', $liste['lis_inverse'] ? 'true' : 'false');
  $xml_liste->addChild ('pagination_tout', $liste['lis_pagination_tout'] ? 'true' : 'false');
  $xml_champs = $xml_liste->addChild ('champs');
  $champs = $base->liste_champ_liste ($token, $liste['lis_id']);
  foreach ($champs as $champ) {
    $xml_champ = $xml_champs->addChild ('champ');
    $xml_champ->addChild ('inf_code', $inf[$champ['inf_id']]['inf_code']);
    $xml_champ->addChild ('libelle', $champ['cha_libelle']);
    $xml_champ->addChild ('filtrer', $champ['cha_filtrer'] ? 'true' : 'false');
    $xml_champ->addChild ('verrouiller', $champ['cha_verrouiller'] ? 'true' : 'false');
    //    $xml_champ->addChild ('type', $int_code[$inf[$champ['inf_id']]['int_id']]);
    switch ($int_code[$inf[$champ['inf_id']]['int_id']]) {
    case 'groupe':
      $xml_champ->addChild ('groupe_cycle', $champ['cha__groupe_cycle'] ? 'true' : 'false');
      $xml_champ->addChild ('groupe_dernier', $champ['cha__groupe_dernier'] ? 'true' : 'false');
      $xml_champ->addChild ('groupe_contact', $champ['cha__groupe_contact'] ? 'true' : 'false');
      break;
    case 'famille':
      $xml_champ->addChild ('famille_details', $champ['cha__famille_details'] ? 'true' : 'false');
      $xml_champ->addChild ('champs_supp', $champ['cha_champs_supp'] ? 'true' : 'false');
      break;
    case 'contact':
      $xml_champ->addChild ('contact_filtre_utilisateur', $champ['cha__contact_filtre_utilisateur'] ? 'true' : 'false');
      $xml_champ->addChild ('champs_supp', $champ['cha_champs_supp'] ? 'true' : 'false');
      break;
    }

    $defauts = $base->liste_defaut_liste ($token, $champ['cha_id']);
    if (count ($defauts)) {
      $xml_defauts = $xml_champ->addChild ('defauts');
      foreach ($defauts as $defaut) {	
	switch ($int_code[$inf[$champ['inf_id']]['int_id']]) {
	case 'texte':
	  $val = $defaut['def_valeur_texte'];
	  $xml_defaut = $xml_defauts->addChild ('defaut', $val);
	  break;
	case 'selection':
	case 'statut_usager':
	case 'metier':
	  $val = $defaut['def_valeur_int'];
	  $xml_defaut = $xml_defauts->addChild ('defaut', $val);
	  break;
	case 'groupe':
	  $val1 = $defaut['def_valeur_int'];
	  $val2 = $defaut['def_valeur_int2'];
	  $xml_defaut = $xml_defauts->addChild ('defaut');
	  $xml_defaut->addChild('eta', $val1);
	  $xml_defaut->addChild('grp', $val2);
	  break;
	}
      }
    }

    $supps = $base->liste_supp_list ($token, $champ['cha_id']);
    if (count ($supps)) {
      $xml_supps = $xml_champ->addChild ('supps');
      foreach ($supps as $supp) {	
	$xml_supp = $xml_supps->addChild ('supp', $inf[$supp['inf_id']]['inf_code']);	
      }
    }    
  }
}

$dom = new DOMDocument('1.0');
$dom->preserveWhiteSpace = false;
$dom->formatOutput = true;
$dom->loadXML($xml->asXML());
echo $dom->saveXML();

$base->commit ();
function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
