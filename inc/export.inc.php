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
function exporte_cat ($token, &$xml_parent, $cat) {
  global $base;
  if ($xml_parent !== NULL) {
    $xml_categorie = $xml_parent->addChild ('categorie');
  } else {
    $xml_categorie = new SimpleXMLElement ('<categorie></categorie>');
  }
  $xml_categorie->addAttribute ('code', $cat['cat_code']);
  $xml_categorie->addChild ('nom', $cat['cat_nom']);
  $portails = $base->meta_portail_liste ($token, $cat['cat_id']);
  if (count ($portails)) {
    foreach ($portails as $portail) {
      exporte_portail ($token, $xml_categorie, $portail);
    }
  }
  return $xml_categorie;
}

function exporte_portail ($token, &$xml_parent, $portail) {
  $ents = array ();
  $ents[] = array ('code' => 'usager',
		   'libelle' => 'Usager');
  $ents[] = array ('code' => 'personnel',
		   'libelle' => 'Personnel');
  $ents[] = array ('code' => 'contact',
		   'libelle' => 'Contact');
  $ents[] = array ('code' => 'famille',
		   'libelle' => 'Famille');

  $xml_portail = $xml_parent->addChild ('portail');
  $xml_portail->addChild ('nom', $portail['por_libelle']);
  foreach ($ents as $ent) {
    exporte_entite ($token, $xml_portail, $portail, $ent);
  }
  exporte_principal ($token, $xml_portail, $portail);
}

function exporte_entite ($token, &$xml_parent, $portail, $ent) {
  global $base;
  $xml_entite = $xml_parent->addChild ('entite');
  $xml_entite->addAttribute ('code', $ent['code']);
  $xml_entite->addChild ('nom', $ent['libelle']); // TODO: utile ?
  $menus = $base->meta_menu_liste ($token, $portail['por_id'], $ent['code']);
  if (count ($menus)) {
    foreach ($menus as $menu) {
      exporte_menu ($token, $xml_entite, $menu);
    }
  }
}

function exporte_menu ($token, &$xml_parent, $menu) {
  global $base;
  $xml_menu = $xml_parent->addChild ('menu');
  $xml_menu->addChild ('nom', $menu['men_libelle']);
  $sousmenus = $base->meta_sousmenu_liste ($token, $menu['men_id']);
  if (count ($sousmenus)) {
    foreach ($sousmenus as $sousmenu) {
      exporte_sousmenu ($token, $xml_menu, $sousmenu);
    }
  }
}

function exporte_sousmenu ($token, &$xml_parent, $sousmenu) {
  global $base;
  $xml_sousmenu = $xml_parent->addChild ('sousmenu');
  $xml_sousmenu->addAttribute ('type', $sousmenu['sme_type']); // parmi: notes, documents, event, '' (pour masque de données) 
  $code = '';
  switch ($sousmenu['sme_type']) {
  case 'notes':
    $nos = $base->notes_notes_get ($token, $sousmenu['sme_type_id']);
    $code = $nos['nos_code'];
    break;
  case 'documents':
    $dos = $base->document_documents_get ($token, $sousmenu['sme_type_id']);
    $code = $dos['dos_code'];
    break;
  case 'event':
    $evs = $base->events_events_get ($token, $sousmenu['sme_type_id']);
    $code = $evs['evs_code'];
    break;
  }
  $xml_sousmenu->addAttribute ('typeid', $code);
  $xml_sousmenu->addAttribute ('modif', $sousmenu['sme_droit_modif']);
  $xml_sousmenu->addAttribute ('suppression', $sousmenu['sme_droit_suppression']);
  $xml_sousmenu->addChild ('nom', $sousmenu['sme_libelle']);
  $xml_sousmenu->addChild ('icone', $sousmenu['sme_icone']);
  $groupes = $base->meta_groupe_infos_liste ($token, $sousmenu['sme_id']);
  if (count ($groupes)) {
    foreach ($groupes as $groupe) {
      $xml_groupe = $xml_sousmenu->addChild ('groupe');
      $xml_groupe->addChild ('nom', $groupe['gin_libelle']);
      $infos = $base->meta_info_groupe_liste ($token, $groupe['gin_id']);
      if (count ($infos)) {
	foreach ($infos as $info) {
	  $xml_infos = $xml_groupe->addChild('infos');
	  $xml_infos->addAttribute ('code', $info['inf_code']);
	  $xml_infos->addAttribute ('groupecycle', $info['ing__groupe_cycle']);
	  $xml_infos->addAttribute ('obligatoire', $info['ing_obligatoire']);
	}
      }
    }
  }
}

function exporte_principal ($token, &$xml_parent, $portail) {
  global $base;
  $xml_topmenus = $xml_parent->addChild ('topmenus');
  $topmenus = $base->meta_topmenu_liste ($token, $portail['por_id']);
  if (count ($topmenus)) {
    foreach ($topmenus as $topmenu) {
      exporte_topmenu ($token, $xml_topmenus, $topmenu);
    }
  }
}

function exporte_topmenu ($token, &$xml_parent, $topmenu) {
  global $base;
  $xml_topmenu = $xml_parent->addChild ('topmenu');
  $xml_topmenu->addChild ('nom', $topmenu['tom_libelle']);
  $topsousmenus = $base->meta_topsousmenu_liste ($token, $topmenu['tom_id']);
  if (count ($topsousmenus)) {
    foreach ($topsousmenus as $topsousmenu) {
      $xml_topsousmenu = $xml_topmenu->addChild ('topsousmenu');
      $xml_topsousmenu->addAttribute ('modif', $topsousmenu['tsm_droit_modif']);
      $xml_topsousmenu->addAttribute ('suppression', $topsousmenu['tsm_droit_suppression']);
      $xml_topsousmenu->addChild ('nom', $topsousmenu['tsm_libelle']);
      $xml_topsousmenu->addChild ('icone', $topsousmenu['tsm_icone']);
      $xml_topsousmenu->addChild ('type', $topsousmenu['tsm_type']); //  notes, documents, liste, groupe, event, ressource
      $code = '';
      switch ($topsousmenu['tsm_type']) {
      case 'notes':
	$nos = $base->notes_notes_get ($token, $topsousmenu['tsm_type_id']);
	$code = $nos['nos_code'];
	break;
      case 'documents':
	$dos = $base->document_documents_get ($token, $topsousmenu['tsm_type_id']);
	$code = $dos['dos_code'];
	break;
      case 'liste':
	$lis = $base->liste_liste_get ($token, $topsousmenu['tsm_type_id']);
	$code = $lis['lis_code'];
	break;
      case 'groupe':
	$sec = $base->meta_secteur_get ($token, $topsousmenu['tsm_type_id']);
	$code = $sec['sec_code'];
	break;
      case 'event':
	$evs = $base->events_events_get ($token, $topsousmenu['tsm_type_id']);
	$code = $evs['evs_code'];
	break;
      case 'agressources':
	$agr = $base->events_agressources_get  ($token, $topsousmenu['tsm_type_id']);
	$code = $agr['agr_code'];
	break;
      }
      $xml_topsousmenu->addChild ('type_id', $code); 
      $xml_topsousmenu->addChild ('titre', $topsousmenu['tsm_titre']);
      // TODO : sme_id_lien_usager 
    }
  }
}
?>
