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

$gin_id = $_POST['gin_id'];
$list = $_POST['list'];

$elements = split (',', $list);

if ($gin_id) {
  $order = 0;
  foreach ($elements as $element) {
    if (substr ($element, 0, 3) == 'ing') {
      $base->meta_info_groupe_update ($_SESSION['token'], substr ($element, 4), $gin_id, $order);
    } else if (substr ($element, 0, 3) == 'inf') {
      $inf_id = substr ($element, 4);
      $base->meta_info_groupe_add_by_id ($_SESSION['token'], $inf_id, $gin_id, $order);
    }
    $order++;
  }
} else {
  // Suppression d'un champ
  if (substr ($list, 0, 3) == "ing") {
    $ing_id = substr ($list, 4);
    $base->meta_info_groupe_delete ($_SESSION['token'], $ing_id);  
    // Suppression d'un bloc de champs
  } else if (substr ($list, 0, 6) == 'topgin') {
    $gin_id = substr ($list, 7);
    $base->meta_groupe_infos_delete ($_SESSION['token'], $gin_id);
  }
}
?>
