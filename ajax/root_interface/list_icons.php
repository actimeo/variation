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
include ('../../inc/config.inc.php');
$dir = $_GET['dir'];
if (substr ($dir, 0, 3) != 'IS_') {
  echo 'ERR';
  return;
}
$dir = str_replace ('/', '', $dir);
$dir = str_replace ('.', '', $dir);
$path = '/Images/'.$dir.'/originals/png/NORMAL/32';
$subdirs = scandir ($dirbase.'/Images/'.$dir.'/originals/png/NORMAL/32');
if (count ($subdirs) == 1) {
  $subdirs = scandir ($dirbase.'/Images/'.$dir.'/png/NORMAL/32');
  $path = 'Images/'.$dir.'/png/NORMAL/32';
}
$ret = array ();
foreach ($subdirs as $subdir) {
  if (substr ($subdir, 0, 1) != '.') {
    $ret[] = $path.'/'.$subdir;
  }
}
header ('Content-Type: application/json ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');
echo json_encode ($ret);
?>
