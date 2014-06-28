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
$pagination->setFunction ('document_documents_liste_details', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Nom', 'dos_titre', 'lien_edit_documents', 'dos_id');
$pagination->addColumn ('Thématiques');
$pagination->addColumn ('Type');
$pagination->setLines (15);

/* Gestion de l'édition des vues documents, à droite */

if (isset ($_POST['ed_enreg'])) {
  if (documents_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (documents_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->document_documents_supprime ($_SESSION['token'], $_GET['dos']);
  header ('Location: '.url_nouveau_dos ());
  exit;
}

if (isset ($_GET['dos'])) {
  $dos_id = (int)$_GET['dos'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $dos['dos_id'] = $dos_id;
    $dos['dos_titre'] = $_POST['ed_nom'];
    $dos['dty_id'] = $_POST['ed_dty'];
    $dos_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$dos_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {    
    $dos = $base->document_documents_get ($_SESSION['token'], $dos_id);
    $dos_secteurs = $base->document_documents_secteur_liste_details_etab ($_SESSION['token'], $dos_id, NULL);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $dos['dos_id'] = $dos_id;
    $dos['dos_titre'] = $_POST['ed_nom'];
    $dos['dty_id'] = $_POST['ed_dty'];
    $dos_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$dos_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {
    $dos = array ();
  }
}
?>

<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer la vue "<?= addslashes ($dos['dos_titre']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>

<h1>Vues de documents</h1>

<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('dos_titre', 'themes', 'typ')); ?>
  <tr><td colspan="4" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
<?php if (isset ($_GET['dos'])) { ?>
  <tr><th colspan="2">Éditer</th></tr>
<?php } else { ?>
  <tr><th colspan="2">Ajouter</th></tr>
<?php } ?>
  <tr class="impair">
    <td>Nom</td>
    <td><input size="30" name="ed_nom" value="<?= $dos['dos_titre'] ?>"></input><?= $erreur['ed_nom'] ?></td>
  </tr>

  <tr class="pair">
    <td>Thématiques</td>
    <td><?php liste_secteurs_cb ($dos_secteurs) ?></td>
  </tr>

  <tr class="impair">
    <td>Type</td>
    <td><?php liste_types_cb ($dos['dty_id']) ?></td>
  </tr>

  <tr><td class="navigtd" align="right" colspan="2">
<?php if (isset ($_GET['dos'])) { ?>
    <a href="<?= url_nouveau_dos () ?>">Ajouter une nouvelle vue</a>
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
function lien_edit_documents ($dos_id) {
  return array ('/admin.php', array ('dos' => $dos_id));
}

function url_nouveau_dos () {
  // Enleve l'argument dos
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['dos']);
  return '/admin.php?'.http_build_query ($args);
}

function liste_secteurs_cb ($dos_secteurs) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $checked = false;
    if (count ($dos_secteurs)) {
      foreach ($dos_secteurs as $dos_secteur) {
	if ($dos_secteur['sec_id'] == $secteur['sec_id']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}

function liste_types_cb ($dty_id) {
  global $base, $dos, $dos_secteurs;
  $sec_ids = array ();
  foreach ($dos_secteurs as $dos_secteur) {
    $sec_ids[] = $dos_secteur['sec_id'];
  }
  // TODO
  $types = $base->document_document_type_liste_par_sec_ids ($_SESSION['token'], $sec_ids, NULL);
  echo '<select name="ed_dty">';
  echo '<option value="">(pas de type particulier)</option>';
  foreach ($types as $type) {
    $selected = $type['id'] == $dty_id;
    echo '<option '.($selected ? 'selected ' : '').'value="'.$type['dty_id'].'">'.$type['dty_nom'].'</option>';
  }
  echo '</select>';
}

function documents_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_nom'])) {
    set_erreur ('ed_nom');
  }
  if (count ($erreur))
    return false;

  global $base, $secteurs;
  $dos_id = $_GET['dos'];
  $base->document_documents_save ($_SESSION['token'], $dos_id, $post['ed_nom'], $post['ed_dty']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->document_documents_secteurs_set ($_SESSION['token'], $dos_id, $secteurs);

  // Sauve les liens categorie
  if (count ($post['ed_eca'])) {
    $ecas = array ();
    foreach ($post['ed_eca'] as $eca) {
      $ecas[] = $eca;
    }
  }
  return true;
}

function documents_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_nom'])) {
    set_erreur ('ed_nom');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs;

  // Crée une nouvelle vue events
  $new_dos_id = $base->document_documents_save ($_SESSION['token'], NULL, $post['ed_nom'], $post['ed_dty']);

  // Sauve les liens secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->document_documents_secteurs_set ($_SESSION['token'], $new_dos_id, $secteurs);
  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>
