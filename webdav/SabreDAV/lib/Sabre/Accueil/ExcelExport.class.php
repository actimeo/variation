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
namespace Sabre\Accueil;

class ExcelExport {
  
  private $str;
  
  public function __contruct () {
    $this->str = '';
  }
  
  public function addLine ($cells) {
    $line = '';
    foreach ($cells as $cell) {
      $line .= '"'.str_replace ("\r", "\\r", str_replace ("\n", "\\n", str_replace ('"', '""', $cell))).'"'."\t";
    }
    $line = substr ($line, 0, -1);
    $line .= "\n";
    $this->str .= $line;
  }
  
  public function display () {
    header("Content-Type: text/csv; charset=utf16-le');"); 
    header("Content-disposition: filename=table.csv");
    echo chr (255).chr(254); // Signature UTF16-LE
    echo mb_convert_encoding ($this->str, 'UTF-16LE', 'UTF-8');
  }

  public function getContents () {
    $ret = chr (255).chr(254); // Signature UTF16-LE
    $ret .= mb_convert_encoding ($this->str, 'UTF-16LE', 'UTF-8');
    return $ret;
  }
}
?>
