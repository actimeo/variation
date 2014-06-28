<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$nos_id = $_POST['nos_id'];
$nom = $_POST['nom'];
$the_id = $_POST['the_id'];

$base->notes_notes_update ($nos_id, $nom, $the_id);
?>
