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
ini_set('session.gc_maxlifetime', 4*60*60);
session_start ();
$reperes = array ('usager' => array ('nom', 'prenom'),
		  'personnel' => array ('nom', 'prenom'),
		  'contact' => array ('nom', 'prenom'),
		  'famille' => array ('nom', 'prenom'),
		  'organisme' => array ('nom')
);
function outils_affiche_periode ($from, $to) {
  if ($from && $to) {
    return "Du $from au $to";
  } else if ($from) {
    return "À partir du $from";
  } else if ($to) {
    return "Jusqu'au $to";
  } else {
    return "<i>Non définie</i>";
  }
}

function filtre_etas ($etas, $type, $soustype) {
  // Retourne uniqement les établissements ayant un groupe d'un soustype particulier
  global $base;
  if (!$soustype)
    return $etas;
  $ret = array ();
  foreach ($etas as $eta) {
    $grps = $base->groupe_filtre ($_SESSION['token'], $type, null, null, $eta['eta_id']);
    $n = 0;
    foreach ($grps as $k => $grp) {  
      if ($grp['grp_'.$type.'_type'] == $soustype)
        $n++;
    }
    if ($n) {
      $ret[] = $eta;
    }
  }
  return $ret;
}
?>
