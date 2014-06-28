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
$(document).ready (function () {
	$(".lienpersonne").click (on_lienpersonne_click);

	var $tabs = $("#maintabs").tabs ({
		tabTemplate: "<li><a href='#{href}'>#{label}</a> <span class='ui-icon ui-icon-close'>X</span></li>",
	    panelTemplate: '<div class="tab_p"></div>',
	    show: function (event, ui) { 
		if (ui.index > 0) {
		    var per = $(ui.panel).attr('id').substr(5);
		    fiche_touch (per);
		}
	    }
	    });
	$("#maintabs span.ui-icon-close").live ("click", function () {
		var index = $( "li", $tabs ).index( $( this ).parent() );
		$tabs.tabs ("remove", index);
		var per = $(this).prev('a').attr('href').substr (6);
		fiche_unlock (per);
	    });
    });

function on_lienpersonne_click (e) {
    var id = $(this).attr('id');
    var parts = id.split ('_');
    var ent = parts[1];
    var per = parts[2];
    $.getJSON('/ajax/personne_get_libelle.php', { prm_token: $("#token").val(), prm_per_id: per, output: 'json2' }, function (data) {
	    on_lien_personne (ent, per, data, !e.shiftKey);
	});
}

function on_lien_personne (ent, per, titre, changeTab) {
    if ($("#tab_p"+per).length) {
	if (changeTab)
	    $("#maintabs").tabs('select', 'tab_p'+per);
    } else {
	$("#maintabs").tabs ('add', "#tab_p"+per, titre);
	if (changeTab)
	    $("#maintabs").tabs('select', 'tab_p'+per);
    }
    $.post('/ajax/fiche_lock.php', { prm_token: $("#token").val(), prm_per_id: per, prm_force: 0}, function (ret) {
	    var loc_id = $(ret).text();
	    if (loc_id > 0) {
		$("#tab_p"+per).html('<iframe width="1035" style="overflow-x: hidden" height="850" frameborder="0" src="/edit.php?ent='+ent+'&per='+per+'&tsm='+$("#tsm_id").val()+'"></iframe>');		
	    } else {
		$.post('/ajax/utilisateur_prenon_nom.php', { prm_token: $("#token").val(), prm_uti_id: -loc_id }, function (retnom) {
		    var nom = $(retnom).text ();
		    if (confirm ("Fiche éditée par "+nom+"\nVoulez-vous tout de même éditer cette fiche ?")) {
			$.post('/ajax/fiche_lock.php', { prm_token: $("#token").val(), prm_per_id: per, prm_force: 1}, function (ret) {
			});
			$("#tab_p"+per).html('<iframe width="1035" style="overflow-x: hidden" height="850" frameborder="0" src="/edit.php?ent='+ent+'&per='+per+'&tsm='+$("#tsm_id").val()+'"></iframe>'); 
		    }
		});
	    }
	});
}

function fiche_unlock (per) {
    $.ajax({ 
	    type: 'POST', 
		url: '/ajax/fiche_unlock.php',
		async: false, 
		data: {prm_token: $("#token").val(), prm_per_id: per }
	});
}

function fiche_touch (per) {
    $.ajax({ 
	    type: 'POST', 
		url: '/ajax/fiche_touch.php',
		async: false, 
		data: {prm_token: $("#token").val(), prm_per_id: per }
	});
}

