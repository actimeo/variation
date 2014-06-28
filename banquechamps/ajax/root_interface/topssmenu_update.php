<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$tsm_id = $_POST['tsm_id'];
$titre = $_POST['titre'];
$icone = $_POST['icone'];
$type = $_POST['type'];
$type_id = $_POST['type_id'];
$sme_id_lien_usager = $_POST['sme_id_lien_usager'];

echo $sme_id_lien_usager;
$base->meta_topsousmenu_update ($tsm_id, $titre, $icone, $type, $type_id, $sme_id_lien_usager);
?>
