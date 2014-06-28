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
$pagination->setFunction ('meta_selection_liste', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Nom', 'sel_libelle', 'lien_edit_sel', 'sel_id');
$pagination->setLines (30);

/* Gestion de l'édition des sélections, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (selection_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
}

if (isset ($_GET['sel'])) {
  $sel_id = (int)$_GET['sel'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $selec['sel_id'] = $sel_id;
    $selec['sel_libelle'] = $_POST['ed_libelle'];
    $selec['sel_info'] = $_POST['ed_info'];
    // TODO entrees
  } else {    
    $selec = $base->meta_selection_infos ($_SESSION['token'], $sel_id);
    $entrees = $base->meta_selection_entree_liste ($_SESSION['token'], $sel_id);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $selec['sel_id'] = $sel_id;
    $selec['sel_libelle'] = $_POST['ed_libelle'];
    $selec['sel_info'] = $_POST['ed_info'];
    // TODO entrees
  } else {
    $selec = array ();
    $entrees = array ();
  }
}
function lien_edit_sel ($sel_id) {
  return array ('/admin.php', array ('sel' => $sel_id));
}

function url_nouveau_selec () {
  // Enleve l'argument sel
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['sel']);  
  return '/admin.php?'.http_build_query ($args);
}

function affiche_entrees () {
  global $entrees;
  if (count ($entrees)) {
    echo '<ul>';
    foreach ($entrees as $entree) {
      echo '<li>'.$entree['sen_libelle'].'</li>';
    }
    echo '</ul>';
  }
}

function selection_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_libelle'])) {
    set_erreur ('ed_libelle');
  }
  if (count ($erreur))
    return false;

  global $base;
  $sel_id = $_GET['sel'];

  $old = $base->meta_selection_infos ($_SESSION['token'], $sel_id);  
  print_r ($post);
  $base->meta_selection_update ($_SESSION['token'], $sel_id, $old['sel_code'], $post['ed_libelle'], $post['ed_info']);
  // TODO entrees
  return true;
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>
<h1>Listes de sélections</h1>
<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('sel_libelle')); ?>
  <tr><td colspan="1" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php if (isset ($_GET['sel'])) { ?>
<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
  <tr><th colspan="2">Éditer</th></tr>
  <tr class="pair">
    <td>Nom</td>
    <td><input size="30" name="ed_libelle" value="<?= $selec['sel_libelle'] ?>"></input><?= $erreur['ed_libelle'] ?></td>
  </tr>
  <tr class="impair">
    <td>Info</td>
    <td><input size="30" name="ed_info" value="<?= $selec['sel_info'] ?>"></input><?= $erreur['ed_info'] ?></td>
  </tr>

  <tr class="pair">
    <td>Options</td>
     <td><?php affiche_entrees (); ?></td>
  </tr>

  <tr><td class="navigtd" align="right" colspan="2">
    <button name="ed_enreg" type="submit">Mettre à jour</button>
  </td></tr>
</table>
</form>
<?php } ?>


<div style="clear: both"></div>
