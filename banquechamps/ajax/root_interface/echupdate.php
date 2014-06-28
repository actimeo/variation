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

$cal_id = $_POST['cal_id'];
$list = $_POST['list'];

$elements = split (',', $list);

foreach ($elements as $element) {
  if (substr ($element, 0, 3) == 'ech') {
  } else {
    $base->calendrier_echeance_add ($cal_id, substr ($element, 4), NULL);
  }
}
?>
