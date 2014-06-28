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
require ('../../inc/enums.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$lis_id = $_GET['lis_id'];

$ret = $base->liste_champ_liste_details ($_SESSION['token'], $lis_id);

foreach ($ret as $k => $re) {
  $supp = $base->liste_supp_list ($_SESSION['token'], $re['cha_id']);
  $d = $base->liste_defaut_liste ($_SESSION['token'], $re['cha_id']);
  switch ($re['int_code']) {
  case 'texte':
    break;
  case 'selection':
    foreach ($d as $k2 => $def) {      
      $sen = $base->meta_selection_entree_get ($_SESSION['token'], $def['def_valeur_int']);
      $d[$k2]['def_valeur_selection'] = $sen['sen_libelle'];
    }
    break;
  case 'statut_usager':
    foreach ($d as $k2 => $def) {
      $d[$k2]['def_valeur_selection'] = $statuts_usager[$def['def_valeur_int']];
    }
    break;
  case 'metier':
    foreach ($d as $k2 => $def) {
      $sen = $base->meta_secteur_get ($_SESSION['token'], $def['def_valeur_int']);
      $d[$k2]['def_valeur_selection'] = $sen['sec_nom'];
    }
    break;
  case 'groupe':
    foreach ($d as $k2 => $def) {      
      $eta = $base->etablissement_get ($_SESSION['token'], $def['def_valeur_int']);
      $grp = $base->groupe_get ($_SESSION['token'], $def['def_valeur_int2']);
      $d[$k2]['def_valeur_groupe'] = $eta['eta_nom'].'<br>'.$grp['grp_nom'];
    }
    break;
  }
  $ret[$k]['defauts'] = $d;
  $ret[$k]['supp'] = $supp;
}

echo json_encode ($ret);
?>
