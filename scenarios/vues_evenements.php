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

$categories = $base->events_events_categorie_list ($token);
$codes_categories = array();
foreach ($categories as $c) {
  $codes_categories[] = $c['eca_code'];
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

/* 1 thématique x 1 catégorie */
foreach ($secteurs as $secteur) {
  foreach ($categories as $categorie) {
    $evs_id = $base->events_events_add ($token, $categorie['eca_nom'].', '.$secteur['sec_nom'], $categorie['eca_code'].'_'.$secteur['sec_code'], NULL);
    $base->events_secteur_events_set ($token, $evs_id, array ($secteur['sec_code']));
    $base->events_categorie_events_set ($token, $evs_id, array ($categorie['eca_code']));
  }
}

/* toutes thématiques x 1 catégorie */
foreach ($categories as $categorie) {
  $evs_id = $base->events_events_add ($token, $categorie['eca_nom'].', (toutes thématiques)', $categorie['eca_code'].'_tout', NULL);
  $base->events_secteur_events_set ($token, $evs_id, $codes_secteurs);
  $base->events_categorie_events_set ($token, $evs_id, array ($categorie['eca_code']));
}

/* 1 thématique x toutes catégories */
foreach ($secteurs as $secteur) {
  $evs_id = $base->events_events_add ($token, '(toutes catégories), '.$secteur['sec_nom'], 'tout_'.$secteur['sec_code'], NULL);
  $base->events_secteur_events_set ($token, $evs_id, array ($secteur['sec_code']));
  $base->events_categorie_events_set ($token, $evs_id, $codes_categories);
}

/* toutes thématiques x toutes catégories */
$evs_id = $base->events_events_add ($token, '(toutes catégories), (toutes thématiques)', 'tout_tout', NULL);
$base->events_secteur_events_set ($token, $evs_id, $codes_secteurs);
$base->events_categorie_events_set ($token, $evs_id, $codes_categories);


/* groupes de thématiques x 1 catégorie */
foreach ($groupes as $groupe_code => $groupe) {
  foreach ($categories as $categorie) {
    $evs_id = $base->events_events_add ($token, $categorie['eca_nom'].', '.$groupe['nom'], $categorie['eca_code'].'_'.$groupe_code, NULL);
    $base->events_secteur_events_set ($token, $evs_id, $groupe['secteurs']);
    $base->events_categorie_events_set ($token, $evs_id, array ($categorie['eca_code']));
  }
}

/* groupes de thématiques x toutes catégories */
foreach ($groupes as $groupe_code => $groupe) {
  $evs_id = $base->events_events_add ($token, $categorie['eca_nom'].', '.$groupe['nom'], $categorie['eca_code'].'_'.$groupe_code, NULL);
  $base->events_secteur_events_set ($token, $evs_id, $groupe['secteurs']);
  $base->events_categorie_events_set ($token, $evs_id, $codes_categories);
}

$base->commit ();
function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
