<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$cha_id = $_GET['prm_cha_id'];
$val = $_GET['prm_val'];
$val2 = $_GET['prm_val2'];
$base->liste_defaut_ajoute_groupe ($cha_id, $val, $val2);
?>
