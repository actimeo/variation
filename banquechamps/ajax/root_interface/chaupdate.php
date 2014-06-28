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

$lis_id = $_POST['lis_id'];
$list = $_POST['list'];

$elements = split (',', $list);

$order = 0;
foreach ($elements as $element) {
  if (substr ($element, 0, 3) == 'cha') {
    $base->liste_champ_set_ordre (substr ($element, 4), $order);
  } else {
    $base->liste_champ_add ($lis_id, substr ($element, 4), $order);
  }
  $order++;
}
?>
