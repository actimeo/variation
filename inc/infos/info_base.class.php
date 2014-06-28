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
class Info_base {
  var $info;
  var $val;

  protected $stats = false;
  
  public function __construct ($info) {
    $this->info = $info;
    $this->val = array ();
  }
  public function rettype () {
    return 'varchar';
  }

  public function afficheHeader1 () {
    global $sortsort, $sortcol;
      echo '<th rowspan="2">';
      if (!$this->info['inf_multiple'] && (!isset ($_GET['export']) || $_GET['export'] != 1) && (!isset ($_GET['print']) || $_GET['print'] != 1))
	echo '<a href="'.link_sort ($this->info['inf_code']).'">';
      echo $this->info['champ']['cha_libelle'] ? $this->info['champ']['cha_libelle'] : $this->info['inf_libelle'];
      if (!$this->info['inf_multiple'] && (!isset ($_GET['export']) || $_GET['export'] != 1) && (!isset ($_GET['print']) || $_GET['print'] != 1)) {
	if ($this->info['inf_code'] == $sortcol) {
	  if ($sortsort == 'ASC')
	    echo '<img src="/Images/navig/Asc.gif"></img>';
	  else
	    echo '<img src="/Images/navig/Desc.gif"></img>';	  
	}
	echo '</a>';

	if ($this->stats) {
	  echo '<br><a href="'.link_stat ($this->info['inf_code']).'"><img src="'.$this->staticon.'" alt="stats"></img></a>';
	}
      }
      echo '</th>';    
      return 1;
  }

  public function afficheHeader2 () {
    // Do nothing
  }

  public function afficheHeader1Inverse () {
      echo '<th colspan="2">';
      echo $this->info['champ']['cha_libelle'] ? $this->info['champ']['cha_libelle'] : $this->info['inf_libelle'];
      echo '</th>';    
  }
  public function afficheHeader2Inverse () {
    // Do nothing
  }

  public function afficheData ($re, $ppcm, $i, $class) {
    global $base;
    $val = '';
    if ($this->info['inf_multiple']) {
      $nbValeurs = $this->nbValeurs ($re);
      if ($nbValeurs == 0)
	$nbValeurs = 1;
      $rowspan = $ppcm / $nbValeurs;
      if ($i % $rowspan > 0)
	return;
      if (isset ($this->val[$re['per_id']])) {
	$vals = $this->val[$re['per_id']];
      } else {
	$this->val[$re['per_id']] = $base->__call ($this->fct(), array ($_SESSION['token'], $re['per_id'], $this->info['inf_code']));
	if ($this->val[$re['per_id']] === NULL)
	  $this->val[$re['per_id']] = '';
	$vals = $this->val[$re['per_id']];
      }
      $v = $vals[$i / $rowspan];
      $val = $this->transformeVal ($re, $v, $class, $rowspan);
      $val = '<td class="'.$class.'" rowspan="'.$rowspan.'">'.$val.'</td>';
    } else { // !multiple
      if ($i == 0) {
	$val = $base->cast_value ($this->rettype(), $re[$this->info['inf_code']]);	  
	$val = $this->transformeVal ($re, $val, $class, $rowspan);
	$val = '<td class="'.$class.'" rowspan="'.$ppcm.'">'.$val.'</td>';
      }
    }
    echo $val;
  }

  public function getData ($re) {
    global $base;
    if ($this->info['inf_multiple']) {
      $val = array ();
      $vals = $base->__call ($this->fct(), array ($_SESSION['token'], $re['per_id'], $this->info['inf_code']));
      foreach ($vals as $v) {
	$val[] = $this->transformeData ($re, $v);
      }
    } else { // !multiple
      $val = $base->cast_value ($this->rettype(), $re[$this->info['inf_code']]);	  
      $val = $this->transformeData ($re, $val);      
    }
    return $val;
  }

  public function afficheDataInverse ($re) {
    global $base;
    $val = $base->cast_value ($this->rettype(), $re[$this->info['inf_code']]);	  
    $val = $this->transformeVal ($re, $val);
    $val = '<td>'.$val.'</td>';
    echo $val;
  }

  public function transformeVal ($re, $val) {
    $val = $this->ajouteLienNom ($re, $val);
    return $val;
  }

  public function transformeData ($re, $val) {
    return $val;
  }

  public function ajouteLienNom ($re, $val) {
    // Do nothing
    return $val;
  }

  public function nbValeurs ($re) {
    global  $base;
    if ($this->info['inf_multiple']) {
      if (isset ($this->val[$re['per_id']])) {
	return count ($this->val[$re['per_id']]);
      } else {
	$ret = $base->__call ($this->fct(), array ($_SESSION['token'], $re['per_id'], $this->info['inf_code']));
	$this->val[$re['per_id']] = $ret === NULL ? '' : $ret;
	return count ($this->val[$re['per_id']]);
      }
    } else { // !multiple
      return 1;
    }
  }

  public function save4new($per_id, $v) { }
}
?>
