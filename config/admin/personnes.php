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
<h1>Personnes</h1>
 <?php
if (isset ($_GET['add'])) {
  $base->personne_ajoute ($_SESSION['token'], $_GET['add']);
  header('Location: /admin.php');
  exit;
}

if (isset ($_GET['del'])) {
  $base->personne_supprime ($_SESSION['token'], $_GET['del']);
  header('Location: /admin.php');
  exit;
}

$entites = $base->meta_entite_liste ($_SESSION['token']);

foreach ($entites as $entite) {
  echo '<h1>'.$entite['ent_libelle'].'</h1>';
  $pers = $base->personne_liste ($_SESSION['token'], $entite['ent_code']);
  echo '<ul>';
  if (count ($pers)) {
    foreach ($pers as $per) {
      $parts = array ();
      foreach ($reperes[$entite['ent_code']] as $repere) {      
	$parts[] = $base->personne_info_varchar_get ($_SESSION['token'], $per, $repere);
      }
      $repere = implode ('&nbsp;', $parts);
      echo '<li><span id="lienpersonne_'.$entite['ent_code']."_".$per.'" class="lienpersonne">&nbsp;'.$repere.'&nbsp;</span> <a href="?del='.$per.'">(supprimer)</a></li>';
    }
  }
  echo '<li><a href="?add='.$entite['ent_code'].'">Ajouter</a></li>';
  echo '</ul>';
}
?>
