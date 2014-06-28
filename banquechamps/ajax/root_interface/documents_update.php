<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$dos_id = $_POST['dos_id'];
$nom = $_POST['nom'];

if ($dos_id && $dos_id != 'null') {
  $base->document_documents_update ($dos_id, $nom);
} else {
  $base->document_documents_create ($nom);
}
?>
