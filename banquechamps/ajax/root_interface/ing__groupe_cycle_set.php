<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$ing_id = $_POST['ing_id'];
$val = $_POST['val'];
echo '/'.$val.'/';
$base->meta_ing__groupe_cycle_set ($ing_id, $val == 'true');
?>
