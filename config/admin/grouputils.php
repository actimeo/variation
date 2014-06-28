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
if (!$_SESSION['uti_config'])
  exit;

include ("inc/pagination.php");

$portails = $base->meta_portail_liste ($_SESSION['token'], NULL);
$groupes = $base->groupe_filtre ($_SESSION['token'], 'prise_en_charge', NULL, true, NULL, $base->order('grp_nom'));
/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('login_grouputil_liste', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Intitulé', 'gut_nom' , 'lien_edit_grouputil', 'gut_id');
$pagination->setLines (15);

/* Gestion de l'édition des grouputils, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (grouputil_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (grouputil_add ($_POST)) {    
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->login_grouputil_supprime ($_SESSION['token'], $_GET['gut']);
  header ('Location: '.url_nouveau_grouputil ());
  exit;
}

if (isset ($_GET['gut'])) {
  $gut_id = (int)$_GET['gut'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $grouputil['gut_id'] = $gut_id;
    $grouputil['gut_nom'] = $_POST['ed_intitule'];

    $grouputil_groupes = array ();
    if (count ($_POST['ed_groupe'])) {
      foreach ($_POST['ed_groupe'] as $s) {
	$grouputil_groupes[] = array ('grp_id' => $s);
      }
    }

    $grouputil_portails = array ();
    if (count ($_POST['ed_portail'])) {
      foreach ($_POST['ed_portail'] as $s) {
	$grouputil_portails[] = array ('por_id' => $s);
      }
    }

  } else {    
    $grouputil = $base->login_grouputil_get ($_SESSION['token'], $gut_id);
    $grouputil_groupes = $base->login_grouputil_groupe_liste ($_SESSION['token'], $gut_id);
    $grouputil_portails = $base->login_grouputil_portail_liste ($_SESSION['token'], $gut_id);
  }
} else {
  if (count ($erreur)) {
    // Si on ajoute et qu'il y a une erreur 
    $grouputil['gut_id'] = $gut_id;
    $grouputil['gut_nom'] = $_POST['ed_intitule'];

    $grouputil_groupes = array ();
    if (count ($_POST['ed_groupe'])) {
      foreach ($_POST['ed_groupe'] as $s) {
	$grouputil_groupes[] = array ('grp_id' => $s);
      }
    }

    $grouputil_portails = array ();
    if (count ($_POST['ed_portail'])) {
      foreach ($_POST['ed_portail'] as $s) {
	$grouputil_portails[] = array ('por_id' => $s);
      }
    }

  } else {
    $grouputil = array ();
  }
}


function lien_edit_grouputil ($gut_id) {
  return array ('/admin.php', array ('gut' => $gut_id));
}

function url_nouveau_grouputil () {
  // Enleve l'argument gut
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['gut']);  
  return '/admin.php?'.$p['query'] = http_build_query ($args);
}

function liste_portails_cb () {
  global $grouputil_portails, $portails;
  foreach ($portails as $portail) {
    $checked = false;
    if (count ($grouputil_portails)) {
      foreach ($grouputil_portails as $grouputil_portail) {
	if ($grouputil_portail['por_id'] == $portail['por_id']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_portail_cb" type="checkbox" id="ed_portail_'.$portail['por_id'].'" name="ed_portail[]" value="'.$portail['por_id'].'"'.($checked ? ' checked' : '').'></input><label for="ed_portail_'.$portail['por_id'].'">'.$portail['por_libelle'].'</label></nobr><br> ';
  }
}

function liste_groupes_cb () {
  global $grouputil_groupes, $groupes;
  foreach ($groupes as $groupe) {
    $checked = false;
    if (count ($grouputil_groupes)) {
      foreach ($grouputil_groupes as $grouputil_groupe) {
	if ($grouputil_groupe['grp_id'] == $groupe['grp_id']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_groupe_cb" type="checkbox" id="ed_groupe_'.$groupe['grp_id'].'" name="ed_groupe[]" value="'.$groupe['grp_id'].'"'.($checked ? ' checked' : '').'></input><label for="ed_groupe_'.$groupe['grp_id'].'">'.$groupe['grp_nom'].'</label></nobr><br> ';
  }  
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

function grouputil_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;
  
  global $base;

  // Crée un nouveau grouputil
  $new_gut_id = $base->login_grouputil_add ($_SESSION['token'], $post['ed_intitule']);

  // Sauve les liens grouputil/portail
  if (count ($post['ed_portail'])) {
    $grouputil_portails = array ();
    foreach ($post['ed_portail'] as $grouputil_portail) {
      $grouputil_portails[] = $grouputil_portail;
    }
  }
  $base->login_grouputil_portail_set ($_SESSION['token'], $new_gut_id, $grouputil_portails);

  // Sauve les liens grouputil/groupe  
  if (count ($post['ed_groupe'])) {
    $grouputil_groupes = array ();
    foreach ($post['ed_groupe'] as $grouputil_groupe) {
      $grouputil_groupes[] = $grouputil_groupe;
    }
  }
  $base->login_grouputil_groupe_set ($_SESSION['token'], $new_gut_id, $grouputil_groupes);
  return true;  
}

function grouputil_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_intitule'])) {
    set_erreur ('ed_intitule');
  }
  if (count ($erreur))
    return false;

  global $base;
  $gut_id = $_GET['gut'];

  // Sauve les données communes
  $base->login_grouputil_update ($_SESSION['token'], $gut_id, $post['ed_intitule']);

  // Sauve les liens grouputil/portail
  if (count ($post['ed_portail'])) {
    $grouputil_portails = array ();
    foreach ($post['ed_portail'] as $grouputil_portail) {
      $grouputil_portails[] = $grouputil_portail;
    }
  }
  $base->login_grouputil_portail_set ($_SESSION['token'], $gut_id, $grouputil_portails);

  // Sauve les liens grouputil/groupe  
  if (count ($post['ed_groupe'])) {
    $grouputil_groupes = array ();
    foreach ($post['ed_groupe'] as $grouputil_groupe) {
      $grouputil_groupes[] = $grouputil_groupe;
    }
  }
  $base->login_grouputil_groupe_set ($_SESSION['token'], $gut_id, $grouputil_groupes);

  return true;
}
?>
<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer le groupe d\'utilisateurs "<?= addslashes ($grouputil['gut_nom']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>
<h1>Groupes d'utilisateurs</h1>
<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('gut_nom')); ?>
  <tr><td colspan="5" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';

if (isset ($_GET['gut'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
 } 

echo '<tr class="impair">';
echo '<td>Intitulé</td>';
echo '<td>';
echo '<input type="text" size="30" name="ed_intitule" value="'.$grouputil['gut_nom'].'"></input>'.$erreur['ed_intitule'];
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Portails</td>';
echo '<td>';
liste_portails_cb ();
echo '</td>';
echo '</tr>';

echo '<tr class="impair">';
echo '<td>Groupes d\'usagers</td>';
echo '<td>';
liste_groupes_cb ();
echo '</td>';
echo '</tr>';

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['gut'])) { 
  echo '<a href="'.url_nouveau_grouputil ().'">Ajouter un nouveau groupe</a> ';
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
