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

$etys_tous = $base->events_event_type_list ($_SESSION['token'], $_POST['eca_id'], $_POST['sec_id'] ? array ($_POST['sec_id']) : NULL, NULL);

if ($_POST['enreg']) {
  foreach ($_POST['ety'] as $ety => $b) {
    $base->events_event_type_etablissement_set ($_SESSION['token'], $ety, $_SESSION['eta_id'], $b == 'on');
  }
}
?>
<h1>Fonctionnement événementiel</h1>
<form method="post" action="<?= $_SERVER['REQUEST_URI'] ?>">

<select name="eca_id">
<option value="">(sélectionner une catégorie)</option>
<?php liste_categories ($_POST['eca_id']); ?>
</select>

<select name="sec_id">
<option value="">(toutes thématiques)</option>
<?php liste_secteurs ($_POST['sec_id']); ?>
</select>
<button type="submit">OK</button>


<table class="t1" width="100%">
<tr><th>Type</th><th>Thématiques</th><th>Utiliser</th>
<?php affiche_types (); ?>
</table>
<div style="text-align: right"><input type="submit" name="enreg" value="Enregistrer"></input></div>
</form>

<?php
function liste_categories ($eca_id) {
  global $base;
  $ecas = $base->events_events_categorie_list ($_SESSION['token']);
  foreach ($ecas as $eca) {
    $selected = $eca['eca_id'] == $eca_id ? ' selected' : '';
    echo '<option value="'.$eca['eca_id'].'"'.$selected.'>'.$eca['eca_nom'].'</option>';
  }
}

function liste_secteurs ($sec_id) {
  global $base;
  $secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  foreach ($secs as $sec) {
    $selected = $sec['sec_id'] == $sec_id ? ' selected' : '';
    echo '<option value="'.$sec['sec_id'].'"'.$selected.'>'.$sec['sec_nom'].'</option>';
  }
}

function affiche_types () {
  global $etys_tous, $base;
  $impair = true;
  foreach ($etys_tous as $ety) {
    $secs = $base->events_event_type_secteur_list ($_SESSION['token'], $ety['ety_id'], $base->order ('sec_nom'));
    $sec_noms = array ();
    foreach ($secs as $sec) {
      $sec_noms[] = $sec['sec_nom'];
    }
    $ete = $base->events_event_type_etablissement_get ($_SESSION['token'], $ety['ety_id'], $_SESSION['eta_id']);
    echo '<tr class="'.($impair ? 'impair' : 'pair').'"><td>'.$ety['ety_intitule'].'</td><td>'.implode (', ', $sec_noms).'</td><td align="center"><input name="ety['.$ety['ety_id'].']" type="hidden" value="off"></input><input name="ety['.$ety['ety_id'].']" type="checkbox"'.($ete ? ' checked' : '').'></input></td>';
    $impair = !$impair;
  }
}
?>
