<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$cal_id = $_POST['cal_id'];
$nom = $_POST['nom'];
$ent_id = $_POST['ent_id'];

if ($cal_id && $cal_id != 'null') {
  $base->calendrier_calendrier_update ($cal_id, $nom, $ent_id);
} else {
  $base->calendrier_calendrier_create ($nom, $ent_id);
}
?>
