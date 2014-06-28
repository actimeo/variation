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
$pagination->setFunction ('procedure_procedure_details', array ($_SESSION['token']));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Titre', 'pro_titre', 'lien_edit_procedure', 'pro_id');
$pagination->addColumn ('Nb', 'n_affectations');
$pagination->setLines (15);

/* Gestion de l'édition des procédures, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (procedure_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if (isset ($_POST['ed_ajout'])) {
  if (procedure_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
} else if ($_POST['ed_suppr'] == '1') {
  $base->procedure_procedure_supprime ($_SESSION['token'], $_GET['pro']);
  header ('Location: '.url_nouvelle_procedure ());
  exit;
}

if (isset ($_GET['pro'])) {
  $pro_id = (int)$_GET['pro'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs
    $procedure['pro_id'] = $pro_id;
    $procedure['pro_titre'] = $_POST['ed_pro_titre'];
    $procedure['pro_contenu'] = $_POST['ed_pro_contenu'];
    $procedure_affectations = array ();
    if (count ($_POST['ed_affectation'])) {
      foreach ($_POST['ed_affectation'] as $s) {
	$procedure_affectations[] = array ('pro_id' => $s);
      }
    }
  } else {    
    $procedure = $base->procedure_procedure_get ($_SESSION['token'], $_GET['pro']);
    $procedure_affectations = $base->procedure_procedure_affectation_liste ($_SESSION['token'], $procedure['pro_id']);
  }
} else {
  if (count ($erreur)) {
    $procedure['pro_titre'] = $_POST['ed_pro_titre'];
    $procedure['pro_contenu'] = $_POST['pro_contenu'];
  } else {
    $procedure = array ();
  }
}

function procedure_save ($post) {
  global $base, $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_pro_titre'])) {
    set_erreur ('ed_pro_titre');
  }
  if (count ($erreur))
    return false;
  $base->procedure_procedure_update ($_SESSION['token'], $_GET['pro'], $post['ed_pro_titre'], $post['ed_pro_contenu']);
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}
?>
<script type="text/javascript" src="jquery/jstree/jquery.jstree.js"></script>
<script type="text/javascript" src="/jquery/ficheselect/jquery.ficheselect.js"></script>
<link href="/jquery/ficheselect/jquery.ficheselect.css" rel="stylesheet" type="text/css" />
<script src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript">
  $(document).ready (function () {
      CKEDITOR.replace ('ed_pro_contenu');
      $("#ed_suppr").click (on_ed_suppr_click);
      
      $(".paf span").click (function () { return false; });
      
      $(".paf").click (on_paf_click);
      $("#paf_add").click (on_paf_add_click);
    });

function on_paf_click () {
  if (confirm ('Supprimer l\'affectation de la procédure à la fiche\n"'+$(this).text()+'" ?')) {
    var paf_id = $(this).attr('id').substr (4);
    $.post('/ajax/edit/procedure_procedure_affectation_supprime.php', { prm_token: $("#token").val(), prm_paf_id: paf_id }, function () {
	location.reload ();
      });
  }
}

function on_paf_add_click () {
  $("#dlg").ficheSelect ({
    por: <?php echo $portail['por_id'] ?>,
      return: function (id) {
      var parts = id.split('_');
      var table = parts[0];
      var theid = parts[1];
      var tsm_id = (table == 'tsm') ? theid : '';
      var sme_id = (table == 'sme') ? theid : '';
      $.post ('/ajax/edit/procedure_procedure_affectation_ajoute.php', { 
	prm_token: $("#token").val(),
	prm_pro_id: <?php echo $_GET['pro'] ?>,	  
	  prm_tsm_id: tsm_id,
	  prm_sme_id: sme_id
	  }, function (data) {
	  location.reload ();
	});
      }
    });
}

function on_ed_suppr_click () {
    if (confirm ('Supprimer la procédure "<?= addslashes ($procedure['pro_titre']) ?>" ?')) {
	$("#ed_suppr_hidden").val('1');
	$("#ed_form").submit();
    } else {
	return false;
    }	
}
</script>
<h1>Procédures</h1>

<table width="300" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('pro_titre', 'n_affectations')); ?>
  <tr><td colspan="5" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>

<?php
function url_nouvelle_procedure () {
  // Enleve l'argument pro
  parse_str (substr ($_SERVER['REQUEST_URI'], strlen ('/admin.php?')), $args);
  unset ($args['pro']);  
  return '/admin.php?'.$p['query'] = http_build_query ($args);
}

function lien_edit_procedure ($pro_id) {
  return array ('/admin.php', array ('pro' => $pro_id));
}

function liste_fiches ($procedure_affectations) {
  global $base;
  echo '<ul style="padding: 0; margin: 0">';
  foreach ($procedure_affectations as $procedure_affectation) {
    $s = $base->procedure_procedure_affectation_detail ($_SESSION['token'], $procedure_affectation['paf_id']);
    echo '<li class="paf" id="paf_'.$procedure_affectation['paf_id'].'"><span>'.$s.'</span></li>';
  }
  echo '</ul>';
  if (isset ($_GET['pro'])) {
    echo '<div id="paf_add">Ajouter une fiche</div>';
  }
}

echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
echo '<table class="t1" width="550" style="margin-left: 310px">';

if (isset ($_GET['pro'])) { 
  echo '<tr><th colspan="2">Éditer</th></tr>';
} else { 
  echo '<tr><th colspan="2">Ajouter</th></tr>';
} 

echo '<tr class="impair">';
echo '<td>Titre</td>';
echo '<td>';
echo '<input type="text" name="ed_pro_titre" size="30" value="'.$procedure['pro_titre'].'"></input>';
echo $erreur['ed_pro_titre'];
echo '</td>';
echo '</tr>';

echo '<tr class="pair">';
echo '<td>Fiches</td>';
echo '<td>';
liste_fiches ($procedure_affectations);
echo '</td>';
echo '</tr>';

echo '<tr class="impair">';
echo '<td colspan="2">';
echo '<textarea cols="73" rows="20" name="ed_pro_contenu">'.$procedure['pro_contenu'].'</textarea>';
echo '</td>';
echo '</tr>';

echo '<tr><td class="navigtd" align="right" colspan="2">';
if (isset ($_GET['pro'])) { 
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
