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
function enregistre ($sme_id, $per_id, $post) {
  global $base, $int_code;
  $groupes = $base->meta_groupe_infos_liste ($_SESSION['token'], $sme_id);
  if (count ($groupes)) {
    foreach ($groupes as $groupe) {
      $infos = $base->meta_info_groupe_liste ($_SESSION['token'], $groupe['gin_id']);
      if (count ($infos)) {
	foreach ($infos as $info) {
	  if ($int_code[$info['int_id']] == 'affectation') {
	    $valeur1 = $post['info_'.$info['inf_code'].'1'];
	    $valeur2 = $post['info_'.$info['inf_code'].'2'];	    
	  } else {
	    $valeur = $post['info_'.$info['inf_code']];
	  }
	  switch ($int_code[$info['int_id']]) {
	  case 'texte':         enregistre_texte ($info, $per_id, $valeur); break;
	  case 'date':          enregistre_date ($info, $per_id, $valeur); break;
	  case 'textelong':     enregistre_textelong ($info, $per_id, $valeur); break;
	  case 'coche':         enregistre_coche ($info, $per_id, $valeur); break;
	  case 'selection':     enregistre_selection ($info, $per_id, $valeur); break;
	  case 'groupe':        break;
	  case 'contact':       break;
	  case 'etablissement': break;
	  case 'metier':        enregistre_metier ($info, $per_id, $valeur); break;
	  case 'affectation':   break;
	  }
	}
      }
    }
  }
}

function enregistre_texte ($info, $per_id, $valeur) {
  global $base;
  if (is_array($valeur)) {
    $base->personne_info_varchar_prepare_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    foreach ($valeur as $val) {
      if ($val)
	$base->personne_info_varchar_set ($_SESSION['token'], $per_id, $info['inf_code'], $val, $_SESSION['uti_id']);
    }
  } else {
    $base->personne_info_varchar_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur, $_SESSION['uti_id']);
  }
}

function enregistre_date ($info, $per_id, $valeur) {
  global $base;
  if (is_array($valeur)) {
    $base->personne_info_date_prepare_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    foreach ($valeur as $val) {
      if ($val)
	$base->personne_info_date_set ($_SESSION['token'], $per_id, $info['inf_code'], $val, $_SESSION['uti_id']);
    }
  } else {
    $base->personne_info_date_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur, $_SESSION['uti_id']);
  }
}

function enregistre_textelong ($info, $per_id, $valeur) {
  global $base;
  $base->personne_info_text_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur, $_SESSION['uti_id']);
}

function enregistre_coche ($info, $per_id, $valeur) {
  global $base;
  $base->personne_info_boolean_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur == 'on', $_SESSION['uti_id']);
}

function enregistre_selection ($info, $per_id, $valeur) {
  global $base;
  if (is_array($valeur)) {
    $base->personne_info_integer_prepare_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    foreach ($valeur as $val) {
      if ($val)
	$base->personne_info_integer_set ($_SESSION['token'], $per_id, $info['inf_code'], $val, $_SESSION['uti_id']);
    }
  } else {
    $base->personne_info_integer_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur, $_SESSION['uti_id']);
  }
}

function enregistre_metier ($info, $per_id, $valeur) {
  global $base;
  if (is_array ($valeur)) {
    $base->personne_info_integer_prepare_multiple ($_SESSION['token'], $per_id, $info['inf_code']);
    foreach ($valeur as $val) {
      if ($val)
	$base->personne_info_integer_set ($_SESSION['token'], $per_id, $info['inf_code'], $val, $_SESSION['uti_id']);
    }    
  } else {
    $base->personne_info_integer_set ($_SESSION['token'], $per_id, $info['inf_code'], $valeur, $_SESSION['uti_id']);
  }
}

?>
