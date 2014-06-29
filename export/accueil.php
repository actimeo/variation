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
require ('../inc/export.inc.php');
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

switch ($basename) {
case 'accueil':
  $xml = new SimpleXMLElement ('<meta></meta>');
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  if (count ($cats)) {
    foreach ($cats as $cat) {
      exporte_cat ($_SESSION['token'], $xml, $cat);
    }
  }
  break;

case 'cat':
  $cat_id = substr ($_GET['id'], 4);
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  if (count ($cats)) {
    foreach ($cats as $cat) {
      if ($cat['cat_id'] == $cat_id) {
	$ref = null;
	$xml = exporte_cat ($_SESSION['token'], $ref, $cat);
	break;
      }
    }
  }
  break;
  /*  
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
      exporte_menu ($_SESSION['token'], $menu);
    }
  }
  echo '</entite>';
  break;

case 'menu':
  $menu = $base->meta_menu_infos ($_SESSION['token'], substr ($_GET['id'], 4));
  exporte_menu ($_SESSION['token'], $menu);
  break;
  
case 'sousmenu':
  $sousmenu = $base->meta_sousmenu_infos ($_SESSION['token'], substr ($_GET['id'], 4));
  exporte_sousmenu ($_SESSION['token'], $sousmenu);
  break;

case 'principal':
  $portail = $base->meta_portail_infos ($_SESSION['token'], substr ($_GET['por'], 4));
  exporte_principal ($_SESSION['token'], $portail);
  break;

case 'topmenu':
  $topmenu = $base->meta_topmenu_get ($_SESSION['token'], substr ($_GET['id'], 4));
  //  print_r ($topmenu);
  exporte_topmenu ($_SESSION['token'], $topmenu);
  break;
  */
}

$dom = new DOMDocument('1.0');
$dom->preserveWhiteSpace = false;
$dom->formatOutput = true;
$dom->loadXML($xml->asXML());
$str = $dom->saveXML();

if (false) {
  $gzipoutput = gzencode ($str);

  header('Content-Type: application/x-download');
  
  header('Content-Disposition: attachment; filename="'.$basename.'.xml.gz"');
  header('Cache-Control: no-cache, no-store, max-age=0, must-revalidate');
  header('Pragma: no-cache');
  
  echo $gzipoutput;
} else {
  header('Content-Type: text/xml');
  echo $str;
}
?>
