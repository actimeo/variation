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
// Dialogue de création d'un nouvel établissement, appelé à partir de la gestion des groupes 
// par le personnel
require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$secteurs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
?>
<table width="370" class="t1">
  <tr><th colspan="2">Ajouter</th></tr>
  <tr class="impair">
    <td>Intitulé</td>
    <td><input type="text" size="35" id="dlg_ed_intitule"></input>
      <img id="dlg_ed_erreur_intitule" src="/Images/icons/exclamation-small.gif" height="20" align="top"></img>
    </td>
  </tr>
  <tr class="pair">
    <td>Thématiques</td>
    <td><div id="dlg_ed_secteurs"><?php liste_secteurs_cb () ;?></div></td>
  </tr>
</table>


</body>
</html>
<?php
function liste_secteurs_cb () {
  global $base, $secteurs;
  foreach ($secteurs as $secteur) {
    
    $plus = ($secteur['sec_id'] == $_GET['s']) ? ' checked disabled' : '';
    echo '<nobr><input class="ed_secteur_cb" type="checkbox" id="dlg_ed_secteur_'.$secteur['sec_code'].'"'.$plus.'></input><label for="dlg_ed_secteur_'.$secteur['sec_code'].'">'.$secteur['sec_nom'].'</label></nobr> ';
  }
}
?>
