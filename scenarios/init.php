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

/* Ajout d'une catégorie */
$cat_id = $base->meta_categorie_add ($token, "Catégorie par défaut", "cat1");

/* Ajout d'un portail */
$por_id = $base->meta_portail_add ($token, $cat_id, "Portail par défaut");

/* Ajout d'un établissement */
$eta_id = $base->etablissement_add ($token, "Établissement par défaut", $cat_id,
				    NULL, NULL, NULL, NULL, NULL, NULL, NULL);
/* Affectation de l'établissement à tous les secteurs */
$base->etablissement_secteurs_set ($token, $eta_id, $codes_secteurs);

/* Ajout d'un groupe de prise en charge */
$grp_id = $base->groupe_add ($token, "Prise en charge par défaut", $eta_id,
			     NULL, NULL, NULL);
$base->groupe_secteurs_set ($token, $grp_id, array ('prise_en_charge'));
$inf = $base->meta_info_get_par_code ($token, 'groupe_prise_en_charge');
if ($inf['inf_id']) {
  $base->groupe_info_secteur_save ($token, $grp_id, 'prise_en_charge', $inf['inf_id']);
}

/* Ajout d'un groupe d'utilisateurs */
$gut_id = $base->login_grouputil_add ($token, "Administrateur système");
$base->login_grouputil_groupe_set ($token, $gut_id, array ($grp_id));
$base->login_grouputil_portail_set ($token, $gut_id, array ($por_id));

/* Ajout d'un usager */
$per_id = $base->personne_ajoute ($token, 'usager');
$base->personne_info_varchar_set ($token, $per_id, 'nom', 'DURAND', $uti_id_variation);
$base->personne_info_varchar_set ($token, $per_id, 'prenom', 'Pierre', $uti_id_variation);

$base->personne_groupe_ajoute ($token, $per_id, $grp_id, '01/01/2014', NULL, NULL, 
			       2 /* accepté */, NULL, NULL, NULL, NULL);
/* Ajout d'un employé */
$per_id = $base->personne_ajoute ($token, 'personnel');
$base->personne_info_varchar_set ($token, $per_id, 'nom', 'Administrateur', $uti_id_variation);
$base->personne_info_varchar_set ($token, $per_id, 'prenom', 'Système', $uti_id_variation);

/* Ajout d'un utilisateur "admin" */
$uti_id = $base->utilisateur_add ($token, 'admin', $per_id, TRUE, TRUE);
$base->utilisateur_grouputil_set ($token, $uti_id, array ($gut_id));

/* Connexion avec admin pour changer le mot de passe */
$uti = $base->utilisateur_get ($token, $uti_id);
$uti_infos_admin = $base->utilisateur_login2 ('admin', $uti['uti_pwd']);
$token_admin = $uti_infos_admin[0]['tok_token'];
$base->utilisateur_mdp_change ($token_admin, 'admin');

$base->commit ();
function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
