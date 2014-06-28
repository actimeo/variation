<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$cha_id = $_GET['prm_cha_id'];
$val = $_GET['prm_val'];
$base->liste_defaut_ajoute_texte ($cha_id, $val);

?>
