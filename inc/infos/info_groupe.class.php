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
class Info_groupe extends Info_base {
  public function afficheHeader1 () {
    $cycle = $this->info['champ']['cha__groupe_cycle'];
    $contact = $this->info['champ']['cha__groupe_contact'];
    $type = $this->info['inf__groupe_type'];
    $colspan = 2; // Etab + groupe
    if ($contact) {
      $colspan++;
    }
    if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
      $colspan++;
    }
    if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
      $colspan++;
    }
    if ($cycle) {
      $colspan++; // pour statut
      if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	$colspan++;
      }
      if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	$colspan++;
      }
    }
    echo '<th colspan="'.$colspan.'">';
    echo $this->info['champ']['cha_libelle'] ? $this->info['champ']['cha_libelle'] : $this->info['inf_libelle'];
    echo '</th>';
    return $contact ? ($cycle ? 8 : 5) : ($cycle ? 7 : 4);
  }

  public function afficheHeader2 () {
    $contact = $this->info['champ']['cha__groupe_contact'];    
    $cycle = $this->info['champ']['cha__groupe_cycle'];
    $type = $this->info['inf__groupe_type'];
    echo '<th>'.localise_par_code_secteur ('info_groupe_etablissement', $type).'</th>';
    echo '<th>'.localise_par_code_secteur ('info_groupe_groupe', $type).'</th>';
    if ($contact)
      echo '<th>Contact</th>';
    if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
      echo '<th>'.localise_par_code_secteur ('info_groupe_date_debut', $type).'</th>';
    }
    if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
      echo '<th>'.localise_par_code_secteur ('info_groupe_date_fin', $type).'</th>';
    }
    if ($cycle) {
      echo '<th>Statut</th>';
      if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	echo '<th>'.localise_par_code_secteur ('info_groupe_date_demande', $type).'</th>';
      }
      if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	echo '<th>'.localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type).'</th>';
      }
    }    
  }

  public function afficheData ($re, $ppcm, $i, $class) {
    global $base;
    $type = $this->info['inf__groupe_type'];
    $groupes = $base->personne_groupe_liste2 ($_SESSION['token'], $re['per_id'], $this->info['inf_id']);
    $contact = $this->info['champ']['cha__groupe_contact'];    
    $cycle = $this->info['champ']['cha__groupe_cycle'];    
    if ($this->info['champ']['cha__groupe_dernier'] || count ($groupes) < 1) {
      $val = '';
      if ($i == 0) {
	$groupe = $groupes[0];
	$val = '<td class="'.$class.'" rowspan="'.$ppcm.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'eta_nom');
	$val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'grp_nom');
	if ($contact) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'grp_id');	  
	}
	if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_debut');
	}
	if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_fin');
	}
	if ($cycle) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_statut');
	  if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	    $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande');
	  }
	  if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	    $val .= '</td><td class="'.$class.'" rowspan="'.$ppcm.'">';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande_renouvellement');
	  }
	}    
	$val .= '</td>';
      }
      echo $val;      
    } else {
      $rowspan = $ppcm / count ($groupes); 
      if (($i % $rowspan) > 0) {
	return;
      }
      $groupe = $groupes[$i/$rowspan];
      $val = '<td class="'.$class.'" rowspan="'.$rowspan.'">';
      $val .= $this->valeur_champ_groupe ($groupe, 'eta_nom');
      $val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
      $val .= $this->valeur_champ_groupe ($groupe, 'grp_nom');
      if ($contact) {
	$val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'grp_id');	  
      }
      if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
	$val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'peg_debut');
      }
      if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
	$val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'peg_fin');
      }
      if ($cycle) {
	$val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	$val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_statut');
	if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande');
	}
	if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	  $val .= '</td><td class="'.$class.'" rowspan="'.$rowspan.'">';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande_renouvellement');
	}
      }    
      $val .= '</td>';
      echo $val;
    }
  }

  public function getData ($re) {
    global $base;
    $type = $this->info['inf__groupe_type'];
    $groupes = $base->personne_groupe_liste2 ($_SESSION['token'], $re['per_id'], $this->info['inf_id']);
    $contact = $this->info['champ']['cha__groupe_contact'];    
    $cycle = $this->info['champ']['cha__groupe_cycle'];    
    if (count ($groupes) < 1)
      return array ();
    else if ($this->info['champ']['cha__groupe_dernier']) {
      $val = '';
      if ($i == 0) {
	$groupe = $groupes[0];
	$val .= $this->valeur_champ_groupe ($groupe, 'eta_nom');
	$val .= '>';
	$val .= $this->valeur_champ_groupe ($groupe, 'grp_nom');
	if ($contact) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'grp_id');	  
	}
	if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_debut');
	}
	if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_fin');
	}
	if ($cycle) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_statut');
	  if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	    $val .= '>';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande');
	  }
	  if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	    $val .= '>';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande_renouvellement');
	  }
	}    
      }
      return array ($val);      
    } else {
      $vals = array ();
      foreach ($groupes as $groupe) {
	$val = $this->valeur_champ_groupe ($groupe, 'eta_nom');
	$val .= '>';
	$val .= $this->valeur_champ_groupe ($groupe, 'grp_nom');
	if ($contact) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'grp_id');	  
	}
	if (localise_par_code_secteur ('info_groupe_date_debut', $type)) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_debut');
	}
	if (localise_par_code_secteur ('info_groupe_date_fin', $type)) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_fin');
	}
	if ($cycle) {
	  $val .= '>';
	  $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_statut');
	  if (localise_par_code_secteur ('info_groupe_date_demande', $type)) {
	    $val .= '>';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande');
	  }
	  if (localise_par_code_secteur ('info_groupe_date_demande_renouvellement', $type)) {
	    $val .= '>';
	    $val .= $this->valeur_champ_groupe ($groupe, 'peg_cycle_date_demande_renouvellement');
	  }
	}    
	$vals[] = $val;
      }
      return $vals;
    }
  }

  public function nbValeurs ($re) {
    global  $base;
    $ngroupes = $base->personne_groupe_liste2 ($_SESSION['token'], $re['per_id'], $this->info['inf_id'], $base->count());
    return $ngroupes['0']['count'];
  }

  function valeur_champ_groupe ($groupe, $code) {
    return $this->valeur_souschamp ($code, $groupe[$code]);
  }

  function valeur_souschamp ($code, $v) {
    global $base, $cycle_statuts;
    switch ($code) {
    case 'grp_id':
      $grp = $base->groupe_get ($_SESSION['token'], $v);
      $champ_contact = 'grp_'.$this->info['inf__groupe_type'].'_contact';
      $per = $base->personne_get ($_SESSION['token'], $grp[$champ_contact]);
      return '<span id="lienpersonne_'.$per['ent_code'].'_'.$grp[$champ_contact].'" class="lienpersonne">'.$base->personne_get_libelle ($_SESSION['token'], $grp[$champ_contact]).'</span>';
      break;
    case 'peg_cycle_statut':
      return $cycle_statuts[$v];
      break;
    default:
      return $v;
    }
  }
  
  public function save4new($per_id, $v) {
    global $base;
    $base->personne_groupe_ajoute ($_SESSION['token'], $per_id, $v['grp_id'], $v['depuis'], NULL, NULL, $v['statut'], NULL, NULL, NULL, NULL);
  }
}
?>
