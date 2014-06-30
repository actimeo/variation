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
if ($argc < 2) { 
  usage();
  exit;
}
require ('../inc/config.inc.php');
require ('../inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$base->startTransaction ();

$uti_infos = $base->utilisateur_login2 ('variation', $argv[1]);
if (!count ($uti_infos)) {
  usage();
  exit;
}
$uti_id_variation = $uti_infos[0]['uti_id'];
$token = $uti_infos[0]['tok_token'];

/* On récupère quelques infos génériques */
$entites = $base->meta_entite_liste ($token);
foreach ($entites as $entite) {
  $ent[$entite['ent_code']] = $entite;
}

$filename = 'portail.xml';
$portail = simplexml_load_file ($filename);

// On sélectionne le premier portail de la première catégorie
$cats = $base->meta_categorie_liste ($token);
$cat = $cats[0];
$pors = $base->meta_portail_liste ($token, $cat['cat_id']);
$por = $pors[0];
$por_id = $por['por_id'];

foreach ($portail->entite as $entite) {
  $ent_code = (string)$entite['code'];
  foreach ($entite->menu as $menu) {
    $men_id = $base->meta_menu_add_end ($token, $por_id, (string)$menu->nom, $ent[$ent_code]['ent_id']);
    foreach ($menu->sousmenu as $sousmenu) {
      // TODO : typeid
      $type = (string)$sousmenu['type'];
      $typeid = (string)$sousmenu['typeid'];
      $id = '';
      switch ($type) {
      case 'notes':
	$nos = $base->notes_notes_get_par_code ($token, $typeid);
	$id = $nos['nos_id'];
	break;
      case 'documents':
	$dos = $base->document_documents_get_par_code ($token, $typeid);
	$id = $dos['dos_id'];
	break;
      case 'event':
	$evs = $base->events_events_get_par_code ($token, $typeid);
	$id = $evs['evs_id'];
	break;
      }
      $sme_id = $base->meta_sousmenu_add_end ($token, $men_id, (string)$sousmenu->nom, 
					      $type, $id,
					      ((string)$sousmenu['modif']) == '1',
					      ((string)$sousmenu['suppression']) == '1',
					      (string)$sousmenu->icone);
      foreach ($sousmenu->groupe as $groupe) {
	$gin_id = $base->meta_groupe_infos_add_end ($token, $sme_id, (string)$groupe->nom);
	foreach ($groupe->infos as $infos) {
	  $base->meta_info_groupe_add_end ($token, (string)$infos['code'], $gin_id, ((string)$infos['groupecycle']) == '1', ((string)$infos['obligatoire']) == '1');
	}
      }
    }
  }
}

foreach ($portail->topmenus->topmenu as $topmenu) {
  $tom_id = $base->meta_topmenu_add_end ($token, $por_id, (string)$topmenu->nom);
  foreach ($topmenu->topsousmenu as $topsousmenu) {
    // TODO : typeid
    $type = (string)$topsousmenu->type;
    $typeid = (string)$topsousmenu->type_id;
    $id = '';
    switch ($type) {
    case 'notes':
      $nos = $base->notes_notes_get_par_code ($token, $typeid);
      $id = $nos['nos_id'];
      break;
    case 'documents':
      $dos = $base->document_documents_get_par_code ($token, $typeid);
      $id = $dos['dos_id'];
      break;
    case 'liste':
      $lis = $base->liste_liste_get_par_code ($token, $typeid);
      $id = $lis['lis_id'];
      break;
    case 'groupe':
      $sec = $base->meta_secteur_get_par_code ($token, $typeid);
      $id = $sec['sec_id'];
      break;
    case 'event':
      $evs = $base->events_events_get_par_code ($token, $typeid);
      $id = $evs['evs_id'];
      break;
    case 'agressources':
      $agr = $base->events_agressources_get_par_code  ($token, $typeid);
      $id = $agr['agr_id'];
      break;
    }

    $tsm_id = $base->meta_topsousmenu_add_end ($token, 
					       $tom_id, (string)$topsousmenu->nom, 
					       (string)$topsousmenu->icone,
					       $type,
					       $id,
					       (string)$topsousmenu->titre,
					       ((string)$topsousmenu['modif']) == '1',
					       ((string)$topsousmenu['suppression']) == '1');
  }
}

//exit;
$base->commit ();


function usage () {
  global $argv;
  echo "Usage: $argv[0] 'mot de passe variation'\n";
}
?>
