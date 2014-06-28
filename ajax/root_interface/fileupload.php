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

$entites = $base->meta_entite_liste ($_SESSION['token']);
foreach ($entites as $entite) {
  $ent[$entite['ent_code']] = $entite;
}

switch ($_GET['type']) {
case 'categorie':
  $cat_id = $base->meta_categorie_add ($_SESSION['token'], (string) $root->nom, (string)$root['code']);
  foreach ($root->portail as $portail) {
    $por_id = $base->meta_portail_add ($_SESSION['token'], $cat_id, (string)$portail->nom);
    foreach ($portail->entite as $entite) {
      $ent_code = (string)$entite['code'];
      foreach ($entite->menu as $menu) {
	$men_id = $base->meta_menu_add_end ($_SESSION['token'], $por_id, (string)$menu->nom, $ent[$ent_code]['ent_id']);
	foreach ($menu->sousmenu as $sousmenu) {
	  $sme_id = $base->meta_sousmenu_add_end ($_SESSION['token'], $men_id, (string)$sousmenu->nom, 
						  (string)$sousmenu['type'], (string)$sousmenu['typeid'],
						  ((string)$sousmenu['modif']) == '1',
						  ((string)$sousmenu['suppression']) == '1',
						  (string)$sousmenu->icone);
	  foreach ($sousmenu->groupe as $groupe) {
	    $gin_id = $base->meta_groupe_infos_add_end ($_SESSION['token'], $sme_id, (string)$groupe->nom);
	    foreach ($groupe->infos as $infos) {
	      $base->meta_info_groupe_add_end ($_SESSION['token'], (string)$infos['code'], $gin_id, ((string)$infos['groupecycle']) == '1');
	    }
	  }
	}
      }
    }
    // TODO: topmenus
    foreach ($portail->topmenus->topmenu as $topmenu) {
      $tom_id = $base->meta_topmenu_add_end ($_SESSION['token'], $por_id, (string)$topmenu->nom);
      foreach ($topmenu->topsousmenu as $topsousmenu) {
	$tsm_id = $base->meta_topsousmenu_add_end ($_SESSION['token'], 
						   $tom_id, (string)$topsousmenu->nom, 
						   (string)$topsousmenu->icone,
						   (string)$topsousmenu->type,
						   (string)$topsousmenu->type_id,
						   (string)$topsousmenu->titre,
						   ((string)$topsousmenu['modif']) == '1',
						   ((string)$topsousmenu['suppression']) == '1');
      }
    }
    // /topmenus            

  }
  break;
  
case 'entite':
  list ($t1, $t2) = split (',', $_GET['id']);
  $ent_code = substr ($t1, 4);
  $por_id = substr ($t2, 4);
  foreach ($root->menu as $menu) {
    $men_id = $base->meta_menu_add_end ($_SESSION['token'], $por_id, (string)$menu->nom, $ent[$ent_code]['ent_id']);
    foreach ($menu->sousmenu as $sousmenu) {
      $sme_id = $base->meta_sousmenu_add_end ($_SESSION['token'], $men_id, (string)$sousmenu->nom, NULL, NULL, NULL, NULL, NULL);
      foreach ($sousmenu->groupe as $groupe) {
	$gin_id = $base->meta_groupe_infos_add_end ($_SESSION['token'], $sme_id, (string)$groupe->nom);
	foreach ($groupe->infos as $infos) {
	  $base->meta_info_groupe_add_end ($_SESSION['token'], (string)$infos['code'], $gin_id, NULL); // TODO cycle
	}
      }
    }
  }  
  break;
  
case 'menu':
  list ($t1, $t2) = split (',', $_GET['id']);
  $ent_code = substr ($t1, 4);
  $por_id = substr ($t2, 4);
  $men_id = $base->meta_menu_add_end ($_SESSION['token'], $por_id, (string)$root->nom, $ent[$ent_code]['ent_id']);
  foreach ($root->sousmenu as $sousmenu) {
    $sme_id = $base->meta_sousmenu_add_end ($_SESSION['token'], $men_id, (string)$sousmenu->nom, NULL, NULL, NULL, NULL, NULL);
    foreach ($sousmenu->groupe as $groupe) {
      $gin_id = $base->meta_groupe_infos_add_end ($_SESSION['token'], $sme_id, (string)$groupe->nom);
      foreach ($groupe->infos as $infos) {
	$base->meta_info_groupe_add_end ($_SESSION['token'], (string)$infos['code'], $gin_id, NULL); // TODO cycle
      }
    }
  }
  break;
  
case 'sousmenu':
  $sme_id = $base->meta_sousmenu_add_end ($_SESSION['token'], substr ($_GET['id'], 4), (string) $root->nom, NULL, NULL, NULL, NULL, NULL);
  foreach ($root->groupe as $groupe) {
    $gin_id = $base->meta_groupe_infos_add_end ($_SESSION['token'], $sme_id, (string)$groupe->nom);
    foreach ($groupe->infos as $infos) {
      $base->meta_info_groupe_add_end ($_SESSION['token'], (string)$infos['code'], $gin_id, NULL); // TODO cycle
    }
  }
  break;

case 'topmenus':
  $por_id = substr ($_GET['id'], 4);
  foreach ($root->topmenu as $topmenu) {
    $tom_id = $base->meta_topmenu_add_end ($_SESSION['token'], $por_id, (string)$topmenu->nom);
    foreach ($topmenu->topsousmenu as $topsousmenu) {
      $tsm_id = $base->meta_topsousmenu_add_end ($_SESSION['token'],
						 $tom_id, (string)$topsousmenu->nom, 
						 (string)$topsousmenu->icone,
						 (string)$topsousmenu->type,
						 (string)$topsousmenu->type_id,
						 (string)$topsousmenu->titre,
						 ((string)$topsousmenu['modif']) == '1',
						 ((string)$topsousmenu['suppression']) == '1');
    }
  }
  break;

case 'topmenu':
  $por_id = substr ($_GET['id'], 4);
  $tom_id = $base->meta_topmenu_add_end ($_SESSION['token'], $por_id, (string)$root->nom);
  foreach ($root->topsousmenu as $topsousmenu) {
    $tsm_id = $base->meta_topsousmenu_add_end ($_SESSION['token'], $tom_id, (string)$topsousmenu->nom, (string)$topsousmenu->icone, 
					       (string)$topsousmenu->type, (string)$topsousmenu->type_id, (string)$topsousmenu->titre,
					       NULL, NULL); // TODO droits
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
