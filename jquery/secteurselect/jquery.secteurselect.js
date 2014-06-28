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
(function ($) {
    $.fn.secteurSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'un secteur",
	    'url': '/',
	    'return': null
	};

	var o = jQuery.extend (defaults, options);
	
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('secteurselect-top');
	    div.empty ().html ('<ul></ul>');
	    $.getJSON (o.url, { }, function (data) {
		$.each (data, function (idx, val) {
		    div.children("ul").append ('<li><div id="secteurselect-divsecteur-'+val.sec_id+'" class="secteurselect-divsecteur"><img width="64" src="'+val.sec_icone.replace (/%d/g, '64')+'"><br/><span>'+val.sec_nom+'</span></div></li>');
		});
		$('.secteurselect-divsecteur').click (function () {
		    if (typeof o.return == 'function') {
			o.return.call (this, $(this).attr('id').substr (25), $(this).children ("span").text());
			div.dialog('destroy');
		    }
		});
		div.dialog ({
		  title: o.title,
		  width: "670px",
		  autoResize: true,
		  modal: true,
			resizable: false
		});
		
	    });
	});
    }
}) (jQuery);
