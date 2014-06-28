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
<style type="text/css">
   .col { float: left; width:30%}
</style>

<h1>Imports</h1>
<form enctype="multipart/form-data" method="POST">
   <div style="height: 100%; overflow: auto; margin-bottom: 30px;">
<h2>Format du fichier CSV :</h2>
<label for="csv_charset">Encodage : </label><select name="csv_charset" id="csv_charset"><option value="unicode">Unicode</option><option value="utf8">UTF-8</option></select>
   <label for="csv_sep">Séparateur : </label><select name="csv_sep"><option value="tab">Tabulation</option></select>
   <p>Pour un enregistrement Sous Excel au format "Texte Unicode", choisir Encodage Unicode et Séparateur Tabulation.</p>
   <input type="file" name="csv_file"></input>
</div>
<div class="col">
<h2>Organismes</h2>
   <p>Entêtes : <ul><li>nom<li>adresse1<li>adresse2<li>code_postal<li>ville<li>telephone<li>fax<li>(codes thématiques)</ul></p>
<input type="submit" value="Importer organismes" name="csv_import_organismes">
</div>

<div class="col">
<h2>Groupes</h2>
<input type="submit" value="Importer groupes" name="csv_import_groupes">
</div>

<div class="col">
<h2>Personnes</h2>
<select name="type_personne">
 <option value="usager">Usagers</option>
 <option value="personnel">Personnels</option>
 <option value="contact">Contacts</option>
 <option value="famille">Famille</option>
</select>
<input type="submit" value="Importer personnes" name="csv_import_personnes">
</div>


</form>

<?php
require 'inc/enums.inc.php';
if (isset ($_FILES['csv_file'])) {
  $seps = array ('tab' => "\t");
  $fichier = $_FILES['csv_file']['tmp_name'];
  if ($_POST['csv_charset'] == 'unicode') {
    file_put_contents ('/tmp/import.csv', iconv ('UNICODE', 'UTF-8', file_get_contents ($fichier)));
    $fichier = '/tmp/import.csv';
  }
  $f = fopen ($fichier, 'r');

  echo '<div style="clear: both" class="resultat"><h2>Résultat</h2>';
  if (isset ($_POST['csv_import_organismes'])) {
    importOrganismes ($f, $seps[$_POST['csv_sep']]);
  } else if (isset ($_POST['csv_import_personnes'])) {
    importPersonnes ($f, $_POST['type_personne'], ";", $seps[$_POST['csv_sep']]);
  } else if (isset ($_POST['csv_import_groupes'])) {
    importGroupes ($f, $seps[$_POST['csv_sep']]);
  }
  fclose ($f);
  //  unlink ($fichier);
  echo '</div>';

}
?>


<?php
  function importOrganismes ($f, $csv_sep) {
      global $base;
      $nl=0;
      $base->startTransaction ();
      
      $secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
      $secteurs = array ();
      foreach ($secs as $sec) {
	$secteurs[$sec['sec_id']] = $sec['sec_code'];
      }
      
      while ( ($ligne = fgetcsv ($f, 0, $csv_sep)) !== FALSE) {
	$nl++;
	echo "Ligne ".$nl." : ";
	if ($nl == 1) {
	  // Entête
	  //	  print_r ($ligne);
	  $entete = array_flip ($ligne);
	  //    print_r ($entete); exit;
	  echo 'Entête OK<br>';
	  continue;
	}

	//  if ($nl < $skip)
	//    continue;
	
	$eta = $base->etablissement_cherche ($_SESSION['token'], $ligne[$entete['nom']]);
	if ($eta['eta_id']) {
	  $eta_id = $eta['eta_id'];
	  $base->etablissement_update($_SESSION['token'],
				      $eta_id, 
				      $ligne[$entete['nom']], 
				      NULL, 
				      trim ($ligne[$entete['adresse1']]."\n".$ligne[$entete['adresse2']]), 
				      $ligne[$entete['code_postal']], 
				      $ligne[$entete['ville']], 
				      $ligne[$entete['telephone']], 
				      $ligne[$entete['fax']], 
				      $ligne[$entete['email']], 
				      NULL);
	} else {
	  $eta_id = $base->etablissement_add ($_SESSION['token'], $ligne[$entete['nom']], NULL, 
					      trim ($ligne[$entete['adresse1']]."\n".$ligne[$entete['adresse2']]), 
					      $ligne[$entete['code_postal']], 
					      $ligne[$entete['ville']], 
					      $ligne[$entete['telephone']], 
					      $ligne[$entete['fax']], 
					      $ligne[$entete['email']], 
					      NULL);
	}
	
	$eta_secs = array ();
	foreach ($entete as $champ => $nil) {
	  if (in_array ($champ, $secteurs)) {
	    if ($ligne[$entete[$champ]]) {
	      $eta_secs[] = $champ;
	    }
	  }
	}
	if (count ($eta_secs)) {
	  $base->etablissement_secteurs_set ($_SESSION['token'], $eta_id, $eta_secs);
	}
	echo "Ajout eta_id=".$eta_id."<br>";
      }
      
      $base->commit ();
      
    }

function importGroupes ($f, $csv_sep) {
  global $base;

  $base->startTransaction ();

  $entete = fgetcsv ($f, 0, $csv_sep);
  array_shift ($entete);
  $types = array ();
  foreach ($entete as $sec_code) {
    if (!$sec_code)
      continue;
    $sets = $base->meta_secteur_type_liste_par_code ($_SESSION['token'], $sec_code);
    $ts = array ();
    foreach ($sets as $set) {
      $ts[$set['set_nom']] = $set['set_id'];
    }
    $types[$sec_code] = $ts;
  }

  $groupes = array ();
  while ( ($ligne = fgetcsv ($f, 0, $csv_sep)) !== FALSE) {
    if (!$ligne[0])
      break;
    $groupe['intitule'] = $ligne[0];
    foreach ($entete as $k => $sec_code) {
      if (!$sec_code)
	continue;
      if (isset ($ligne[$k+1])) {
	list ($type, $champ) = explode ('>', $ligne[$k+1]);
	$inf = $base->meta_info_get_par_code ($_SESSION['token'], $champ);
	$groupe['secteurs'][$sec_code]['type'] = $types[$sec_code][$type];
	$groupe['secteurs'][$sec_code]['champ'] = $inf['inf_id'];
      }
    }
    $groupes[] = $groupe;
  }  

  while ( ($ligne = fgetcsv ($f, 0, $csv_sep)) !== FALSE) {
    $eta_nom = $ligne[0];
    $eta = $base->etablissement_cherche ($_SESSION['token'], $eta_nom);
    if (!$eta['eta_id']) {
      $base->rollback ();
      echo $eta_nom." non trouvé. Arrêt";
      return;
    }
    //    echo $eta_nom;
    echo 'Ajout dans établissement eta_id = '.$eta['eta_id']." : <br>";
    foreach ($groupes as $groupe) {
      $grp_id = $base->groupe_add ($_SESSION['token'], $groupe['intitule'], $eta['eta_id'], NULL, NULL, NULL);
      echo ' - Ajout groupe grp_id = '.$grp_id.'<br>';
      $base->groupe_secteurs_set ($_SESSION['token'], $grp_id, array_keys($groupe['secteurs']));
      foreach (array_keys($groupe['secteurs']) as $sec_code) {
	$infos = $groupe['secteurs'][$sec_code];
	if ($infos['type']) {
	  $base->groupe_type_secteur_update ($_SESSION['token'], $grp_id, $sec_code, $infos['type']);
	}
	$base->groupe_info_secteur_save ($_SESSION['token'], $grp_id, $sec_code, $infos['champ']);
      }
    }
  }


  $base->commit ();
}

function importPersonnes ($f, $ent_code, $multsep, $csv_sep) {
  global $base, $cycle_statuts;
  $verifEntetes = true;
  $nl=0;
  $base->startTransaction ();

  $sens = array ();
  $metiers = NULL;

  while ( ($ligne = fgetcsv ($f, 0, $csv_sep)) !== FALSE) {
    $nl++;
    $err = false; // Au moins une erreur détectée dans les données
    echo "Ligne ".$nl." : ";
    if ($nl == 1) {
      // Entête
      $entete = array_flip ($ligne);
      $errEntete = array ();
      foreach ($entete as $champ => $nil) {
	$int = $base->meta_info_get_type_par_code ($_SESSION['token'], $champ);
	$inf = $base->meta_info_get_par_code ($_SESSION['token'], $champ);
	/*      if ($verifEntetes && 
		$champ != 'nom_prenom' && 
		$champ != 'photo' && 
		$champ != 'nouveau_nom' && 
		$champ != 'nouveau_prenom') {
		echo $int.' '.$inf['inf_multiple']."\n";
		}*/
	if (!$inf['inf_id'] && 
	    $champ != 'nom_prenom' && 
	    $champ != "photo" && 
	    $champ != 'nouveau_nom' && 
	    $champ != 'nouveau_prenom') {
	  $errEntete[] = $champ;
	  continue;
	}
	if ($int == 'selection') {
	  $sens[$champ] = $base->meta_selection_entree_liste ($_SESSION['token'], $inf['inf__selection_code']);
	} else if ($int == 'metier' && $metiers === NULL) {
	  $metiers = $base->metier_liste ($_SESSION['token'], $ent_code);
	}
      }
      if ($verifEntetes) {
	if (count ($errEntete)) {
	  echo "Champs inexistants : ".implode (', ', $errEntete).'<br>';
	  return;
	} else {
	  echo "Entêtes OK<br>";
	}
      }
      continue;
    }
  
    if (isset ($entete['nom_prenom'])) {
      $per_ids = $base->personne_cherche_exact_tout ($_SESSION['token'], $ligne[$entete['nom_prenom']], $ent_code);
    } else {
      $per_ids = $base->personne_cherche_exact ($_SESSION['token'], $ligne[$entete['nom']], $ligne[$entete['prenom']], $ent_code);
    }  
    if (!count ($per_ids)) {
      if (isset ($entete['nom_prenom'])) {
	echo $ligne[$entete['nom_prenom']].' non trouvé'." ... "; 
      } else {
	echo $ligne[$entete['nom']]." ".$ligne[$entete['prenom']].' non trouvé'." ... "; 
      }
      $per_id = $base->personne_ajoute ($_SESSION['token'], $ent_code);
      $base->personne_info_varchar_set ($_SESSION['token'], $per_id, 'nom', $ligne[$entete['nom']], $_SESSION['uti_id']);
      $base->personne_info_varchar_set ($_SESSION['token'], $per_id, 'prenom', $ligne[$entete['prenom']], $_SESSION['uti_id']);
      echo 'Ajouté per_id = '.$per_id.'<br>';
    } else if (count ($per_ids) == 1) {
      $per_id = $per_ids[0];
      echo 'Trouvé per_id = '.$per_id.'<br>';
    } else {
      echo 'Trouvé plusieurs personnes '.$ligne[$entete['nom']]." ".$ligne[$entete['prenom']].'<br>';
      $err = true;
      continue;
    }

    foreach ($entete as $champ => $nil) {
      if ($champ == 'nom' || $champ == 'prenom' || $champ == 'nom_prenom') {
	continue;
      }
      if ($champ == 'nouveau_nom' || $champ == 'nouveau_prenom') {
	$nouveau_champ = substr ($champ, 8);
	$base->personne_info_varchar_set ($_SESSION['token'], $per_id, $nouveau_champ, $ligne[$entete[$champ]], $_SESSION['uti_id']);
	continue;
      }
      /* TODO
	 if ($champ == 'photo') {
	 if (!file_exists ($dirbase.'/photos/'.$per_id.'/')) {
	 mkdir ($dirbase.'/photos/'.$per_id.'/');
	 }
	 copy ($docdir.'/'.$ligne[$entete['photo']], $dirbase.'/photos/'.$per_id.'/photo.png');
	 continue;
	 }*/
      $inf = $base->meta_info_get_par_code ($_SESSION['token'], $champ);
      if (!$inf['inf_id']) {
	echo "$champ non trouvé\n"; exit;
      }
      $int = $base->meta_info_get_type_par_code ($_SESSION['token'], $champ);
      switch ($int) {
      case 'texte':
	if (strlen (trim ($ligne[$entete[$champ]]))) {
	  if ($inf['inf_multiple']) {
	    $base->personne_info_varchar_prepare_multiple ($_SESSION['token'], $per_id, $champ);
	    $vals = explode ($multsep, $ligne[$entete[$champ]]);
	    foreach ($vals as $val) {
	      if (trim ($val)) {
		$base->personne_info_varchar_set ($_SESSION['token'], $per_id, $champ, trim ($val), $_SESSION['uti_id']);
	      }
	    }
	  } else {
	    $base->personne_info_varchar_set ($_SESSION['token'], $per_id, $champ, trim ($ligne[$entete[$champ]]), $_SESSION['uti_id']);
	  }
	}
	break;

      case "date":
	if (strlen (trim ($ligne[$entete[$champ]]))) {
	  if ($inf['inf_multiple']) {
	    echo "TODO date multiple\n"; exit;
	    //	$base->personne_info_date_prepare_multiple ($_SESSION['token'], $per_id, $champ);
	  } else {
	    $base->personne_info_date_set ($_SESSION['token'], $per_id, $champ, $ligne[$entete[$champ]], $_SESSION['uti_id']);
	  }
	}
	break;

      case "textelong":
	if ($champ === $cumules || in_array ($champ, $cumules)) {
	  $ancien = $base->personne_info_text_get ($_SESSION['token'], $per_id, $champ);
	  if (strlen ($ancien)) {
	    $ancien .= "\n";
	  }
	  $base->personne_info_text_set ($_SESSION['token'], $per_id, $champ, $ancien.str_replace ("<>", "\n", trim ($ligne[$entete[$champ]])), $_SESSION['uti_id']);
	} else {
	  //	echo 'ne pas cumuler';
	  $base->personne_info_text_set ($_SESSION['token'], $per_id, $champ, str_replace ("<>", "\n", trim ($ligne[$entete[$champ]])), $_SESSION['uti_id']);
	}
	break;

      case "coche":
	$base->personne_info_boolean_set ($_SESSION['token'], $per_id, $champ, trim ($ligne[$entete[$champ]]) != '', $_SESSION['uti_id']);
	break;

      case "selection":
	if (strlen (trim ($ligne[$entete[$champ]]))) {
	  if ($inf['inf_multiple']) {
	    echo "TODO selection multiple\n"; exit;
	    //	$base->personne_info_integer_prepare_multiple ($_SESSION['token'], $per_id, $champ);
	  } else {
	    $val = $ligne[$entete[$champ]];
	    $entrees = $sens[$champ];
	    $found = false;
	    foreach ($entrees as $entree) {
	      if ($entree['sen_libelle'] == $val) {
		$found = true;
		$base->personne_info_integer_set ($_SESSION['token'], $per_id, $champ, $entree['sen_id'], $_SESSION['uti_id']);
		break;
	      }
	    }
	    if (!$found) {
	      echo "Entrée de sélection \"$val\" non trouvé.\n"; exit;
	    }
	  }
	}
	break;

      case "groupe":
	$vals = explode ($multsep, $ligne[$entete[$champ]]);
	foreach ($vals as $val) {
	  if (trim ($val)) {
	    $parts = explode ('>', trim ($val));
	    $debut = isset ($parts[2]) && $parts[2] ? $parts[2] : NULL;
	    $fin = isset ($parts[3]) && $parts[3] ? $parts[3] : NULL;
	    $cycle_statut_lib = isset ($parts[4]) && $parts[4] ? $parts[4] : NULL;
	    if ($cycle_statut_lib) {
	      $cycle_statuts_flip = array_flip ($cycle_statuts);
	      if (!isset ($cycle_statuts_flip[$cycle_statut_lib])) {
		echo 'Statut "'.$cycle_statut_lib.'" non trouvé'."\n"; 
		exit;
	      }
	      $cycle_statut = $cycle_statuts_flip[$cycle_statut_lib];
	      $cycle_date_demande = isset ($parts[5]) && $parts[5] ? $parts[5] : NULL;
	      $cycle_date_renouv = isset ($parts[6]) && $parts[6] ? $parts[6] : NULL;
	    } else {
	      $cycle_statut = NULL;
	    $cycle_date_demande = NULL;
	    $cycle_date_renouv = NULL;
	    }
	    $grps = $base->groupe_cherche ($_SESSION['token'], $parts[0], $parts[1]);
	    if (count ($grps) != 1) {
	      echo $parts[0]." > ".$parts[1]." : ".count ($grps)." trouvé\n"; exit;
	    }
	    $base->personne_groupe_ajoute ($_SESSION['token'], $per_id, $grps[0]['grp_id'], $debut, $fin, NULL, $cycle_statut, $cycle_date_demande, $cycle_date_renouv, NULL, NULL);
	  }
	}
	break;

      case "contact":
	if ($inf['inf_multiple']) {
	  $vals = explode ($multsep, $ligne[$entete[$champ]]);
	  foreach ($vals as $val) {
	    if (trim ($val)) {
	      $per_ids_contact = $base->personne_cherche_exact_tout ($_SESSION['token'], trim ($val), $inf['inf__contact_filtre']);
	      if (count ($per_ids_contact) != 1) {
		echo "$val trouvé ".count($per_ids_contact)." fois\n"; exit;
	      }
	      $per_id_contact = $per_ids_contact[0];
	      $base->personne_info_integer_set ($_SESSION['token'], $per_id, $champ, $per_id_contact, $_SESSION['uti_id']);
	    }
	  }
	} else {
	  $val = $ligne[$entete[$champ]];
	  $per_ids_contact = $base->personne_cherche_exact_tout ($_SESSION['token'], trim ($val), $inf['inf__contact_filtre']);
	  if (count ($per_ids_contact) != 1) {
	    echo "$val trouvé ".count($per_ids_contact)." fois\n"; exit;
	  }
	  $per_id_contact = $per_ids_contact[0];
	  $base->personne_info_integer_set ($_SESSION['token'], $per_id, $champ, $per_id_contact, $_SESSION['uti_id']);
	}
	break;

      case "metier":
	if (strlen (trim ($ligne[$entete[$champ]]))) {
	  if ($inf['inf_multiple']) {
	    echo "TODO metier multiple\n"; exit;
	    //	$base->personne_info_integer_prepare_multiple ($_SESSION['token'], $per_id, $champ);
	  } else {
	    $val = $ligne[$entete[$champ]];
	    $found = false;
	    foreach ($metiers as $metier) {
	      if ($metier['met_nom'] == $val) {
		$found = true;
		$base->personne_info_integer_set ($_SESSION['token'], $per_id, $champ, $metier['met_id'], $_SESSION['uti_id']);
		break;
	      }
	    }
	    if (!$found) {
	      echo "Métier \"$val\" non trouvé.\n"; exit;
	    }
	  }
	}
	break;

      case "etablissement":
	if ($ligne[$entete[$champ]]) {
	  $eta = $base->etablissement_cherche ($_SESSION['token'], $ligne[$entete[$champ]]);
	  if (!$eta['eta_id']) {
	    echo $ligne[$entete[$champ]].' non trouvé'."\n";
	    exit;
	  }
	  if ($inf['inf_multiple']) {
	    echo "TODO etablissement multiple\n";
	    exit;
	  } else {
	    $base->personne_info_integer_set ($_SESSION['token'], $per_id, $champ, $eta['eta_id'], $_SESSION['uti_id']);
	  }
	}
	break;

      case "affectation":
	if (strlen (trim ($ligne[$entete[$champ]]))) {
	  if ($inf['inf_multiple']) {
	    $base->personne_info_integer2_prepare_multiple ($_SESSION['token'], $per_id, $champ);
	    $vals = explode ($multsep, $ligne[$entete[$champ]]);
	    foreach ($vals as $val) {
	      list ($eta, $grp) = explode ('>', trim ($val));
	      $grps = $base->groupe_cherche ($_SESSION['token'], $eta, $grp);
	      if (count ($grps) != 1) {
		echo "$eta > $grp : ".count ($grps)." trouvé\n"; exit;
	      }
	      $base->personne_info_integer2_set ($_SESSION['token'], $per_id, $champ, $grps[0]['eta_id'], $grps[0]['grp_id'], $_SESSION['uti_id']);
	    }
	  } else {
	    echo "TODO affectation non multiple\n"; exit;
	  }
	}
	break;

      case "famille":
	// On considère que c'est multiple
	$vals = explode ($multsep, $ligne[$entete[$champ]]);
	foreach ($vals as $val) {
	  if (trim ($val)) {
	    $parts = explode ('>', trim ($val));
	    $per_ids_famille = $base->personne_cherche_exact_tout ($_SESSION['token'], $parts[0], 'famille');
	    if (count ($per_ids_famille) != 1) {
	      echo $parts[0]." trouvé ".count($per_ids_famille)." fois\n"; exit;
	    }
	    $per_id_famille = $per_ids_famille[0];
	    $lfa = $base->meta_lien_familial_cherche ($_SESSION['token'], $parts[1]);
	    if (!$lfa['lfa_id']) {
	      echo "Lien familial ".$parts[1]." non trouvé\n"; exit;
	    }
	    $base->personne_info_lien_familial_set ($_SESSION['token'], $per_id, $champ, $per_id_famille, $lfa['lfa_id'], NULL, NULL, NULL);
	  
	  }
	}
	break;

      case "statut_usager":
	echo "TODO statut_usager\n"; exit;
	break;
      }
    }
    /*
      $base->personne_info_date_set ($per_id, 'date_de_naissance', $ligne[3]);
      $base->personne_info_date_set ($per_id, 'personnel_date_embauche', $ligne[4]);
      // personnel_metier
      $base->personne_info_date_set ($per_id, 'date_depart', $ligne[6]);
      // personnel_affectation
      $base->personne_info_varchar_set ($per_id, 'personnel_qualification', $ligne[8]);
      // statut
      */

  }
  //exit;
  $base->commit ();

}
?>
