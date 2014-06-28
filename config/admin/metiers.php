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

$secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $_SESSION['eta_id'], NULL);
$entites = $base->meta_entite_liste ($_SESSION['token']);

// TODO
if (!$_SESSION['uti_config'])
  exit;

$metier_secteurs = $base->metier_secteur_liste ($_SESSION['token'], $_GET['met']);

/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('metier_liste_details', array ($_SESSION['token'], $_GET['ent_id'], $_GET['sec_id']));
$pagination->setUrl ('/admin.php', array ('ent_id' => $_GET['ent_id'],
					  'sec_id' => $_GET['sec_id']
					  ));
$pagination->addColumn ('Intitulé', 'met_nom' , 'lien_edit_metier', 'met_id');
$pagination->addColumn ('Thématiques');
$pagination->addColumn ('Types');
$pagination->setLines (15);


/* Gestion de l'édition des organismes, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (metier_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (metier_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->metier_supprime ($_SESSION['token'], $_GET['met']);
  header ('Location: '.url_nouveau_metier ());
  exit;
}

if (isset ($_GET['met'])) {
  $met_id = (int)$_GET['met'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $metier['met_id'] = $met_id;
    $metier['met_nom'] = $_POST['ed_intitule'];

    $metier_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$metier_secteurs[] = array ('sec_code' => $s);
      }
    }

    $metier_entites = array ();
    if (count ($_POST['ed_entite'])) {
      foreach ($_POST['ed_entite'] as $s) {
	$metier_entites[] = array ('ent_code' => $s);
      }
    }

  } else {    
    $metier = $base->metier_get ($_SESSION['token'], $met_id);
    $metier_secteurs = $base->metier_secteur_liste ($_SESSION['token'], $met_id);
    $metier_entites = $base->metier_entite_liste ($_SESSION['token'], $met_id);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $metier['met_id'] = $met_id;
    $metier['met_nom'] = $_POST['ed_intitule'];

    $metier_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$metier_secteurs[] = array ('sec_code' => $s);
      }
    }

    $metier_entites = array ();
    if (count ($_POST['ed_entite'])) {
      foreach ($_POST['ed_entite'] as $s) {
	$metier_entites[] = array ('ent_code' => $s);
      }
    }

  } else {
    $metier = array ();
  }
}

?>
<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer le métier "<?= addslashes ($metier['met_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>
<h1>Métiers</h1>

<form method="get" action="<?= $_SERVER['REQUEST_URI'] ?>">
<select name="ent_id">
<option value="">(tous types)</option>
<?php liste_entites ($_GET['ent_id']); ?>
</select>
<select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_GET['sec_id']); ?>
</select>
<button type="submit">OK</button>
</form>


<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('met_nom', 'secteurs', 'entites')); ?>
  <tr><td colspan="5" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';

if (isset ($_GET['met'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
 } 

echo '<tr class="impair">';
echo '<td>Métier</td>';
echo '<td>';
echo '<input type="text" size="30" name="ed_intitule" value="'.$metier['met_nom'].'"></input>'.$erreur['ed_intitule'];
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Thématiques</td>';
echo '<td>';
liste_secteurs_cb ($metier_secteurs);
echo '</td>';
echo '</tr>';

echo '<tr class="impair">';
echo '<td>Types</td>';
echo '<td>';
liste_entites_cb ($metier_entites);
echo '</td>';
echo '</tr>';

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['met'])) { 
  echo '<a href="'.url_nouveau_metier ().'">Ajouter un nouveau métier</a> ';
  echo '<button name="ed_enreg" type="submit">Mettre à jour</button>';
  echo '<input type="hidden" name="ed_suppr" id="ed_suppr_hidden"></input>';
  echo '<button id="ed_suppr" type="button">Supprimer</button>';
} else { 
  echo '<button name="ed_ajout" type="submit">Ajouter</button>';
}
echo '</td></tr>';
echo '</table>';
echo '</form>';
?>
<div style="clear: both"></div>


<?php 
function liste_secteurs ($sec_id) {
  global $base;
  $secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  foreach ($secteurs as $secteur) {
    echo '<option '.($secteur['sec_id'] == $sec_id ? ' selected ' : '').'value="'.$secteur['sec_id'].'">'.$secteur['sec_nom'].'</option>';
  }
}

function liste_entites ($ent_id) {  
  global $base, $entites;
  foreach ($entites as $entite) {
    if ($entite['ent_code'] != 'personnel' && $entite['ent_code'] != 'contact')
      continue;
    echo '<option '.($entite['ent_id'] == $ent_id ? ' selected ' : '').'value="'.$entite['ent_id'].'">'.$entite['ent_libelle'].'</option>';
  }
}

function lien_edit_metier ($met_id) {
  return array ('/admin.php', array ('ent_id' => $_GET['ent_id'],
				     'sec_id' => $_GET['sec_id'],
				     'met' => $met_id));
}

function liste_secteurs_cb ($metier_secteurs) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $checked = false;
    if (count ($metier_secteurs)) {
      foreach ($metier_secteurs as $metier_secteur) {
	if ($metier_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function liste_entites_cb ($metier_entites) {
  global $base, $entites;
  foreach ($entites as $entite) {
    if ($entite['ent_code'] != 'personnel' && $entite['ent_code'] != 'contact')
      continue;
    $checked = false;
    if (count ($metier_entites)) {
      foreach ($metier_entites as $metier_entite) {
	if ($metier_entite['ent_code'] == $entite['ent_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_entite_cb" type="checkbox" id="ed_entite_'.$entite['ent_code'].'" name="ed_entite[]" value="'.$entite['ent_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_entite_'.$entite['ent_code'].'">'.$entite['ent_libelle'].'</label></nobr> ';
  }
}

function metier_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;

  global $base, $secteurs, $entites;
  $met_id = $_GET['met'];

  // Sauve les données communes
  $base->metier_update ($_SESSION['token'], $met_id, $post['ed_intitule']);

  // Sauve les liens metier/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->metier_secteurs_set ($_SESSION['token'], $met_id, $secteurs);

  // Sauve les liens metier/entite
  if (count ($post['ed_entite'])) {
    $entites = array ();
    foreach ($post['ed_entite'] as $entite) {
      $entites[] = $entite;
    }
  }
  $base->metier_entites_set ($_SESSION['token'], $met_id, $entites);

  return true;
}

function metier_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs, $entites;

  // Crée un nouveau metier
  $new_met_id = $base->metier_add ($_SESSION['token'], $post['ed_intitule']);

  // Sauve les liens metier/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->metier_secteurs_set ($_SESSION['token'], $new_met_id, $secteurs);

  // Sauve les liens metier/entite
  if (count ($post['ed_entite'])) {
    $entites = array ();
    foreach ($post['ed_entite'] as $entite) {
      $entites[] = $entite;
    }
  }
  $base->metier_entites_set ($_SESSION['token'], $new_met_id, $entites);

  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

function url_nouveau_metier () {
  // Enleve l'argument grp
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['met']);  
  return '/admin.php?'.http_build_query ($args);
}
?>
