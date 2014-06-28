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
$erreur = false;
$ok = false;
if (isset ($_POST['ancien_mdp'])) {  
  if ($_POST['mdp1'] != $_POST['mdp2']) {
    $erreur = 'Vous avez saisi des valeurs différentes pour le nouveau mot de passe';
    goto fin_verif;
  }
  if (strlen ($_POST['mdp1']) < 4) {
    $erreur = 'Le nouveau mot de passe doit contenir au moins 4 caractères';
    goto fin_verif;
  }
  $uti_infos = $base->utilisateur_login2 ($_SESSION['uti_login'], $_POST['ancien_mdp']);
  if (!$uti_infos) {
    $erreur = "L'ancien mot de passe n'est pas valide";
    goto fin_verif;
  }
  $_SESSION['token'] = $uti_infos[0]['tok_token'];
  $ok = "Votre nouveau mot de passe est enregistré";
}

fin_verif:
if ($ok) {
  $base->utilisateur_mdp_change ($_SESSION['token'], $_POST['mdp1']);
}
?>

<script type="text/javascript">
  $(document).ready (function () {
  $("#btn_enreg").button ();
});
</script>
<h1>Mon profil</h1>
<style type="text/css">
  label { display: inline-block;width: 150px; text-align: right; }
  fieldset { width: 350px; }
  #buttons { text-align: center; margin-top: 10px;}
  #erreur { text-align: center; margin-top: 10px; color: red; }
  #ok { text-align: center; margin-top: 10px; color: green; }
</style>
<form method="POST" action="/?profil">
  <fieldset><legend> Modifier mon mot de passe </legend>
    <label for="ancien_mdp">Ancien mot de passe : </label>
    <input type="password" name="ancien_mdp" id="ancien_mdp">
    <br>
    <label for="mdp1">Nouveau mot de passe : </label>
    <input type="password" name="mdp1" id="mdp1">
    <br>
    <label for="mdp2">Vérification : </label>
    <input type="password" name="mdp2" id="mdp2">
    <div id="erreur"><?php echo $erreur ?></div>
    <div id="ok"><?php echo $ok ?></div>
    <div id="buttons">
      <button id="btn_enreg" type="submit">Modifier</button>
    </div>
  </fieldset>
</form>
