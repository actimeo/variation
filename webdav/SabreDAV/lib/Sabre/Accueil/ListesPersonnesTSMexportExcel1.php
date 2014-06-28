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
use Sabre\DAV;

/**
 * 
 */

class ListesPersonnesTSMexportExcel1 extends ListesPersonnesTSMexport {
  private $auth;
  private $base;
  private $tsmid;
  private $multsep = ';';

  function __construct ($auth, $base, $tsmid) {
    parent::__construct ($auth, $base, $tsmid);
  }

  function get () {
    if ($this->contents === NULL) {
      $this->getData ();
      $excel = new ExcelExport ();
      $entete = array ();      
      $code = array ();
      foreach ($this->infos as $info) {
	$entete[] = $info['champ']['cha_libelle'] ? $info['champ']['cha_libelle'] : $info['inf_libelle'];
	$code[] = $info['inf_code'];
      }
      $excel->addLine ($entete);

      foreach ($this->data as $d) {
	$line = array ();
	foreach ($this->infos as $info) {
	  //	  $t = 'Info_'.$this->type[$info['int_id']]['int_code'];
	  //	  $oInfo = new $t ($info);
	  if (isset ($d[$info['inf_code']])) { 
	    $line[] = $info['obj']->getData($d);
	  } else {
	    $line[] = implode ($this->multsep, $info['obj']->getData($d));
	  }
	}
	$excel->addLine ($line);
      }

      $this->contents = $excel->getContents ();
      //$this->contents = print_r ($this->infos, true);
    }
    return $this->contents;
  }

  function getNamePart () {
    return "excel1.csv";
  }
}
?>
