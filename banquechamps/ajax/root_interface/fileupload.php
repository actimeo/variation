<?php
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$gzcontents = file_get_contents('php://input');

// Gz-decompress content
$contents = gzdecode ($gzcontents);
if ($contents === FALSE) {
  $contents = $gzcontents;
}

// Verify that root element is OK
$root = simplexml_load_string ($contents);
if ($root->getName () != $_GET['type']) {
  echo 'ERR ROOT'.$root->getName ().' <> '.$_GET['type'];
  exit;
}

$entites = $base->meta_entite_liste ();
foreach ($entites as $entite) {
  $ent[$entite['ent_code']] = $entite;
}

switch ($_GET['type']) {
case 'categorie':
  $cat_id = $base->meta_categorie_add ((string) $root->nom, (string)$root['code']);
  foreach ($root->portail as $portail) {
    $por_id = $base->meta_portail_add ($cat_id, (string)$portail->nom);
    foreach ($portail->entite as $entite) {
      $ent_code = (string)$entite['code'];
      foreach ($entite->menu as $menu) {
	$men_id = $base->meta_menu_add_end ($por_id, (string)$menu->nom, $ent[$ent_code]['ent_id']);
	foreach ($menu->sousmenu as $sousmenu) {
	  $sme_id = $base->meta_sousmenu_add_end ($men_id, (string)$sousmenu->nom);
	  foreach ($sousmenu->groupe as $groupe) {
	    $gin_id = $base->meta_groupe_infos_add_end ($sme_id, (string)$groupe->nom);
	    foreach ($groupe->infos as $infos) {
	      $base->meta_info_groupe_add_end ((string)$infos['code'], $gin_id);
	    }
	  }
	}
      }
    }
  }
  break;
  
case 'entite':
  list ($t1, $t2) = split (',', $_GET['id']);
  $ent_code = substr ($t1, 4);
  $por_id = substr ($t2, 4);
  foreach ($root->menu as $menu) {
    $men_id = $base->meta_menu_add_end ($por_id, (string)$menu->nom, $ent[$ent_code]['ent_id']);
    foreach ($menu->sousmenu as $sousmenu) {
      $sme_id = $base->meta_sousmenu_add_end ($men_id, (string)$sousmenu->nom);
      foreach ($sousmenu->groupe as $groupe) {
	$gin_id = $base->meta_groupe_infos_add_end ($sme_id, (string)$groupe->nom);
	foreach ($groupe->infos as $infos) {
	  $base->meta_info_groupe_add_end ((string)$infos['code'], $gin_id);
	}
      }
    }
  }  
  break;
  
case 'menu':
  list ($t1, $t2) = split (',', $_GET['id']);
  $ent_code = substr ($t1, 4);
  $por_id = substr ($t2, 4);
  $men_id = $base->meta_menu_add_end ($por_id, (string)$root->nom, $ent[$ent_code]['ent_id']);
  foreach ($root->sousmenu as $sousmenu) {
    $sme_id = $base->meta_sousmenu_add_end ($men_id, (string)$sousmenu->nom);
    foreach ($sousmenu->groupe as $groupe) {
      $gin_id = $base->meta_groupe_infos_add_end ($sme_id, (string)$groupe->nom);
      foreach ($groupe->infos as $infos) {
	$base->meta_info_groupe_add_end ((string)$infos['code'], $gin_id);
      }
    }
  }
  break;
  
case 'sousmenu':
  $sme_id = $base->meta_sousmenu_add_end (substr ($_GET['id'], 4), (string) $root->nom);
  foreach ($root->groupe as $groupe) {
    $gin_id = $base->meta_groupe_infos_add_end ($sme_id, (string)$groupe->nom);
    foreach ($groupe->infos as $infos) {
      $base->meta_info_groupe_add_end ((string)$infos['code'], $gin_id);
    }
  }
  break;

case 'topmenus':
  $por_id = substr ($_GET['id'], 4);
  foreach ($root->topmenu as $topmenu) {
    $tom_id = $base->meta_topmenu_add_end ($por_id, (string)$topmenu->nom);
    foreach ($topmenu->topsousmenu as $topsousmenu) {
      $tsm_id = $base->meta_topsousmenu_add_end ($tom_id, (string)$topsousmenu->nom, 
						 (string)$topsousmenu->icone,
						 (string)$topsousmenu->type,
						 (string)$topsousmenu->type_id,
						 (string)$topsousmenu->titre);
    }
  }
  break;
}
function gzdecode($data){
  $g=tempnam('/tmp','ff');
  @file_put_contents($g,$data);
  ob_start();
  readgzfile($g);
  $d=ob_get_clean();
  return $d;
}
?>
