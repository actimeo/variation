<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$lis_id = $_POST['lis_id'];
$nom = $_POST['nom'];
$ent_id = $_POST['ent_id'];
$inverse = $_POST['inverse'];

if ($lis_id && $lis_id != 'null') {
  $base->liste_liste_update ($lis_id, $nom, $ent_id, $inverse == 'true');
} else {
  $base->liste_liste_create ($nom, $ent_id, $inverse == 'true');
}
?>
