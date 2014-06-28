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
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');

// L'un ou l'autre en paramètre
$inf_id = $_GET['prm_inf_id'];
$cha_id = $_GET['prm_cha_id'];

$eta_id = $_GET['prm_eta_id'];

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
if ($cha_id) {
  $champ = $base->liste_champ_get ($_SESSION['token'], $cha_id);
  $inf_id = $champ['inf_id'];
}
$info = $base->meta_info_get ($_SESSION['token'], $inf_id);
$grps = $base->groupe_filtre ($_SESSION['token'], $info['inf__groupe_type'], null, null, null, $base->order ('grp_nom'));
if (count ($grps)) {
  foreach ($grps as $k => $grp) {
    if ($grp['eta_id'] != $eta_id)
      unset ($grps[$k]);
  }
}

echo json_encode ($grps);
?>
