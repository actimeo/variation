<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$str = $_GET['str'];

$ints = $base->meta_infos_type_liste ();
foreach ($ints as $i) {
  $int[$i['int_id']] = $i;
}

$infos = $base->meta_info_liste ($str, $base->order ('inf_code'));
foreach ($infos as $info) {
  if (!$info['din_id']) {
    $ret[] = array ('data' => $info['inf_libelle'].' ('.$int[$info['int_id']]['int_libelle'].')',
		    'attr' => array ('myid' => 'inf_'.$info['inf_id'], 
				     'id' => 'inf_'.$info['inf_id'], 
				     'rel' => 'champ_'.$int[$info['int_id']]['int_code']));
  }
}

$dirs = liste_dirs (null);

if (count($ret)) {
  $dirs [] = array ('data' => "Non classés", 'attr' => array ('rel' => 'nonclasse'), 'children' => $ret);
}
$root = array ('data' => 'Champs disponibles', "attr" => array ('rel' => 'root', 'id' => 'din_0'), 'children' => $dirs);
echo json_encode ($root);

function liste_dirs ($parent) {
  global $base, $str;
  $dirs = $base->meta_dirinfo_list ($parent, $base->order('din_libelle'));
  $ret = array ();
  if (count ($dirs)) {
    foreach ($dirs as $dir) {
      $children = array_merge ((array)liste_dirs ($dir['din_id']), (array)liste_champs ($dir['din_id']));
      if ((strlen ($str) && count ($children)) || !strlen ($str)) {
	$ret[] = array ('data' => $dir['din_libelle'], "attr" => array ('id' => 'din_'.$dir['din_id'],
									  'rel' => 'dossier'),
			  'children' => $children);
      }
    }
  }
  return $ret;
}
function liste_champs ($din_id) {
  global $infos, $int;
  $ret = array ();
  foreach ($infos as $info) {
    if ($info['din_id'] == $din_id) {
      $ret[] = array ('data' => $info['inf_libelle'].' ('.$int[$info['int_id']]['int_libelle'].')',
		      'attr' => array ('myid' => 'inf_'.$info['inf_id'], 
				       'id' => 'inf_'.$info['inf_id'], 
				       'rel' => 'champ_'.$int[$info['int_id']]['int_code']));
    }
  }
  return $ret;
}
?>
