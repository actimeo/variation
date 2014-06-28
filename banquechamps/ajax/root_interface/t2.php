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

$ints = $base->meta_infos_type_liste ();
foreach ($ints as $i) {
  $int[$i['int_id']] = $i;
}
$sme_id = $_GET['sme_id'];
$ret = array ();
$groupes = $base->meta_groupe_infos_liste ($sme_id);
foreach ($groupes as $groupe) {
  $infos = $base->meta_info_groupe_liste ($groupe['gin_id']);
  if (count ($infos)) {
    foreach ($infos as &$info) {
      $info['int'] = $int[$info['int_id']];
      $info['ing'] = $base->meta_info_groupe_get ($info['ing_id']);
    }
  }
  $ret[] = array ('gin_id' => $groupe['gin_id'], 
		  'gin_libelle' => $groupe['gin_libelle'],
		  'infos' => $infos);
}
echo json_encode ($ret);
?>
