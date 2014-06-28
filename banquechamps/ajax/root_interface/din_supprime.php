<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$din = substr ($_POST['din'], 4);
$base->meta_dirinfo_delete ($din);
?>
