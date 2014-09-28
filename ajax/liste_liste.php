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
require_once ('funcs.xmlentities.php');
require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
$_SESSION['token'] = $_GET['prm_token'];
require_once '../inc/infos/info.class.php';

$token = $_GET['prm_token'];
$lis_id = $_GET['prm_lis_id'];

$types = $base->meta_infos_type_liste ($token);
$type = array ();
foreach ($types as $t) {
  $type[$t['int_id']] = $t;
}

$lis = $base->liste_liste_get ($token, $lis_id);
$champs =  $base->liste_champ_liste ($token, $lis['lis_id']);
$infos = array ();
foreach ($champs as $champ) {
  $tmp = $base->meta_info_get ($token, $champ['inf_id']);
  $tmp['champ'] = $champ;
  $t = 'Info_'.$type[$tmp['int_id']]['int_code'];  
  $tmp['obj'] = new $t ($tmp);
  $infos[] = $tmp;
}
$entites = $base->meta_entite_liste ($token);
$entite = array ();
foreach ($entites as $e) {
  $entite[$e['ent_id']] = $e;
}

// On récupère les valeurs par défaut verrouillées
//    $this->strdebug .= "1. ".print_r ($this->infos, true)."\n";
foreach ($infos as $info) {
  if ($info['champ']['cha_verrouiller']) {
    $defauts = $base->liste_defaut_liste ($token, $info['champ']['cha_id']);
    if (count ($defauts)) {
      foreach ($defauts as $defaut) {
	if ($type[$info['int_id']]['int_code'] == 'texte') {	
	  $get['rech-'.$info['inf_code']][] = $defaut['def_valeur_texte'];
	} else if ($type[$info['int_id']]['int_code'] == 'selection') {	
	  $get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	} else if ($type[$info['int_id']]['int_code'] == 'statut_usager') {	
	  $get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	} else if ($type[$info['int_id']]['int_code'] == 'metier') {	
	  $get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	} else if ($type[$info['int_id']]['int_code'] == 'groupe') {	
	  $get['rech-'.$info['inf_code'].'-eta'][] = $defaut['def_valeur_int'];
	  $get['rech-'.$info['inf_code'].'-grp'][] = $defaut['def_valeur_int2'];
	}
      }
    }
  }
}  
//    $this->strdebug .= "2. ".print_r ($this->get, true)."\n";

$sql = 'SELECT DISTINCT per_id, ';
$sqlfiltre = '';
foreach ($infos as $info) {  
  if ($info['inf_multiple'])
    continue;
  if (get_class ($info['obj']) == 'Info_groupe')
    continue;
  $sql .= $info['obj']->fct()." (".$token.", per_id, '".pg_escape_string ($info['inf_code'])."') AS ".$info['inf_code'].", ";
      
  if (isset ($get['rech-'.$info['inf_code']]) && $get['rech-'.$info['inf_code']]) {
	if ($type[$info['int_id']]['int_code'] == 'texte') {
	  $parts = array ();
	  foreach ($get['rech-'.$info['inf_code']] as $val) {
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$token.", per_id, '".pg_escape_string ($info['inf_code'])."') ilike '%".$val."%'";
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	  
	} else if ($type[$info['int_id']]['int_code'] == 'selection' || $type[$info['int_id']]['int_code'] == 'statut_usager') {
	  $parts = array ();
	  foreach ($get['rech-'.$info['inf_code']] as $val) {
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$token.", per_id, '".pg_escape_string ($info['inf_code'])."') = ".$val;
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	} else if ($type[$info['int_id']]['int_code'] == 'metier') {
	  $parts = array ();
	  foreach ($get['rech-'.$info['inf_code']] as $val) {
	    $mets = $base->metier_secteur_metier_liste ($token, $val);
	    $metparts = array ();
	    foreach ($mets as $met) {
	      $metparts[] = $met['met_id'];
	    }
	    $mets = implode (', ', $metparts);
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$token.", per_id, '".pg_escape_string ($info['inf_code'])."') IN (".$mets.")";
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	}
      }
    }
    $sql = substr ($sql, 0, -2);
    if ($entite[$lis['ent_id']]['ent_code'] == 'usager') {
      $sql .= ' FROM personne INNER JOIN personne_groupe USING (per_id) INNER JOIN login.grouputil_groupe USING(grp_id) INNER JOIN login.utilisateur_grouputil USING(gut_id) WHERE uti_id = (SELECT uti_id FROM login.token WHERE tok_token='.$token.')';
      $sql .= " AND ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
    } else {
      $sql .= ' FROM personne';
      $sql .= " WHERE ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
    }
//echo $sql."<br>";
    $sql .= $sqlfiltre;
    $sqldebug = $sql;
    $res = $base->execute_sql ($sql);
//    $res = filtre_groupes ($res);
//    $res =filtre_multiples ($res);
if (isset ($_GET['taille']))
  $results = array ('count' => count ($res));
else
  $results = $res;

header ('Content-Type: text/xml ; charset=utf-8');
header ('Cache-Control: no-cache , private');
header ('Pragma: no-cache');
echo '<?xml version="1.0" encoding="utf-8"?>';
echo '<results>';
//print_r ($results);
if (is_array ($results) && isset ($results[0])) {
  foreach ($results as $result) {
    echo '<result>';
    foreach ($result as $key => $val) {
      if (is_numeric ($key))
	continue;
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
      if (is_numeric ($key))
	continue;
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
exit;
/*
  
function filtre_groupes ($rs) {
  foreach ($this->infos as $info) {
    if ($this->type[$info['int_id']]['int_code'] == 'groupe') {
      // Filtre sur les etabs/groupes
      $filtres = array ();
      // On crée la structure des filtres et on supprime les vides
      if (isset ($this->get['rech-'.$info['inf_code'].'-eta'])) {
	foreach ($this->get['rech-'.$info['inf_code'].'-eta'] as $k => $f) {
	  if ($this->get['rech-'.$info['inf_code'].'-eta'][$k] || 
	      $this->get['rech-'.$info['inf_code'].'-grp'][$k])
	    $filtres[] = array ('eta' => $this->get['rech-'.$info['inf_code'].'-eta'][$k],
				'grp' => $this->get['rech-'.$info['inf_code'].'-grp'][$k]);
	}
      }
      foreach ($rs as $k => $re) {
	$found = false;
	$groupes = $this->base->personne_groupe_liste2 ($this->auth->token, $re['per_id'], $info['inf_id']);
	if (count ($filtres)) {
	  foreach ($filtres as $filtre) {	    
	    
	    foreach ($groupes as $groupe) {
	      if ($groupe['eta_id'] == $filtre['eta']) {
		if ($filtre['grp']) {
		  if ($groupe['grp_id'] == $filtre['grp']) {
		    if (dates_correspondent ($info, $groupe, $re))
		      $found = true;		    
		  }
		} else {
		  if (dates_correspondent ($info, $groupe, $re))
		    $found = true;
		}
	      }
	    }
	  }
	  if (!$found) {
	    unset ($rs[$k]);
	  }
	}            
      }
    }
  }
  return $rs;
}

function filtre_multiples ($rs) {
  foreach ($this->infos as $info) {
    if ($info['inf_multiple']) {
      if (isset ($this->get['rech-'.$info['inf_code']])) {
	$filtres = $this->get['rech-'.$info['inf_code']];
	if (count ($filtres)) {
	  foreach ($filtres as $k => $filtre) {
	    if (!$filtre)
	      unset ($filtres[$k]);
	  }
	}
      } else {
	$filtres = array ();
      }
      $thetype = $this->type[$info['int_id']]['int_code'];
      if ($thetype != 'selection')
	continue;
      foreach ($rs as $k => $re) {
	$found = false;
	$vals = $this->base->__call ($info['obj']->fct(), array ($this->auth->token, $re['per_id'], $info['inf_code']));
	if (count ($filtres)) {
	  foreach ($filtres as $filtre) {
	    if ($filtre) {
	      foreach ($vals as $val) {
		if ($val == $filtre) {
		  $found = true;
		  break;
		}
	      }
	    }
	  }
	} else {
	  $found = true;
	}
	if (!$found) {
	  unset ($rs[$k]);
	}
      }      
    }
  }
  return $rs;
}

  function getSize () {    
    return 0;
  }    

  function getName() {
    return $this->name.'-'.$this->getNamePart();
  }
}
?>
*/