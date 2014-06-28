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
include ("inc/pagination.php");
include ("inc/groupes/groupe.class.php");

$etas = $base->etablissement_liste ($_SESSION['token'], true, NULL);
$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);

if (!$_SESSION['uti_config'])
  exit;


/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (5);
$pagination->setFunction ('groupe_liste_details', array ($_SESSION['token'], $_GET['eta_id'], $_GET['sec_id_role'], $_GET['sec_id_besoin'], true));
$pagination->setUrl ('/admin.php', array ('eta_id' => $_GET['eta_id'],
					  'sec_id_role' => $_GET['sec_id_role'],
					  'sec_id_besoin' => $_GET['sec_id_besoin']
					  ));
$pagination->addColumn ('Établissement', 'eta_nom');
$pagination->addColumn ('Intitulé', 'grp_nom' , 'lien_edit_groupe', 'grp_id');
$pagination->addColumn ('Rôles');
$pagination->addColumn ('Besoins');
$pagination->addColumn ('Début', 'grp_debut');
$pagination->addColumn ('Fin', 'grp_fin');
$pagination->setLines (15);

/* Gestion de l'édition des groupes, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (groupe_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (groupe_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->groupe_supprime ($_SESSION['token'], $_GET['grp']);
  header ('Location: '.url_nouveau_groupe ());
  exit;
}

if (isset ($_GET['grp'])) {
  $grp_id = (int)$_GET['grp'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs
    $groupe['grp_id'] = $grp_id;
    $groupe['grp_nom'] = $_POST['ed_intitule'];
    $groupe['eta_id'] = $_POST['ed_etab'];
    $groupe['grp_debut'] = $_POST['ed_debut'];
    $groupe['grp_fin'] = $_POST['ed_fin'];
    $groupe['grp_notes'] = $_POST['ed_notes'];
    foreach ($secteurs as $secteur) {
      $classname = 'Groupe'.ucfirst ($secteur['sec_code']);
      $objSecteur = new $classname();
      if (count ($objSecteur->champs())) {
	foreach ($objSecteur->champs() as $champ_db => $champ_form) {
	  $groupe[$champ_db] = $_POST[$champ_form];
	}
      }
    }
    $groupe_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$groupe_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {    
    $groupe = $base->groupe_get ($_SESSION['token'], $grp_id);
    $groupe_secteurs = $base->groupe_secteur_liste ($_SESSION['token'], $grp_id, NULL);
  }

  $etab_secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $groupe['eta_id'], NULL);

} else if (isset ($_POST['ed_new'])) {
  $groupe['eta_id'] = $_POST['ed_etab'];
  $etab_secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $_POST['ed_etab'], NULL);
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur
    $groupe['grp_id'] = $grp_id;
    $groupe['grp_nom'] = $_POST['ed_intitule'];
    $groupe['eta_id'] = $_POST['ed_etab'];
    $groupe['grp_debut'] = $_POST['ed_debut'];
    $groupe['grp_fin'] = $_POST['ed_fin'];
    $groupe['grp_notes'] = $_POST['ed_notes'];
    foreach ($secteurs as $secteur) {
      $classname = 'Groupe'.ucfirst ($secteur['sec_code']);
      $objSecteur = new $classname();
      if (count ($objSecteur->champs())) {
	foreach ($objSecteur->champs() as $champ_db => $champ_form) {
	  $groupe[$champ_db] = $_POST[$champ_form];
	}
      }
    }
    $groupe_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$groupe_secteurs[] = array ('sec_code' => $s);
      }
    }
    $etab_secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $groupe['eta_id'], NULL);
  } else {
    $groupe = array ();
  }
}
?>
<script type="text/javascript">
$(document).ready (function () {
    $(".tr_ed_secteur").hide ();
    $(".ed_secteur_cb").click (on_ed_secteur_cb_click);
    $(".ed_secteur_cb:checked").each (function () {
	$(".tr_"+$(this).attr('id')).show();	
    });
    
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_secteur_cb_click () {
    if ($(this).is(":checked")) {
	$(".tr_"+$(this).attr('id')).show();
    } else {
	$(".tr_"+$(this).attr('id')).hide();
    }
}

function on_ed_suppr_click () {
    if (confirm ('Supprimer le groupe "<?= addslashes ($groupe['grp_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>
<h1>Prestations</h1>

<form method="get" action="<?= $_SERVER['REQUEST_URI'] ?>">
<select name="eta_id">
<option value="">(tous établissements)</option>
<?php liste_etablissements ($_GET['eta_id']); ?>
</select>

<select name="sec_id_role">
<option value="">(tous rôles)</option>
  <?php liste_secteurs ($_GET['sec_id_role'], true); ?>
</select>

<select name="sec_id_besoin">
<option value="">(tous besoins)</option>
  <?php liste_secteurs ($_GET['sec_id_besoin'], false); ?>
</select>

<button type="submit">OK</button>
</form>


<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('eta_nom', 'grp_nom', 'roles', 'besoins', 'grp_debut', 'grp_fin')); ?>
  <tr><td colspan="6" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';

if (isset ($_GET['grp'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
 } 

echo '<tr class="impair">';
echo '<td>Établissement</td>';
echo '<td>';
if (isset ($_GET['grp'])) { 
  echo nom_etablissement ($groupe['eta_id']);
  echo '<input type="hidden" name="ed_etab" value="'.$groupe['eta_id'].'"></input>';
} else if ($_POST['ed_etab']) {
  echo nom_etablissement ($_POST['ed_etab']);
  echo '<input type="hidden" name="ed_etab" value="'.$_POST['ed_etab'].'"></input>';
} else {
  echo '<select name="ed_etab">';
  echo '<option value="">(choisir un établissement)</option>';
  liste_etablissements ($groupe['eta_id']);
  echo '</select>'.$erreur['ed_etab'];
} 
echo '</td>';
echo '</tr>';

if ((isset ($_POST['ed_etab']) && $_POST['ed_etab']) || isset ($_GET['grp'])) {
  echo '<tr class="pair">';
  echo '<td>Intitulé</td>';
  echo '<td><input size="30" name="ed_intitule" value="'.$groupe['grp_nom'].'">';
  echo '</input>'.$erreur['ed_intitule'].'</td>';
  echo '</tr>';
  
  echo '<tr class="impair">';
  echo '<td>Période</td>';
  echo '<td>Du <input size="10" name="ed_debut" class="datepicker" value="'.$groupe['grp_debut'].'">  au <input size="10" name="ed_fin" class="datepicker" value="'.$groupe['grp_fin'].'">';
  echo '</input>';
  echo '</td>';
  echo '</tr>';
  
  echo '<tr class="pair">';
  echo '<td>Rôles</td>';
  echo '<td>';
  if (isset ($_GET['grp'])) {
    liste_secteurs_cb ($groupe_secteurs, true);
  } else {
    liste_secteurs_cb ($groupe_secteurs, true);
  }
  echo '</td>';
  echo '</tr>';
  
  echo '<tr class="impair">';
  echo '<td>Besoins</td>';
  echo '<td>';
  if (isset ($_GET['grp'])) {
    liste_secteurs_cb ($groupe_secteurs, false);
  } else {
    liste_secteurs_cb ($groupe_secteurs, false);
  }
  echo '</td>';
  echo '</tr>';
  
  foreach ($secteurs as $secteur) {
    $classname = 'Groupe'.ucfirst ($secteur['sec_code']);
    $objSecteur = new $classname();
    echo '<tr class="tr_ed_secteur tr_ed_secteur_'.$secteur['sec_code'].'"><th colspan="2">'.$secteur['sec_nom'].'</th></tr>';
    $objSecteur->display ($groupe);
  }
  
  echo '<tr><th colspan="2">Notes</th></tr>';

  echo '<tr class="impair">';
  echo '<td colspan="2"><textarea name="ed_notes" cols="43" rows="5">'.$groupe['grp_notes'].'</textarea></td>';
  echo '</tr>';
}

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['grp'])) { 
  echo '<a href="'.url_nouveau_groupe ().'">Ajouter un nouveau groupe</a>';
  echo '<button name="ed_enreg" type="submit">Mettre à jour</button>';
  echo '<input type="hidden" name="ed_suppr" id="ed_suppr_hidden"></input>';
  echo '<button id="ed_suppr" type="button">Supprimer</button>';
} else if (isset ($_POST['ed_etab']) && $_POST['ed_etab']) {
  echo '<button name="ed_ajout" type="submit">Ajouter</button>';
} else { 
  echo '<button name="ed_new" type="submit">Continuer</button>';
}
echo '</td></tr>';

echo '</table>';
echo '</form>';
?>
<div style="clear: both"></div>


<?php 
  function liste_secteurs ($sec_id, $est_prise_en_charge) {
  global $base;
  $secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  foreach ($secteurs as $secteur) {
    if ($secteur['sec_est_prise_en_charge'] != $est_prise_en_charge)
      continue;
    echo '<option '.($secteur['sec_id'] == $sec_id ? ' selected ' : '').'value="'.$secteur['sec_id'].'">'.$secteur['sec_nom'].'</option>';
  }
}

function liste_etablissements ($eta_id) {  
  global $etas;
  foreach ($etas as $eta) {
    echo '<option '.($eta['eta_id'] == $eta_id ? ' selected ' : '').'value="'.$eta['eta_id'].'">'.$eta['eta_nom'].'</option>';
  }
}

function nom_etablissement ($eta_id) {
  global $etas;
  foreach ($etas as $eta) {
    if ($eta['eta_id'] == $eta_id)
      return $eta['eta_nom'];
  }
  return '';
}

function lien_edit_groupe ($grp_id) {
  return array ('/admin.php', array ('eta_id' => $_GET['eta_id'],
				     'sec_id_role' => $_GET['sec_id_role'],
				     'sec_id_besoin' => $_GET['sec_id_besoin'],
				     'grp' => $grp_id));
}

function liste_secteurs_cb ($groupe_secteurs, $est_prise_en_charge) {
  global $base, $secteurs, $etab_secteurs;
  foreach ($secteurs as $secteur) {
    if ($secteur['sec_est_prise_en_charge'] != $est_prise_en_charge)
      continue;
    // Affiche la CB seulement si le secteur est relié à l'établissement
    $affiche = false;
    foreach ($etab_secteurs as $etab_secteur) {
      if ($etab_secteur['sec_code'] == $secteur['sec_code']) {
	$affiche = true;
	break;
      }
    }
    if (!$affiche)
      continue;
    $checked = false;
    if (count ($groupe_secteurs)) {
      foreach ($groupe_secteurs as $groupe_secteur) {
	if ($groupe_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function groupe_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (!strlen ($post['ed_etab'])) {
    set_erreur ('ed_etab');
  }
  if (count ($erreur))
    return false;

  global $base, $secteurs;
  $grp_id = $_GET['grp'];

  // Sauve les données communes
  $base->groupe_update ($_SESSION['token'], $grp_id, $post['ed_intitule'], $post['ed_etab'], $post['ed_debut'], $post['ed_fin'], $post['ed_notes']);

  // Sauve les données de chaque secteur
  foreach ($secteurs as $secteur) {
    $classname = 'Groupe'.ucfirst ($secteur['sec_code']);
    $objSecteur = new $classname();
    echo '<tr class="tr_ed_secteur tr_ed_secteur_'.$secteur['sec_code'].'"><th colspan="2">'.$secteur['sec_nom'].'</th></tr>';
    $objSecteur->update ($grp_id, $post);
  }

  // Sauve les liens groupe/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->groupe_secteurs_set ($_SESSION['token'], $grp_id, $secteurs);
  return true;
}

function groupe_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (!strlen ($post['ed_etab'])) {
    set_erreur ('ed_etab');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs;

  // Crée un nouveau groupe
  $new_grp_id = $base->groupe_add ($_SESSION['token'], $post['ed_intitule'], $post['ed_etab'], $post['ed_debut'], $post['ed_fin'], $post['ed_notes']);

  // Sauve les données de chaque secteur
  foreach ($secteurs as $secteur) {
    $classname = 'Groupe'.ucfirst ($secteur['sec_code']);
    $objSecteur = new $classname();
    echo '<tr class="tr_ed_secteur tr_ed_secteur_'.$secteur['sec_code'].'"><th colspan="2">'.$secteur['sec_nom'].'</th></tr>';
    $objSecteur->update ($new_grp_id, $post);
  }


  // Sauve les liens groupe/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->groupe_secteurs_set ($_SESSION['token'], $new_grp_id, $secteurs);
  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

function url_nouveau_groupe () {
  // Enleve l'argument grp
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ("/admin.php?")), $args);
  unset ($args['grp']);  
  return '/admin.php?'.http_build_query ($args);
}
?>
