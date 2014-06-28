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

$gin_id = $_POST['gin_id'];
$list = $_POST['list'];

$elements = split (',', $list);

if ($gin_id) {
  $order = 0;
  foreach ($elements as $element) {
    if (substr ($element, 0, 3) == 'ing') {
      $base->meta_info_groupe_update (substr ($element, 4), $gin_id, $order);
    } else if (substr ($element, 0, 3) == 'inf') {
      $inf_id = substr ($element, 4);
      $base->meta_info_groupe_add_by_id ($inf_id, $gin_id, $order);
    }
    $order++;
  }
} else {
  // Suppression d'un champ
  if (substr ($list, 0, 3) == "ing") {
    $ing_id = substr ($list, 4);
    $base->meta_info_groupe_delete ($ing_id);  
    // Suppression d'un bloc de champs
  } else if (substr ($list, 0, 6) == 'topgin') {
    $gin_id = substr ($list, 7);
    $base->meta_groupe_infos_delete ($gin_id);
  }
}
?>
