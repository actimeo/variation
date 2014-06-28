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

$str = $_GET['str'];

$ints = $base->meta_infos_type_liste ($_SESSION['token']);
foreach ($ints as $i) {
  $int[$i['int_id']] = $i;
}

$infos = $base->meta_info_liste ($_SESSION['token'], $str, $_GET['usedonly'] == 1, NULL, $base->order ('inf_code'));
foreach ($infos as $info) {
  if (!$info['din_id']) {
    $ret[] = array ('data' => $info['inf_libelle'].' ('.$int[$info['int_id']]['int_libelle'].')',
		    'attr' => array ('myid' => 'inf_'.$info['inf_id'], 
				     'id' => 'inf_'.$info['inf_id'], 
				     'rel' => 'champ_'.$int[$info['int_id']]['int_code']));
  }
}

$dirs = liste_dirs (null);

if (count($ret)) {
  $dirs [] = array ('data' => "Non classés", 'attr' => array ('rel' => 'nonclasse'), 'children' => $ret);
}
$root = array ('data' => 'Champs disponibles', "attr" => array ('rel' => 'root', 'id' => 'din_0'), 'children' => $dirs);
echo json_encode ($root);

function liste_dirs ($parent) {
  global $base, $str;
  $dirs = $base->meta_dirinfo_list ($_SESSION['token'], $parent, $base->order('din_libelle'));
  $ret = array ();
  if (count ($dirs)) {
    foreach ($dirs as $dir) {
      $children = array_merge ((array)liste_dirs ($dir['din_id']), (array)liste_champs ($dir['din_id']));
      if ((strlen ($str) && count ($children)) 
	  || ($_GET['usedonly'] && count($children)) 
	  || (!strlen ($str) && !$_GET['usedonly'])) {
	$ret[] = array ('data' => $dir['din_libelle'], "attr" => array ('id' => 'din_'.$dir['din_id'],
									  'rel' => 'dossier'),
			  'children' => $children);
      }
    }
  }
  return $ret;
}
function liste_champs ($din_id) {
  global $infos, $int;
  $ret = array ();
  foreach ($infos as $info) {
    if ($info['din_id'] == $din_id) {
      $ret[] = array ('data' => $info['inf_libelle'].' ('.$int[$info['int_id']]['int_libelle'].')',
		      'attr' => array ('myid' => 'inf_'.$info['inf_id'], 
				       'id' => 'inf_'.$info['inf_id'], 
				       'rel' => 'champ_'.$int[$info['int_id']]['int_code']));
    }
  }
  return $ret;
}
?>
