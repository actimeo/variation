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
require ('inc/config.inc.php');
require ('inc/common.inc.php');
require ('inc/localise.inc.php');
require ('inc/enums.inc.php');
require ('inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
require ('inc/infos/info.class.php');

if (isset ($_GET['ent'])) {
  $ent_code = $_GET['ent'];
} else {
  $ent_code = 'usager';
}

$etab = $base->etablissement_get ($_SESSION['token'], $_SESSION['eta_id']);
$portail = $base->meta_portail_get ($_SESSION['token'], $etab['cat_id'], $_SESSION['portail']);
if (isset ($_GET['sme'])) {
  $sme_id = $_GET['sme'];
} else if (isset ($_GET['men'])) {
  $men_id = $_GET['men'];
  $smes = $base->meta_sousmenu_liste ($_SESSION['token'], $men_id);
  $sme_id = $smes[0]['sme_id'];  
} else if (isset ($_GET['tsm']) && $_GET['ent'] == 'usager') {
  $topsousmenu = $base->meta_topsousmenu_get ($_SESSION['token'], $_GET['tsm']);
  $sme_id = $topsousmenu['sme_id_lien_usager'];
  if (!$sme_id) {
    $menu = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent_code, $base->limit (1));  
    $sousmenu = $base->meta_sousmenu_liste ($_SESSION['token'], $menu[0]['men_id']);
    $sme_id = $sousmenu[0]['sme_id'];
  }
} else {
  $menu = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent_code, $base->limit (1));  
  $sousmenu = $base->meta_sousmenu_liste ($_SESSION['token'], $menu[0]['men_id']);
  $sme_id = $sousmenu[0]['sme_id'];
}
$sousmenu = $base->meta_sousmenu_infos($_SESSION['token'], $sme_id);
$men_id_actif = $sousmenu['men_id'];
$droit_modif = $sousmenu['sme_droit_modif'];
if (isset ($_GET['per'])) {
  $per_id = $_GET['per'];
}

$base->lock_fiche_set_sme ($per_id, $_SESSION['token'], $sme_id);
if (!isset ($_GET['notviewed'])) {
  $base->fiche_touch ($_SESSION['token'], $per_id);
}

$droit = $ent_code != 'usager' || $_SESSION['uti_root'] || $base->login_utilisateur_acces_personne ($_SESSION['token'], $per_id);

/* Calcul int_code */
$info_types = $base->meta_infos_type_liste ($_SESSION['token']);  
  $int_code = array ();
foreach ($info_types as $info_type) {
  $int_code[$info_type['int_id']] = $info_type['int_code'];
}

if (isset ($_POST['enregistrer'])) {
  require ('inc/enregistre.inc.php');
  enregistre ($sme_id, $per_id, $_POST);
}

$procedures = $base->procedure_liste ($_SESSION['token'], $sme_id, 'sme');

function remplace_tags ($matches) {
  global $base, $per_id;
  $match = substr ($matches[0], 1, -1);  
  switch ($match) {
  case 'famille': 
    // On affiche les liens de tous les champs de type famille
    $ms = array ();
    foreach ($base->meta_info_liste ($_SESSION['token'], null, true, 'famille') as $inf) {
      $membres = $base->personne_info_lien_familial_get_multiple ($_SESSION['token'], $per_id, $inf['inf_code']);
      foreach ($membres as $membre) {
	$lien = $base->meta_lien_familial_get ($_SESSION['token'], $membre['lfa_id']);
	$nom = $base->personne_get_libelle ($_SESSION['token'], $membre['per_id_parent']).' ('.$lien['lfa_nom'].')';	
	$ms[] = '<span id="lienpersonne_famille_'.$membre['per_id_parent'].'" class="lienpersonne">'.$nom.'</span>';
      }
    }
    return implode (', ', $ms);
    break;
  case 'prise_en_charge':
    // On affiche toutes les prises en charges
    $infos = $base->meta_info_liste ($_SESSION['token'], NULL, true, 'groupe');
    foreach ($infos as $k => $info) {
      if ($info['inf__groupe_type'] != 'prise_en_charge') {
	unset ($infos[$k]);
      }
    }
    $ms = array ();
    foreach ($infos as $info) {      
      $grps = $base->personne_groupe_liste2 ($_SESSION['token'], $per_id, $info['inf_id']);
      foreach ($grps as $grp) {
	if ($grp['peg_cycle_statut'] != 2)
	  continue; // On ne prend que le statut Accepté
	$nom = $grp['grp_nom'];
	if ($grp['eta_id'] != $_SESSION['eta_id']) {
	  $nom = $grp['eta_nom'].' &rarr; '.$nom;
	}
	$ms[] = $nom;
      }
    }
    return implode (' ; ', $ms);
    break;
  default:
    // On affiche la valeur du champ particulier
    $type = $base->meta_info_get_type_par_code ($_SESSION['token'], $match);
    switch ($type) {
    case 'texte': 
    case 'textelong':  return $base->personne_info_varchar_get ($_SESSION['token'], $per_id, $match); break;
    case 'date': return $base->personne_info_date_get ($_SESSION['token'], $per_id, $match); break;
    default: return '???';
    }
  }
  return $matches[0];
}

function affiche_entete () {
  global $dirbase, $droit_modif;
  global $base, $ent_code, $per_id;
  global $procedures, $sousmenu;

  // Sert à griser l'entête si un usager n'est pas présent. Les personnes autres 
  // qu'usagers sont toujours marqués comme présents.
  $est_present = true; 

  switch ($ent_code) {
  case 'usager':
    $format_entete = "Date de naissance : [date_naissance]<br>Membres de l'entourage : [famille]<br>Prises en charge actuelle : [prise_en_charge]"; 
    $statut = $base->personne_info_integer_get ($_SESSION['token'], $per_id, 'statut_usager');
    $est_present = ($statut == 4);
    break;
  case 'personnel': 
    $format_entete = "Date de naissance : [date_naissance]<br>Date d'embauche : [personnel_date_embauche]<br>Téléphone fixe : [telephone_fixe]<br>Téléphone mobile : [telephone_mobile]";
    break;
  case 'contact':
    $format_entete = "Adresse : [adresse] [code_postal] [ville]<br>Téléphone fixe : [telephone_fixe]<br>Téléphone mobile : [telephone_mobile]";
    break;
  case 'famille':
    $format_entete = "Adresse : [adresse] [code_postal] [ville]<br>Téléphone fixe : [telephone_fixe]<br>Téléphone mobile : [telephone_mobile]";    
    break;
  default: 
    $format_entete = '';
  }
  

  $entite = $base->meta_entite_infos_par_code ($_SESSION['token'], $ent_code);
  $nom = $base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'nom');
  $prenom = $base->personne_info_varchar_get ($_SESSION['token'], $per_id, 'prenom');
  echo '<form method="POST" action="">';
  echo '<div class="entete'.($est_present ? '' : ' hachure').'">';  
  if (file_exists ($dirbase.'/photos/'.$per_id.'/photo.png')) {
    $url_photo = '/photos/'.$per_id.'/photo.png';
  } else {
    $url_photo = '/photos/0/photo.png';
  }
  echo '<div class="photo"><img src="'.$url_photo.'" height="100"></img>';
  if ($droit_modif) {
    echo '<div id="photo_change">Modifier photo</div>';
  }
  echo '</div>'; 
  echo '<div class="details">';
  echo '<h1>'.$nom.' '.$prenom.' ('.$entite['ent_libelle'].')</h1>';  
  echo '<div class="listinfos">';
  echo preg_replace_callback ('/\[.[^\]]*\]/', 'remplace_tags', $format_entete);
  echo '</div>';
  if ($ent_code == 'usager') {
    affiche_etats ();
  }
  echo '</div>';
  echo '</div>';
  echo '<div style="clear: both"></div>';
}

function affiche_etats () {
  global $per_id;
  $d = dir ('etats/');
  $entries = array ();
  while (false !== ($entry = $d->read ())) {
    if (substr ($entry, -4) == '.pdf') {
      $entries[] = $entry;
    }
  }
  if (count ($entries)) {
    echo '<div class="listetats">';
    echo '<ul>';
    sort ($entries);
    foreach ($entries as $entry) {
      echo '<li><a href="/export/etat.php?pdf='.rawurlencode ($entry).'&amp;id='.$per_id.'">'.preg_replace ('/\.pdf$/', '', $entry).'</a></li>';
    }
    echo '</ul>';
    echo '</div>';
  }
}

// Affiche menu et sous-menus
function affiche_menu () {
  global $base, $ent_code, $per_id, $portail, $sme_id;
  $un_seul_niveau = $base->meta_menu_un_seul_niveau ($_SESSION['token'], $portail['por_id'], $ent_code);
  if ($un_seul_niveau) {
    echo '<div class="menu1niveau"><ul class="ultopsousmenu">';
    $menus = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent_code);  
    if (count ($menus)) {
      foreach ($menus as $menu) {
	$sousmenus = $base->meta_sousmenu_liste ($_SESSION['token'], $menu['men_id']);
	$sousmenu = $sousmenus[0];
	echo '<li'.($sousmenu['sme_id'] == $sme_id ? ' class="selected"' : '').'><a href="?ent='.$ent_code.'&per='.$per_id.'&sme='.$sousmenu['sme_id'].'"'.$currenttag.'><span class="icone"><img src="'.$sousmenu['sme_icone'].'"></img></span><span class="label">'.$sousmenu['sme_libelle'].'</span></a></li>';
      }    
    }
    echo '</ul></div>';
  } else {
    $menus = $base->meta_menu_liste ($_SESSION['token'], $portail['por_id'], $ent_code);  
    if (count ($menus)) {
      echo '<div class="menu">';
      echo '<div class="accmenu">';
      foreach ($menus as $menu) {
	$sousmenus = $base->meta_sousmenu_liste ($_SESSION['token'], $menu['men_id']);
	echo '<h3>';
	echo $menu['men_libelle'];
	echo '</h3>';
	echo '<div>';
	echo '<ul class="ultopsousmenu">';
	foreach ($sousmenus as $sousmenu) {
	  echo '<li'.($sousmenu['sme_id'] == $sme_id ? ' class="selected"' : '').'><a href="?ent='.$ent_code.'&per='.$per_id.'&sme='.$sousmenu['sme_id'].'"><span class="icone"><img src="'.$sousmenu['sme_icone'].'"></img></span><span class="label">'.$sousmenu['sme_libelle'].'</span></a></li>';
	}
	echo '</ul>';
	echo '</div>';
      }
      echo '</div></div>';
    }
  }
}

function affiche_contenu ($sme_id) {
  global $base, $int_code, $per_id, $droit_modif, $procedures;
  
  $sousmenu = $base->meta_sousmenu_infos ($_SESSION['token'], $sme_id);
  $menu = $base->meta_menu_infos($_SESSION['token'], $sousmenu['men_id']);
  $nsousmenus = $base->meta_sousmenu_liste ($_SESSION['token'], $sousmenu['men_id'], $base->count());
  $nsousmenus = $nsousmenus[0]['count'];

  if (count ($procedures)) {
    echo '<div class="procedures_liste">';
    foreach ($procedures as $procedure) {
      echo '<span id="pro_'.$procedure['pro_id'].'" class="procedure">'.$procedure['pro_titre'].'</span> ';
    }
    echo '</div>';
  }
  echo '<h1>'.$menu['men_libelle'].' &gt; '.$sousmenu['sme_libelle'].'</h1>';

  if ($droit_modif && !$sousmenu['sme_type']) {
    echo '<div class="enregbar"><input type="submit" name="enregistrer" value="Enregistrer"></input></div>';
    }
  echo '<table class="infos" cellpadding="0" cellspacing="0">';
  echo '<col width="135">';
  echo '<col width="265">';
  echo '<col width="135">';
  echo '<col width="265">';

  if (!$sousmenu['sme_type']) {
    $groupes = $base->meta_groupe_infos_liste ($_SESSION['token'], $sme_id);
    if (count ($groupes)) {
      $first = true;
      foreach ($groupes as $groupe) {
	if (!$first) {
	  echo '<tr><td class="lignevide" colspan="4">&nbsp;</td></tr>';
	}
	$first = false;
	echo '<tr><td colspan="4" class="titre2">'.$groupe['gin_libelle'].'</td></tr>';
	$infos = $base->meta_info_groupe_liste ($_SESSION['token'], $groupe['gin_id']);
	$prochain_premier = true;
	if (count ($infos)) {
	  foreach ($infos as $info) {
	    $premier = false;
	    $dernier = false;
	    if ($info['inf_etendu']) {
	      $premier = true;
	      $dernier = true;
	      $prochain_premier = true;
	    } else if ($int_code[$info['int_id']] == 'groupe') {
	      $premier = true;
	      $dernier = true;
	      $prochain_premier = true;	    
	    } else {
	      if ($prochain_premier == true) {
		$premier = true;
	      } else {
		$dernier = true;
	      }
	      $prochain_premier = !$prochain_premier;
	    }
	    if ($premier) {
	      echo '<tr>';
	    }
	    affiche_info ($info);
	    if ($dernier) {
	      echo '</tr>';
	    }
	  }
	}
      }
    }
  } else if ($sousmenu['sme_type'] == 'documents') {
    echo '<tr><td colspan="4">';
    $dos_id = $sousmenu['sme_type_id'];
    include ('scripts/documents.php');
    echo '</td></tr>';
  } else if ($sousmenu['sme_type'] == 'event') {
    echo '<tr><td colspan="4">';
    $evs_id = $sousmenu['sme_type_id'];
    include ('scripts/events.php');
    echo '</td></tr>';
  } else if ($sousmenu['sme_type'] == 'notes') {
    echo '<tr><td colspan="4">';
    include ('scripts/notes.php');
    echo '</td></tr>';
  }
  echo '</table>';
  if ($droit_modif && !$sousmenu['sme_type']) {
    echo '<div class="enregbar"><input type="submit" name="enregistrer" value="Enregistrer"></input></div>';
  }
  echo '</form>';
}

function affiche_info ($info) {
  global $int_code;
  $affiche_libelle = ($int_code[$info['int_id']] != 'groupe');
  /* Affiche le libellé */
  if ($affiche_libelle) 
    echo '<td class="libelle" align="right"><label for="info_'.$info['inf_code'].'">'.$info['inf_libelle'].'&nbsp:</label></td>';

  /* Affiche le champ de saisie */
  if ($info['inf_etendu']) {
    if ($affiche_libelle) 
      $etendu=' colspan="3" class="etendu"';
    else
      $etendu=' colspan="4" class="etendu"';
  } else {
    if ($affiche_libelle) 
      $etendu = '';
    else
      $etendu=' colspan="4" ';
  }
  echo '<td'.$etendu.'>';
  /* Affiche selon le type */
  switch ($int_code[$info['int_id']]) {
  case 'texte':           affiche_info_texte ($info); break;
  case 'date':            affiche_info_date ($info); break;
  case 'textelong':       affiche_info_textelong ($info); break;
  case 'coche':           affiche_info_coche ($info); break;
  case 'selection':       affiche_info_selection ($info); break;
  case 'groupe':          affiche_info_groupe ($info); break;
  case 'contact':         affiche_info_contact ($info); break;
  case 'metier':          affiche_info_metier ($info); break;
  case 'etablissement':   affiche_info_etablissement ($info); break;
  case 'affectation':     affiche_info_affectation ($info); break;
  case 'famille':         affiche_info_famille ($info); break;
  case 'statut_usager':   affiche_info_statut_usager ($info); break;
  case 'date_calcule':    affiche_info_date_calcule ($info); break;
  }

  /* Affiche l'historique */
  if ($info['inf_historique']) {
    global $per_id;
    
    $type = '';
    switch ($int_code[$info['int_id']]) {
    case 'texte':     $type = 'varchar'; break;
    case 'date':      $type = 'date'; break;
    case 'textelong': $type = 'text'; break;
    case 'coche':     $type = 'boolean'; break;
    case 'selection': $type = 'integer'; break;
    case 'groupe':    $type = ''; break;
    case 'contact':   $type = 'contact'; break;
    }

    echo ' <span class="boutonhisto" id="boutonhisto:'.$type.':'.$per_id.':'.$info['inf_code'].'">H</span>';
  }
  echo '</td>';
}

function affiche_info_texte ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $dim = '[]';
    $valeurs = $base->personne_info_varchar_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    $valeurs[] = null;
  } else {
    $dim = '';
    $valeurs = array ($base->personne_info_varchar_get ($_SESSION['token'], $per_id, $info['inf_code']));
  }
  foreach ($valeurs as $valeur) {
    echo '<input type="text" class="info_texte" name="info_'.$info['inf_code'].$dim.'" id="info_'.$info['inf_code'].'" value="'.$valeur.'"'.($droit_modif ? '' : ' disabled').'></input>';
  }
}

function affiche_info_date ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $dim = '[]';
    $valeurs = $base->personne_info_date_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    $valeurs[] = null;
  } else {
    $dim = '';
    $valeurs = array ($base->personne_info_date_get ($_SESSION['token'], $per_id, $info['inf_code']));
  }
  foreach ($valeurs as $valeur) {
    echo '<input type="text" class="info_date'.($droit_modif ? ' datepicker' : '').'" maxlength="10" size="10" name="info_'.$info['inf_code'].$dim.'" id="info_'.$info['inf_code'].'" value="'.$valeur.'"'.($droit_modif ? '' : ' disabled').'></input>';
  }
}

function affiche_info_textelong ($info) {
  global $base, $per_id, $droit_modif;
  $valeur = $base->personne_info_text_get ($_SESSION['token'], $per_id, $info['inf_code']);
  echo '<textarea class="info_textelong" name="info_'.$info['inf_code'].'" id="info_'.$info['inf_code'].'" rows="'.$info['inf__textelong_nblignes'].'"'.($droit_modif ? '' : ' disabled').'>'.$valeur.'</textarea>';
}

function affiche_info_coche ($info) {
  global $base, $per_id, $droit_modif;
  $valeur = $base->personne_info_boolean_get ($_SESSION['token'], $per_id, $info['inf_code']);
  $checked = $valeur ? " checked" : "";
  echo '<input type="checkbox" class="info_coche" name="info_'.$info['inf_code'].'" id="info_'.$info['inf_code'].'"'.$checked.($droit_modif ? '' : ' disabled').'></input>';
}

function affiche_info_selection ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $dim = '[]';
    $valeurs = $base->personne_info_integer_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    $valeurs[] = null;
  } else {
    $dim = '';
    $valeurs = array ($base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']));
  }
  $selection = $base->meta_selection_infos ($_SESSION['token'], $info['inf__selection_code']);
  $entrees = $base->meta_selection_entree_liste ($_SESSION['token'], $info['inf__selection_code']);

  foreach ($valeurs as $valeur) {
    echo '<select name="info_'.$info['inf_code'].$dim.'" id="info_'.$info['inf_code'].'"'.($droit_modif ? '' : ' disabled').'>';
    if ($droit_modif) {
      echo '<option value="">'.$selection['sel_info'].'</option>';
    } else {
      echo '<option value=""></option>';
    }
    foreach ($entrees as $entree) {
      $selected = '';
      if ($entree['sen_id'] == $valeur)
	$selected=' selected';
      echo '<option value="'.$entree['sen_id'].'"'.$selected.'>'.$entree['sen_libelle'].'</option>';
    }
    echo '</select>';
  }
}

function affiche_info_groupe ($info) {
  global $base, $per_id, $cycle_statuts, $droit_modif;
  $affiche_date_debut = false;
  $affiche_date_fin = false;
  $affiche_date_demande = false;
  $affiche_date_demande_renouvellement = false;
  $ing = $base->meta_info_groupe_get ($_SESSION['token'], $info['ing_id']);
  $cycle = $ing['ing__groupe_cycle'];
  $type = $info['inf__groupe_type'];  
  $soustype = $info['inf__groupe_soustype'];
  echo '<table width="100%" class="t1"><tr>';
  echo '<th>'.$info['inf_libelle'].'</th>';
  if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
    echo '<th width="100">'.localise_par_code_secteur ('info_groupe_date_debut', $type).'</th>';
    $affiche_date_debut = true;
  }
  if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
    echo '<th width="100">'.localise_par_code_secteur ('info_groupe_date_fin', $type).'</th>';
    $affiche_date_fin = true;
  }
  if (!$affiche_date_debut && !$affiche_date_fin) {
    echo 'Erreur : Les traductions de date_debut et date_fin ne doivent pas être vides ensemble.';
    return;
  }    
  if ($cycle) {
    echo '<th width="100">Statut</th>';
    if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
      echo '<th width="100">'.localise_par_code_secteur ('info_groupe_date_demande', $type).'</th>';
      $affiche_date_demande = true;
    }
    if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
      echo '<th width="100">'.localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type).'</th>';
      $affiche_date_demande_renouvellement = true;
    }
  }
  if ($droit_modif) {
    echo '<th width="120"></th>';
  }
  echo '</tr>';
  $groupes = $base->personne_groupe_liste2 ($_SESSION['token'], $per_id, $info['inf_id']);
  if (count ($groupes)) {
    $impair = true;
    foreach ($groupes as $groupe) {
      echo '<tr class="'.($impair ? 'impair' : 'pair').'"><td>';
      echo $groupe['eta_nom'].' &rarr; '.$groupe['grp_nom'];
      if ($affiche_date_debut) {
	echo '</td><td align="center">';
	echo $groupe['peg_debut'];
      }
      if ($affiche_date_fin) {
	echo '</td><td align="center">';
	echo $groupe['peg_fin'];
      }
      echo '</td>';
      if ($cycle) {	
	echo '<td align="center">'.$cycle_statuts[$groupe['peg_cycle_statut']].'</td>';
	if ($affiche_date_demande) {
	  echo '<td align="center">'.$groupe['peg_cycle_date_demande'].'</td>';
	}
	if ($affiche_date_demande_renouvellement) {
	  echo '<td align="center">'.$groupe['peg_cycle_date_demande_renouvellement'].'</td>';
	}
      }
      if ($droit_modif) {
	echo '<td align="center">';      
	echo '<span class="smallbutton info_groupe_edit" id="info_edit_'.$groupe['peg_id'].'_'.$ing['ing_id'].'">Modifier</span>';
	echo ' <span class="smallbutton info_groupe_del" id="info_del_'.$groupe['peg_id'].'">Supprimer</span>';
	echo '</td>';
      }
      echo '</tr>';            
      $impair = !$impair;
    }
  } else {
    echo '<tr class="impair"><td align="center" colspan="7"><i>Pas de '.$info['inf_libelle'].' enregistré</i></td></tr>';
  }

  if ($droit_modif) {
    echo '<tr><th colspan="7" align="right">';
    echo '<span style="font-weight: normal" class="smallbutton info_groupe_add" id="info_add_'.$per_id.'_'.$ing['ing_id'].'">Ajouter</span>';
    echo '</th></tr>';
  }
  echo '</table>';
}


function affiche_info_contact ($info) {
  global $base, $per_id, $reperes, $droit_modif, $ent_code;
  if ($ent_code == 'usager') {
    $multiple = $info['inf_multiple'];  
    if ($multiple) {
      $classe = $droit_modif ? 'infocontact' : 'infocontact_ro';
      $valeurs = $base->personne_info_integer_get_multiple_details ($_SESSION['token'], $per_id, $info['inf_code']);
      echo '<div id="'.$info['inf_code'].'_'.'list">';
      if (count ($valeurs)) {
	foreach ($valeurs as $valeur) {
	  $nomprenom = $base->personne_get_libelle ($_SESSION['token'], $valeur['pii_valeur']);
	  echo '<span id="pii_'.$valeur['pii_id'].'" class="'.$classe.'"><nobr><span id="lienpersonne_'.$info['inf__contact_filtre'].'_'.$valeur['pii_valeur'].'" class="lienpersonne">'.$nomprenom.'</span></nobr></span> ';
	}
      }
      echo '</div>';
      if ($droit_modif) {
	echo '<span id="infocontact_ajout_'.$info['inf_code'].'" class="infocontact_ajout">Ajouter</span>';
      }
    
    } else {
      $classe = $droit_modif ? 'infocontact1' : 'infocontact1_ro';
      $valeur = $base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']);    
      $nomprenom = $base->personne_get_libelle ($_SESSION['token'], $valeur);
      echo '<span class="'.$classe.'" id="infocontact1_'.$info['inf_code'].'"><nobr>'.$nomprenom.'</nobr></span>';
    }
  } else {
    // non usager
    $valeurs = $base->contact_recherche ($_SESSION['token'], $per_id);
    foreach ($valeurs as $valeur) {
      echo '<div>'.$valeur['inf_libelle'].' : <span class="lienpersonne" id="lienpersonne_usager_'.$valeur['per_id'].'">'.$valeur['per_libelle'].'</span></div>';
    }
  }
}

function affiche_info_metier ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $dim = '[]';
    $valeurs = $base->personne_info_integer_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    $valeurs[] = null;
  } else {
    $dim = '';
    $valeurs = array ($base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']));
  }
  //  $met_id = $base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']);
  $metiers = $base->metier_liste ($_SESSION['token'], $info['inf__metier_secteur']);
  foreach ($valeurs as $met_id) {    
    echo '<select name="info_'.$info['inf_code'].$dim.'"'.($droit_modif ? '' : ' disabled').'><option value=""></option>';
    foreach ($metiers as $metier) {
      echo '<option value="'.$metier['met_id'].'"'.($met_id == $metier['met_id'] ? ' selected' : '').'>'.$metier['met_nom'].'</option>';
    }
    echo '</select><br/>';
  }
}

function affiche_info_etablissement ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $classe = $droit_modif ? 'infoetab' : 'infoetab_ro';
    $valeurs = $base->personne_info_integer_get_multiple_details ($_SESSION['token'], $per_id, $info['inf_code']);
    echo '<div id="'.$info['inf_code'].'_'.'list">';
    foreach ($valeurs as $valeur) {
      $etab = $base->etablissement_get ($_SESSION['token'], $valeur['pii_valeur']);
      echo '<span id="pii_'.$valeur['pii_id'].'" class="'.$classe.'"><nobr>'.$etab['eta_nom'].'</nobr></span> ';
    }
    echo '</div>';
    if ($droit_modif) {
      echo '<span id="infoetab_ajout_'.$info['inf_code'].'" class="infoetab_ajout">Ajouter</span>';
    }
  } else {
    $classe = $droit_modif ? 'infoetab1' : 'infoetab1_ro';
    $valeur = $base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']);
    $etab = $base->etablissement_get ($_SESSION['token'], $valeur);
    echo '<span class="'.$classe.'" id="infoetab1_'.$info['inf_code'].'"><nobr>'.$etab['eta_nom'].'</nobr></span>';
  }
  return;
}

function affiche_info_affectation ($info) {
  global $base, $per_id, $droit_modif;
  $multiple = $info['inf_multiple'];  
  if ($multiple) {
    $classe = $droit_modif ? 'infoaffectation' : 'infoaffectation_ro';
    $valeurs = $base->personne_info_integer2_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    echo '<div id="'.$info['inf_code'].'_'.'list">';
    foreach ($valeurs as $valeur) {
      $etab = $base->etablissement_get ($_SESSION['token'], $valeur['valeur1']);
      echo '<span id="pij_'.$valeur['pij_id'].'" class="'.$classe.'"><nobr>'.$etab['eta_nom'];
      if ($valeur['valeur2']) {
	$grp = $base->groupe_get ($_SESSION['token'], $valeur['valeur2']);
	echo ' &rarr; '.$grp['grp_nom'];
      }
      echo '</nobr></span> ';
    }
    echo '</div>';
    if ($droit_modif) {
      echo '<span id="infoaffectation_ajout_'.$info['inf_code'].'" class="infoaffectation_ajout">Ajouter</span>';
    }
  } else {
    echo 'Affectation non multiple Non implémenté';
  }
}

function affiche_info_famille ($info) {
  global $base, $per_id, $ent_code, $droit_modif, $droits_parent;
  // On considère que c'est multiple
  if ($ent_code == 'usager') {
    $classe = $droit_modif ? 'membrefam' : 'membrefam_ro';
    $valeurs = $base->personne_info_lien_familial_get_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    echo '<div id="'.$info['inf_code'].'_'.'list">';
    foreach ($valeurs as $valeur) {
      $libelle = $base->personne_get_libelle ($_SESSION['token'], $valeur['per_id_parent']);
      $lien = $base->meta_lien_familial_get ($_SESSION['token'], $valeur['lfa_id']);
      $autorite = $valeur['pif_autorite_parentale'] == 1 ? 'Autorité parentale' : ($valeur['pif_autorite_parentale'] == 2 ? 'Tutelle' : 'Aucune autorité');
      $qtip_content = '<u>'.$lien['lfa_nom'].' : '.$libelle."</u><br>".$autorite."<br>".$droits_parent[$valeur['pif_droits']].'<br>'.$valeur['pif_periodicite'];
      echo '<span id="pij_'.$valeur['pif_id'].'" class="'.$classe.' cliquable qtipable" title="'.$qtip_content.'"><nobr>'.$lien['lfa_nom'].' : '.$libelle.'</nobr></span> ';
    }
    echo '</div>';
    if ($droit_modif) {
      echo '<span id="membrefam_ajout_'.$info['inf_code'].'" class="membrefam_ajout">Ajouter</span>';
    }
  } else {
    $valeurs = $base->famille_recherche ($_SESSION['token'], $per_id, $info['inf_id']);
    foreach ($valeurs as $valeur) {
      $lien = $base->meta_lien_familial_get($_SESSION['token'], $valeur['lfa_id']);
      $autorite = $valeur['pif_autorite_parentale'] ? 'Autorité parentale' : 'Tutelle';
      $qtip_content = '<u>'.$valeur['per_libelle']."</u><br>".$autorite."<br>".$droits_parent[$valeur['pif_droits']].'<br>'.$valeur['pif_periodicite'];
      echo '<div>'.$lien['lfa_nom'].' de '.'<span title="'.$qtip_content.'" class="lienpersonne qtipable" id="lienpersonne_usager_'.$valeur['per_id'].'">'.$valeur['per_libelle'].'</span></div>';
    }
  }
}

function affiche_info_statut_usager ($info) {
  global $base, $per_id, $statuts_usager;
  $valeur = $base->personne_info_integer_get ($_SESSION['token'], $per_id, $info['inf_code']);
  echo $statuts_usager[$valeur];
}

function affiche_info_date_calcule ($info) {
  global $per_id;
  $obj = new Info_date_calcule ($info);
  echo $obj->valeurCalculee ($per_id);
}

require ('inc/main.inc.php');
?>
