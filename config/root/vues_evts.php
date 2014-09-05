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

$secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $_SESSION['eta_id'], NULL);
$ecas = $base->events_events_categorie_list ($_SESSION['token']);

$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('events_events_liste_details', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Nom', 'evs_titre', 'lien_edit_events', 'evs_id');
$pagination->addColumn ('Thématiques');
$pagination->addColumn ('Catégories');
$pagination->addColumn ('Type');
$pagination->setLines (15);

/* Gestion de l'édition des organismes, à droite */

if (isset ($_POST['ed_enreg'])) {
  echo 'save';
  if (events_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (events_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->events_events_supprime ($_SESSION['token'], $_GET['evs']);
  header ('Location: '.url_nouvel_evs ());
  exit;
}

if (isset ($_GET['evs'])) {
  $evs_id = (int)$_GET['evs'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $evs['evs_id'] = $evs_id;
    $evs['evs_titre'] = $_POST['ed_nom'];
    $evs['evs_code'] = $_POST['ed_code'];
    $evs['ety_id'] = $_POST['ed_ety'];
    $evs_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$evs_secteurs[] = array ('sec_code' => $s);
      }
    }
    $evs_ecas = array ();
    if (count ($_POST['ed_eca'])) {
      foreach ($_POST['ed_eca'] as $s) {
	$evs_ecas[] = array ('eca_code' => $s);
      }
    }
  } else {    
    $evs = $base->events_events_get ($_SESSION['token'], $evs_id);
    $evs_secteurs = $base->events_secteur_events_liste ($_SESSION['token'], $evs_id, $_SESSION['eta_id']);
    $evs_ecas = $base->events_categorie_events_liste ($_SESSION['token'], $evs_id);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $evs['evs_id'] = $evs_id;
    $evs['evs_titre'] = $_POST['ed_nom'];
    $evs['evs_code'] = $_POST['ed_code'];
    $evs['ety_id'] = $_POST['ed_ety'];
    $evs_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$evs_secteurs[] = array ('sec_code' => $s);
      }
    }
    $evs_ecas = array ();
    if (count ($_POST['ed_eca'])) {
      foreach ($_POST['ed_eca'] as $s) {
	$evs_ecas[] = array ('eca_code' => $s);
      }
    }
  } else {
    $evs = array ();
  }
}

?>

<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer la vue "<?= addslashes ($evs['evs_titre']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>

<h1>Vues d'événements</h1>

<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('evs_titre', 'themes', 'categories', 'typ')); ?>
  <tr><td colspan="4" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
<?php if (isset ($_GET['evs'])) { ?>
  <tr><th colspan="2">Éditer</th></tr>
<?php } else { ?>
  <tr><th colspan="2">Ajouter</th></tr>
<?php } ?>
  <tr class="impair">
    <td>Nom</td>
    <td><input size="30" name="ed_nom" value="<?= $evs['evs_titre'] ?>"></input><?= $erreur['ed_nom'] ?></td>
  </tr>

  <tr class="pair">
    <td>Code</td>
    <td><input size="30" name="ed_code" value="<?= $evs['evs_code'] ?>"></input><?= $erreur['ed_code'] ?></td>
  </tr>

  <tr class="impair">
    <td>Thématiques</td>
    <td><?php liste_secteurs_cb ($evs_secteurs) ?></td>
  </tr>

  <tr class="pair">
    <td>Catégories</td>
    <td><?php liste_ecas_cb ($evs_ecas) ?></td>
  </tr>

  <tr class="impair">
    <td>Type</td>
    <td><?php liste_types_cb ($evs['ety_id']) ?></td>
  </tr>

  <tr><td class="navigtd" align="right" colspan="2">
<?php if (isset ($_GET['evs'])) { ?>
    <a href="<?= url_nouvel_evs () ?>">Ajouter une nouvelle vue</a>
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
function lien_edit_events ($evs_id) {
  return array ('/admin.php', array ('evs' => $evs_id));
}

function url_nouvel_evs () {
  // Enleve l'argument evs
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['evs']);
  return '/admin.php?'.http_build_query ($args);
}

function liste_secteurs_cb ($evs_secteurs) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $checked = false;
    if (count ($evs_secteurs)) {
      foreach ($evs_secteurs as $evs_secteur) {
	if ($evs_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function liste_types_cb ($ety_id) {
  global $base, $evs;
  $types = $base->events_event_type_list_par_evs ($_SESSION['token'], $evs['evs_id']);
  echo '<select name="ed_ety">';
  echo '<option value="">(pas de type particulier)</option>';
  foreach ($types as $type) {
    $selected = $type['id'] == $ety_id;
    echo '<option '.($selected ? 'selected ' : '').'value="'.$type['id'].'">'.$type['nom'].'</option>';
  }
  echo '</select>';
}

function liste_ecas_cb ($evs_ecas) {
  global $base, $ecas;
  foreach ($ecas as $eca) {
    $checked = false;
    if (count ($evs_ecas)) {
      foreach ($evs_ecas as $evs_eca) {
	if ($evs_eca['eca_code'] == $eca['eca_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_eca_cb" type="checkbox" id="ed_eca_'.$eca['eca_code'].'" name="ed_eca[]" value="'.$eca['eca_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_eca_'.$eca['eca_code'].'">'.$eca['eca_nom'].'</label></nobr> ';
  }
}

function events_save ($post) {
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

  global $base, $secteurs, $ecas;
  $evs_id = $_GET['evs'];

  $base->events_events_update ($_SESSION['token'], $evs_id, $post['ed_nom'], $post['ed_code'], $post['ed_ety']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->events_secteur_events_set ($_SESSION['token'], $evs_id, $secteurs);

  // Sauve les liens categorie
  if (count ($post['ed_eca'])) {
    $ecas = array ();
    foreach ($post['ed_eca'] as $eca) {
      $ecas[] = $eca;
    }
  }
  $base->events_categorie_events_set ($_SESSION['token'], $evs_id, $ecas);
  return true;
}

function events_add ($post) {
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
  $new_evs_id = $base->events_events_add ($_SESSION['token'], $post['ed_nom'], $post['ed_code'], $post['ed_ety']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->events_secteur_events_set ($_SESSION['token'], $new_evs_id, $secteurs);

  // Sauve les liens categorie
  if (count ($post['ed_eca'])) {
    $ecas = array ();
    foreach ($post['ed_eca'] as $eca) {
      $ecas[] = $eca;
    }
  }
  $base->events_categorie_events_set ($_SESSION['token'], $new_evs_id, $ecas);
  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>
