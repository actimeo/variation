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
    $.fn.etablissementSelect = function (options) {
	var defaults = {
	    title: 'Choisissez un établissement',
	    url: '/ajax/etablissement_liste.php',
	    sec_code: '',
	    interne: null
	};
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {
	    var div = $(this);
	    div.empty().html ('<div style="margin: 10px"><ul id="etablissementselect-ul"></ul></div>');
	    $.getJSON (o.url, { prm_token: $("#token").val(),
				prm_interne: o.interne, 
				prm_secteur: o.sec_code != null ? o.sec_code : '', 
				output: 'json2' }, function (res) {
			$.each (res, function (idx, val) {
				$("#etablissementselect-ul").append('<li id="etablissementselect-res-'+val.eta_id+'" class="etablissementselect-res">'+val.eta_nom+'</li>');
			    });
			div.find('li').click (function () {
				var id = $(this).attr('id').substr (24);
				if (typeof o.return == 'function') {
				    o.return.call (this, id, $(this).text());
				    div.dialog('destroy');
				}
			    });
		    });
		
		div.dialog ({
			title: o.title,
			    width: 300,
			    height: 300,
			    modal: true,
			    resizable: false
			    });
		
	    });
    }
}) (jQuery);
