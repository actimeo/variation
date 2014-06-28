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
ob_start ('ob_start_callback');
require ('inc/config.inc.php');
require ('inc/common.inc.php');
require ('inc/pgprocedures.class.php');

if (!isset ($_SESSION['uti_id']) || !$_SESSION['portail']) {
  header('Location: /login2.php');
  exit;
}

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$etab = $base->etablissement_get ($_SESSION['token'], $_SESSION['eta_id']);
$portail = $base->meta_portail_get ($_SESSION['token'], $etab['cat_id'], $_SESSION['portail']);
$dajs = $base->droit_ajout_entite_portail_liste_par_portail ($_SESSION['token'], $portail['por_id']);
foreach ($dajs as $daj) {
  $portail['por_droit_ajout_'.$daj['ent_code']] = $daj['daj_droit'];
}

$topmenus = $base->meta_topmenu_liste ($_SESSION['token'], $portail['por_id']);

// Personnes à afficher dans les onglets
$fiches = $base->lock_fiche_liste ($_SESSION['token']);
if (count ($fiches)) {
  foreach ($fiches as $k => $fiche) {
    $fiches[$k]['per_libelle'] = $base->personne_get_libelle ($_SESSION['token'], $fiche['per_id']);
    $fiches[$k]['personne'] = $base->personne_get ($_SESSION['token'], $fiche['per_id']);
  }
}

$script = null;
if (isset ($_GET['tom']) && (int)$_GET['tom'] == $_GET['tom']) {
  // Menu utilisateur
  $_SESSION['tom_id'] = $_GET['tom'];
  $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $_SESSION['tom_id']);
  header('Location: /?tsm='.$topsousmenus[0]['tsm_id']);
  exit;
} else if (isset ($_GET['tsm']) && (int)$_GET['tsm'] == $_GET['tsm']) {
  // Sous-menu utilisateur
  $_SESSION['tsm_id'] = $_GET['tsm'];
  $topsousmenu = $base->meta_topsousmenu_get ($_SESSION['token'], $_SESSION['tsm_id']);
    $_SESSION['tom_id'] = $topsousmenu['tom_id'];
  if ($topsousmenu['tsm_type']) {
    $tsm = $topsousmenu;
    $script = '/scripts/topsousmenu.php';
  }
  $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $_SESSION['tom_id']);
  $procedures = $base->procedure_liste ($_SESSION['token'], $tsm['tsm_id'], 'tsm');
} else if (isset ($_GET['boite'])) {
  $_SESSION['tom_id'] = 0;
  $script = "/scripts/boite.php";
  $page_note = true;
} else if (isset ($_GET['procedures'])) {
  $_SESSION['tom_id'] = 0;
  $script = "/scripts/procedures.php";
} else if (isset ($_GET['profil'])) {
  $_SESSION['tom_id'] = 0;
  $script = "/scripts/profil.php";
} else if (isset ($_GET['svnlog'])) {
  $_SESSION['tom_id'] = 0;
  $script = "/scripts/svnlog.php";
} else {
  // Page d'accueil
  $_SESSION['tom_id'] = $topmenus[0]['tom_id'];
  $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $_SESSION['tom_id']);
  $_SESSION['tsm_id'] = $topsousmenus[0]['tsm_id'];
  header('Location: /?tsm='.$topsousmenus[0]['tsm_id']);
  exit;
}

function affiche_topmenu_accordion () {
  global $base, $topmenus;
  echo '<div class="acctopmenu">';
  if (count ($topmenus)) {
    foreach ($topmenus as $topmenu) {
      echo '<h3>'.$topmenu['tom_libelle'].'</h3>';
      echo '<div>';
      // Sous-menu
      affiche_topsousmenu_accordion ($topmenu['tom_id']);
      echo '</div>';
    }
  }
  echo 'SUP_COL_GAUCHE';
  echo '</div>';
}

function affiche_topsousmenu_accordion ($tom_id) {
  global $base;
  $topsousmenus = $base->meta_topsousmenu_liste ($_SESSION['token'], $tom_id);
  echo '<ul class="ultopsousmenu">';
  foreach ($topsousmenus as $topsousmenu) {
    echo '<li'.($topsousmenu['tsm_id'] == $_SESSION['tsm_id'] ? ' class="selected"' : '').'><a href="/?tsm='.$topsousmenu['tsm_id'].'"><span class="icone"><img src="'.$topsousmenu['tsm_icone'].'"></img></span><span class="label">'.$topsousmenu['tsm_libelle'].'</span></a></li>';
  }
  echo '</ul>';
}

function affiche_topmenu () {
  global $page_note;
  if (!$page_note)
    return;
  echo '<div id="maintopmenu">';
  echo '<ul>';
  if ($page_note) {
    $selected = $_GET['boite'] == 'envoi' ? '' : ' class="selected"';
    echo '<li'.$selected.'><a href="?boite=reception"><span class="icone"><img src="/Images/IS_Real_vista_Mail_icons/originals/png/NORMAL/32/inbox_32.png"></img></span><span class="label">Notes reçues</span></a></li>';
    $selected = $_GET['boite'] == 'envoi' ? ' class="selected"' : '';    
    echo '<li'.$selected.'><a href="?boite=envoi"><span class="icone"><img src="/Images/IS_Real_vista_Social/originals/png/NORMAL/32/feedback_32.png"></img></span><span class="label">Notes envoyées</span></a></li>';
  }
  echo '</ul>';
  echo '</div>';
}


function affiche_boite_non_lus () {
  global $base;
  $nb = $base->notes_note_boite_reception_nombre_non_lu ($_SESSION['token']);
  if ($nb) {
    echo ' ('.$nb.')';
  }
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
	  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>VARIATION</title>
    <link href="css/default.css" rel="stylesheet" type="text/css" />
    <link href="jquery/css/theme/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="jquery/css/theme/jquery-ui-timepicker-addon.css" rel="stylesheet" type="text/css" />

    <script src="jquery/js/jquery.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery.ui.datepicker-fr.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>

    <script src='jquery/qtip/qtip.min.js' type='text/javascript'></script>

    <script src="js/index.js" type="text/javascript"></script>     
    <script src="js/all.js" type="text/javascript"></script>     
    <script type="text/javascript">
  $(document).ready (function () {
      var n = $("h3").index($(".ultopsousmenu > li.selected").parent('ul').parent('div').prev('h3'));
      $(".acctopmenu").accordion ({ icons: false, collapsible: true, autoHeight: false, animated: false});
      if (n>0) {
	$(".acctopmenu").accordion ('option', 'active', n);
      }
    });
    </script>
  </head>
  <body class="main">
    <div id="mainhead">
      <img src="/Images/logo.png"></img>
      <span id="mainetabnom"><?= $etab['eta_nom'] ?> - <?= $portail['por_libelle'] ?> - <?= $_SESSION['uti_login'] ?></span>
      <div id="mainfloatmenu">
	<ul id="topmenu">
  <li><a href="/?boite" <?php if (isset ($_GET['boite'])) { echo 'class="actif"'; } ?>>Ma boîte<?php affiche_boite_non_lus (); ?></a></li>
	  <li><a href="/?procedures" <?php if (isset ($_GET['procedures'])) { echo 'class="actif"'; } ?>>Procédures</a></li>
	  <li><a href="/?profil" <?php if (isset ($_GET['profil'])) { echo 'class="actif"'; } ?>>Mon profil</a></li>
	  <li><a href="/login2.php?quitter">Quitter</a></li>
	</ul>
      </div>
    </div>

    <div id="maintabs">
      <ul>
	<li><a href="#tab_principal">Accueil</a></li>
	<?= affiche_tabs_fiches_onglets (); ?>
      </ul>
      <div id="tab_principal" style="padding: 10px">
	<?php  include ('indexprincipal.php');?>
      </div>
      <?= affiche_tabs_fiches (); ?>
    </div>
  <div id="maincopyright"><a href="http://www.variation.fr" target="_blank">VARIATION</a> - Copyright &copy; 2012-2014 KAVARNA SARL - <a href="http://www.gnu.org/licenses/agpl-3.0.html" target="_blank">Licence GNU Affero GPL</a> - 
  <?php $rev = exec('svnversion .');
  if ($rev) {
    echo '<a href="/?svnlog">Révision '.$rev.'</a>';;
  } else {
    require 'inc/version.inc.php';
    echo "Version ".$version;
  }
?>
</div>
    <input type="hidden" id="token" value="<?= $_SESSION['token'] ?>"></input>
    <input type="hidden" id="uti_id" value="<?= $_SESSION['uti_id'] ?>"></input>
    <input type="hidden" id="tsm_id" value="<?= $_SESSION['tsm_id'] ?>"></input>
    <input type="hidden" id="eta_id" value="<?= $_SESSION['eta_id'] ?>"></input>
    <div id="dlg"></div>
    <div id="dlg2"></div>
    <div id="dlg_aide"></div>
  </body>
</html>
<?php
ob_end_flush ();

function ob_start_callback ($str) {
  $sup_col_gauche_str = function_exists ('sup_col_gauche') ? sup_col_gauche () : '';
  return str_replace ('SUP_COL_GAUCHE', $sup_col_gauche_str, $str);
}

function affiche_tabs_fiches_onglets () {
  global $fiches;
  if (count ($fiches)) {
    foreach ($fiches as $fiche) {
      echo '<li><a href="#tab_p'.$fiche['per_id'].'">'.$fiche['per_libelle'].'</a> <span class="ui-icon ui-icon-close">X</span></li>';
    }
  }
}

function affiche_tabs_fiches () {
  global $fiches;
  if (count ($fiches)) {
    foreach ($fiches as $fiche) {
      echo '<div id="tab_p'.$fiche['per_id'].'"><iframe width="1035" style="overflow-x: hidden" height="850" frameborder="0" src="/edit.php?notviewed&ent='.$fiche['personne']['ent_code'].'&per='.$fiche['per_id'].'&sme='.$fiche['sme_id'].'"></iframe></div>';
    }
  }
}
?>
