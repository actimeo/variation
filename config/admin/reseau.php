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

$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);

if (!$_SESSION['uti_config'])
  exit;

/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('etablissement_liste_details', array ($_SESSION['token'], $_GET['sec_id_role'], $_GET['sec_id_besoin'], FALSE));
$pagination->setUrl ('/admin.php', array ('sec_id_role' => $_GET['sec_id_role'],
					  'sec_id_besoin' => $_GET['sec_id_besoin']
					  ));
$pagination->addColumn ('Intitulé', 'eta_nom', 'lien_edit_etab', 'eta_id');
$pagination->addColumn ('Rôles');
$pagination->addColumn ('Besoins');
$pagination->setLines (15);


/* Gestion de l'édition des organismes, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (etablissement_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (etablissement_add ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->etablissement_supprime ($_SESSION['token'], $_GET['eta']);
  header ('Location: '.url_nouvel_etab ());
  exit;
}

if (isset ($_GET['eta'])) {
  $eta_id = (int)$_GET['eta'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $etabli['eta_id'] = $eta_id;
    $etabli['eta_nom'] = $_POST['ed_intitule'];
    $etablissement_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$etablissement_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {    
    $etabli = $base->etablissement_get ($_SESSION['token'], $eta_id);
    if ($etabli['adr_id'])
      $etab_adresse = $base->adresse_get ($_SESSION['token'], $etabli['adr_id']);
    $etablissement_secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $eta_id, NULL);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $etabli['eta_id'] = $eta_id;
    $etabli['eta_nom'] = $_POST['ed_intitule'];
    $etablissement_secteurs = array ();
    if (count ($_POST['ed_secteur'])) {
      foreach ($_POST['ed_secteur'] as $s) {
	$etablissement_secteurs[] = array ('sec_code' => $s);
      }
    }
  } else {
    $etabli = array ();
  }
}

?>

<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer l\'organisme "<?= addslashes ($etabli['eta_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>


<h1>Partenaires</h1>

<form method="get" action="<?= $_SERVER['REQUEST_URI'] ?>">
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
  <?php $pagination->displayData (array ('eta_nom', 'roles', 'besoins')); ?>
  <tr><td colspan="3" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>


<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
<?php if (isset ($_GET['eta'])) { ?>
  <tr><th colspan="2">Éditer</th></tr>
<?php } else { ?>
  <tr><th colspan="2">Ajouter</th></tr>
<?php } ?>
  <tr class="impair">
    <td>Intitulé</td>
    <td><input size="30" name="ed_intitule" value="<?= $etabli['eta_nom'] ?>"></input><?= $erreur['ed_intitule'] ?></td>
  </tr>

  <tr class="pair">
    <td>Adresse</td>
    <td><textarea name="ed_adr_adresse" rows="3" cols="30"><?= $etab_adresse['adr_adresse'] ?></textarea></td>
  </tr>

  <tr class="impair">
    <td>CP/Ville</td>
    <td>
      <input type="text" size="5" name="ed_adr_cp" value="<?= $etab_adresse['adr_cp'] ?>"></input>
      <input type="text" size="20" name="ed_adr_ville" value="<?= $etab_adresse['adr_ville'] ?>"></input>
    </td>
  </tr>

  <tr class="pair">
    <td>Tél/Fax</td>
    <td>
      <input type="text" size="12" name="ed_adr_tel" value="<?= $etab_adresse['adr_tel'] ?>"></input>
      <input type="text" size="12" name="ed_adr_fax" value="<?= $etab_adresse['adr_fax'] ?>"></input>
    </td>
  </tr>

  <tr class="impair">
    <td>Email</td>
    <td>
      <input type="text" size="30" name="ed_adr_email" value="<?= $etab_adresse['adr_email'] ?>"></input>
    </td>
  </tr>

  <tr class="pair">
    <td>Site web</td>
    <td>
      <input type="text" size="30" name="ed_adr_web" value="<?= $etab_adresse['adr_web'] ?>"></input>
    </td>
  </tr>

  <tr class="impair">
    <td>Rôles</td>
    <td><?php liste_secteurs_cb ($etablissement_secteurs, true) ?></td>
  </tr>

  <tr class="pair">
    <td>Besoins</td>
    <td><?php liste_secteurs_cb ($etablissement_secteurs, false) ?></td>
  </tr>

  <tr><td class="navigtd" align="right" colspan="2">
<?php if (isset ($_GET['eta'])) { ?>
    <a href="<?= url_nouvel_etab () ?>">Ajouter un nouvel organisme</a>
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
function liste_secteurs ($sec_id, $est_prise_en_charge) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    if ($secteur['sec_est_prise_en_charge'] != $est_prise_en_charge)
      continue;
    echo '<option '.($secteur['sec_id'] == $sec_id ? ' selected ' : '').'value="'.$secteur['sec_id'].'">'.$secteur['sec_nom'].'</option>';
  }
}

function lien_edit_etab ($eta_id) {
  return array ('/admin.php', array ('sec_id_role' => $_GET['sec_id_role'],
			             'sec_id_besoin' => $_GET['sec_id_besoin'],
			             'eta' => $eta_id));
}

function url_nouvel_etab () {
  // Enleve l'argument eta
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['eta']);  
  return '/admin.php?'.http_build_query ($args);
}

function liste_secteurs_cb ($etabli_secteurs, $est_prise_en_charge) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    if ($secteur['sec_est_prise_en_charge'] != $est_prise_en_charge)
      continue;
    $checked = false;
    if (count ($etabli_secteurs)) {
      foreach ($etabli_secteurs as $etabli_secteur) {
	if ($etabli_secteur['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}


function etablissement_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;

  global $base, $secteurs;
  $eta_id = $_GET['eta'];

  $base->etablissement_update ($_SESSION['token'], $eta_id, $post['ed_intitule'], NULL, $post['ed_adr_adresse'], $post['ed_adr_cp'], $post['ed_adr_ville'], $post['ed_adr_tel'], $post['ed_adr_fax'], $post['ed_adr_email'], $post['ed_adr_web']);

  // Sauve les liens groupe/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->etablissement_secteurs_set ($_SESSION['token'], $eta_id, $secteurs);
  return true;
}

function etablissement_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;
  
  global $base, $secteurs;

  // Crée un nouvel établissement
  $new_grp_id = $base->etablissement_add ($_SESSION['token'], $post['ed_intitule'], NULL, $post['ed_adr_adresse'], $post['ed_adr_cp'], $post['ed_adr_ville'], $post['ed_adr_tel'], $post['ed_adr_fax'], $post['ed_adr_email'], $post['ed_adr_web']);

  // Sauve les liens étab/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->etablissement_secteurs_set ($_SESSION['token'], $new_grp_id, $secteurs);
  return true;  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

?>
