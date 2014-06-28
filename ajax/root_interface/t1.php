<?php
/*
This file is part of Variation.

Variation is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Variation is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with Variation.  If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------------------
Ce fichier fait partie de Variation.

Variation est un logiciel libre ; vous pouvez le redistribuer ou le modifier 
suivant les termes de la GNU Affero General Public License telle que publiée 
par la Free Software Foundation ; soit la version 3 de la licence, soit 
(à votre gré) toute version ultérieure.

Variation est distribué dans l'espoir qu'il sera utile, 
mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de 
QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la 
GNU Affero General Public License pour plus de détails.

Vous devez avoir reçu une copie de la GNU Affero General Public License 
en même temps que Variation ; si ce n'est pas le cas, 
consultez <http://www.gnu.org/licenses>.
--------------------------------------------------------------------------------
Copyright (c) 2014 Kavarna SARL
*/
?>
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

$ret = array ();
$cats = $base->meta_categorie_liste($_SESSION['token'], $base->order('cat_id'));

if (count ($cats)) {
  foreach ($cats as $cat) {  
    $portails = $base->meta_portail_liste ($_SESSION['token'], $cat['cat_id']);
    $ch = array ();
    if (count ($portails)) {
      foreach ($portails as $portail) {
	$entites = array ();
	$principal = array ();
	$topmenus = $base->meta_topmenu_liste ($_SESSION['token'], $portail['por_id']);
	$retopmenus = array ();
	if (count ($topmenus)) {
	  foreach ($topmenus as $topmenu) {
	    $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $topmenu['tom_id']);
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
	$entites[] = array ('data' => 'Fenêtre principale', 
			    "attr" => array ('rel' => 'principal'),
			    'children' => $retopmenus);
	
	// Usager
	$ents = array ();
	$ents[] = array ('code' => 'usager',
			 'libelle' => 'Fenêtre usager');
	$ents[] = array ('code' => 'personnel',
			 'libelle' => 'Fenêtre personnel');
	$ents[] = array ('code' => 'contact',
			 'libelle' => 'Fenêtre contact');
	$ents[] = array ('code' => 'famille',
			 'libelle' => 'Fenêtre famille');
	
	foreach ($ents as $ent) {
	  $menus = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent['code']);
	  $chmenus = array ();
	  if (count ($menus)) {
	    foreach ($menus as $menu) {
	      $sousmenus = $base->meta_sousmenu_liste ($_SESSION['token'], $menu['men_id']);
	      $chssmenus = array ();
	      if (count ($sousmenus)) {
		foreach ($sousmenus as $sousmenu) {
		  $groupes = $base->meta_groupe_infos_liste ($_SESSION['token'], $sousmenu['sme_id']);
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
$root[] = array ("data" => "Portails", "attr" => array ("rel" => "root"), "children" => $ret);
echo json_encode ($root);
?>
