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
require ('../../inc/enums.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

require ('../../inc/infos/info.class.php');

$prm_ent_code = $_GET['type'];
$per_id = $base->personne_ajoute ($_SESSION['token'], $prm_ent_code);

$types = $base->meta_infos_type_liste ($_SESSION['token']);
$type = array ();
foreach ($types as $t) {
  $type[$t['int_id']] = $t;
}
foreach ($_POST as $k => $v) {
  $info = $base->meta_info_get_par_code ($_SESSION['token'], $k);
  $clas = 'Info_'.$type[$info['int_id']]['int_code'];
  $o = new $clas($info);
  $o->save4new ($per_id, $v);
}

echo $per_id;
?>
