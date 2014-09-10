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
require ('../../inc/config.inc.php');
require ('../../inc/common.inc.php');
require ('../../inc/pgprocedures.class.php');

if (!$_SESSION['uti_root'])
  exit;

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if ($_POST['inf_id'] != 0) {
  $base->meta_info_update ($_SESSION['token'],
			   $_POST['inf_id'], 
			   $_POST['int_id'],
			   $_POST['inf_code'],
			   $_POST['inf_libelle'],
			   $_POST['inf_libelle_complet'],
			   $_POST['inf_etendu'] == 'checked',
			   $_POST['inf_historique'] == 'checked',
			   $_POST['inf_multiple'] == 'checked');
  $inf_id = $_POST['inf_id'];
} else {
  $inf_id = $base->meta_info_add ($_SESSION['token'],
				  $_POST['int_id'],
				  $_POST['inf_code'],
				  $_POST['inf_libelle'],
				  $_POST['inf_libelle_complet'],
				  $_POST['inf_etendu'] == 'checked',
				  $_POST['inf_historique'] == 'checked',
				  $_POST['inf_multiple'] == 'checked');
  if (!$inf_id) {
    echo 'ERR';
    exit;
  }
  $base->meta_info_move ($_SESSION['token'], $inf_id, substr ($_POST['dirid'], 4));
}

$base->meta_info_aide_set ($_SESSION['token'], $inf_id, $_POST['ina_aide']);

$types = $base->meta_infos_type_liste ($_SESSION['token']);
foreach ($types as $type) {
  $thetypes[$type['int_id']] = $type;
}

switch ($thetypes[$_POST['int_id']]['int_code']) {
  case 'contact':
    $base->meta_infos_contact_update ($_SESSION['token'],
				      $inf_id, 
				      $_POST['inf__contact_filtre'],
				      $_POST['inf__contact_secteur']
				      );
    break;
  case 'etablissement':
    $base->meta_infos_etablissement_update ($_SESSION['token'],
					    $inf_id,
					    $_POST['inf__etablissement_interne'] == 'checked',
					    $_POST['inf__etablissement_secteur']
					    );
    break;
  case 'groupe':
    $base->meta_infos_groupe_update ($_SESSION['token'],
				     $inf_id,
				     $_POST['inf__groupe_type'],
				     $_POST['inf__groupe_soustype']);
    break;
  case 'metier':
    $base->meta_infos_metier_update ($_SESSION['token'],
				     $inf_id,
				     $_POST['inf__metier_secteur']);
    break;
  case 'selection':
    $base->meta_infos_selection_update ($_SESSION['token'],
					$inf_id,
					$_POST['inf__selection_code']);
    break;
  case 'textelong':
    $base->meta_infos_textelong_update ($_SESSION['token'],
					$inf_id,
					$_POST['inf__textelong_nblignes']);
    break;
  case 'date':
    $base->meta_infos_date_update ($_SESSION['token'],
				   $inf_id,
				   $_POST['inf__date_echeance']  == 'checked',
				   $_POST['inf__date_echeance_icone'],
				   $_POST['inf__date_echeance_secteur']
				   );
    break;
  case 'date_calcule':
  case 'coche_calcule':
    $base->meta_infos_formule_update ($_SESSION['token'],
				      $inf_id,
				      $_POST['inf_formule']				      
				      );
    break;
}
?>
