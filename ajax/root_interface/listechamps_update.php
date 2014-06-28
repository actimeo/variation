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
header('Cache-Control: no-cache, must-revalidate');
header('Expires: Mon, 26 Jul 1997 05:00:00 GMT');
header('Content-type: application/json');

require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$last_din = $base->meta_dirinfo_dernier ($_SESSION['token']);
if (!$last_din) {
  $last_din = "0";
}
$dins = json_decode (file_get_contents ($banquechamps.'/dir/new/'.$last_din));
foreach ($dins as $din) {
  $base->meta_dirinfo_add_avec_id ($_SESSION['token'], $din->din_id, $din->din_id_parent, $din->din_libelle);
}

$last_sel = $base->meta_selection_dernier ($_SESSION['token']);
if (!$last_sel) {
  $last_sel = "0";
}
$sels = json_decode (file_get_contents ($banquechamps.'/selection/new/'.$last_sel));
foreach ($sels as $sel) {
  $base->meta_selection_add_avec_id ($_SESSION['token'], $sel->sel_id, $sel->sel_code, $sel->sel_libelle, $sel->sel_info);
  $sens = json_decode (file_get_contents ($banquechamps.'/selection/'.$sel->sel_code.'/entree'));
  foreach ($sens as $sen) {
    $base->meta_selection_entree_add ($_SESSION['token'], $sel->sel_id, $sen->sen_libelle, $sen->sen_sen_ordre);
  }
}

$last_inf = $base->meta_info_dernier ($_SESSION['token']);
if (!$last_inf) {
  $last_inf = "0";
}
$infs = json_decode (file_get_contents ($banquechamps.'/champs/new/'.$last_inf));
foreach ($infs as $inf) {
  $base->meta_info_add_avec_id ($_SESSION['token'],
				$inf->inf_id,
				$inf->int_id,
				$inf->inf_code,
				$inf->inf_libelle,
				$inf->inf__textelong_nblignes,
				$inf->inf__selection_code,
				$inf->inf_etendu,
				$inf->inf_historique,
				$inf->inf_multiple,
				$inf->inf__groupe_type,
				$inf->inf__contact_filtre,
				$inf->inf__metier_secteur,
				$inf->inf__contact_secteur,
				$inf->inf__etablissement_interne,
				$inf->din_id,
				$inf->inf__groupe_soustype,
				$inf->inf_libelle_complet,
				$inf->inf__date_echeance,
				$inf->inf__date_echeance_icone,
				$inf->inf__date_echeance_secteur,
				$inf->inf__etablissement_secteur);
  if ($inf->aide) {
    $base->meta_info_aide_set ($_SESSION['token'], $inf->inf_id, $inf->aide);
  }
}

echo count ($infs);
?>
