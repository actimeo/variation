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


$grouputils = $base->login_grouputil_liste ($_SESSION['token']);
/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('utilisateur_liste_details_configuration', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Login', 'uti_login' , 'lien_edit_utilisateur', 'uti_id');
$pagination->addColumn ('Prénom', 'uti_prenom');
$pagination->addColumn ('Nom', 'uti_nom');
$pagination->setLines (15);

/* Gestion de l'édition des utilisateurs, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (utilisateur_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (utilisateur_add ($_POST)) {    
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->utilisateur_supprime ($_SESSION['token'], $_GET['uti']);
  header ('Location: '.url_nouvel_utilisateur ());
  exit;
} else if ($_POST['mdp_generer']) {
  $base->utilisateur_mdp_genere ($_SESSION['token'], $_GET['uti']);
  header ('Location: '.$_SERVER['REQUEST_URI']);
}

if (isset ($_GET['uti'])) {
  $uti_id = (int)$_GET['uti'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs 
    $util['uti_id'] = $uti_id;
    $util['uti_login'] = $_POST['ed_login'];
    $util['uti_nom_prenom'] = $_POST['ed_nom_prenom'];
    $util['per_id'] = $_POST['ed_per_id'];
    $util['uti_config'] = $_POST['ed_uti_config'];
    $util['uti_root'] = $_POST['ed_uti_root'];

    $util_grouputils = array ();
    if (count ($_POST['ed_grouputil'])) {
      foreach ($_POST['ed_grouputil'] as $s) {
	$util_grouputils[] = array ('gut_id' => $s);
      }
    }
  } else {    
    $util = $base->utilisateur_get ($_SESSION['token'], $uti_id);
    $util['uti_nom_prenom'] = $base->personne_info_varchar_get ($_SESSION['token'], $util['per_id'], 'nom').' '.$base->personne_info_varchar_get ($_SESSION['token'], $util['per_id'], 'prenom');
    $util_grouputils = $base->utilisateur_grouputil_liste ($_SESSION['token'], $uti_id);
  }
} else {
  if (count ($erreur)) {
    $util['uti_id'] = $uti_id;
    $util['uti_login'] = $_POST['ed_login'];
    $util['uti_nom_prenom'] = $_POST['ed_nom_prenom'];
    $util['per_id'] = $_POST['ed_per_id'];
    $util['uti_config'] = $_POST['ed_uti_config'];
    $util['uti_root'] = $_POST['ed_uti_root'];

    $util_grouputils = array ();
    if (count ($_POST['ed_grouputil'])) {
      foreach ($_POST['ed_grouputil'] as $s) {
	$util_grouputils[] = array ('gut_id' => $s);
      }
    }
  } else {
    $util = array ();
  }
}


function lien_edit_utilisateur ($uti_id) {
  return array ('/admin.php', array ('uti' => $uti_id));
}

function url_nouvel_utilisateur () {
  // Enleve l'argument uti
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ("/admin.php?")), $args);
  unset ($args['uti']);  
  return '/admin.php?'.$p['query'] = http_build_query ($args);
}

function liste_grouputils_cb () {
  global $util_grouputils, $grouputils;
  foreach ($grouputils as $grouputil) {
    $checked = false;
    if (count ($util_grouputils)) {
      foreach ($util_grouputils as $util_grouputil) {
	if ($util_grouputil['gut_id'] == $grouputil['gut_id']) {
	  $checked = true;
	}
      }
    }
    echo '<nobr><input class="ed_grouputil_cb" type="checkbox" id="ed_grouputil_'.$grouputil['gut_id'].'" name="ed_grouputil[]" value="'.$grouputil['gut_id'].'"'.($checked ? ' checked' : '').'></input><label for="ed_grouputil_'.$grouputil['gut_id'].'">'.$grouputil['gut_nom'].'</label></nobr><br> ';
  }
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

function utilisateur_add ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_login'])) {
    set_erreur ('ed_login');
  }
  if (!strlen ($post['ed_per_id'])) {
    set_erreur ('ed_per_id');
  }
  if (count ($erreur))
    return false;
  
  global $base;

  // Crée un nouvel utilisateur
  $new_uti_id = $base->utilisateur_add ($_SESSION['token'], $post['ed_login'], $post['ed_per_id'], 
					$post['ed_uti_config'], $post['ed_uti_root']);

  // Sauve les liens utilisateur/grouputil
  if (count ($post['ed_grouputil'])) {
    $util_grouputils = array ();
    foreach ($post['ed_grouputil'] as $util_grouputil) {
      $util_grouputils[] = $util_grouputil;
    }
  }
  $base->utilisateur_grouputil_set ($_SESSION['token'], $new_uti_id, $util_grouputils);

  return true;  
}

function utilisateur_save ($post) {
  global $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_login'])) {
    set_erreur ('ed_login');
  }
  if (!strlen ($post['ed_per_id'])) {
    set_erreur ('ed_per_id');
  }
  if (count ($erreur))
    return false;

  global $base;
  $uti_id = $_GET['uti'];

  // Sauve les données communes
  $base->utilisateur_update ($_SESSION['token'], 
			     $uti_id, $post['ed_login'], $post['ed_per_id'],
			     $post['ed_uti_config'], $post['ed_uti_root']);

  // Sauve les liens utilisateur/grouputil
  if (count ($post['ed_grouputil'])) {
    $util_grouputils = array ();
    foreach ($post['ed_grouputil'] as $util_grouputil) {
      $util_grouputils[] = $util_grouputil;
    }
  }
  $base->utilisateur_grouputil_set ($_SESSION['token'], $uti_id, $util_grouputils);

  return true;
}
?>
<script type="text/javascript" src="/jquery/participantselect/jquery.participantselect.js"></script>
<link href="/jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready (function () {
    $("#ed_suppr").click (on_ed_suppr_click);
    $("#ed_cherche_personnel").click (on_ed_cherche_personnel_click);
});

function on_ed_suppr_click () {
    if (confirm ('Supprimer l\'utilisateur "<?= addslashes ($util['uti_login']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}

function on_ed_cherche_personnel_click () {
    $("#participantdlg").participantSelect ({
      title: "Sélection d'un membre du personnel",
	  url: '/ajax/personne_cherche.php',
	  type: ['personnel'],
	  return: function (per_id, per_type, per_nom_prenom) {
	    $("#participantinfos").empty ().append ('<input type="hidden" name="ed_nom_prenom" value="'+per_nom_prenom+'"></input><input type="hidden" name="ed_per_id" value="'+per_id+'"></input>'+per_nom_prenom);
	}
    });
  
}
</script>
<h1>Utilisateurs</h1>
<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('uti_login', 'uti_prenom', 'uti_nom')); ?>
  <tr><td colspan="5" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="370" style="margin-left: 480px">';

if (isset ($_GET['uti'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
 } 

echo '<tr class="impair">';
echo '<td>Login</td>';
echo '<td>';
echo '<input type="text" size="30" name="ed_login" value="'.$util['uti_login'].'"></input>'.$erreur['ed_login'];
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Nom</td>';
echo '<td>';
echo '<div id="participantinfos">';
if ($util['per_id']) {
  echo '<input type="hidden" name="ed_nom_prenom" value="'.$util['uti_nom_prenom'].'"></input>';
  echo '<input type="hidden" name="ed_per_id" value="'.$util['per_id'].'"></input>';
  echo $util['uti_nom_prenom'];
}
echo $erreur['ed_per_id'];
echo '</div>';
echo '<button type="button" id="ed_cherche_personnel">...</button><div id="participantdlg"></div>';
echo '</td>';
echo '</tr>';

echo '<tr class="impair">';
echo '<td>Mot de passe provisoire</td>';
echo '<td>';
if ($util['uti_pwd']) {
  echo $util['uti_pwd'];
} else {
  echo '<input type="submit" name="mdp_generer" value="Générer un nouveau"></input>';
}
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Groupes d\'utilisateurs</td>';
echo '<td>';
liste_grouputils_cb ();
echo '</td>';
echo '</tr>';

echo '<tr class="impair">';
echo '<td>Droits de configuration</td>';
echo '<td>';
echo '<input type="checkbox" name="ed_uti_config" id="ed_uti_config"'.($util['uti_config'] ? ' checked' : '').'><label for="ed_uti_config">Établissement</label><br/>';
echo '<input type="checkbox" name="ed_uti_root" id="ed_uti_root"'.($util['uti_root'] ? ' checked' : '').'><label for="ed_uti_root">Système</label>';
echo '</td>';
echo '</tr>';

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['uti'])) { 
  echo '<a href="'.url_nouvel_utilisateur ().'">Ajouter un nouvel utilisateur</a> ';
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
