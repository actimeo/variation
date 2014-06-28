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
class Info_contact extends Info_base {

  public function __construct ($info) {
    global $base;
    parent::__construct($info);
    $this->champs_supp = $base->liste_supp_list ($_SESSION['token'], $this->info['champ']['cha_id']);
  }

  public function fct () {
    if ($this->info['inf_multiple'])      
      return 'personne_info_integer_get_multiple';
    else
      return 'personne_info_integer_get';
  }

  // voir Base
  public function afficheHeader1 () {
    if (count ($this->champs_supp)) {
      $colspan = 1 + count ($this->champs_supp);
      echo '<th colspan="'.$colspan.'">';
      echo $this->info['champ']['cha_libelle'] ? $this->info['champ']['cha_libelle'] : $this->info['inf_libelle'];
      echo '</th>';
      return $colspan;
    } else {
      return parent::afficheHeader1 ();
    }
  }
  
  public function afficheHeader2 () {    
    if (count ($this->champs_supp)) {
      echo '<th>Nom</th>';
      foreach ($this->champs_supp as $c) {
	echo '<th>'.$c['inf_libelle'].'</th>';
      }
    } else {
      return parent::afficheHeader2 ();
    }
  }
  
  public function transformeVal ($re, $v, $class='', $rowspan='') {
    global $base;
    if ($v) {
      $per = $base->personne_get ($_SESSION['token'], $v);
      $nom_contact = $base->personne_get_libelle ($_SESSION['token'], $v);
      $v = '<span id="lienpersonne_'.$per['ent_code'].'_'.$v.'" class="lienpersonne">';
      $v .= $nom_contact;
      $v .= '</span>';
    } else {
      $v = '';
    }
    if (count ($this->champs_supp)) {
      $tdargs = ($class ? ' class="'.$class.'"' : '').($rowspan ? ' rowspan="'.$rowspan.'"' : '');
      foreach ($this->champs_supp as $c) {
	$val = $base->personne_info_varchar_get ($_SESSION['token'], $per['per_id'], $c['inf_code']);
	$v .= "</td><td".$tdargs.">".$val;
      }
    }
    return $v;
  }

  public function transformeData ($re, $v) {
    global $base;
    $per = $base->personne_get ($_SESSION['token'], $v);
    $ret = $base->personne_get_libelle ($_SESSION['token'], $v);
    if (count ($this->champs_supp)) {
      foreach ($this->champs_supp as $c) {
	$val = $base->personne_info_varchar_get ($_SESSION['token'], $per['per_id'], $c['inf_code']);
	$ret .= ">".$val;
      }
    }
    return $ret;
  }
}
?>
