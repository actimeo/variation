<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$din = substr ($_POST['din'], 4);

if ($din == 0)
  $din = null;

if (isset ($_POST['inf'])) {
  $inf = substr ($_POST['inf'], 4);
  $base->meta_info_move ($inf, $din);
} else if (isset ($_POST['din2'])) {
  $din2 = substr ($_POST['din2'], 4);
  $base->meta_dirinfo_move ($din2, $din);
}
?>
