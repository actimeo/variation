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
/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('notes_theme_liste_details', array ($_SESSION['token'], $_GET['por']));
$pagination->setUrl ('/admin.php', array ('por' => $_GET['por']));
$pagination->addColumn ('Nom', 'the_nom', 'lien_edit_theme', 'the_id');
$pagination->addColumn ('Portails', 'portails');
$pagination->setLines (15);

/* Gestion de l'édition des thèmes, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (theme_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (theme_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->notes_theme_supprime ($_SESSION['token'], $_GET['the']);
  header ('Location: '.url_nouveau_theme ());
  exit;
}

if (isset ($_GET['the'])) {
  $the_id = (int)$_GET['the'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs
    $theme['the_id'] = $the_id;
    $theme['the_nom'] = $_POST['ed_the_nom'];
    $theme_portails = array ();
    if (count ($_POST['ed_portail'])) {
      foreach ($_POST['ed_portail'] as $s) {
	$theme_portails[] = array ('por_id' => $s);
      }
    }
  } else {    
    $theme = $base->notes_theme_get ($_SESSION['token'], $_GET['the']);
    $theme_portails = $base->notes_theme_portail_liste ($_SESSION['token'], $theme['the_id']);
  }
} else {
  if (count ($erreur)) {
    $theme['the_nom'] = $_POST['ed_the_nom'];
  } else {
    $theme = array ();
  }
}

?>

<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});
function on_ed_suppr_click () {
    if (confirm ('Supprimer la boîte thématique "<?= addslashes ($theme['the_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>

<?php
function url_nouveau_theme () {
  // Enleve l'argument the
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['the']);  
  return '/admin.php?'.http_build_query ($args);
}

function lien_edit_theme ($the_id) {
  return array ('/admin.php', array ('por' => $_GET['por'],
				     'the' => $the_id));
}

function liste_portails () {
  global $base;
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  foreach ($cats as $cat) {
    echo '<optgroup label="'.$cat['cat_nom'].'">';
    $pors = $base->meta_portail_liste ($_SESSION['token'], $cat['cat_id']);
    foreach ($pors as $por) {
      $selected = $por['por_id'] == $_GET['por'] ? ' selected' : '';
      echo '<option value="'.$por['por_id'].'"'.$selected.'>'.$por['por_libelle'].'</option>';
    }
    echo '</optgroup>';
  }
}


function liste_portails_cb ($theme_portails) {
  global $base;
  $cats = $base->meta_categorie_liste ($_SESSION['token']);
  foreach ($cats as $cat) {
    echo '<strong>'.$cat['cat_nom'].'</strong><br>';
    $pors = $base->meta_portail_liste ($_SESSION['token'], $cat['cat_id']);
    foreach ($pors as $por) {
      $checked = '';
      foreach ($theme_portails as $tpo) {
	if ($por['por_id'] == $tpo['por_id']) {
	  $checked = ' checked';
	  break;
	}
      }
      echo '<input id="ed_portail_'.$por['por_id'].'" name="ed_portail[]" value="'.$por['por_id'].'" type="checkbox"'.$checked.'></input><label for="ed_portail_'.$por['por_id'].'">'.$por['por_libelle'].'</label><br>';
    }
    echo '</optgroup>';
  }
  
}

function theme_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_the_nom'])) {
    set_erreur ('ed_the_nom');
  }
  if (count ($erreur))
    return false;
  global $base;
  if (count ($post['ed_portail'])) {
    $portails = array ();
    foreach ($post['ed_portail'] as $portail) {
      $portails[] = $portail;
    }
  }
  $base->notes_theme_update ($_SESSION['token'], $_GET['the'], $post['ed_the_nom'], $portails);
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>

<h1>Boîtes de notes</h1>
<form method="GET" action="">
  <select name="por">
  <option value="">(tous portails)</option>
  <?php liste_portails (); ?>
  </select>
  <input type="submit" value="OK"></input>
</form>

<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('the_nom', 'portails')); ?>
  <tr><td colspan="5" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';

if (isset ($_GET['the'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
} 

echo '<tr class="impair">';
echo '<td>Nom</td>';
echo '<td>';
echo '<input type="text" name="ed_the_nom" size="30" value="'.$theme['the_nom'].'"></input>';
echo $erreur['ed_the_nom'];
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Portails</td>';
echo '<td>';
liste_portails_cb ($theme_portails);
echo '</td>';
echo '</tr>';

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['the'])) { 
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
