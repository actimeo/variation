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

require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$ints = $base->meta_infos_type_liste ($_SESSION['token']);
foreach ($ints as $i) {
  $int[$i['int_id']] = $i;
}
$sme_id = $_GET['sme_id'];
$ret = array ();
$groupes = $base->meta_groupe_infos_liste ($_SESSION['token'], $sme_id);
foreach ($groupes as $groupe) {
  $infos = $base->meta_info_groupe_liste ($_SESSION['token'], $groupe['gin_id']);
  if (count ($infos)) {
    foreach ($infos as &$info) {
      $info['int'] = $int[$info['int_id']];
      $info['ing'] = $base->meta_info_groupe_get ($_SESSION['token'], $info['ing_id']);
    }
  }
  $ret[] = array ('gin_id' => $groupe['gin_id'], 
		  'gin_libelle' => $groupe['gin_libelle'],
		  'infos' => $infos);
}
echo json_encode ($ret);
?>
