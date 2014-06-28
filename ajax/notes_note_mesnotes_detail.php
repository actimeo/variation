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
$token = $_GET['prm_token'];
$nos_id = $_GET['prm_nos_id'];
if ($nos_id === 0)
  $nos_id = null;

require '../inc/config.inc.php';
require '../inc/common.inc.php';
require '../inc/enums.inc.php';
require '../inc/pgprocedures.class.php';
require 'funcs.xmlentities.php';

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if (isset ($_GET['taille'])) {
  $ret = $base->notes_note_mesnotes ($token, null, $nos_id, $base->count());
  $results = $ret;
} else {
  $notes = $base->notes_note_mesnotes ($token, null, $nos_id, $base->limit ($_GET['prm_limit'], $_GET['prm_offset']), $base->order ('not_date_evenement', 'DESC'));
  foreach ($notes as &$note) {
    $note['auteur'] = $base->utilisateur_prenon_nom ($token, $note['uti_id_auteur']);
    $note['usagers'] = implode (', ', array_map (function ($e) { return $e['libelle']; }, 
						 $base->note_usagers_liste ($token, $note['not_id'])));
  }
  
  //  print_r ($notes);
  $results = $notes;
}


header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');
echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<results>';
if (is_array ($results) && isset ($results[0])) {
  foreach ($results as $result) {
    echo '<result>';
    foreach ($result as $key => $val) {
      if ($val === true)
	echo "<$key>".$val."</$key>";
      else
	echo "<$key>".xmlentities ($val)."</$key>";
    }
    echo '</result>';  
  }
 } else {
  if (is_array ($results)) {
    echo '<result>';
    foreach ($results as $key => $val) {
      if ($val === true)
	echo "<$key>".$val."</$key>";
      else
	echo "<$key>".xmlentities ($val)."</$key>";
    }
    echo '</result>';    
  } else {
    echo $results;
  }
 }
echo '</results>';
?>
