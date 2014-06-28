<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$sme_id = substr ($_POST['sme'], 4);
$base->meta_sousmenu_deplacer_bas ($sme_id);
?>
