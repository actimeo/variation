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
<script type="text/javascript" src="jquery/iconeselect/jquery.iconeselect.js"></script>
<link href="/jquery/iconeselect/jquery.iconeselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
    $(document).ready (function () {
        $("#sme_icone_change").click (function () {
            $("#dlg").iconeSelect ({
              'return': function (path) {
                  $("#sme_icone_img").attr ('src', '/'+path);
                  $("#sme_icone").val ('/'+path);
                }
              });
          });
        
        var sme_icone=$("#sme_icone").val ();
        if (sme_icone!='') {
          $("#sme_icone_img").attr ("src", sme_icone);
        } else {
          $("#sme_icone_img").attr ('src', '');
        }
        $('.t1 tr td:nth-child(3)').each(function(){
            pathImage = $(this).text();
            pathImage = pathImage.replace('%d','24');
            pathImage = pathImage.replace('%d','24');
            $(this).html('<img src="'+pathImage+'" alt="'+pathImage+'"/>');
        });        
    });
</script>
<h1>Thématiques d'ensemble</h1>
<?php
include ("inc/pagination.php");

/* Tableau de gauche, paginé */
$pagination = new Pagination ($base);
$pagination->setImagesPath ('/Images/navig');
$pagination->setDefaultColOrder (1);
$pagination->setFunction ('meta_secteur_liste', array ($_SESSION['token'], NULL));
$pagination->setUrl ('/admin.php', array ());
$pagination->addColumn ('Code', 'sec_code', 'lien_edit_secteur', 'sec_id');
$pagination->addColumn ('Libellé', 'sec_nom');
$pagination->addColumn('Icone', 'sec_icone');
$pagination->setLines (40);

/* Gestion de l'édition des secteurs, à droite */
if (isset ($_POST['ed_enreg'])) {
  if (secteur_save ($_POST)) {
    header ('Location: '.$_SERVER['REQUEST_URI']);
    exit;
  }
}

if (isset ($_GET['sec'])) {
  $sec_id = (int)$_GET['sec'];
  if (count ($erreur)) {
    // Si on enregistre et qu'il y a des erreurs
    $secteur['sec_code'] = $_POST['ed_code'];
    $secteur['sec_nom'] = $_POST['ed_nom'];
    $secteur['sec_icone'] = $_POST['ed_icone'];
  } else {    
    $secteur = $base->meta_secteur_get ($_SESSION['token'], $sec_id);
  }
}
//print_r ($secteur);

?>
<table width="470" class="t1" style="float: left">
  <?php $pagination->displayHeader (); ?>
  <?php $pagination->displayData (array ('sec_code', 'sec_nom', 'sec_icone')); ?>
  <tr><td colspan="3" align="center" class="navigtd">
  <?php $pagination->displayPagination (); ?>
  </td></tr>
</table>


<?php
if (isset ($_GET['sec'])) { 
  echo '<form id="ed_form" method="post" action="'.$_SERVER['REQUEST_URI'].'">';
  echo '<table class="t1" width="370" style="margin-left: 480px">';

  echo '<tr><th colspan="2">Éditer</th></tr>';
  echo '<tr class="impair">';
  echo '<td>Code</td>';
  echo '<td>';
  echo '<input type="hidden" name="ed_code" value="'.$secteur['sec_code'].'" />';
  echo $secteur['sec_code'];
  echo '</td>';
  echo '</tr>';
  
  echo '<tr class="pair">';
  echo '<td>Libellé</td>';
  echo '<td>';
  echo '<input type="text" name="ed_nom" size="30" value="'.$secteur['sec_nom'].'" />'.$erreur['ed_nom'];
  echo '</td>';
  echo '</tr>';
  
  echo '<tr class="impair">';
  echo '<td>Icone</td>';
  echo '<td>';
  $secteur['sec_icone']=  str_replace('%d', '24', $secteur['sec_icone']);
  echo '<input type="text" size="20" id="sme_icone" name="ed_icone" value="'.$secteur['sec_icone'].'"/>';
  echo '<img src="" id="sme_icone_img" align="middle" />';
  echo '<input type="button" id="sme_icone_change" value="..." />';
  echo '</td>';
  echo '</tr>';
  
  echo '<tr><td class="navigtd" align="right" colspan="2">';
  echo '<button name="ed_enreg" type="submit">Mettre à jour</button>';
  echo '</td></tr>';

  echo '</table>';
  echo '</form>';
}
?>
<div style="clear: both"></div>


<?php
function lien_edit_secteur ($sec_id) {
  return array ('/admin.php', array ('sec' => $sec_id));
}

function secteur_save ($post) {
  global $base, $erreur;
  $erreur = array ();
  if (!strlen ($post['ed_nom'])) {
    set_erreur ('ed_nom');
  }
  if (count ($erreur))
    return false;
  if ($post['ed_icone']!=''){
      $post['ed_icone']=  str_replace('32', '%d', $post['ed_icone']);
      $post['ed_icone']=  str_replace('24', '%d', $post['ed_icone']);
  }
  $base->meta_secteur_save ($_SESSION['token'], $post['ed_code'], $post['ed_nom'], $post['ed_icone']);

  return true;
}

function set_erreur ($code) {
  global $erreur;
  $erreur[$code] = '<img src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>';
}

?>
