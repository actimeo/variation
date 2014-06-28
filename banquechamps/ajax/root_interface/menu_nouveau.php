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

$por = substr ($_POST['por'], 4);
$ent = substr ($_POST['ent'], 4);
$nom = $_POST['nom'];

$entites = $base->meta_entite_liste ();
foreach ($entites as $entite) {
  $enti[$entite['ent_code']] = $entite;
}


$base->meta_menu_add_end ($por, $nom, $enti[$ent]['ent_id']);
?>
