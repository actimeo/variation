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
class Info_date_calcule extends Info_base {
  protected $stats = true;
  protected $staticon = '/Images/IS_Real_vista_Text/originals/png/NORMAL/24/chart_24.png';

  public function rettype () {
    return 'date';
  }

  public function afficheData ($re, $ppcm, $i, $class) {
    if ($i == 0) {
      $val = $this->valeurCalculee ($re['per_id']);
      $val = '<td class="'.$class.'" rowspan="'.$ppcm.'">'.$val.'</td>';    
      echo $val;
    }
  }

  function valeurCalculee ($per_id) {
    $this->per_id = $per_id;
    // Si formule non définie, on n'affiche rien
    if (!$this->info['inf_formule'])
      return '';
    // Si une des dates en paramètre n'est pas définie, on n'affiche rien
    $matches = array ();
    preg_match_all ('/\[.*?\]/', $this->info['inf_formule'], $matches);
    if (count ($matches)) {
      foreach ($matches as $match) {
	if (!$this->replace_date_calcule_callback ($match))
	  return '';
      }
    }
    
    $calc = preg_replace_callback ('/\[.*?\]/', array ($this, 'replace_date_calcule_callback'), $this->info['inf_formule']);
    $val = date ('d/m/Y', strtotime ($calc));
    return $val;
  }

  function replace_date_calcule_callback ($match) {
    global $base;
    $code = substr ($match[0], 1, -1);
    // On considère que c'est un champ date non multiple
    $base->set_date_return_format ('Y-m-d');
    $inf = $base->personne_info_date_get ($_SESSION['token'], $this->per_id, $code);
    $base->set_date_return_format ('d/m/Y');
    return $inf;
  }
}

?>
