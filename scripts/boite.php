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
<script type="text/javascript">
   $(document).ready (function () {
       $(".note_done").click (function () {
	   var thespan = $(this);
	   var nde = $(this).attr('id').substr (4);
	   $.post('/ajax/notes_note_destinataire_marque_done.php', { prm_token: $("#token").val(), prm_nde_id: nde }, function () {
	       thespan.parents('tr.todo').removeClass('todo');
	       thespan.remove ();
	     });
	 });
     });
</script>
<?php
define ('NPAGES', 10);
if ($_GET['boite'] == 'envoi') {
  $soustitre = ' - Notes envoyées';
} else {
  $soustitre = ' - Notes reçues';
}

function affiche_notes () {
  if ($_GET['boite'] == 'envoi') 
    affiche_notes_envoi ();
  else if ($_GET['boite'] == 'mesnotes')  // Non utilisé
    affiche_mesnotes ();
  else
    affiche_notes_reception ();
}

function link_page ($p) {
  parse_str($_SERVER['QUERY_STRING'], $aargs);
  $aargs['p'] = $p;
  return $_SERVER['STRING_NAME'].'?'.http_build_query ($aargs);
}

function affiche_notes_reception () {
  global $base;
  // Page de pagination
  $p = isset ($_GET['p']) ? $_GET['p'] : '1';
  $nnotes = $base->notes_note_boite_reception_liste ($_SESSION['token'], $base->count());
  $notes = $base->notes_note_boite_reception_liste ($_SESSION['token'], $base->order ('not_date_evenement', 'DESC'), $base->limit (NPAGES, ($p-1)*NPAGES));
  echo '<table width="100%" class="t1"><tr><th width="150">Date<br>Expéditeur</th><th width="70">Reçu pour</th><th width="150">Usagers</th><th>Note</th><th width="150">Autres destinataires</th></tr>';
  $impair = true;
  
  foreach ($notes as $note) {
    $auteur = $base->utilisateur_prenon_nom ($_SESSION['token'], $note['uti_id_auteur']);    
    $usagers = $base->note_usagers_liste ($_SESSION['token'], $note['not_id']);
    $destinataires = $base->note_destinataires_liste_autres ($_SESSION['token'], $note['not_id']);
    
    echo '<tr class="'.($impair ? ' impair' : ' pair').'">';
    echo '<td>'.substr ($note['not_date_evenement'], 0, 16).'<br>'.$auteur.'</td>';
    echo '<td>';
    if ($note['nde_pour_action']) echo 'Action';
    if ($note['nde_pour_information']) echo 'Information';
    if (($note['nde_pour_action'] && !$note['nde_action_faite']) || 
	($note['nde_pour_information'] && !$note['nde_information_lue'])) {
      if ($note['nde_pour_information']) {
	echo '<br><span id="nde_'.$note['nde_id'].'" class="cliquable note_done">Marquer comme lu</span>';
      } else if ($note['nde_pour_action']) {
	echo '<br><span id="nde_'.$note['nde_id'].'" class="cliquable note_done">Marquer comme lu</span>';
      }
    }
    echo '</td>';
    echo '<td>';
    foreach ($usagers as $usager) {
      echo '<span class="lienpersonne" id="lienpersonne_usager_'.$usager['per_id'].'">'.$usager['libelle'].'</span><br>';
    }
    echo '</td>';
    echo '<td>';
    if ($note['not_objet']) {
      echo '<strong>'.$note['not_objet'].'</strong><br>';
    }
    echo $note['not_texte'];
    echo '</td>';
    echo '<td>';
    foreach ($destinataires as $destinataire) {
        if (($note['nde_pour_action'] && !$note['nde_action_faite']) || 
	($note['nde_pour_information'] && !$note['nde_information_lue'])) {
            echo '<b>';
          }
        echo $destinataire.' ';
        if ($destinataire['nde_pour_action']) {
            echo '(A)';
          } else if ($destinataire['nde_pour_information']) {
            echo '(I)';
          }
        if (($note['nde_pour_action'] && !$note['nde_action_faite']) || 
          ($note['nde_pour_information'] && !$note['nde_information_lue'])) {
            echo '</b>';
        }
        echo '<br />';
    }
    echo '</td>';    
    echo '</tr>';
    $impair = !$impair;
  }

  echo '<tr><td class="navigtd" colspan="12" align="center">';
  // Affiche pagination
  $imagesPath = '/Images/navig';
  $nnotes = $nnotes[0]['count'];
  $npages = max (1, ceil($nnotes / NPAGES));
  echo '<div class="navigdiv">';
  if ($p == 1) {
    echo '<img src="'.$imagesPath.'/FirstOff.gif"></img> ';
    echo '<img src="'.$imagesPath.'/PrevOff.gif"></img> ';
  } else {
    echo '<a href="'.link_page (1).'"><img src="'.$imagesPath.'/First.gif"></img></a> ';
    echo '<a href="'.link_page ($p-1).'"><img src="'.$imagesPath.'/Prev.gif"></img></a> ';
  }
  echo '<span class="navign">'.$p." de ".$npages."</span>";
  if ($p == $npages) {
    echo ' <img src="'.$imagesPath.'/NextOff.gif"></img>';
    echo ' <img src="'.$imagesPath.'/LastOff.gif"></img>';
  } else {
    echo ' <a href="'.link_page ($p+1).'"><img src="'.$imagesPath.'/Next.gif"></img></a>';
    echo ' <a href="'.link_page ($npages).'"><img src="'.$imagesPath.'/Last.gif"></img></a>';
  }
  echo '</div>';    
  echo '</td></tr>';
  echo '</table>';
}

function affiche_notes_envoi () {
  global $base;
  $p = isset ($_GET['p']) ? $_GET['p'] : '1';
  $nnotes = $base->notes_note_boite_envoi_liste ($_SESSION['token'], $base->count());
  $notes = $base->notes_note_boite_envoi_liste ($_SESSION['token'], $base->order ('not_date_evenement', 'DESC'), $base->limit (NPAGES, ($p-1)*NPAGES));
  echo '<table width="100%" class="t1"><tr><th width="110">Date</th><th width="150">Usagers</th><th>Note</th><th width="150">Destinataires</th></tr>';
  $impair = true;
  foreach ($notes as $note) {
    $usagers = $base->note_usagers_liste ($_SESSION['token'], $note['not_id']);
    $destinataires = $base->note_destinataires_liste ($_SESSION['token'], $note['not_id']);
    echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
    echo '<td>'.substr ($note['not_date_evenement'], 0, 16).'</td>';
    echo '<td>';
    foreach ($usagers as $usager) {
      echo '<span class="lienpersonne" id="lienpersonne_usager_'.$usager['per_id'].'">'.$usager['libelle'].'</span><br>';
    }
    echo '</td>';
    echo '<td>';
    if ($note['not_objet']) {
      echo '<strong>'.$note['not_objet'].'</strong><br>';
    }
    echo $note['not_texte'];
    echo '</td>';
    echo '<td>';
    foreach ($destinataires as $destinataire) {
      if ($destinataire['nde_supprime']) {
	echo '<s>';
      } else if (($destinataire['nde_pour_action'] && !$destinataire['nde_action_faite']) || 
		 ($destinataire['nde_pour_information'] && !$destinataire['nde_information_lue'])) {
	echo '<b>';
      }
      echo $destinataire['libelle'].' ';
      if ($destinataire['nde_pour_action']) {
	echo '(A)';
      } else if ($destinataire['nde_pour_information']) {
	echo '(I)';
      }
      if ($destinataire['nde_supprime']) {
	echo '</s>';
      } else if (($destinataire['nde_pour_action'] && !$destinataire['nde_action_faite']) || 
		 ($destinataire['nde_pour_information'] && !$destinataire['nde_information_lue'])) {
	echo '</b>';
      }
      echo '<br>';
    }
    echo '</td>';
    echo '</tr>';
    $impair = !$impair;
  }
  echo '<tr><td class="navigtd" align="center" colspan="5">';
  // Affiche pagination
  $imagesPath = '/Images/navig';
  $nnotes = $nnotes[0]['count'];
  $npages = max (1, ceil($nnotes / NPAGES));
  echo '<div class="navigdiv">';
  if ($p == 1) {
    echo '<img src="'.$imagesPath.'/FirstOff.gif"></img> ';
    echo '<img src="'.$imagesPath.'/PrevOff.gif"></img> ';
  } else {
    echo '<a href="'.link_page (1).'"><img src="'.$imagesPath.'/First.gif"></img></a> ';
    echo '<a href="'.link_page ($p-1).'"><img src="'.$imagesPath.'/Prev.gif"></img></a> ';
  }
  echo '<span class="navign">'.$p." de ".$npages."</span>";
  if ($p == $npages) {
    echo ' <img src="'.$imagesPath.'/NextOff.gif"></img>';
    echo ' <img src="'.$imagesPath.'/LastOff.gif"></img>';
  } else {
    echo ' <a href="'.link_page ($p+1).'"><img src="'.$imagesPath.'/Next.gif"></img></a>';
    echo ' <a href="'.link_page ($npages).'"><img src="'.$imagesPath.'/Last.gif"></img></a>';
  }
  echo '</div>';    
  echo '</td></tr>';
  echo '</table>';
}

/* Non utilisé */
function affiche_mesnotes () {
  global $base;
  $grps = $base->utilisateur_groupe_liste ($_SESSION['token']);
  echo '<form method="post" action="'.$_SERVER['REQUEST_URI'].'">';
  echo 'Groupe : <select name="grp"><option value=""></option>';
  foreach ($grps as $grp) {
    $selected = $grp['grp_id'] == $_REQUEST['grp'] ? ' selected' : '';
    echo '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';
  }
  echo '</select>';
  echo '<input type="submit" name="go" value="OK"></input>';
  echo '</form>';
  $notes = $base->notes_note_mesnotes ($_SESSION['token'], $_REQUEST['grp'], NULL);

  echo '<table width="100%" class="t1"><tr><th width="150">Date<br>Expéditeur</th><th width="150">Usagers</th><th>Note</th><th width="150">Destinataires</th></tr>';
  $impair = true;
  foreach ($notes as $note) {     
    $auteur = $base->utilisateur_prenon_nom ($_SESSION['token'], $note['uti_id_auteur']);    
    $usagers = $base->note_usagers_liste ($_SESSION['token'], $note['not_id']);
    $destinataires = $base->note_destinataires_liste_autres ($_SESSION['token'], $note['not_id']);
    echo '<tr class="'.($impair ? 'impair' : 'pair').'">';
    echo '<td>'.substr ($note['not_date_evenement'], 0, 16).'<br>'.$auteur.'</td>';
    echo '<td>';
    foreach ($usagers as $usager) {
      echo '<span class="lienpersonne" id="lienpersonne_usager_'.$usager['per_id'].'">'.$usager['libelle'].'</span><br>';
    }
    echo '</td>';
    echo '<td>';
    if ($note['not_objet']) {
      echo '<strong>'.$note['not_objet'].'</strong><br>';
    }
    echo $note['not_texte'];
    echo '</td>';
    echo '<td>';
    foreach ($destinataires as $destinataire) {
      if (($note['nde_pour_action'] && !$note['nde_action_faite']) || 
	($note['nde_pour_information'] && !$note['nde_information_lue'])) {
            echo '<b>';
          }
        echo $destinataire.' ';
        if ($destinataire['nde_pour_action']) {
            echo '(A)';
          } else if ($destinataire['nde_pour_information']) {
            echo '(I)';
          }
        if (($note['nde_pour_action'] && !$note['nde_action_faite']) || 
          ($note['nde_pour_information'] && !$note['nde_information_lue'])) {
            echo '</b>';
        }
        echo '<br />';
    }
    echo '</td>';
    echo '</tr>';
    $impair = !$impair;
  }
  echo '</table>';

}
?>
<h1>Ma boîte<?= $soustitre ?></h1>
  <?php affiche_notes (); ?>
