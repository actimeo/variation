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
    $.fn.ficheSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une fiche",
	    'url': '/ajax/fiche_list.php?por=',
	    'return': null,
	}
	var o = jQuery.extend (defaults, options);
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('ficheselect-top');
	    div.empty().html('<div id="ficheselect-frame"></div>');
	    $("#ficheselect-frame").load(o.url+o.por, {}, function () {
		$("#ficheselect-frame").jstree ({
		    "plugins": ['themes', 'html_data', 'ui', 'types'],
		    "types": {
			"types": {
			    "default": {
				"icon": {
				    "image": "/Images/icons/jstree_page.gif"
				}
			    }
			}
		    }
		}).bind("select_node.jstree", function (event, data) {
		    var id = data.rslt.obj.attr("id");
		    if (id != undefined)  {
			o.return.call (this, id);
			div.dialog('destroy');			
		    }
		    }).bind ('dblclick.jstree', function (event) {
			var node = $(event.target).closest("li");
			$("#ficheselect-frame").jstree ("toggle_node", node);
		    })
	    });

	    div.dialog ({
		    title: o.title,
			width: 350,
			autoResize: true,
			modal: true,
			resizable: false
			});
	    });
    }
}) (jQuery);
