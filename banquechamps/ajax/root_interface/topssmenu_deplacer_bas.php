<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$tsm_id = substr ($_POST['tsm'], 4);
$base->meta_topsousmenu_deplacer_bas ($tsm_id);
?>
