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
/* Affiche la liste des entrées d'une sélection, pour un champ de liste donné de type selection */
(function ($) {
    $.fn.senSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une valeur",
	    'url': '/ajax/meta_selection_entree_liste_par_cha.php',
	    return: null
	}
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {
		var div = $(this);
		div.empty().append('<ul>');
	    $.getJSON (o.url, { prm_token: $("#token").val(), prm_cha_id: o.cha_id, output: 'json' }, function (data) {
			$.each (data, function (idx, val) {
				div.find('ul').append ('<li id="sen_'+val.sen_id+'">'+val.sen_libelle+'</li>');
			    });
			div.find('li').css ('cursor', 'pointer');
			div.find('li').unbind('click').click (function () {
				var sen_id = $(this).attr('id').substr (4);
				if (typeof o.return == 'function') {
				    o.return.call (this, sen_id);
				    div.dialog('destroy');
				}
			    });
		    });

		div.dialog ({
			title: o.title,
			    width: 450,
			    height: 400,
			    modal: true,
			    resizable: true
		    });
	    });
    }
}) (jQuery);
