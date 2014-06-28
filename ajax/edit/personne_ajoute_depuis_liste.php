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
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/enums.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$prm_ent_code = $_GET['prm_ent_code'];
$prm_prenom = $_GET['prm_prenom'];
$prm_nom = $_GET['prm_nom'];
$grp_id_prise_en_charge = $_GET['prm_grp_id_prise_en_charge'];
$per_id = $base->personne_ajoute ($_SESSION['token'], $prm_ent_code);
$base->personne_info_varchar_set ($_SESSION['token'], $per_id, 'nom', $prm_nom, NULL);
$base->personne_info_varchar_set ($_SESSION['token'], $per_id, 'prenom', $prm_prenom, NULL);

if ($grp_id_prise_en_charge) {
  $base->personne_groupe_ajoute ($_SESSION['token'], $per_id, $grp_id_prise_en_charge, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
}
echo $per_id;
?>
