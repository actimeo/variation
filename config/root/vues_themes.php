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

if (!$_SESSION['uti_root'])
  exit;

$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);

$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('events_agressources_list_details', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Nom', 'agr_titre', 'lien_edit_agressources', 'agr_id');
$pagination->addColumn ('Thématiques');
$pagination->setLines (15);

/* Gestion de l'édition des organismes, à droite */

if (isset ($_POST['ed_enreg'])) {
  echo 'save';
  if (agressources_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (agressources_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->events_agressources_supprime ($_SESSION['token'], $_GET['agr']);
  header ('Location: '.url_nouvel_agr ());
  exit;
}

if (isset ($_GET['agr'])) {
  $agr_id = (int)$_GET['agr'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $agr['agr_id'] = $agr_id;
    $agr['agr_titre'] = $_POST['ed_nom'];
    $agr['agr_code'] = $_POST['ed_code'];
    $agr_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$agr_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {    
    $agr = $base->events_agressources_get ($_SESSION['token'], $agr_id);
    $agr_secteurs = $base->events_agressources_secteur_liste ($_SESSION['token'], $agr_id);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $agr['agr_id'] = $agr_id;
    $agr['agr_titre'] = $_POST['ed_nom'];
    $agr['agr_code'] = $_POST['ed_code'];
    $agr_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$agr_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {
    $agr = array ();
  }
}

?>

<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer la vue "<?= addslashes ($agr['agr_titre']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>

<h1>Vues de ressources</h1>

<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('agr_titre', 'themes')); ?>
  <tr><td colspan="2" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
<?php if (isset ($_GET['agr'])) { ?>
  <tr><th colspan="2">Éditer</th></tr>
<?php } else { ?>
  <tr><th colspan="2">Ajouter</th></tr>
<?php } ?>
  <tr class="impair">
    <td>Nom</td>
    <td><input size="30" name="ed_nom" value="<?= $agr['agr_titre'] ?>"></input><?= $erreur['ed_nom'] ?></td>
  </tr>

  <tr class="pair">
    <td>Code</td>
    <td><input size="30" name="ed_code" value="<?= $agr['agr_code'] ?>"></input><?= $erreur['ed_code'] ?></td>
  </tr>

  <tr class="impair">
    <td>Thématiques</td>
    <td><?php liste_secteurs_cb ($agr_secteurs) ?></td>
  </tr>

  <tr><td class="navigtd" align="right" colspan="2">
<?php if (isset ($_GET['agr'])) { ?>
    <a href="<?= url_nouvel_agr () ?>">Ajouter une nouvelle vue</a>
    <button name="ed_enreg" type="submit">Mettre à jour</button>
    <input type="hidden" name="ed_suppr" id="ed_suppr_hidden"></input>
    <button id="ed_suppr" type="button">Supprimer</button>
<?php } else { ?>
    <button name="ed_ajout" type="submit">Ajouter</button>
<?php } ?>
  </td></tr>
</table>
</form>


<div style="clear: both"></div>


<?php
function lien_edit_agressources ($agr_id) {
  return array ('/admin.php', array ('agr' => $agr_id));
}

function url_nouvel_agr () {
  // Enleve l'argument agr
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['agr']);
  return '/admin.php?'.http_build_query ($args);
}

function liste_secteurs_cb ($agr_secteurs) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $checked = false;
    if (count ($agr_secteurs)) {
      foreach ($agr_secteurs as $agr_secteur) {
	if ($agr_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function agressources_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_nom'])) {
    set_erreur ('ed_nom');
  }
  if (!strlen ($post['ed_code'])) {
    set_erreur ('ed_code');
  }
  if (count ($erreur))
    return false;

  global $base, $secteurs;
  $agr_id = $_GET['agr'];

  $base->events_agressources_save ($_SESSION['token'], $agr_id, $post['ed_code'], $post['ed_nom']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->events_agressources_secteurs_set ($_SESSION['token'], $agr_id, $secteurs);
  return true;
}

function agressources_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_nom'])) {
    set_erreur ('ed_nom');
  }
  if (!strlen ($post['ed_code'])) {
    set_erreur ('ed_code');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs;

  // Crée une nouvelle vue events
  $new_agr_id = $base->events_agressources_save ($_SESSION['token'], NULL, $post['ed_code'], $post['ed_nom']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->events_agressources_secteurs_set ($_SESSION['token'], $new_agr_id, $secteurs);

  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>
