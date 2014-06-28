<?php
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$ret = array ();
$cats = $base->meta_categorie_liste($base->order('cat_id'));

if (count ($cats)) {
  foreach ($cats as $cat) {  
    $portails = $base->meta_portail_liste ($cat['cat_id']);
    $ch = array ();
    if (count ($portails)) {
      foreach ($portails as $portail) {
	$entites = array ();
	$principal = array ();
	$topmenus = $base->meta_topmenu_liste ($portail['por_id']);
	$retopmenus = array ();
	if (count ($topmenus)) {
	  foreach ($topmenus as $topmenu) {
	    $topsousmenus = $base->meta_topsousmenu_liste ($topmenu['tom_id']);
	    $retopsousmenus = array ();
	    if (count ($topsousmenus)) {
	      foreach ($topsousmenus as $topsousmenu) {
		$retopsousmenus[] = array ('data' => $topsousmenu['tsm_libelle'], 
					   'attr' => array ('rel' => 'topfiche',
							    'id' => 'tsm_'.$topsousmenu['tsm_id']));
	      }
	    }
	    $retopmenus[] = array ('data' => $topmenu['tom_libelle'],
				   'attr' => array ('rel' => 'topmenu',
						    'id' => 'tom_'.$topmenu['tom_id']),
				   'children' => $retopsousmenus);
	  }
	}
	$entites[] = array ('data' => 'Menu principal', 
			    "attr" => array ('rel' => 'principal'),
			    'children' => $retopmenus);
	
	// Usager
	$ents = array ();
	$ents[] = array ('code' => 'usager',
			 'libelle' => 'Usager');
	$ents[] = array ('code' => 'personnel',
			 'libelle' => 'Personnel');
	$ents[] = array ('code' => 'contact',
			 'libelle' => 'Contact');
	$ents[] = array ('code' => 'famille',
			 'libelle' => 'Famille');
	
	foreach ($ents as $ent) {
	  $menus = $base->meta_menu_liste ($portail['por_id'], $ent['code']);
	  $chmenus = array ();
	  if (count ($menus)) {
	    foreach ($menus as $menu) {
	      $sousmenus = $base->meta_sousmenu_liste ($menu['men_id']);
	      $chssmenus = array ();
	      if (count ($sousmenus)) {
		foreach ($sousmenus as $sousmenu) {
		  $groupes = $base->meta_groupe_infos_liste ($sousmenu['sme_id']);
		  $chssmenus[] = array ("data" => $sousmenu['sme_libelle'], "attr" => array ("id" => "sme_".$sousmenu['sme_id'], "rel" => "page"));
		}
	      }
	      $chmenus[] = array ("data" => $menu['men_libelle'], "attr" => array ("id" => "men_".$menu['men_id'], "rel" => "menu"), "children" => $chssmenus);
	    }
	  }
	  $entites[] = array ("data" => $ent['libelle'], "attr" => array ("id" => "ent_".$ent['code'].$portail['por_id'], "rel" => "entite"), "children" => $chmenus);
	}
	
	$ch[] = array ("data" => $portail['por_libelle'], "attr" => array ("id"=> "por_".$portail['por_id'], "rel" => "portail"), "children" => $entites);
      }
    }
    $ret[] = array ("data" => $cat['cat_nom'], "attr" => array ("id" => 'cat_'.$cat['cat_id'], "rel" => "categorie"), "children" => $ch);
  }
}
$root = array ();
$root[] = array ("data" => "Accueil", "attr" => array ("rel" => "root"), "children" => $ret);
echo json_encode ($root);
?>
