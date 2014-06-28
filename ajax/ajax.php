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
require_once ('../inc/config.inc.php');
require_once ('../inc/pgprocedures.class.php');
require_once ('funcs.xmlentities.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$cmd = $_SERVER['PHP_SELF'];
$cmd = basename ($cmd, '.php');

$debug = false;

$ret = $base->get_arguments ($cmd);

if ($debug)
  print_r ($ret);

if (count ($ret)) {
  foreach ($ret as $r) {
    $all = true;
    foreach ($r['argnames'] as $argname) {
      if (!isset ($_REQUEST[$argname])) {
	if ($debug) {
	  echo "$argname non trouve\n" ;
	  print_r ($_REQUEST);
	}
	$all = false;
	break;
      }
    }
    if ($all) {
      break;
    }
    
  }
}

// Continue, $r contains argnames and argtypes
//print_r ($r);

$args = array ();
if ($all) {
  foreach ($r['argnames'] as $argname) {
    $a = get_magic_quotes_gpc() ? stripslashes($_REQUEST[$argname]) : $_REQUEST[$argname];
    if ($a == 'null')
      $a = null;
    $args[] = $a;
    //    $args[] = $_REQUEST[$argname];
  }
 }
$results = $base->__call ($cmd, $args);

if (isset ($_REQUEST['output']) && $_REQUEST['output'] == 'json') {
  header ('Content-Type: application/json ; charset=utf-8');
  header ('Cache-Control: no-cache , private');
  header ('Pragma: no-cache');
  echo '[ ';
  
  $aout = array ();
  if (is_array ($results) && isset ($results[0])) {
    foreach ($results as $result) {
      $ares = array ();
      foreach ($result as $key => $val) {
	$ares[] = '"'.$key.'": "'.$val.'"';
      }
      $aout[] = '{ '.implode (', ', $ares).' }';
    }
    echo implode (', ', $aout);
  } 
  echo ' ]';
  exit;
 }

if (isset ($_REQUEST['output']) && $_REQUEST['output'] == 'json2') {
  header ('Content-Type: application/json ; charset=utf-8');
  header ('Cache-Control: no-cache , private');
  header ('Pragma: no-cache');
  echo json_encode ($results);
  exit;
 }

if (!$results)
  exit;

header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');
echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<results>';
//print_r ($results);
if (is_array ($results) && isset ($results[0])) {
  foreach ($results as $result) {
    echo '<result>';
    foreach ($result as $key => $val) {
      if ($val === true)
	echo "<$key>".$val."</$key>";
      else
	echo "<$key>".xmlentities ($val)."</$key>";
    }
    echo '</result>';  
  }
 } else {
  if (is_array ($results)) {
    echo '<result>';
    foreach ($results as $key => $val) {
      if ($val === true)
	echo "<$key>".$val."</$key>";
      else
	echo "<$key>".xmlentities ($val)."</$key>";
    }
    echo '</result>';    
  } else {
    echo $results;
  }
 }
echo '</results>';
?>
