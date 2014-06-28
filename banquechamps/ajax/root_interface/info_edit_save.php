<?php
require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if ($_POST['inf_id'] != 0) {
  $base->meta_info_update ($_POST['inf_id'], 
			   $_POST['int_id'],
			   $_POST['inf_code'],
			   $_POST['inf_libelle'],
			   $_POST['inf_libelle_complet'],
			   $_POST['inf_etendu'] == 'checked',
			   $_POST['inf_historique'] == 'checked',
			   $_POST['inf_multiple'] == 'checked');
  $inf_id = $_POST['inf_id'];
} else {
  $inf_id = $base->meta_info_add ($_POST['int_id'],
				  $_POST['inf_code'],
				  $_POST['inf_libelle'],
				  $_POST['inf_libelle_complet'],
				  $_POST['inf_etendu'] == 'checked',
				  $_POST['inf_historique'] == 'checked',
				  $_POST['inf_multiple'] == 'checked');
  if (!$inf_id) {
    echo 'ERR';
    exit;
  }
  $base->meta_info_move ($inf_id, substr ($_POST['dirid'], 4));
}

$base->meta_info_aide_set ($inf_id, $_POST['ina_aide']);

$types = $base->meta_infos_type_liste ();
foreach ($types as $type) {
  $thetypes[$type['int_id']] = $type;
}

switch ($thetypes[$_POST['int_id']]['int_code']) {
  case 'contact':
    $base->meta_infos_contact_update ($inf_id, 
				      $_POST['inf__contact_filtre'],
				      $_POST['inf__contact_secteur']
				      );
    break;
  case 'etablissement':
    $base->meta_infos_etablissement_update ($inf_id,
					    $_POST['inf__etablissement_interne'] == 'checked',
					    $_POST['inf__etablissement_secteur']
					    );
    break;
  case 'groupe':
    $base->meta_infos_groupe_update ($inf_id,
				     $_POST['inf__groupe_type'],
				     $_POST['inf__groupe_soustype']);
    break;
  case 'metier':
    $base->meta_infos_metier_update ($inf_id,
				     $_POST['inf__metier_secteur']);
    break;
  case 'selection':
    $base->meta_infos_selection_update ($inf_id,
					$_POST['inf__selection_code']);
    break;
  case 'textelong':
    $base->meta_infos_textelong_update ($inf_id,
					$_POST['inf__textelong_nblignes']);
    break;
  case 'date':
    $base->meta_infos_date_update ($inf_id,
				   $_POST['inf__date_echeance']  == 'checked',
				   $_POST['inf__date_echeance_icone'],
				   $_POST['inf__date_echeance_secteur']
				   );
    break;
}
?>
