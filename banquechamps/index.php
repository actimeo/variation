<?php
header('Content-type: application/json');

require ('inc/config.inc.php');
require ('inc/pgprocedures.class.php');

$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

$uri = $_SERVER['REQUEST_URI'];
if ($uri[0] != '/')
  exit;

$uri = substr ($uri, 1);
$parts = explode ('/', $uri);

if ($parts[0] == 'banquechamps') {
  array_shift ($parts);
}

if (count ($parts) == 0)
  exit;

if (count ($parts) == 1) {
  if ($parts[0] == 'champs') {
    print_r (json_encode (liste_champs ()));
  } else if ($parts[0] == 'dir') {
    print_r (json_encode (liste_dirs ()));
  } else if ($parts[0] == 'selection') {
    print_r (json_encode (liste_selection ()));
  }
} else if (count ($parts) == 3) {
  if ($parts[0] == 'selection' && $parts[2] == 'entree') {
    print_r (json_encode (liste_selection_entrees ($parts[1])));
  } else if ($parts[0] == 'dir' && $parts[1] == 'new') {
    print_r (json_encode (dir_nouveaux ($parts[2])));
  } else if ($parts[0] == 'selection' && $parts[1] == 'new') {
    print_r (json_encode (selection_nouveaux ($parts[2])));
  } else if ($parts[0] == 'champs' && $parts[1] == 'new') {
    print_r (json_encode (champs_nouveaux ($parts[2])));
  }
}

function liste_dirs () {
  return liste_dir_rec (NULL);
}

function liste_dir_rec ($din_id) {
  global $base;
  $dirs = $base->meta_dirinfo_list ($din_id);
  foreach ($dirs as &$dir) {
    $dir['child'] = liste_dir_rec ($dir['din_id']);
  }
  return $dirs;
}

function liste_champs () {
  global $base;
  $infs = $base->meta_info_liste ();
  foreach ($infs as &$inf) {
    $inf['aide'] = $base->meta_info_aide_get ($inf['inf_id']);
  }
  return $infs;
}

function liste_selection () {
  global $base;
  $sels = $base->meta_selection_liste ();
  return $sels;
}

function liste_selection_entrees ($sel_code) {
  global $base;
  $sens = $base->meta_selection_entree_liste_par_code ($sel_code);
  return $sens;
}

function dir_nouveaux ($last_din_id) {
  global $base;
  return $base->meta_dirinfo_nouveaux ($last_din_id);
}

function selection_nouveaux ($last_sel_id) {
  global $base;
  return $base->meta_selection_nouveaux ($last_sel_id);
}

function champs_nouveaux ($last_inf_id) {
  global $base;
  $infs = $base->meta_info_nouveaux ($last_inf_id);
  foreach ($infs as &$inf) {
    $inf['aide'] = $base->meta_info_aide_get ($inf['inf_id']);
  }
  return $infs;
}
?>
