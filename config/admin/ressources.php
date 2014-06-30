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

if (!$_SESSION['uti_config'])
  exit;

/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('ressource_liste_details', array ($_SESSION['token'], $_GET['sec_id']));
$pagination->setUrl ('/admin.php', array ('sec_id' => $_GET['sec_id']
					  ));
$pagination->addColumn ('Intitulé', 'res_nom', 'lien_edit_ressource', 'res_id');
$pagination->addColumn ('Secteurs');
$pagination->setLines (15);

if (isset ($_POST['ed_enreg'])) {
  if (ressource_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (ressource_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->ressource_supprime ($_SESSION['token'], $_GET['res']);
  header ('Location: '.url_nouvelle_ressource ());
  exit;
}

if (isset ($_GET['res'])) {
  $res_id = (int)$_GET['res'];
  $ressource = $base->ressource_get ($_SESSION['token'], $res_id);
  $ressource_secteurs = $base->ressource_secteur_liste ($_SESSION['token'], $res_id);
}

?>
<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer la ressource "<?= addslashes ($ressource['res_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>
<h1>Ressources</h1>
<form method="get" action="<?= $_SERVER['REQUEST_URI'] ?>">
<select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_GET['sec_id']); ?>
</select>
<button type="submit">OK</button>
</form>


<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('res_nom', 'secteurs')); ?>
  <tr><td colspan="2" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>


  <?php 
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';
if ($_GET['res']) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else {
  echo '<tr><th colspan="2">Ajouter</th></tr>';
}
?>
  <tr class="pair">
    <td>Ressource</td>
    <td><input type="text" value="<?= $ressource['res_nom'] ?>" name="ed_res_nom"></input></td>
  </tr>
  <tr class="impair">
    <td>Thématiques</td>
   <td><?php liste_secteurs_cb ($ressource_secteurs) ?></td>
  </tr>
  <tr><td class="navigtd" align="right" colspan="2">
<?php
if (isset ($_GET['res'])) { 
  echo '<a href="'.url_nouvelle_ressource ().'">Ajouter un nouvelle ressource</a> ';
  echo '<button name="ed_enreg" type="submit">Mettre à jour</button>';
  echo '<input type="hidden" name="ed_suppr" id="ed_suppr_hidden"></input>';
  echo '<button id="ed_suppr" type="button">Supprimer</button>';
} else { 
  echo '<button name="ed_ajout" type="submit">Ajouter</button>';
}
?>
  </td></tr>
</table>
</form>



<div style="clear: both"></div>

<?php
function liste_secteurs ($sec_id) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    echo '<option '.($secteur['sec_id'] == $sec_id ? ' selected ' : '').'value="'.$secteur['sec_id'].'">'.$secteur['sec_nom'].'</option>';
  }
}

function liste_secteurs_cb ($ressource_secteurs) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $checked = false;
    if (count ($ressource_secteurs)) {
      foreach ($ressource_secteurs as $ressource_secteur) {
	if ($ressource_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function lien_edit_ressource ($res_id) {
  return array ('/admin.php', array ('sec_id' => $_GET['sec_id'],
				     'res' => $res_id));
}

function ressource_save ($post) {
  global $base, $secteurs;
  $res_id = $_GET['res'];

  $base->ressource_save ($_SESSION['token'], $res_id, $post['ed_res_nom']);
  // Sauve les liens ressource/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->ressource_secteur_set ($_SESSION['token'], $res_id, $secteurs);
  return true;
}

function url_nouvelle_ressource () {
  // Enleve l'argument res
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['res']);  
  return '/admin.php?'.http_build_query ($args);
}

function ressource_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_res_nom'])) {
    set_erreur ('ed_res_nom');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs;

  // Crée un nouvelle ressource
  $new_res_id = $base->ressource_add ($_SESSION['token'], $post['ed_res_nom']);

  // Sauve les liens ressource/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->ressource_secteur_set ($_SESSION['token'], $new_res_id, $secteurs);

  return true;  
}
?>
