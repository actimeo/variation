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
/* Sélectionne un établissement et un groupe, pour un champ de liste donné de type groupe */
(function ($) {
    $.fn.grpSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'un groupe",
	    'url_eta': '/ajax/grpselect_etas.php',
	    'url_grp': '/ajax/groupes_liste.php',
	    return: null
	}
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {
		var div = $(this);
		div.empty();
		div.append('Établissement :<br/><select id="grpselect_eta"><option value=""></option></select>');
		div.append('<br/>Groupe : <br/><select id="grpselect_grp"><option value=""></option></select>');
		div.append ('<div style="text-align: center; margin-top: 15px"><button id="grpselect_ok">OK</button></div>');
		div.find('#grpselect_ok').button ().click (function () {
			if (typeof o.return == 'function') {
			    var retnom = $("#grpselect_eta option:selected").html();
			    if ($("#grpselect_grp").val()) {
				retnom += ' &rarr; '+ $("#grpselect_grp option:selected").html();
			    }
			    o.return.call (this, $("#grpselect_eta").val(), $("#grpselect_grp").val(), retnom);
			    div.dialog('destroy');
			}
		    });
		$.getJSON (o.url_eta, { cha_id: o.cha_id }, function (data) {
			$.each (data, function (idx, val) {
				$("#grpselect_eta").append('<option value="'+val.eta_id+'">'+val.eta_nom+'</option>');
			    });
			$("#grpselect_eta").unbind('change').change (function () {
				$.getJSON (o.url_grp, { prm_cha_id: o.cha_id, prm_eta_id: $(this).val() }, function (data2) {
					$("#grpselect_grp").html('<option value=""></option>');
					$.each (data2, function (idx2, val2) {
						$("#grpselect_grp").append('<option value="'+val2.grp_id+'">'+val2.grp_nom+'</option>');
					    });
				    });
			    });
		    });
		div.dialog ({
			title: o.title,
			    width: 350,
			    height: 200,
			    modal: true,
			    resizable: true
		    });
	    });
    }
}) (jQuery);
