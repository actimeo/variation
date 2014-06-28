<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/enums.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$lis_id = $_GET['lis_id'];

$ret = $base->liste_champ_liste_details ($lis_id);

foreach ($ret as $k => $re) {
  $d = $base->liste_defaut_liste ($re['cha_id']);
  switch ($re['int_code']) {
  case 'texte':
    break;
  case 'selection':
    foreach ($d as $k2 => $def) {      
      $sen = $base->meta_selection_entree_get ($def['def_valeur_int']);
      $d[$k2]['def_valeur_selection'] = $sen['sen_libelle'];
    }
    break;
  case 'statut_usager':
    foreach ($d as $k2 => $def) {
      $d[$k2]['def_valeur_selection'] = $statuts_usager[$def['def_valeur_int']];
    }
    break;
  case 'metier':
    foreach ($d as $k2 => $def) {
      $sen = $base->meta_secteur_get ($def['def_valeur_int']);
      $d[$k2]['def_valeur_selection'] = $sen['sec_nom'];
    }
    break;
  case 'groupe':
    foreach ($d as $k2 => $def) {      
      $eta = $base->etablissement_get ($def['def_valeur_int']);
      $grp = $base->groupe_get ($def['def_valeur_int2']);
      $d[$k2]['def_valeur_groupe'] = $eta['eta_nom'].'<br>'.$grp['grp_nom'];
    }
    break;
  }
  $ret[$k]['defauts'] = $d;
}

echo json_encode ($ret);
?>
