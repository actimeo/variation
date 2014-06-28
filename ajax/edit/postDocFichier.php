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
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$upload = '../../doc_fichiers';
if (!isset ($_GET['doc_id']) || !$_GET['doc_id'])
  exit;
if (!isset ($_FILES['file']))
  exit;
if ($_FILES['file']['error'] != 0)
  exit;

$doc_id = $_GET['doc_id'];
$f = $_FILES['file'];
$destdir = $upload.DIRECTORY_SEPARATOR.$doc_id;

@mkdir ($destdir);
foreach (scandir($destdir) as $item) {
  if ($item == '.' || $item == '..') 
    continue;
  unlink($destdir.DIRECTORY_SEPARATOR.$item);
}
move_uploaded_file ($_FILES['file']['tmp_name'], 
		    $upload.DIRECTORY_SEPARATOR.$doc_id.DIRECTORY_SEPARATOR.$_FILES['file']['name']);
$base->document_document_set_fichier ($_SESSION['token'], $doc_id, $_FILES['file']['name']);
?>
