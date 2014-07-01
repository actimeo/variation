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
require 'inc/config.inc.php';
$d = file_get_contents ($banquechamps.'/dir');
if ($d === FALSE)
  exit (1);
$dirs = json_decode ($d);
affiche_dirs ($dirs);

$s = file_get_contents ($banquechamps.'/selection');
if ($s === FALSE)
  exit (1);
$sels = json_decode ($s);
affiche_selections ($sels);

$c = file_get_contents($banquechamps.'/champs');
if ($c === FALSE)
  exit (1);
$chas = json_decode ($c);
affiche_champs ($chas);

function affiche_dirs ($dirs) {
  if (!count ($dirs)) 
    return;  
  foreach ($dirs as $dir) {
    //echo $dir->din_id."\n";
    echo 'INSERT INTO meta.dirinfo (din_id, din_id_parent, din_libelle) VALUES ('.pg_escape_string ($dir->din_id).', '.pg_escape_string ($dir->din_id_parent ? $dir->din_id_parent : 'NULL').', \''.pg_escape_string ($dir->din_libelle).'\');'."\n";
    affiche_dirs ($dir->child);
  }
  echo "SELECT setval ('meta.dirinfo_din_id_seq', coalesce((select max(din_id)+1 from meta.dirinfo), 1), false);\n";
}

function affiche_selections ($sels) {
  global $banquechamps;
  if (!count ($sels)) 
    return;  
  foreach ($sels as $sel) {
    echo 'INSERT INTO meta.selection (sel_id, sel_code, sel_libelle, sel_info) VALUES ('.pg_escape_string ($sel->sel_id).', \''.pg_escape_string ($sel->sel_code).'\', \''.pg_escape_string ($sel->sel_libelle).'\', \''.pg_escape_string ($sel->sel_info).'\');'."\n";    
    
    $s = file_get_contents ($banquechamps.'/selection/'.$sel->sel_code.'/entree');
    if ($s === FALSE)
      exit (1);
    $sens = json_decode ($s);
    affiche_selection_entrees ($sens);
  }
  echo "SELECT setval ('meta.selection_sel_id_seq', coalesce((select max(sel_id)+1 from meta.selection), 1), false);\n";
}

function affiche_selection_entrees ($sens) {
  if (!count ($sens)) 
    return;  
  foreach ($sens as $sen) {
    echo "INSERT INTO meta.selection_entree (sen_id, sel_id, sen_libelle, sen_ordre) VALUES (".pg_escape_string ($sen->sen_id).", ".pg_escape_string ($sen->sel_id).", '".pg_escape_string ($sen->sen_libelle)."', ".pg_escape_string ($sen->sen_ordre).");\n";
  }
  echo "SELECT setval ('meta.selection_entree_sen_id_seq', coalesce((select max(sen_id)+1 from meta.selection_entree), 1), false);\n";
}

function affiche_champs ($chas) {
  foreach ($chas as $cha) {
    echo "INSERT INTO meta.info (
  inf_id, 
  int_id, 
  inf_code, 
  inf_libelle, 
  inf__textelong_nblignes,
  inf__selection_code,
  inf_etendu,
  inf_historique,
  inf_multiple,
  inf__groupe_type,
  inf__contact_filtre,
  inf__metier_secteur,
  inf__contact_secteur,
  inf__etablissement_interne,
  din_id,
  inf__groupe_soustype,
  inf_libelle_complet,
  inf__date_echeance,
  inf__date_echeance_icone,
  inf__date_echeance_secteur,
  inf__etablissement_secteur
    ) VALUES (
".pg_escape_string ($cha->inf_id).",
".pg_escape_string ($cha->int_id).",
'".pg_escape_string ($cha->inf_code)."',
'".pg_escape_string ($cha->inf_libelle)."',
".pg_escape_string ($cha->inf__textelong_nblignes ? $cha->inf__textelong_nblignes : 'NULL').",
".pg_escape_string ($cha->inf__selection_code ? $cha->inf__selection_code : 'NULL').",
".($cha->inf_etendu ? 'TRUE' : 'FALSE').",
".($cha->inf_historique ? 'TRUE' : 'FALSE').",
".($cha->inf_multiple ? 'TRUE' : 'FALSE').",
".($cha->inf__groupe_type ? "'".pg_escape_string ($cha->inf__groupe_type)."'" : 'NULL').",
".($cha->inf__contact_filtre ? "'".pg_escape_string ($cha->inf__contact_filtre)."'" : 'NULL').",
".($cha->inf__metier_secteur ? "'".pg_escape_string ($cha->inf__metier_secteur)."'" : 'NULL').",
".($cha->inf__contact_secteur ? "'".pg_escape_string ($cha->inf__contact_secteur)."'" : 'NULL').",
".($cha->inf__etablissement_interne ? 'TRUE' : 'FALSE').",
".pg_escape_string ($cha->din_id ? $cha->din_id : 'NULL').",
".pg_escape_string ($cha->inf__groupe_soustype ? $cha->inf__groupe_soustype : 'NULL').",
".($cha->inf_libelle_complet ? "'".pg_escape_string ($cha->inf_libelle_complet)."'" : 'NULL').",
".($cha->inf__date_echeance ? 'TRUE' : 'FALSE').",
".($cha->inf__date_echeance_icone ? "'".pg_escape_string ($cha->inf__date_echeance_icone)."'" : 'NULL').",
".($cha->inf__date_echeance_secteur ? "'".pg_escape_string ($cha->inf__date_echeance_secteur)."'" : 'NULL').",
".($cha->inf__etablissement_secteur ? "'".pg_escape_string ($cha->inf__etablissement_secteur)."'" : 'NULL')."
);\n";
    if ($cha->aide) 
      echo "INSERT INTO meta.info_aide (inf_id, ina_aide) VALUES (".pg_escape_string ($cha->inf_id).", ".($cha->aide ? "'".pg_escape_string ($cha->aide)."'" : 'NULL').");\n";
  }
  echo "SELECT setval ('meta.info_inf_id_seq', coalesce((select max(inf_id)+1 from meta.info), 1), false);\n";
}
?>
