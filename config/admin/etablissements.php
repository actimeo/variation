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
$categories = $base->meta_categorie_liste ($_SESSION['token']);

if (!$_SESSION['uti_config'])
  exit;

/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('etablissement_liste_details', array ($_SESSION['token'], $_GET['sec_id'], TRUE));
$pagination->setUrl ('/admin.php', array ('sec_id' => $_GET['sec_id']));
$pagination->addColumn ('Intitulé', 'eta_nom', 'lien_edit_etab', 'eta_id');
$pagination->addColumn ('Rôles', 'roles');
$pagination->addColumn ('Besoins', 'besoins');
$pagination->setLines (15);

if (isset ($_POST['ed_enreg'])) {
  if (etablissement_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
}

if (isset ($_GET['eta'])) {
  $eta_id = (int)$_GET['eta'];
  $etabli = $base->etablissement_get ($_SESSION['token'], $eta_id);
  $etablissement_secteurs = $base->etablissement_secteur_liste ($_SESSION['token'], $eta_id, NULL);
  $etablissement_secteurs_edit = $base->etablissement_secteur_edit_liste ($_SESSION['token'], $eta_id);
}

?>
<h1>Prestations fournies</h1>
<form method="get" action="<?= $_SERVER['REQUEST_URI'] ?>">
<Select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_GET['sec_id']); ?>
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


  <?php if ($_GET['eta']) { ?>
<form id="ed_form" method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">
<table class="t1" width="370" style="margin-left: 480px">
  <tr><th colspan="2">Éditer</th></tr>
  <tr class="pair">
    <td>Intitulé</td>
    <td><?= $etabli['eta_nom'] ?></td>
  </tr>
  <tr class="impair">
    <td>Thématiques éditables<br><span title="Indique si les utilisateurs peuvent rajouter des groupes de la thématique donnée à l'établissement" class="qtipable"><img src="/Images/icons/tip.png"></span></td>
   <td><?php liste_secteurs_cb ($etablissement_secteurs, $etablissement_secteurs_edit) ?></td>
  </tr>
  <tr><td class="navigtd" align="right" colspan="2">
    <button name="ed_enreg" type="submit">Mettre à jour</button>
  </td></tr>
</table>
</form>
<?php } ?>



<div style="clear: both"></div>

<?php
function liste_secteurs ($sec_id) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    echo '<option '.($secteur['sec_id'] == $sec_id ? ' selected ' : '').'value="'.$secteur['sec_id'].'">'.$secteur['sec_nom'].'</option>';
  }
}

function liste_secteurs_cb ($etabli_secteurs, $etabli_secteurs_edit) {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    $affiche = false;
    $checked = false;
    if (count ($etabli_secteurs)) {
      foreach ($etabli_secteurs as $etabli_secteur) {
	if ($etabli_secteur['sec_code'] == $secteur['sec_code']) {
	  $affiche = true;
	}
      }
    }
    if (count ($etabli_secteurs_edit)) {
      foreach ($etabli_secteurs_edit as $etabli_secteur_edit) {
	if ($etabli_secteur_edit['sec_code'] == $secteur['sec_code']) {
	  $checked = true;
	}
      }
    }
    if ($affiche) {
      echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'.$secteur['sec_code'].'" name="ed_secteur[]" value="'.$secteur['sec_code'].'"'.($checked ? ' checked' : '').'></input><label for="ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
    }
  }
}

function lien_edit_etab ($eta_id) {
  return array ('/admin.php', array ('sec_id' => $_GET['sec_id'],
				     'eta' => $eta_id));
}

function etablissement_save ($post) {
  global $base, $secteurs;
  $eta_id = $_GET['eta'];

  // Sauve les liens edit groupe/secteur
  if (count ($post['ed_secteur'])) {
    $secteurs = array ();
    foreach ($post['ed_secteur'] as $secteur) {
      $secteurs[] = $secteur;
    }
  }
  $base->etablissement_secteurs_edit_set ($_SESSION['token'], $eta_id, $secteurs);
  return true;
}
?>
