<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$tom_id = substr ($_POST['tom'], 4);
$base->meta_topmenu_deplacer_haut ($tom_id);
?>
