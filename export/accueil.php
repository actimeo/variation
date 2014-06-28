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
// Exporte la racine de l'interface d'amin des menus (root/interface.php)

require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$basename = $_GET['basename'];
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$ents = array ();
$ents[] = array ('code' => 'usager',
		 'libelle' => 'Usager');
$ents[] = array ('code' => 'personnel',
		 'libelle' => 'Personnel');
$ents[] = array ('code' => 'contact',
		 'libelle' => 'Contact');
$ents[] = array ('code' => 'famille',
		 'libelle' => 'Famille');

ob_start ();
echo '<?xml version="1.0" encoding="utf-8"?>';

switch ($basename) {
case 'accueil':
  echo '<meta>';
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  if (count ($cats)) {
    foreach ($cats as $cat) {
      exporte_cat ($cat);
    }
  }
  echo '</meta>';
  break;
  
case 'cat':
  $cat_id = substr ($_GET['id'], 4);
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  if (count ($cats)) {
    foreach ($cats as $cat) {
      if ($cat['cat_id'] == $cat_id) 
	exporte_cat ($cat);
    }
  }
  break;
  
case 'entite':
  foreach ($ents as $ent) {
    if ($ent['code'] == substr ($_GET['ent'], 4))
      break;
  }
  echo '<entite code="'.$ent['code'].'">';
  echo '<nom>'.xml_entities ($ent['libelle']).'</nom>';
  $menus = $base->meta_menu_liste ($_SESSION['token'], substr ($_GET['por'], 4), substr ($_GET['ent'], 4));
  if (count ($menus)) {
    foreach ($menus as $menu) {
      exporte_menu ($menu);
    }
  }
  echo '</entite>';
  break;

case 'menu':
  $menu = $base->meta_menu_infos ($_SESSION['token'], substr ($_GET['id'], 4));
  exporte_menu ($menu);
  break;
  
case 'sousmenu':
  $sousmenu = $base->meta_sousmenu_infos ($_SESSION['token'], substr ($_GET['id'], 4));
  exporte_sousmenu ($sousmenu);
  break;

case 'principal':
  $portail = $base->meta_portail_infos ($_SESSION['token'], substr ($_GET['por'], 4));
  exporte_principal ($portail);
  break;

case 'topmenu':
  $topmenu = $base->meta_topmenu_get ($_SESSION['token'], substr ($_GET['id'], 4));
  //  print_r ($topmenu);
  exporte_topmenu ($topmenu);
  break;
}

$strflat = ob_get_contents ();

$dom = new DOMDocument('1.0');
$dom->preserveWhiteSpace = false;
$dom->formatOutput = true;
$dom->loadXML($strflat);
$str = $dom->saveXML();

ob_end_clean ();
if (true) {
  $gzipoutput = gzencode ($str);

  header('Content-Type: application/x-download');

  //header('Content-Encoding: gzip'); #
  //header('Content-Length: '.strlen($gzipoutput)); #
  
  header('Content-Disposition: attachment; filename="'.$basename.'.xml.gz"');
  header('Cache-Control: no-cache, no-store, max-age=0, must-revalidate');
  header('Pragma: no-cache');
  
  echo $gzipoutput;
} else {
  header('Content-Type: text/xml');
  echo $str;
}

function exporte_cat ($cat) {
  global $base;
  echo '<categorie code="'.xml_entities ($cat['cat_code']).'"><nom>'.xml_entities ($cat['cat_nom']).'</nom>';
  $portails = $base->meta_portail_liste ($_SESSION['token'], $cat['cat_id']);
  if (count ($portails)) {
    foreach ($portails as $portail) {
      exporte_portail ($portail);
    }
  }
  echo '</categorie>';

}

function exporte_portail ($portail) {
  global $ents;
  echo '<portail><nom>'.xml_entities ($portail['por_libelle']).'</nom>';
  foreach ($ents as $ent) {
    exporte_entite ($portail, $ent);
  }
  exporte_principal ($portail);
  echo '</portail>';
}

function exporte_entite ($portail, $ent) {
  global $base;
  echo '<entite code="'.xml_entities ($ent['code']).'">';
  echo '<nom>'.xml_entities ($ent['libelle']).'</nom>';
  $menus = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent['code']);
  if (count ($menus)) {
    foreach ($menus as $menu) {
      exporte_menu ($menu);
    }
  }
  echo '</entite>';
}

function exporte_menu ($menu) {
  global $base;
  echo '<menu><nom>'.xml_entities ($menu['men_libelle']).'</nom>';
  $sousmenus = $base->meta_sousmenu_liste ($_SESSION['token'], $menu['men_id']);
  if (count ($sousmenus)) {
    foreach ($sousmenus as $sousmenu) {
      exporte_sousmenu ($sousmenu);
    }
  }
  echo '</menu>';
}

function exporte_sousmenu ($sousmenu) {
  global $base;
  echo '<sousmenu type="'.$sousmenu['sme_type'].'" typeid="'.$sousmenu['sme_type_id'].'" modif="'.$sousmenu['sme_droit_modif'].'" suppression="'.$sousmenu['sme_droit_suppression'].'"><nom>'.xml_entities ($sousmenu['sme_libelle']).'</nom>';
  echo '<icone>'.xml_entities ($sousmenu['sme_icone']).'</icone>';
  $groupes = $base->meta_groupe_infos_liste ($_SESSION['token'], $sousmenu['sme_id']);
  if (count ($groupes)) {
    foreach ($groupes as $groupe) {
      echo '<groupe><nom>'.xml_entities ($groupe['gin_libelle']).'</nom>';
      $infos = $base->meta_info_groupe_liste ($_SESSION['token'], $groupe['gin_id']);
      if (count ($infos)) {
	foreach ($infos as $info) {
	  echo '<infos code="'.xml_entities ($info['inf_code']).'" groupecycle="'.$info['ing__groupe_cycle'].'"></infos>';
	}
      }
      echo '</groupe>';
    }
  }
  echo '</sousmenu>';
}

function exporte_principal ($portail) {
  global $base;
  echo '<topmenus>';
  $topmenus = $base->meta_topmenu_liste ($_SESSION['token'], $portail['por_id']);
  if (count ($topmenus)) {
    foreach ($topmenus as $topmenu) {
      exporte_topmenu ($topmenu);
    }
  }
  echo '</topmenus>';
}

function exporte_topmenu ($topmenu) {
  global $base;
  echo '<topmenu><nom>'.xml_entities ($topmenu['tom_libelle']).'</nom>';
  $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $topmenu['tom_id']);
  if (count ($topsousmenus)) {
    foreach ($topsousmenus as $topsousmenu) {
      echo '<topsousmenu modif="'.$topsousmenu['tsm_droit_modif'].'" suppression="'.$topsousmenu['tsm_droit_suppression'].'"><nom>'.xml_entities ($topsousmenu['tsm_libelle']).'</nom>';
      echo '<icone>'.xml_entities ($topsousmenu['tsm_icone']).'</icone>';
      echo '<type>'.xml_entities ($topsousmenu['tsm_type']).'</type>';
      echo '<type_id>'.xml_entities ($topsousmenu['tsm_type_id']).'</type_id>';
      echo '<titre>'.xml_entities ($topsousmenu['tsm_titre']).'</titre>';
      echo '</topsousmenu>';
    }
  }
  echo '</topmenu>';
}

function xml_entities($string) {
  return strtr(
	       $string, 
	       array(
		     "<" => "&lt;",
		     ">" => "&gt;",
		     '"' => "&quot;",
		     "'" => "&apos;",
		     "&" => "&amp;",
		     )
	       );
}
?>
