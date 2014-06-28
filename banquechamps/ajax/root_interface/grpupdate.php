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

$sme_id = $_POST['sme_id'];
$list = $_POST['list'];

$elements = split (',', $list);

$order = 0;
foreach ($elements as $element) {
  if (substr ($element, 0, 6) == 'topgin') {
    $base->meta_groupe_infos_update (substr ($element, 7), $order);
  }
  $order++;
}
?>
