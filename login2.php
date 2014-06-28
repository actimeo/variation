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
require ('inc/config.inc.php');
require ('inc/common.inc.php');
require ('inc/pgprocedures.class.php');
$base = new PgProcedures ($pghost, $pguser, $pgpass, $pgbase);

if (isset ($_GET['from'])) {
  $_SESSION['from'] = $_GET['from'];
}

if (isset ($_GET['quitter'])) {
  $base->fiche_unlock_tout ($_SESSION['token']);
  unset ($_SESSION['uti_id']);
    header('Location: /login2.php');
}

$disabled = '';
$erreur = false;
if (isset ($_POST['connexion'])) {
  if ($_POST['login'] == $editeur_login) {
    $uti_infos = $base->utilisateur_login2 ($_POST['login'], $_POST['mdp']);
    if (count ($uti_infos) == 1) {
      $_SESSION['uti_id'] = '0';
      $_SESSION['uti_root'] = true;
      $_SESSION['uti_config'] = true;
      $_SESSION['eta_id'] = 0;
      $_SESSION['portail'] = '-1';
      $_SESSION['uti_login'] = 'kavarna';
      $_SESSION['token'] = $uti_infos[0]['tok_token'];
      go_back ();
      exit;
    } else {
      $erreur = true;      
    }
  } else if (isset ($_POST['portail'])) {
    echo $_POST['portail'];
    list ($_SESSION['eta_id'], $_SESSION['portail']) = explode (',', $_POST['portail']);
    go_back ();   
    exit;
  } else {
    $uti_infos = $base->utilisateur_login2 ($_POST['login'], $_POST['mdp']);
    //    echo '/'.$uti_infos[0]['uti_pwd_provisoire'].'/';
    if (count ($uti_infos) == 1) {
      $_SESSION['uti_id'] = $uti_infos[0]['uti_id'];
      $_SESSION['token'] = $uti_infos[0]['tok_token'];
      $_SESSION['uti_root'] = $uti_infos[0]['uti_root'];
      $_SESSION['uti_config'] = $uti_infos[0]['uti_config'];
      $_SESSION['eta_id'] = $uti_infos[0]['eta_id'];
      $_SESSION['portail'] = $uti_infos[0]['por_id'];
      $_SESSION['uti_login'] = $_POST['login'];
      $base->fiche_unlock_tout ($_SESSION['token']);
      go_back ();
      exit;
    } else if (count ($uti_infos) > 1) {
      $_SESSION['uti_id'] = $uti_infos[0]['uti_id'];
      $_SESSION['token'] = $uti_infos[0]['tok_token'];
      $_SESSION['uti_root'] = $uti_infos[0]['uti_root'];
      $_SESSION['uti_config'] = $uti_infos[0]['uti_config'];
      $_SESSION['uti_login'] = $_POST['login'];
      $_SESSION['portail'] = '';
      $base->fiche_unlock_tout ($_SESSION['token']);
      $disabled = ' disabled';
    } else {
      $erreur = true;
    }
  }
}

function go_back () {
  if (isset ($_SESSION['from']) && $_SESSION['from'] == 'admin') {
    unset ($_SESSION['from']);
    header('Location: /admin.php');
  } else {
    header('Location: /');
  }
}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
	  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>VARIATION - Identification</title>
    <link href="css/default.css" rel="stylesheet" type="text/css" />
  </head>
  <body style="width: 300px; text-align: center">
    <div style="margin-top: 30px">
      <img src="/Images/logo-text.png"></img>
      <form method="post" action="/login2.php">
	<table class="login" style="width: 300px; margin-top: 50px">
	  <tr><th colspan="2">Identification</th></tr>
	  <tr>
	    <td><label for="login">Nom d'utilisateur</label></td>
	    <td><input type="text" name="login" id="login" value="<?php echo $_SESSION['uti_login'] ?>"<?php echo $disabled ?>></input></td>
	  </tr>
	  <tr>
	    <td><label for="mdp">Mot de passe</label></td>
	    <td><input type="password" name="mdp" id="mdp"<?php echo $disabled ?>></input></td>
	  </tr>
<?php
if (count ($uti_infos) > 1) {
  echo '<tr><td><label for="portail">Portail</td><td><select name="portail">';
  foreach ($uti_infos as $uti_info) {
    $eta = $base->etablissement_get ($_SESSION['token'], $uti_info['eta_id']);
    $por = $base->meta_portail_get ($_SESSION['token'], $eta['cat_id'], $uti_info['por_id']);
    echo '<option value="'.$uti_info['eta_id'].','.$uti_info['por_id'].'">'.$eta['eta_nom'].' / '.$por['por_libelle'].'</option>';
  }
  echo '</select></td></tr>';
}
?>
	  <tr>
	    <td colspan="2" class="foot">
	      <button name="connexion" type="submit">Connexion</button>
	    </td>
	  </tr>
<?php if ($erreur) { ?>
          <tr><td colspan="2" style="text-align: center; color: red">Erreur de connexion</td></tr>
<?php } ?>
	</table>
      </form>
    </div>
  </body>
</html>
<?php

?>
