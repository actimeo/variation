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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
	  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>VARIATION</title>

    <link href="css/default.css" rel="stylesheet" type="text/css" />
    <link href="jquery/css/theme/jquery-ui.css" rel="stylesheet" type="text/css" />

    <script src="jquery/js/jquery.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery.ui.datepicker-fr.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>

    <script src='jquery/qtip/qtip.min.js' type='text/javascript'></script>


    <script src="jquery/grpselect/jquery.grpselect.js" type="text/javascript"></script>
    <script src="jquery/participantselect/jquery.participantselect.js" type="text/javascript"></script>
    <link href="jquery/participantselect/jquery.participantselect.css" rel="stylesheet" type="text/css"></link>
    <script src="jquery/etablissementselect/jquery.etablissementselect.js" type="text/javascript"></script>
    <link href="jquery/etablissementselect/jquery.etablissementselect.css" rel="stylesheet" type="text/css"></link>

    <script src="/js/main.js" type="text/javascript"></script>     
    <script src="/js/all.js" type="text/javascript"></script>     
  </head>
  <body style="padding: 0; margin: 0;background-color: #fff">
   <div style="padding: 10px">
<?php
   if (!$droit) {
  echo '<p style="color: red">Accès interdit</p>';
 exit;
   }
?>
    <input type="hidden" id="per_id" value="<?= $per_id ?>"></input>
    <input type="hidden" id="uti_id" value="<?= $_SESSION['uti_id'] ?>"></input>
    <input type="hidden" id="token" value="<?= $_SESSION['token'] ?>"></input>
    <?php affiche_entete ()?>
   <?php affiche_menu (); ?>
   <div style="margin-left: 140px"><div style="padding: 0 0 0 10px">
   <?php affiche_contenu ($sme_id) ?>   
   </div></div>
   <div id="editdlg"></div>
   </div>
  </body>
</html>
