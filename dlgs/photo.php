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
<script type="text/javascript" src="/js/uploader.js"></script>
<script type="text/javascript">
$(document).ready (function () {
    $("#photo_envoi").click (function () {
	var up = new uploader ($("#photo_upload").get(0), {
	  url: '/ajax/edit/postPhoto.php?per_id='+$("#per_id").val(),
			progress: function (ev) { $("#progress").html(Math.floor((ev.loaded/ev.total)*100)+'%'); $("#progress").css('width',$("#progress").html()); },
			error: function (ev) {},
			  success: function (ev) {  location.reload (); }
		    });
		    $("#progress").show();
		    up.send ();
	
      });
  });
</script>
<input type="hidden" name="per_id" value='<?php echo $_GET['per_id'] ?>'></input>
<input type="file" name="photo_upload" id="photo_upload"></input><br/><span id="progress" style="display: none">0%</span>
<div style="text-align: center; margin-top: 30px">
   <input type="button" id='photo_envoi' value="Envoyer photo"></input>
</div>
