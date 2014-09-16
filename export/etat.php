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
require ('../inc/config.inc.php');
require ('../inc/common.inc.php');
require ('../inc/pgprocedures.class.php');
require ('../fpdm/fpdm.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
require ('../inc/infos/info.class.php');

$pdfname = $_GET['pdf'];
$token = $_SESSION['token'];
$per_id = $_GET['id'];
$nom_usager = $base->personne_get_libelle ($token, $per_id);

$pdf = new FPDM ('../etats/'.$pdfname);
$pdf->parsePDFEntries ($lines);
$fields = array ();

$info_types = $base->meta_infos_type_liste ($token);
$int_code = array ();
foreach ($info_types as $info_type) {
  $int_code[$info_type['int_id']] = $info_type['int_code'];
}

foreach ($lines as $name => $line) {
  $valeur = '';
  $parts = explode (':', trim ($name), 2);
  switch ($parts[0]) {
  case 'usager':
    $valeur = valeur_champ ($per_id, $parts[1]);
    break;

  case 'variable':
    switch ($parts[1]) {

    case 'date_jour':
      $valeur = date ('d/m/Y');
      break;
      
    case 'vide':
      $valeur = '';
      break;

    }
  }
  
  $fields[$name] = $valeur;
}
$pdf->Load ($fields, true);
$pdf->Merge ();
$pdf->Output (preg_replace ('/\.pdf$/', '', $pdfname).' - '.$nom_usager.'.pdf', 'I');

function valeur_champ ($per_id, $inf_code) {
  global $base, $token, $int_code;
  $valeur = '';
  $parts = explode (':', trim ($inf_code), 2);
  $inf_code = $parts[0];
  $inf = $base->meta_info_get_par_code ($token, $inf_code);
  $int_id = $inf['int_id'];

  switch ($int_code[$int_id]) {

  case 'texte':
    $multiple = $inf['inf_multiple'];  
    if ($multiple) {
      $valeurs = $base->personne_info_varchar_get_multiple ($token, $per_id, $inf['inf_code']);
    } else {
      $valeurs = array ($base->personne_info_varchar_get ($token, $per_id, $inf['inf_code']));
    }
    $valeur = implode (', ', $valeurs);
    break;
    
  case 'date':
    $multiple = $inf['inf_multiple'];  
    if ($multiple) {
      $valeurs = $base->personne_info_date_get_multiple ($token, $per_id, $inf['inf_code']);
    } else {
      $valeurs = array ($base->personne_info_date_get ($token, $per_id, $inf['inf_code']));
    }
    $valeur = implode (', ', $valeurs);
    break;

  case 'date_calcule':
    $obj = new Info_date_calcule ($inf);
    $valeur = $obj->valeurCalculee ($per_id);
    break;
    
  case 'coche':
    $val = $base->personne_info_boolean_get ($token, $per_id, $inf['inf_code']);
    $valeur = $val ? "X" : "";
    break;

  case 'coche_calcule':
    $obj = new Info_coche_calcule ($inf);
    $valeur = $obj->valeurCalculee ($per_id) ? 'X' : '';
    break;
    
  case 'selection':
    $multiple = $inf['inf_multiple'];  
    if ($multiple) {
      $valeurs = $base->personne_info_integer_get_multiple ($token, $per_id, $inf['inf_code']);
    } else {
      $valeurs = array ($base->personne_info_integer_get ($token, $per_id, $inf['inf_code']));
    }
    $selection = $base->meta_selection_infos ($token, $inf['inf__selection_code']);
    $entrees = $base->meta_selection_entree_liste ($token, $inf['inf__selection_code']);
    $vals = array ();
    foreach ($valeurs as $valid) {
      $tmp = $base->meta_selection_entree_get ($token, $valid);
      $vals[] = $tmp['sen_libelle'];
    }
    $valeur = implode ("\n", $vals);
    break;

  case 'textelong':
    $valeur = $base->personne_info_text_get ($token, $per_id, $inf['inf_code']);    
    break;

  case 'groupe':
    $groupes = $base->personne_groupe_liste2 ($token, $per_id, $inf['inf_id'], $base->limit (1));
    if (!isset ($parts[1])) {
      $valeur = $groupes[0]['eta_nom'].' - '.$groupes[0]['grp_nom'];
    } if ($parts[1] == 'debut') {
      $valeur = $groupes[0]['peg_debut'];
    } else if ($parts[1] == 'fin') {
      $valeur = $groupes[0]['peg_fin'];      
    }
    break;

  case 'contact':
    $multiple = $inf['inf_multiple'];        
    if ($multiple) {
      $vals = $base->personne_info_integer_get_multiple_details ($token, $per_id, $inf['inf_code']);
      $valeurs = array ();
      if (count ($vals)) {
	foreach ($vals as $val) {
	  if (!isset ($parts[1])) {
	    $valeurs[] = $base->personne_get_libelle ($token, $val['pii_valeur']);
	  } else {
	    $valeurs[] = valeur_champ ($val['pii_valeur'], $parts[1]);
	  }
	}
      }
      $valeur = implode (', ', $valeurs);
    } else {
      $val = $base->personne_info_integer_get ($token, $per_id, $inf['inf_code']);    
      if (!isset ($parts[1])) {
	$valeur = $base->personne_get_libelle ($token, $val);
      } else {
      	$valeur = valeur_champ ($val, $parts[1]);
	//	$valeur = $parts[1];
      }
    }    
    break; 

  case 'famille':
    $valeurs = $base->personne_info_lien_familial_get_multiple ($token, $per_id, $inf['inf_code']);
    $vals = array ();
    foreach ($valeurs as $val) {
      if (!isset ($parts[1])) {
	$libelle = $base->personne_get_libelle ($token, $val['per_id_parent']);
	$lien = $base->meta_lien_familial_get ($token, $val['lfa_id']);
	$vals[] = $libelle.' ('.$lien['lfa_nom'].')';
      } else {
	$vals[] = valeur_champ ($val['per_id_parent'], $parts[1]);	
      }
    }
    $valeur = implode (', ', $vals);
    break;

  default:
    //    echo $int_code[$int_id];
  }  

  return $valeur;
}

?>
