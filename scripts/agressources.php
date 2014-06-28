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
<link rel='stylesheet' type='text/css' href='fullcalendar/fullcalendar.css' />
<script type='text/javascript' src='fullcalendar/fullcalendar.js'></script>
<script type='text/javascript' src='jquery/qtip/qtip.min.js'></script>
<script type="text/javascript">
     $(document).ready (function () {

	 $("#calendar").fullCalendar ({
	   header: {
	     left: 'prev,next today',
		 center: 'title',
		 right: 'month,agendaWeek,agendaDay'
		 },

	       eventSources:[ {
	       url: '/ajax/eventsAgressources.php',
		   data: {
		 fromCal: true,
		     code: $("#agr_code").val()
		     }
	       }    
		 ],
	       
	       editable: false,

	       eventRender: function (event, element) {
	       if (event.description) {
		 element.qtip ({ content: event.description, 
		       position: {
		     corner: {
		       target: 'topMiddle',
			   tooltip: 'bottomMiddle'
			   }
		     },
		       style: {
		     name: 'light',
			 tip: "bottomMiddle"
			 }
		   })
		   }
	       if (event.icone) 
		 element.find('.fc-event-title').prepend ('<img align="top" style="float: left" src="'+event.icone+'"></img> ');
	     },	       
	       });		     
       });
</script>

<?php
$agr = $base->events_agressources_get ($_SESSION['token'], $agr_id);
?>

<div id="calendar"></div>
<input type="hidden" id="agr_code" value="<?= urlencode ($agr['agr_code']) ?>"></input>
