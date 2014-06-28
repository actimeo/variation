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
class Info_famille extends Info_base {
  private $champs_supp = NULL;

  public function __construct ($info) {
    global $base;
    parent::__construct($info);
    $this->champs_supp = $base->liste_supp_list ($_SESSION['token'], $this->info['champ']['cha_id']);
  }

  public function afficheHeader1 () {
    $details = $this->info['champ']['cha__famille_details'];
    $rowspan = ($details || count($this->champs_supp)) ? '' : ' rowspan="2" ';
    $colspan = $details ? 4 : 1;
    $colspan += count($this->champs_supp);
    echo '<th '.$rowspan.'colspan="'.$colspan.'">';
    echo $this->info['champ']['cha_libelle'] ? $this->info['champ']['cha_libelle'] : $this->info['inf_libelle'];
    echo '</th>';
    return $colspan;
  }

  public function afficheHeader2 () {
    $details = $this->info['champ']['cha__famille_details'];
    if ($details || count ($this->champs_supp)) {
      echo '<th>Nom</th>';
    }
    if ($details) {
      echo '<th>Autorité</th>';
      echo '<th>Droits</th>';
      echo '<th>Périodicité</th>';
    }
    if (count ($this->champs_supp)) {
      foreach ($this->champs_supp as $c) {
	echo '<th>'.$c['inf_libelle'].'</th>';
      }
    }
  }

  public function fct () {
    return 'personne_info_lien_familial_get_multiple';
  }

  public function transformeVal ($re, $v, $class='', $rowspan='') {
    global $base, $droits_parent;
    $tdargs = ($class ? ' class="'.$class.'"' : '').($rowspan ? ' rowspan="'.$rowspan.'"' : '');
    if (!$v) {
      $ret = '';
      if ($this->info['champ']['cha__famille_details']) {
	$ret .= '</td><td'.$tdargs.'></td><td'.$tdargs.'></td><td'.$tdargs.'>';
      }
      if (count ($this->champs_supp)) {
	foreach ($this->champs_supp as $c) {
	  $ret .= '<td'.$tdargs.'></td>';
	}
      }
      return $ret;
    }
    $per = $base->personne_get ($_SESSION['token'], $v['per_id_parent']);
    $nom_contact = $base->personne_get_libelle ($_SESSION['token'], $v['per_id_parent']);
    $lf = $base->meta_lien_familial_get ($_SESSION['token'], $v['lfa_id']);
    $ret = '<span id="lienpersonne_'.$per['ent_code'].'_'.$v['per_id_parent'].'" class="lienpersonne">';
    $ret .= $nom_contact.' ('.$lf['lfa_nom'].')';
    $ret .= '</span>';

    if ($this->info['champ']['cha__famille_details']) {
      $ret .= '</td><td'.$tdargs.'>'.($v['pif_autorite_parentale'] == "1" ? 'Parentale' : ($v['pif_autorite_parentale'] == "2" ? 'Tutelle' : 'Aucune')).'</td><td'.$tdargs.'>'.$droits_parent[$v['pif_droits']].'</td><td'.$tdargs.'>'.$v['pif_periodicite'];
    }

    if (count ($this->champs_supp)) {
      foreach ($this->champs_supp as $c) {
	$val = $base->personne_info_varchar_get ($_SESSION['token'], $v['per_id_parent'], $c['inf_code']);
	$ret .= '<td'.$tdargs.'>'.$val.'</td>';
      }
    }
    return $ret;
  }

  public function transformeData ($re, $v) {
    global $base, $droits_parent;
    if (!$v) {
      if ($this->info['champ']['cha__famille_details']) {
	return "\n";
      } else {
	return;
      }
    }
    $per = $base->personne_get ($_SESSION['token'], $v['per_id_parent']);
    $nom_contact = $base->personne_get_libelle ($_SESSION['token'], $v['per_id_parent']);
    $lf = $base->meta_lien_familial_get ($_SESSION['token'], $v['lfa_id']);
    $ret .= $nom_contact.' ('.$lf['lfa_nom'].')';

    if ($this->info['champ']['cha__famille_details']) {
      $ret .= '>'.($v['pif_autorite_parentale'] == "1" ? 'Parentale' : ($v['pif_autorite_parentale'] == "2" ? 'Tutelle' : 'Aucune')).'>'.$droits_parent[$v['pif_droits']].'>'.$v['pif_periodicite'];
    }
    if (count ($this->champs_supp)) {
      foreach ($this->champs_supp as $c) {
	$val = $base->personne_info_varchar_get ($_SESSION['token'], $v['per_id_parent'], $c['inf_code']);
	$ret .= '>'.$val;
      }
    }
    return $ret;
  }

  public function save4new($per_id, $v) {
    global $base;
    $base->personne_info_lien_familial_set ($_SESSION['token'], $v['usager'], $this->info['inf_code'], $per_id, $v['lfa_id'], NULL, NULL, NULL);
  }
}
?>
