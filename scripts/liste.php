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
if ((isset ($_GET['export']) && $_GET['export'] == '1') 
    || (isset ($_GET['print']) && $_GET['print'] == '1') 
    || (isset ($_GET['trombi']) && $_GET['trombi'] == 1)) {
  require_once '../inc/config.inc.php';
  require_once '../inc/common.inc.php';
  require_once '../inc/localise.inc.php';
  require_once '../inc/pgprocedures.class.php';
  require_once '../inc/enums.inc.php';
  $base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);
  require_once '../inc/infos/info.class.php';
  $tsm = $base->meta_topsousmenu_get ($_SESSION['token'], $_SESSION['tsm_id']);
  $lis_id = $tsm['tsm_type_id'];
  if ($_GET['export'] == '1') {
    header('Content-type: application/msexcel');
    header('Content-Disposition: attachement; filename="export.xls"'); 
  }
  echo '<html><head><meta http-equiv="content-type" content="text/html; charset=utf-8"></head>';
  if ($_GET['print'] == '1') {
    echo '<body onload="window.print()">';
    echo '<h1>'.$tsm['tsm_titre'].'</h1>';
    echo '<style type="text/css">
    .tableliste {
      border: 1px solid #3D84CC;
      border-collapse: collapse; 
    }
    td, th {
      border: 1px solid #3D84CC;
      padding: 2px;
    }
    th {
      background-color: #ddd;
    }
    table.tableliste td.impair {
      background-color: #F7F7F7;
    }
    table.tableliste td.pair {
      background-color: #EBF2F8;
    }
    </style>';
  } else if ($_GET['trombi'] == 1) {
    echo '<body onload="window.print()">';
  }
} else {
  require_once ('inc/enums.inc.php');
  require_once ('inc/localise.inc.php');
  require_once ('inc/infos/info.class.php');
}

$types = $base->meta_infos_type_liste ($_SESSION['token']);
$type = array ();
foreach ($types as $t) {
  $type[$t['int_id']] = $t;
}

define ('NLIGNES', 10);
$lis = $base->liste_liste_get ($_SESSION['token'], $lis_id);
$champs =  $base->liste_champ_liste ($_SESSION['token'], $lis['lis_id']);
$infos = array ();
foreach ($champs as $champ) {
  $tmp = $base->meta_info_get ($_SESSION['token'], $champ['inf_id']);
  $tmp['champ'] = $champ;

  $t = 'Info_'.$type[$tmp['int_id']]['int_code'];  
  $tmp['obj'] = new $t ($tmp);

  $infos[] = $tmp;
}

$entites = $base->meta_entite_liste ($_SESSION['token']);
$entite = array ();
foreach ($entites as $e) {
  $entite[$e['ent_id']] = $e;
}

// Récupère les valeurs par défaut pour les filtres
if (!isset ($_GET['recherchego']) && !isset ($_GET['col'])) {
  $uti = $base->utilisateur_get ($_SESSION['token'], $_SESSION['uti_id']);
  foreach ($infos as $info) {

    if ($type[$info['int_id']]['int_code'] == 'contact') {	
      if ($info['champ']['cha__contact_filtre_utilisateur']) {
	$_GET['rech-'.$info['inf_code']][] = $uti['per_id'];	
      }
    } else {
      $defauts = $base->liste_defaut_liste ($_SESSION['token'], $info['champ']['cha_id']);
      if (count ($defauts)) {
	foreach ($defauts as $defaut) {
	  
	  if ($type[$info['int_id']]['int_code'] == 'texte') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_texte'];
	    
	  } else if ($type[$info['int_id']]['int_code'] == 'selection') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    
	  } else if ($type[$info['int_id']]['int_code'] == 'statut_usager') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    
	  } else if ($type[$info['int_id']]['int_code'] == 'metier') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	    
	  } else if ($type[$info['int_id']]['int_code'] == 'groupe') {	
	    $_GET['rech-'.$info['inf_code'].'-eta'][] = $defaut['def_valeur_int'];
	    $_GET['rech-'.$info['inf_code'].'-grp'][] = $defaut['def_valeur_int2'];
	  }
	}
      }
    }
  }
} else {
  foreach ($infos as $info) {
    if ($info['champ']['cha_verrouiller']) {
      $defauts = $base->liste_defaut_liste ($_SESSION['token'], $info['champ']['cha_id']);
      if (count ($defauts)) {
	foreach ($defauts as $defaut) {
	  if ($type[$info['int_id']]['int_code'] == 'texte') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_texte'];
	  } else if ($type[$info['int_id']]['int_code'] == 'selection') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	  } else if ($type[$info['int_id']]['int_code'] == 'statut_usager') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	  } else if ($type[$info['int_id']]['int_code'] == 'metier') {	
	    $_GET['rech-'.$info['inf_code']][] = $defaut['def_valeur_int'];
	  } else if ($type[$info['int_id']]['int_code'] == 'groupe') {	
	    $_GET['rech-'.$info['inf_code'].'-eta'][] = $defaut['def_valeur_int'];
	    $_GET['rech-'.$info['inf_code'].'-grp'][] = $defaut['def_valeur_int2'];
	  }
	}
      }
    }
  }  
}

$sql = 'SELECT DISTINCT per_id, ';
$sqlfiltre = '';

foreach ($infos as $info) {  
  if ($info['inf_multiple'])
    continue;
  if (get_class ($info['obj']) == 'Info_groupe')
    continue;
  if (get_class ($info['obj']) == 'Info_date_calcule')
    continue;
  if (get_class ($info['obj']) == 'Info_coche_calcule')
    continue;
  $sql .= $info['obj']->fct()." (".$_SESSION['token'].", per_id, '".pg_escape_string ($info['inf_code'])."') AS ".$info['inf_code'].", ";
  
  if (isset ($_GET['rech-'.$info['inf_code']]) && $_GET['rech-'.$info['inf_code']]) {
    if ($type[$info['int_id']]['int_code'] == 'texte') {
      $parts = array ();
      foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	if ($val)
	  $parts[] = $info['obj']->fct()." (".$_SESSION['token'].", per_id, '".pg_escape_string ($info['inf_code'])."') ilike '%".$val."%'";
      } 
      if (count ($parts))
	$sqlfiltre .= " AND (".implode (' OR ', $parts).' )';

    } else if ($type[$info['int_id']]['int_code'] == 'selection' 
	       || $type[$info['int_id']]['int_code'] == 'statut_usager'
	       || $type[$info['int_id']]['int_code'] == 'contact') {
      $parts = array ();
      foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	if ($val)
	  $parts[] = $info['obj']->fct()." (".$_SESSION['token'].", per_id, '".pg_escape_string ($info['inf_code'])."') = ".$val;
      } 
      if (count ($parts))
	$sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	
    } else if ($type[$info['int_id']]['int_code'] == 'metier') {
      $parts = array ();
      foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	$mets = $base->metier_secteur_metier_liste ($_SESSION['token'], $val);
	$metparts = array ();
	foreach ($mets as $met) {
	  $metparts[] = $met['met_id'];
	}
	$mets = implode (', ', $metparts);
	if ($val)
	  $parts[] = $info['obj']->fct()." (".$_SESSION['token'].", per_id, '".pg_escape_string ($info['inf_code'])."') IN (".$mets.")";
      } 
      if (count ($parts))
	$sqlfiltre .= " AND (".implode (' OR ', $parts).' )';
	
    }
  }
}
$sql = substr ($sql, 0, -2);
if ($entite[$lis['ent_id']]['ent_code'] == 'usager') {
  if ($_SESSION['uti_root']) {
    $sql .= ' FROM personne INNER JOIN personne_etablissement USING (per_id) WHERE eta_id = '.$_SESSION['eta_id'];
  } else {
    $sql .= ' FROM personne INNER JOIN personne_groupe USING (per_id) INNER JOIN login.grouputil_groupe USING(grp_id) INNER JOIN login.utilisateur_grouputil USING(gut_id) WHERE uti_id = '.$_SESSION['uti_id'];
  }
  $sql .= " AND ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
} else {
  $sql .= ' FROM personne';
  $sql .= " WHERE ent_code = '".$entite[$lis['ent_id']]['ent_code']."'";
}
$sql .= $sqlfiltre;

//echo $sql;
$sortcol = isset ($_GET['col']) && $_GET['col'] ? $_GET['col'] : 'nom';
$sortsort = isset ($_GET['sort']) ? $_GET['sort'] : 'ASC';
$sql .= ' ORDER BY '.$sortcol.' '.$sortsort;
$res = $base->execute_sql ($sql);

$res = filtre_groupes ($res);
$res = filtre_multiples ($res);
$count = count ($res);

/* Calcul pour stats, avant de paginer */
if (isset ($_GET['stat'])) {
  switch ($_GET['echelle']) {
  case 'day':
  case 'month':
  case 'year':
    $echelle = $_GET['echelle'];
    break;
  default:
    $echelle = 'month';
  }
  $statinfo = $base->meta_info_get_par_code ($_SESSION['token'], $_GET['stat']);
  if ($statinfo['inf_id']) {
    $stattyp = $type[$statinfo['int_id']]['int_code'];
    if ($stattyp == 'selection') {
      $statnb = array ();
      $stattotal = 0;
      foreach ($res as $re) {
	$statnb[$re[$_GET['stat']]]++;
	$stattotal++;
      }      
    } else if ($stattyp == 'date') {
      $statnb = array ();
      $stattotal = 0;
      foreach ($res as $re) {
	$a = age($re[$_GET['stat']], $echelle, $statinfo['inf__date_echeance']);
	if ($a !== null) {
	  $statnb[$a]++;
	}
	$stattotal++;
      }      
      ksort ($statnb);
    }
  }
}

function age ($date, $type, $echeance) {
  $unite = array ('day' => array ('jour', 'jours'), 
		  'month' => array ('mois', 'mois'),
		  'year' => array ('an', 'ans'));
  if (strlen ($date)) {
    if ($_GET['pivot']) {
      $pivfr = $_GET['pivot'];
      $pivot = substr($pivfr, 6).'-'.substr($pivfr, 3, 2).'-'.substr($pivfr, 0, 2);
    } else {
      $pivot = 'now';
    }
    try {
      $age = DateTime::createFromFormat('Y-m-d', $date)
	->diff(new DateTime($pivot));
    } catch (Exception $e) {
      return null;
    }
    switch ($type) {
    case 'day': $ret = $age->days; break;
    case 'month': $ret = 12*$age->y + $age->m; break;
    case 'year': $ret = $age->y; break;
    }
    if ($echeance && $age->invert)
      $ret = -$ret;
    return $ret;
  } else {
    return null;
  }
}

if (!isset ($_GET['all']) && $lis['lis_pagination_tout']) {
  $_GET['all'] = $lis['lis_pagination_tout'];
}
$all = ( (isset ($_GET['all']) && $_GET['all']) 
	 || isset ($_GET['export']) 
	 || isset ($_GET['print']) 
	 || isset ($_GET['trombi'])) ? true : false;
if (!$all) {
  if (isset ($_GET['p'])) {
    for ($i=0; $i< ($_GET['p']-1)*NLIGNES; $i++) {
      array_shift ($res);
    }
  }
  array_splice ($res, NLIGNES);
}

if (isset ($_GET['trombi']) && $_GET['trombi'] == 1) {
  $nparligne = 9;
  echo '<table>';
  $i = 0;
  foreach ($res as $re) {
    if ($i && !($i%$nparligne)) {
      echo '</tr>';
    }
    if (!($i%$nparligne)) {
      echo '<tr>';
    }
    if (file_exists ($dirbase.'/photos/'.$re['per_id'].'/photo.png')) {
      $url_photo = '/photos/'.$re['per_id'].'/photo.png';
    } else {
      $url_photo = '/photos/0/photo.png';
    }
    echo '<td align="center">';
    echo '<img src="'.$url_photo.'" height="100"></img><br/>';
    echo $base->personne_get_libelle($_SESSION['token'], $re['per_id']);
    echo '</td>';
    $i++;
  }
  echo '</body></html>';
  exit;
}

if ((!isset ($_GET['export']) || $_GET['export'] != '1') && (!isset ($_GET['print']) || $_GET['print'] != 1)) {
?>
<div class="bartool">
<div class="bartoolel" id="liste_recherche" style="cursor: pointer" >
<span class="icone"><img src="/Images/IS_Real_vista_Text/originals/png/NORMAL/32/zoom_32.png"></span><span class="label">Recherche</span></img>
</div>

<div class="bartoolel">
<a href="<?= link_all ('1') ?>"><span class="icone"><img src="/Images/IS_Real_vista_Multimedia/originals/png/NORMAL/32/screen_zoom_in_32.png"></img></span><span class="label">Tous</span></a>
</div>

<div class="bartoolel">
<a href="<?= link_all ('0') ?>"><span class="icone"><img src="/Images/IS_Real_vista_Multimedia/originals/png/NORMAL/32/screen_zoom_out_32.png"></img></span><span class="label">Paginé</span></a>
</div>

<div class="bartoolel">
<a target="_blank" href="<?= link_trombi () ?>"><span class="icone"><img src="/Images/IS_Real_vista_Video_production/originals/png/NORMAL/32/overlay_track_manager_32.png"></img></span><span class="label">Trombinoscope</span></a>
</div>

<div class="bartoolel">
<a href="<?= link_export () ?>"><span class="icone"><img src="/Images/IS_Real_vista_Text/originals/png/NORMAL/32/import_export_excel_32.png"></img></span><span class="label">Export tableur</span></a>
</div>

<!--img src="/Images/IS_Real_vista_Text/originals/png/NORMAL/32/import_export_word_32.png"></img-->

<div class="bartoolel">
<a target="_blank" href="<?= link_print () ?>"><span class="icone"><img src="/Images/IS_Real_vista_Text/originals/png/NORMAL/32/print_32.png"></img></span><span class="label">Impression</span></a>
</div>

<div class="bartoolel" id="ajout_personne" style="cursor: pointer">
<span class="icone"><img src="/Images/IS_real_vista_general/originals/png/NORMAL/32/add_32.png"></img></span><span class="label">Ajouter <?= libelle_entite () ?></span>
</div>
<input type="hidden" id="lis_ent_code" value="<?= $entite[$lis['ent_id']]['ent_code'] ?>"></input>
<input type="hidden" id="uti_id" value="<?= $_SESSION['uti_id'] ?>"></input>
<input type="hidden" id="eta_id" value="<?= $_SESSION['eta_id'] ?>"></input>
<input type="hidden" id="por_id" value="<?= $_SESSION['portail'] ?>"></input>
</div>
<?php 
} 
if (!isset ($_GET['export']) || $_GET['export'] != '1') {
  echo $count;
  switch ($entite[$lis['ent_id']]['ent_code']) {
  case 'usager': echo $count > 1 ? " usagers" : " usager"; break;
  case 'personnel' : echo $count > 1 ? ' personnels' : ' personnel'; break;
  case 'contact': echo $count > 1 ? ' contacts' : ' contact'; break;
  case 'famille': echo $count > 1 ? ' membres de la famille' : ' membre de la famille'; break;
  } 
}
?>
<?php
$unite_echelle = array ('day' => 'de jours',
			'month' => 'de mois',
			'year' => "d'années");
if (isset ($_GET['stat'])) {
  $statinfo = $base->meta_info_get_par_code ($_SESSION['token'], $_GET['stat']);
  if ($statinfo['inf_id']) {
    echo '<fieldset style="margin-bottom: 10px"><legend>Statistiques</legend>';

    if ($stattyp == 'date') {
      echo '<div class="stats_options">';
      echo '<div id="echelle" style="display: inline-block">';
      echo '<a'.($echelle == 'day' ? ' class="ui-state-active"' : '').' href="'.link_echelle ('day').'">Jours</a>';
      echo '<a'.($echelle == 'month' ? ' class="ui-state-active"' : '').' href="'.link_echelle ('month').'">Mois</a>';
      echo '<a'.($echelle == 'year' ? ' class="ui-state-active"' : '').' href="'.link_echelle ('year').'">Années</a>';
      echo '</div>';
      echo '<form type="GET" style="display: inline-block">';
      if ($_GET['tsm'])
	echo '<input type="hidden" name="tsm" value="'.$_GET['tsm'].'"></input>';
      if ($_GET['sort'])
      echo '<input type="hidden" name="sort" value="'.$_GET['sort'].'"></input>';
      if ($_GET['col'])
      echo '<input type="hidden" name="col" value="'.$_GET['col'].'"></input>';
      if ($_GET['echelle'])
      echo '<input type="hidden" name="echelle" value="'.$_GET['echelle'].'"></input>';
      if ($_GET['p'])
      echo '<input type="hidden" name="p" value="'.$_GET['p'].'"></input>';
      if ($_GET['all'])
      echo '<input type="hidden" name="all" value="'.$_GET['all'].'"></input>';
      if ($_GET['stat'])
      echo '<input type="hidden" name="stat" value="'.$_GET['stat'].'"></input>';
      echo '<label for="pivot">Date pour calcul de durée : </label>';
      echo '<input type="text" size="10" class="datepicker" id="pivot" name="pivot" value="'.$_GET['pivot'].'"></input>';
      echo '<input type="submit" value="Modifier"></input>';
      echo '</form>';
      echo '</div>';
    }

    echo '<table class="tabstats" style="width: 350px; float: left;"><tr><th>'.($stattyp == 'date' ? 'Nombre '.$unite_echelle[$echelle].' depuis<br>' : '').$statinfo['inf_libelle'].'</th><th>Nombre d\'usagers</th><th>%</th></tr>';
    foreach ($statnb as $id => $n) {
      if ($stattyp == 'selection') {
	$sen = $base->meta_selection_entree_get ($_SESSION['token'], $id);
	$libelle = $sen['sen_libelle'];
      } else if ($stattyp == 'date') {
	$libelle = $id;
      }
      echo '<tr><td>'.$libelle.'</td><td>'.$n.'</td><td>'.sprintf ("%d", 100*$n/$stattotal).'</td>';
    }
    echo '</table>';
    echo '<div id="chartdiv" style="float: left; height:300px;width:450px;"></div>';
    echo '<script type="text/javascript">'."\n";
    echo <<<EOF
      $(document).ready (function () {
	  $("#echelle").buttonset ();
	  var data = [ 
EOF;
    foreach ($statnb as $id => $n) {
      if ($stattyp == 'selection') {
	$sen = $base->meta_selection_entree_get ($_SESSION['token'], $id);
	$libelle = $sen['sen_libelle'];
      echo "['".$libelle."', ".$n."],\n";
      } else if ($stattyp == 'date') {
	$libelle = $id;
      echo "[".$libelle.", ".$n."],\n";
      }
    }
    if ($stattyp == 'selection') {
      echo <<<EOF
		      ];
	  $.jqplot ('chartdiv', [data], { 
	    seriesDefaults: { 
	      renderer: jQuery.jqplot.PieRenderer,
	      rendererOptions: {
		showDataLabels: true,
		    dataLabels: 'value',
	      }
	    },
		legend: { show:true, location: 'e', background: '#FFFFFF' },
		grid: { background: '#F7F7F7', drawBorder: true, borderWidth: 1.0, borderColor: "#7BA7D2" }
	  });
	});
EOF;
    } else if ($stattyp == 'date') {
      echo <<<EOF
		      ];
    $.jqplot ('chartdiv', [data], {
      seriesDefaults: {
	pointLabels: {
	  show: true,
	      }
	},
	  axes: {
	yaxis: { min: 0}
	}
      });
  });
EOF;
    }
    echo '</script>';
    echo '</fieldset>';
  }
}
?>

<table class="tableliste">
<?php 
  if ($lis['lis_inverse']) {
    affiche_inverse ();
  } else {
    $ncols = affiche_header () ;
    affiche_res (); 
    if (!$all && (!isset ($_GET['export']) || $_GET['export'] != '1') && (!isset ($_GET['print']) || $_GET['print'] != '1'))
      affiche_navigation ($ncols);
  }
?>
</table>
<script type="text/javascript" src="/jquery/jqplot/jquery.jqplot.min.js"></script>
<link href="/jquery/jqplot/jquery.jqplot.min.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/jquery/jqplot/plugins/jqplot.pieRenderer.min.js"></script>
<script type="text/javascript" src="/jquery/jqplot/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="jquery/genericselect/jquery.genericselect.js"></script>
<link href="/jquery/genericselect/jquery.genericselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="jquery/personneajout/jquery.personneajout.js"></script>
<link href="/jquery/personneajout/jquery.personneajout.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready (function () {
    $(".rech-eta").change (on_rech_eta_change);
    $(".rech-plus-texte").click (on_rech_plus_texte_click);
    $(".rech-plus-selection").click (on_rech_plus_selection_click);
    $(".rech-plus-groupe").click (on_rech_plus_groupe_click);
    $(".rech-plus-statut-usager").click (on_rech_plus_statut_usager_click);
    $(".rech-plus-contact").click (on_rech_plus_contact_click);
    $("#ajout_personne").click (on_ajout_personne_click);
    $("#liste_recherche").click (on_liste_recherche_click);
});

function on_rech_eta_change () {
    var inf_id = $(this).attr('id').substr (9);
    var eta_id = $(this).val();
    if (eta_id) {
	$.getJSON ('/ajax/groupes_liste.php', { prm_inf_id: inf_id,
						prm_eta_id: $(this).val() }, 
		   function (data) {
		       var sel = $("#rech-grp-"+inf_id);
		       sel.html('<option value="">(tous)</option>');
		       $.each (data, function (idx, val) {
			   sel.append ('<option value="'+val.grp_id+'">'+val.grp_nom+'</option>');
		       });
		   });
    } else {
	var sel = $("#rech-grp-"+inf_id);
	sel.empty ();
    }
}

function on_rech_plus_texte_click () {
    var inf_id = $(this).attr('id').substr (10);
    var el = this;
    $.getJSON('/ajax/meta_info_get.php', { prm_token: $("#token").val(), prm_inf_id: inf_id, output: 'json2' }, function (data) {
	$(el).parents('.rechtop').next('div').append ('ou<br/><input type="text" name="rech-'+data.inf_code+'[]"></input>');
    });
}

function on_rech_plus_selection_click () {
    var inf_id = $(this).attr('id').substr (10);
    var el = this;
    $.getJSON('/ajax/meta_info_get.php', { prm_token: $("#token").val(), prm_inf_id: inf_id, output: 'json2' }, function (data) {
	$(el).parents('.rechtop').next('div').append ('ou<br/><select name="rech-'+data.inf_code+'[]"><option value="">(tous)</option></select>');
	$.getJSON('/ajax/meta_selection_entree_liste.php', { prm_sel_id: data.inf__selection_code, output: 'json2'},
		  function (data2) {
		      $.each (data2, function (idx, val) {
			  $(el).parents('.rechtop').next('div').find('select:last').append ('<option value="'+val.sen_id+'">'+val.sen_libelle+'</option>');
		      });
		  });
    });
}

function on_rech_plus_contact_click () {
    var inf_id = $(this).attr('id').substr (10);
    var el = this;
    $.getJSON('/ajax/meta_info_get.php', { prm_token: $("#token").val(), prm_inf_id: inf_id, output: 'json2' }, function (data) {
	$(el).parents('.rechtop').next('div').append ('ou<br/><select name="rech-'+data.inf_code+'[]"><option value="">(tous)</option></select>');
	$.getJSON('/ajax/personne_cherche2.php', { prm_token: $("#token").val(), prm_nom: '', prm_prenom: '', prm_type: data.inf__contact_filtre, prm_secteur: data.inf__contact_secteur, output: 'json2'},
		  function (data2) {
		      $.each (data2, function (idx, val) {
			  $(el).parents('.rechtop').next('div').find('select:last').append ('<option value="'+val.per_id+'">'+val.nom_prenom+'</option>');
		      });
		  });
    });
}

function on_rech_plus_statut_usager_click () {
    var inf_id = $(this).attr('id').substr (10);
    var el = this;
    $.getJSON('/ajax/meta_info_get.php', { prm_token: $("#token").val(), prm_inf_id: inf_id, output: 'json2' }, function (data) {
	$(el).parents('.rechtop').next('div').append ('ou<br/><select name="rech-'+data.inf_code+'[]"><option value="">(tous)</option></select>');
	$.getJSON('/ajax/statuts_usager_liste.php', { },
		  function (data2) {
		      $.each (data2, function (idx, val) {
			  $(el).parents('.rechtop').next('div').find('select:last').append ('<option value="'+idx+'">'+val+'</option>');
		      });
		  });
      });
}

function on_rech_plus_groupe_click () {
    var inf_id = $(this).attr('id').substr (10);
    var el = this;
    $.getJSON('/ajax/meta_info_get.php', { prm_token: $("#token").val(), prm_inf_id: inf_id, output: 'json2' }, function (data) {
	var n = 1 + $(el).parents('.rechtop').next('div').find('select').length/2;
	$(el).parents('.rechtop').next('div').append ('ou<br/><select class="rech-eta" id="rech-eta-'+data.inf_id+'-'+n+'" name="rech-'+data.inf_code+'-eta[]"><option value="">(tous)</option></select>');
	$.getJSON ('/ajax/etablissement_listepar_secteur.php', { inf_id: inf_id, output: 'json' }, function (data2) {
	    $.each (data2, function (idx, val) {
		$(el).parents('.rechtop').next('div').find('select:last').append ('<option value="'+val.eta_id+'">'+val.eta_nom+'</option>');
	    });
	    $(el).parents('.rechtop').next('div').find('select:last').change (on_rech_eta_change);

	    $(el).parents('.rechtop').next('div').append ('<select class="rech-grp" id="rech-grp-'+data.inf_id+'-'+n+'" name="rech-'+data.inf_code+'-eta[]"><option value="">(tous)</option></select>');
	});
    });
}

function on_ajout_personne_click () {
  $("#dlg").personneAjout({
      "por_id": $("#por_id").val(),
	"eta_id": $("#eta_id").val(),
	"type": $("#lis_ent_code").val(),
	"droit": <?= $portail['por_droit_ajout_'.$entite[$lis['ent_id']]['ent_code']] ? 'true': 'false' ?>,
	"return": function () { location.reload(); }
    });
  $("#dlg").position();
}

function on_liste_recherche_click () {
  $(".accrecherche").click ();
}
</script>
<?php
// Affichage dans la colonne de gauche

function sup_col_gauche () {
  global $infos, $type, $base, $statuts_usager, $cycle_statuts;
  $ret = "";
  $ret .= '<h3 class="accrecherche accplus">Recherche</h3>';
  $ret .= "<div>";
  $ret .= '<form method="GET" action="/">';
  $ret .= '<input type="hidden" name="tsm" value="'.$_GET['tsm'].'"></input>';
  $ret .= '<input type="hidden" name="col" value="'.(isset ($_GET['col']) ? $_GET['col'] : '').'"></input>';
  $ret .= '<input type="hidden" name="sort" value="'.(isset ($_GET['sort']) ? $_GET['sort'] : '').'"></input>';
  $ret .= '<input type="hidden" name="p" value="'.(isset ($_GET['p']) ? $_GET['p'] : '').'"></input>';
  $ret .= '<input type="hidden" name="all" value="'.(isset ($_GET['all']) ? $_GET['all'] : '').'"></input>';
  $ret .= '<div id="recherche-gauche">';
  
  foreach ($infos as $info) {
    if ($info['champ']['cha_filtrer'] && !$info['champ']['cha_verrouiller']) {


      if ($type[$info['int_id']]['int_code'] == 'texte') {
	// Supprime les valeurs vides
	if (isset ($_GET['rech-'.$info['inf_code']]) && count ($_GET['rech-'.$info['inf_code']])) {
	  foreach ($_GET['rech-'.$info['inf_code']] as $k => $val) {
	    if (!$val)
	      unset ($_GET['rech-'.$info['inf_code']][$k]);
	  }
	}
	// Si aucune valeur, on en met une vide
	if (!isset ($_GET['rech-'.$info['inf_code']]) || !count ($_GET['rech-'.$info['inf_code']]))
	  $_GET['rech-'.$info['inf_code']] = array ('');

	$ret .= '<div class="rechtop"><h3>'.$info['inf_libelle'].'</h3> <span class="rech-plus rech-plus-texte" id="rech-plus-'.$info['inf_id'].'">[+]</span></div><div>';
	$i=0;
	foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	  if ($i > 0)
	    $ret .= 'ou<br/>';
	  $ret .= '<input type="text" name="rech-'.$info['inf_code'].'[]" value="'.$val.'"></input>';
	  $i++;
	}
	$ret .= '</div>';

      } else if ($type[$info['int_id']]['int_code'] == 'contact') {
	$uti = $base->utilisateur_get ($_SESSION['token'], $_SESSION['uti_id']);
	// Supprime les valeurs vides
	if (isset ($_GET['rech-'.$info['inf_code']]) && count ($_GET['rech-'.$info['inf_code']])) {
	  foreach ($_GET['rech-'.$info['inf_code']] as $k => $val) {
	    if (!$val)
	      unset ($_GET['rech-'.$info['inf_code']][$k]);
	  }
	}
	// Si aucune valeur, on en met une vide ou par défaut
	if (!isset ($_GET['rech-'.$info['inf_code']]) || !count ($_GET['rech-'.$info['inf_code']]))
	  $_GET['rech-'.$info['inf_code']] = array ('');
	
	$ret .= '<div class="rechtop"><h3>'.$info['inf_libelle'].'</h3> <span class="rech-plus rech-plus-contact" id="rech-plus-'.$info['inf_id'].'">[+]</span></div><div>';
	$entrees = $base->personne_cherche2 ($_SESSION['token'], NULL, NULL, $info['inf__contact_filtre'], $info['inf__contact_secteur']);
	$i=0;
	foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	  if ($i > 0)
	    $ret .= 'ou<br/>';
	  $ret .= '<select name="rech-'.$info['inf_code'].'[]">';
	  $ret .= '<option value="">(tous)</option>';
	  $selected = ($uti['per_id'] == $val) ? ' selected' : '';
	  $ret .= '<option value="'.$uti['per_id'].'"'.$selected.'>(moi)</option>';
	  foreach ($entrees as $entree) {
	    $selected = ($entree['per_id'] == $val) ? ' selected' : '';
	    $ret .= '<option value="'.$entree['per_id'].'"'.$selected.'>'.$entree['nom_prenom'].'</option>';
	  }
	  $ret .= '</select>';
	  $i++;
	}
	$ret .= '</div>';
            
      } else if ($type[$info['int_id']]['int_code'] == 'selection') {
	// Supprime les valeurs vides
	if (isset ($_GET['rech-'.$info['inf_code']]) && count ($_GET['rech-'.$info['inf_code']])) {
	  foreach ($_GET['rech-'.$info['inf_code']] as $k => $val) {
	    if (!$val)
	      unset ($_GET['rech-'.$info['inf_code']][$k]);
	  }
	}
	// Si aucune valeur, on en met une vide
	if (!isset ($_GET['rech-'.$info['inf_code']]) || !count ($_GET['rech-'.$info['inf_code']]))
	  $_GET['rech-'.$info['inf_code']] = array ('');
	
	$ret .= '<div class="rechtop"><h3>'.$info['inf_libelle'].'</h3> <span class="rech-plus rech-plus-selection" id="rech-plus-'.$info['inf_id'].'">[+]</span></div><div>';
	
	$entrees = $base->meta_selection_entree_liste ($_SESSION['token'], $info['inf__selection_code']);
	$i = 0;
	foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	  if ($i > 0)
	    $ret .= 'ou<br/>';
	  $ret .= '<select name="rech-'.$info['inf_code'].'[]">';
	  $ret .= '<option value="">(tous)</option>';
	  foreach ($entrees as $entree) {
	    $selected = ($entree['sen_id'] == $val) ? ' selected' : '';
	    $ret .= '<option value="'.$entree['sen_id'].'"'.$selected.'>'.$entree['sen_libelle'].'</option>';
	  }
	  $ret .= '</select>';
	  $i++;
	}
	$ret .= '</div>';

      } else if ($type[$info['int_id']]['int_code'] == 'groupe') {
	$ret .= '<div class="rechtop"><h3>'.$info['inf_libelle'].'</h3> <span class="rech-plus rech-plus-groupe" id="rech-plus-'.$info['inf_id'].'">[+]</span></div><div>';
	
	$etas = $base->etablissement_liste_par_secteur ($_SESSION['token'], $info['inf__groupe_type'], $base->order('eta_nom'));
	$etas = filtre_etas ($etas, $info['inf__groupe_type'], $info['inf__groupe_soustype']);

	$filtres = array ();
	// On crée la structure des filtres et on supprime les vides
	foreach ($_GET['rech-'.$info['inf_code'].'-eta'] as $k => $f) {
	  if ($_GET['rech-'.$info['inf_code'].'-eta'][$k] || 
	      $_GET['rech-'.$info['inf_code'].'-grp'][$k])
	    $filtres[] = array ('eta' => $_GET['rech-'.$info['inf_code'].'-eta'][$k],
				'grp' => $_GET['rech-'.$info['inf_code'].'-grp'][$k]);			 
	}
	if (!count ($filtres)) {
	  $filtres = array (array ('eta'=>'', 'grp'=>''));
	}

	$i=0;
	foreach ($filtres as $filtre) {
	  $i++;
	  if ($i > 1)
	    $ret .= 'ou <br/>';
	  $ret .= '<select class="rech-eta" id="rech-eta-'.$info['inf_id'].'-'.$i.'" name="rech-'.$info['inf_code'].'-eta[]">';
	  $ret .= '<option value="">(tous)</option>';
	  foreach ($etas as $eta) {
	    $selected = $eta['eta_id'] == $filtre['eta'] ? ' selected' : '';
	    $ret .= '<option value="'.$eta['eta_id'].'"'.$selected.'>'.$eta['eta_nom'].'</option>';
	  }
	  $ret .= '</select><br/>';

	  if ($filtre['eta']) {
	    $grps = $base->groupe_filtre ($_SESSION['token'], $info['inf__groupe_type'], NULL, NULL, NULL);
	  }
	  $ret .= '<select id="rech-grp-'.$info['inf_id'].'-'.$i.'" name="rech-'.$info['inf_code'].'-grp[]">';
	  if (count ($grps)) {
	    $ret .= '<option value="">(tous)</option>';
	    foreach ($grps as $grp) {
	      if ($grp['eta_id'] != $filtre['eta'])
		continue;
	      $selected = $grp['grp_id'] == $filtre['grp'] ? ' selected' : '';
	      $ret .= '<option value="'.$grp['grp_id'].'"'.$selected.'>'.$grp['grp_nom'].'</option>';	  
	    }
	  }
	  $ret .= '</select><br/>';
	}
	$ret .= '</div>';
	$ret .= 'Statut : <select name="rech-'.$info['inf_code'].'-sta">';
	$ret .= '<option value="">(tous)</option>';
	foreach ($cycle_statuts as $k => $lib) {
	  $selected = $_GET['rech-'.$info['inf_code'].'-sta'] == $k ? ' selected' : '';
	  $ret .= '<option'.$selected.' value="'.$k.'">'.$lib.'</option>';
	}
	$ret .= '</select><br/>';
	$ret .= 'Du <input name="rech-'.$info['inf_code'].'-du'.'" class="datepicker" type="text" size="8" value="'.$_GET['rech-'.$info['inf_code'].'-du'].'"></input><br/>';
	$ret .= 'Au <input name="rech-'.$info['inf_code'].'-au'.'" class="datepicker" type="text" size="8" value="'.$_GET['rech-'.$info['inf_code'].'-au'].'"></input><br/>';
	


      } else if ($type[$info['int_id']]['int_code'] == 'statut_usager') {
	// Supprime les valeurs vides
	if (isset ($_GET['rech-'.$info['inf_code']]) && count ($_GET['rech-'.$info['inf_code']])) {
	  foreach ($_GET['rech-'.$info['inf_code']] as $k => $val) {
	    if (!$val)
	      unset ($_GET['rech-'.$info['inf_code']][$k]);
	  }
	}
	// Si aucune valeur, on en met une vide
	if (!isset ($_GET['rech-'.$info['inf_code']]) || !count ($_GET['rech-'.$info['inf_code']]))
	  $_GET['rech-'.$info['inf_code']] = array ('');
	
	$ret .= '<div class="rechtop"><h3>'.$info['inf_libelle'].'</h3> <span class="rech-plus rech-plus-statut-usager" id="rech-plus-'.$info['inf_id'].'">[+]</span></div><div>';
	
	$entrees = $statuts_usager;
	$i = 0;
	foreach ($_GET['rech-'.$info['inf_code']] as $val) {
	  if ($i > 0)
	    $ret .= 'ou<br/>';
	  $ret .= '<select name="rech-'.$info['inf_code'].'[]">';
	  $ret .= '<option value="">(tous)</option>';
	  foreach ($entrees as $k_entree => $v_entree) {
	    $selected = ($k_entree == $val) ? ' selected' : '';
	    $ret .= '<option value="'.$k_entree.'"'.$selected.'>'.$v_entree.'</option>';
	  }
	  $ret .= '</select>';
	  $i++;
	}
	$ret .= '</div>';
	

      }
      
      
    }
  }

  $ret .= '<div class="rechtop" style="text-align: right; margin-top: 5px;"><input type="submit" name="recherchego" value="Rechercher"></input></div>';
  $ret .= '</div></form>';
  $ret .= '</div>';// accordion
  return $ret;
}

function affiche_header () {
  global $infos, $type, $base;
  echo '<tr>';
  $ret = 0;
  foreach ($infos as $info) {
    if ($info['champ']['cha_verrouiller'])
      continue;
    $ret += $info['obj']->afficheHeader1 ();
  }
  echo '</tr><tr>';
  foreach ($infos as $info) {
    if ($info['champ']['cha_verrouiller'])
      continue;
    $info['obj']->afficheHeader2 ();
  }
  echo '</tr>';
  return $ret;
}

function affiche_res () {
  global $res, $infos, $base, $type, $cycle_statuts;
  $impair = true;
  foreach ($res as $re) {    
    $ppcm = 1;
    foreach ($infos as $info) {
      $ppcm = ppcm2 ($ppcm, $info['obj']->nbValeurs ($re));
    }
    for ($i=0; $i<$ppcm; $i++) {
      echo '<tr>';
      foreach ($infos as $info) {
	if ($info['champ']['cha_verrouiller'])
	  continue;
	$info['obj']->afficheData ($re, $ppcm, $i, $impair ? 'impair' : 'pair');
      }
      echo '</tr>';
    }
    $impair = !$impair;
    //    exit;
  }
}

function affiche_inverse () {
  global $infos, $type, $res;
  foreach ($infos as $info) {
    echo '<tr>';
    $info['obj']->afficheHeader1Inverse ();
    $info['obj']->afficheHeader2Inverse ();
    foreach ($res as $re) {
      $info['obj']->afficheDataInverse ($re);
    }
  }

}

function ajoute_params_recherche ($p) {
  global $infos;
  foreach ($infos as $info) {
    if ($info['champ']['cha_filtrer']) {
      if (isset ($_GET['rech-'.$info['inf_code']]))
	$p['rech-'.$info['inf_code']] = $_GET['rech-'.$info['inf_code']];
      if (isset ($_GET['rech-'.$info['inf_code'].'-eta']))
	$p['rech-'.$info['inf_code'].'-eta'] = $_GET['rech-'.$info['inf_code'].'-eta'];
      if (isset ($_GET['rech-'.$info['inf_code'].'-grp']))
	$p['rech-'.$info['inf_code'].'-grp'] = $_GET['rech-'.$info['inf_code'].'-grp'];
      if (isset ($_GET['rech-'.$info['inf_code'].'-du']))
	$p['rech-'.$info['inf_code'].'-du'] = $_GET['rech-'.$info['inf_code'].'-du'];
      if (isset ($_GET['rech-'.$info['inf_code'].'-au']))
	$p['rech-'.$info['inf_code'].'-au'] = $_GET['rech-'.$info['inf_code'].'-au'];
      if (isset ($_GET['rech-'.$info['inf_code'].'-sta']))
	$p['rech-'.$info['inf_code'].'-sta'] = $_GET['rech-'.$info['inf_code'].'-sta'];
    }
  }
  return $p;
}

function link_sort ($col) {
  if (isset ($_GET['col']) && $_GET['col'] == $col && isset ($_GET['sort']) && $_GET['sort'] == 'ASC')
    $sort = 'DESC';
  else
    $sort = 'ASC';
  $params = array ();
  $params['col'] = $col;
  $params['sort'] = $sort;
  if (isset ($_GET['echelle'])) $params['echelle'] = $_GET['echelle'];
  if (isset ($_GET['p'])) $params['p'] = $_GET['p'];
  if (isset ($_GET['all'])) $params['all'] = $_GET['all'];
  if (isset ($_GET['stat'])) $params['stat'] = $_GET['stat'];
  if (isset ($_GET['pivot'])) $params['pivot'] = $_GET['pivot'];
  $params = ajoute_params_recherche ($params);
  return '/?tsm='.$_GET['tsm']."&".http_build_query ($params);
}


function link_all ($all) {
  $params = array ();
  $params['all'] = $all;
  if (isset ($_GET['echelle'])) $params['echelle'] = $_GET['echelle'];
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  if (isset ($_GET['p'])) $params['p'] = $_GET['p'];
  if (isset ($_GET['stat'])) $params['stat'] = $_GET['stat'];
  if (isset ($_GET['pivot'])) $params['pivot'] = $_GET['pivot'];
  $params = ajoute_params_recherche ($params);
  return '/?tsm='.$_GET['tsm']."&".http_build_query ($params);

}

function link_page ($p) {
  $params = array ();
  $params['p'] = $p;
  if (isset ($_GET['echelle'])) $params['echelle'] = $_GET['echelle'];
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  if (isset ($_GET['all'])) $params['all'] = $_GET['all'];
  if (isset ($_GET['stat'])) $params['stat'] = $_GET['stat'];
  if (isset ($_GET['pivot'])) $params['pivot'] = $_GET['pivot'];
  $params = ajoute_params_recherche ($params);
  return '/?tsm='.$_GET['tsm']."&".http_build_query ($params);
}


function link_stat ($p) {
  $params = array ();
  $params['stat'] = $p;
  if (isset ($_GET['echelle'])) $params['echelle'] = $_GET['echelle'];
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  if (isset ($_GET['all'])) $params['all'] = $_GET['all'];
  if (isset ($_GET['pivot'])) $params['pivot'] = $_GET['pivot'];
  $params = ajoute_params_recherche ($params);
  return '/?tsm='.$_GET['tsm']."&".http_build_query ($params);
}

function link_echelle ($e) {
  $params = array ();
  $params['echelle'] = $e;
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  if (isset ($_GET['all'])) $params['all'] = $_GET['all'];
  if (isset ($_GET['stat'])) $params['stat'] = $_GET['stat'];
  if (isset ($_GET['pivot'])) $params['pivot'] = $_GET['pivot'];
  $params = ajoute_params_recherche ($params);
  return '/?tsm='.$_GET['tsm']."&".http_build_query ($params);
}

function link_trombi () {
  global $p;
  $params = array ();
  $params['trombi'] = '1';
  $params['p'] = $p;
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  $params = ajoute_params_recherche ($params);
  return '/scripts/liste.php?tsm='.$_GET['tsm']."&".http_build_query ($params);
}

function link_export () {
  global $p;
  $params = array ();
  $params['export'] = '1';
  $params['p'] = $p;
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  $params = ajoute_params_recherche ($params);
  return '/scripts/liste.php?tsm='.$_GET['tsm']."&".http_build_query ($params);
}

function link_print () {
  global $p;
  $params = array ();
  $params['print'] = '1';
  $params['p'] = $p;
  if (isset ($_GET['col'])) $params['col'] = $_GET['col'];
  if (isset ($_GET['sort'])) $params['sort'] = $_GET['sort'];
  $params = ajoute_params_recherche ($params);
  return '/scripts/liste.php?tsm='.$_GET['tsm']."&".http_build_query ($params);
}

function affiche_navigation ($ncols) {
  global $count;
  $npages = ceil($count / NLIGNES);
  if ($npages < 1)
    $npages = 1;
  $p = (isset ($_GET['p']) && $_GET['p']) ? $_GET['p'] : '1';
  echo '<tr><td class="navigtd" align="center" colspan="'.$ncols.'">';
  echo '<div class="navigdiv">';
  if ($p == 1) {
    echo '<img src="'.'/Images/navig'.'/FirstOff.gif"></img> ';
    echo '<img src="'.'/Images/navig'.'/PrevOff.gif"></img> ';
  } else {
    echo '<a href="'.link_page (1).'"><img src="'.'/Images/navig'.'/First.gif"></img></a> ';
    echo '<a href="'.link_page ($p-1).'"><img src="'.'/Images/navig'.'/Prev.gif"></img></a> ';
  }
  echo '<span class="navign">'.$p." de ".$npages."</span>";
  if ($p == $npages) {
    echo ' <img src="'.'/Images/navig'.'/NextOff.gif"></img>';
    echo ' <img src="'.'/Images/navig'.'/LastOff.gif"></img>';
  } else {
    echo ' <a href="'.link_page ($p+1).'"><img src="'.'/Images/navig'.'/Next.gif"></img></a>';
    echo ' <a href="'.link_page ($npages).'"><img src="'.'/Images/navig'.'/Last.gif"></img></a>';
  }
  echo '</div>';    
  echo '</td></tr>';
}

function ppcm2($nombre, $nombre2){
  if ($nombre2 == 0)
    $nombre2 = 1;
  $res = $nombre * $nombre2;
  $result = $nombre*$nombre2;
  while($nombre > 1){
    $reste = $nombre % $nombre2;
    if($reste == 0 ){
      $result = $res / $nombre2;
      break;  // sortie quand resultat trouvé
    }
    $nombre = $nombre2;
    $nombre2 = $reste;
  }
  return $result; // retourne le resultat
}

function dates_correspondent ($info, $groupe, $re) {
  global $base;
  // Filtre sur les dates
  if (isset ($_GET['rech-'.$info['inf_code'].'-du']))
    $du1 = $_GET['rech-'.$info['inf_code'].'-du'];
  else
    $du1 = '';
  if (isset ($_GET['rech-'.$info['inf_code'].'-au']))
    $au1 = $_GET['rech-'.$info['inf_code'].'-au'];
  else
    $au1 = '';
  $found = true;
  if ($du1 || $au1) {
    $found = false;
    $du2 = $groupe['peg_debut'];
    $au2 = $groupe['peg_fin'];
    $overlap = $base->periods_overlap ($du1, $au1, $du2, $au2);
    if ($overlap) {
      $found = true;
    }
  }
  return $found;
}


function statut_correspond ($info, $groupe) {
  global $base;
  if (!isset ($_GET['rech-'.$info['inf_code'].'-sta']))
    return true;  
  $sta_filtre = $_GET['rech-'.$info['inf_code'].'-sta'];
  if ($sta_filtre === '')
    return true;
  return $sta_filtre == $groupe['peg_cycle_statut'];
}

function filtre_groupes ($rs) {
  global $infos, $base, $type;
  foreach ($infos as $info) {
    if ($type[$info['int_id']]['int_code'] == 'groupe') {
      // Filtre sur les etabs/groupes
      $filtres = array ();
      // On crée la structure des filtres et on supprime les vides
      if (isset ($_GET['rech-'.$info['inf_code'].'-eta'])) {
	foreach ($_GET['rech-'.$info['inf_code'].'-eta'] as $k => $f) {
	  if ($_GET['rech-'.$info['inf_code'].'-eta'][$k] || 
	      $_GET['rech-'.$info['inf_code'].'-grp'][$k])
	    $filtres[] = array ('eta' => $_GET['rech-'.$info['inf_code'].'-eta'][$k],
				'grp' => $_GET['rech-'.$info['inf_code'].'-grp'][$k]);			 
	}
      }
      if (count ($filtres)) {
	foreach ($rs as $k => $re) {
	  $found = false;
	  $groupes = $base->personne_groupe_liste2 ($_SESSION['token'], $re['per_id'], $info['inf_id']);
	  foreach ($filtres as $filtre) {	    
	    
	    foreach ($groupes as $groupe) {
	      if ($groupe['eta_id'] == $filtre['eta']) {
		if ($filtre['grp']) {
		  if ($groupe['grp_id'] == $filtre['grp']) {
		    if (dates_correspondent ($info, $groupe, $re) && statut_correspond ($info, $groupe))
		      $found = true;		    
		  }
		} else {
		  if (dates_correspondent ($info, $groupe, $re) && statut_correspond ($info, $groupe))
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
  global $infos, $base, $type;
  foreach ($infos as $info) {
    if ($info['inf_multiple']) {
      if (isset ($_GET['rech-'.$info['inf_code']])) {
	$filtres = $_GET['rech-'.$info['inf_code']];
	if (count ($filtres)) {
	  foreach ($filtres as $k => $filtre) {
	    if (!$filtre)
	      unset ($filtres[$k]);
	  }
	}
      } else {
	$filtres = array ();
      }
      $thetype = $type[$info['int_id']]['int_code'];
      if ($thetype != 'selection' && $thetype != 'contact')
	continue;
      if (count ($filtres)) {
	foreach ($rs as $k => $re) {
	  $found = false;
	  $vals = $base->__call ($info['obj']->fct(), array ($_SESSION['token'], $re['per_id'], $info['inf_code']));
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
	  if (!$found) {
	    unset ($rs[$k]);
	  }
	}      
      }
    }
  }
  return $rs;
}

function libelle_entite () {
  global $entite, $lis;
  switch ($entite[$lis['ent_id']]['ent_code']) {
  case 'usager': return 'un usager'; break;
  case 'personnel': return 'un personnel'; break;
  case 'contact': return 'un contact'; break;
  case 'famille': return 'un membre familial'; break;
  }
}
?>
