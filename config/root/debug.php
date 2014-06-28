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
<h1>Debug</h1>
<ul>
<?php
$infos_utilises = $base->meta_info_liste ($_SESSION['token'], NULL, true, NULL);
$infos = $base->meta_info_liste ($_SESSION['token'], NULL, NULL, NULL);
$champs_supp = $base->liste_supp_list($_SESSION['token'], NULL);

/********************************************************************/
echo '<li><strong>Champs multiples et historisés utilisés dans l\'interface&nbsp;: </strong>';
$err = array ();
foreach ($infos_utilises as $info) {
  if ($info['inf_multiple'] && $info['inf_historique']) {
    $err[] = $info;
  }
}
if (count ($err)) {
  echo '<ul>';
  foreach ($err as $info) {
    echo '<li>'.$info['inf_libelle'].' ('.$info['inf_code'].')</li>';
  }
  echo '</ul>';
} else {
  echo "OK";
}
echo '</li>';

/********************************************************************/
echo '<li><strong>Champs multiples et historisés dans la banque de champs&nbsp;: </strong>';
$err = array ();
foreach ($infos as $info) {
  if ($info['inf_multiple'] && $info['inf_historique']) {
    $err[] = $info;
  }
}
if (count ($err)) {
  echo '<ul>';
  foreach ($err as $info) {
    echo '<li>'.$info['inf_libelle'].' ('.$info['inf_code'].')</li>';
  }
  echo '</ul>';
} else {
  echo "OK";
}
echo '</li>';

/********************************************************************/
echo '<li><strong>Champs supplémentaires de colonne Famille/Lien de type autre que Texte&nbsp;: </strong>';
$err = array ();
foreach ($champs_supp as $supp) {
  if ($supp['int_id'] != 1) {
    $err[] = $info;
  }
}
if (count ($err)) {
  echo '<ul>';
  foreach ($err as $info) {
    echo '<li>'.$info['inf_libelle'].' ('.$info['inf_code'].')</li>';
  }
  echo '</ul>';
} else {
  echo "OK";
}
echo '</li>';

?>
</li>
</ul>