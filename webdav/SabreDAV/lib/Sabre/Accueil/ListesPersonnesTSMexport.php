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
require_once '../inc/infos/info.class.php';

abstract class ListesPersonnesTSMexport extends Dav\File {
  private $auth;
  private $base;
  private $tsmid;
  private $name;
  protected $type;
  private $get;
  protected $infos;
  protected $data;
  protected $contents;
  protected $strdebug;
  protected $sqldebug;

  function __construct ($auth, $base, $tsmid) {
    $this->base = $base;
    $this->auth = $auth;
    $this->tsmid = $tsmid;
    $this->infos = NULL;
    $this->data = NULL;
    $this->get = NULL;
    $tsm = $this->base->meta_topsousmenu_get ($this->auth->token, $this->tsmid);
    $this->name = $tsm['tsm_libelle'];
  }

  function getData () {

    $types = $this->base->meta_infos_type_liste ($this->auth->token);
    $this->type = array ();
    foreach ($types as $t) {
      $this->type[$t['int_id']] = $t;
    }

    $this->strdebug = '';
    $tsm = $this->base->meta_topsousmenu_get ($this->auth->token, $this->tsmid);
    $lis_id = $tsm['tsm_type_id'];
    $lis = $this->base->liste_liste_get ($this->auth->token, $lis_id);
    $champs =  $this->base->liste_champ_liste ($this->auth->token, $lis['lis_id']);
    $this->infos = array ();
    foreach ($champs as $champ) {
      $tmp = $this->base->meta_info_get ($this->auth->token, $champ['inf_id']);
      $tmp['champ'] = $champ;
      $t = 'Info_'.$this->type[$tmp['int_id']]['int_code'];  
      $tmp['obj'] = new $t ($tmp);
     $this->infos[] = $tmp;
    }

    $entites = $this->base->meta_entite_liste ($this->auth->token);
    $entite = array ();
    foreach ($entites as $e) {
      $entite[$e['ent_id']] = $e;
    }

    // On récupère les valeurs par défaut verrouillées
    //    $this->strdebug .= "1. ".print_r ($this->infos, true)."\n";
    foreach ($this->infos as $info) {
      if ($info['champ']['cha_verrouiller']) {
	$defauts = $this->base->liste_defaut_liste ($this->auth->token, $info['champ']['cha_id']);
	if (count ($defauts)) {
	  foreach ($defauts as $defaut) {
	    if ($this->type[$info['int_id']]['int_code'] == 'texte') {	
	      $this->get['rech-'.$info['inf_code']][] = $defaut['def_valeur_texte'];
	    } else if ($this->type[$info['int_id']]['int_code'] == 'selection') {	
	      $this->get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    } else if ($this->type[$info['int_id']]['int_code'] == 'statut_usager') {	
	      $this->get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    } else if ($this->type[$info['int_id']]['int_code'] == 'metier') {	
	      $this->get['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    } else if ($this->type[$info['int_id']]['int_code'] == 'groupe') {	
	      $this->get['rech-'.$info['inf_code'].'-eta'][] = $defaut['def_valeur_int'];
	      $this->get['rech-'.$info['inf_code'].'-grp'][] = $defaut['def_valeur_int2'];
	    }
	  }
	}
      }
    }  
    //    $this->strdebug .= "2. ".print_r ($this->get, true)."\n";

    $sql = 'SELECT DISTINCT per_id, ';
    $sqlfiltre = '';
    foreach ($this->infos as $info) {  
      if ($info['inf_multiple'])
	continue;
      if (get_class ($info['obj']) == 'Info_groupe')
	continue;
      $sql .= $info['obj']->fct()." (".$this->auth->token.", per_id, '".pg_escape_string ($info['inf_code'])."') AS ".$info['inf_code'].", ";
      
      if (isset ($this->get['rech-'.$info['inf_code']]) && $this->get['rech-'.$info['inf_code']]) {
	if ($this->type[$info['int_id']]['int_code'] == 'texte') {
	  $parts = array ();
	  foreach ($this->get['rech-'.$info['inf_code']] as $val) {
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$this->auth->token.", per_id, '".pg_escape_string ($info['inf_code'])."') ilike '%".$val."%'";
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	  
	} else if ($this->type[$info['int_id']]['int_code'] == 'selection' || $this->type[$info['int_id']]['int_code'] == 'statut_usager') {
	  $parts = array ();
	  foreach ($this->get['rech-'.$info['inf_code']] as $val) {
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$this->auth->token.", per_id, '".pg_escape_string ($info['inf_code'])."') = ".$val;
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	} else if ($this->type[$info['int_id']]['int_code'] == 'metier') {
	  $parts = array ();
	  foreach ($this->get['rech-'.$info['inf_code']] as $val) {
	    $mets = $this->base->metier_secteur_metier_liste ($this->auth->token, $val);
	    $metparts = array ();
	    foreach ($mets as $met) {
	      $metparts[] = $met['met_id'];
	    }
	    $mets = implode (', ', $metparts);
	    if ($val)
	      $parts[] = $info['obj']->fct()." (".$this->auth->token.", per_id, '".pg_escape_string ($info['inf_code'])."') IN (".$mets.")";
	  } 
	  if (count ($parts))
	    $sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	}
      }
    }
    $sql = substr ($sql, 0, -2);
    if ($entite[$lis['ent_id']]['ent_code'] == 'usager') {
      $sql .= ' FROM personne INNER JOIN personne_groupe USING (per_id) INNER JOIN login.grouputil_groupe USING(grp_id) INNER JOIN login.utilisateur_grouputil USING(gut_id) WHERE uti_id = (SELECT uti_id FROM login.token WHERE tok_token='.$this->auth->token.')';
      $sql .= " AND ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
    } else {
      $sql .= ' FROM personne';
      $sql .= " WHERE ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
    }
    $sql .= $sqlfiltre;
    $this->sqldebug = $sql;
    $res = $this->base->execute_sql ($sql);
    $res = $this->filtre_groupes ($res);
    $res = $this->filtre_multiples ($res);
    $this->data = $res;
  }
  
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
    /*    if (!$this->contents) {
      $this->get ();
    }
    return strlen ($this->contents);*/
  }    

  function getName() {
    return $this->name.'-'.$this->getNamePart();
  }
}
?>
