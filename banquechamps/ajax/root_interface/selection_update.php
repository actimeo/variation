<?php
require ('../../inc/config.inc.php');
require ('../../inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if (!$_POST['sel_id']) {
  $sel_id = $base->meta_selection_add ($_POST['sel_code'],
				       $_POST['sel_libelle'],
				       $_POST['sel_info']); 
  if (!$sel_id) {
    echo 'ERR'; exit;
  }
} else {
  $sel_id = $_POST['sel_id'];
  $base->meta_selection_update ($sel_id,
				$_POST['sel_code'],
				$_POST['sel_libelle'],
				$_POST['sel_info']); 
}

$anciennes_options = $base->meta_selection_entree_liste ($sel_id);
$anciens_sen = array ();

if ($_POST['options']) {
  $options = explode (';', $_POST['options']);
  $ordre = 1;
  if (count ($anciennes_options)) {
    foreach ($anciennes_options as $ancienne_option) {
      $anciens_sen[$ancienne_option['sen_id']] = 1;
    }
  }
  foreach ($options as $option) {
    if (substr ($option, 0, 4) == 'sen_') {
      $sen_id = substr ($option, 4);
      $base->meta_selection_entree_set_ordre ($sen_id, $ordre);    
      unset ($anciens_sen[$sen_id]);
    } else {
      $sen_id = $base->meta_selection_entree_add ($sel_id, $option, $ordre);
    }
    $ordre++;
  }
}

if (count ($anciens_sen)) {
  foreach ($anciens_sen as $ancien_sen => $nil) {
    $base->meta_selection_entree_supprime ($ancien_sen);
  }
}

echo $sel_id;
?>
