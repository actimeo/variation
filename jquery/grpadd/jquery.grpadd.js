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
/* Création d'un groupe dans un établissement donné */
(function ($) {
    $.fn.grpAdd = function (options) {
	var defaults = {
	    "title": "Ajouter un groupe",
	    "eta_id": null,
	    "inf_id": null,
	    "secteur": null,
	    return: null
	}
	
	var o = jQuery.extend (defaults, options);
	
	return this.each (function () {
	    var div = $(this);
	    div.hide ();
	    div.empty();
	    div.append (''+
'<table class="t1">'+
' <tr class="impair"><td>Nom</td><td><input type="text" size="30" id="grpadd_nom"></td></tr>'+
' <tr class="pair">'+
'  <td>Période</td>'+
'  <td>Du <input id="grpadd_du" type="text" class="datepicker" size="10"></input> '+
' au  <input id="grpadd_au" type="text" class="datepicker" size="10"></input>'+
' <tr class="impair"><td>Rôles</td><td><div id="liste_roles"></div></td></tr>'+
' <tr class="pair"><td>Besoins</td><td><div id="liste_besoins"></div></td></tr>'+
' <tr class="impair"><td>Notes</td><td><textarea id="grpadd_notes" rows="5" cols="36"></textarea>' +
' <tr><td colspan="2" align="center" class="navigtd"><button type="button" id="grpadd_save">Enregistrer</button></td></tr>' +
'</table>');

	    $("#grpadd_save").button ({icons: {primary:'ui-icon-disk'}}).click (function () {
		var nom = $("#grpadd_nom").val();
		if (!nom.length) {
		    alert ('Vous devez saisir un nom');
		    return;
		}
		$.getJSON ('/ajax/edit/groupe_add.php', {
		    prm_token: $("#token").val(),
		    prm_nom: nom, 
		    prm_eta_id: o.eta_id,
		    prm_debut: $("#grpadd_du").val(),
		    prm_fin: $("#grpadd_au").val(),
		    prm_notes: $("grpadd_notes").text(),
		    output: 'json2'
		}, function (new_grp_id) {
		    var secs = new Array ();
		    $("#liste_roles input:checked").each (function () {
			secs.push ($(this).attr('id').substr (11));
		    });
		    $("#liste_besoins input:checked").each (function () {
			secs.push ($(this).attr('id').substr (11));
		    });
		    $.post ('/ajax/edit/groupe_secteurs_set.php', {
			prm_token: $("#token").val(),
			prm_grp_id: new_grp_id,
			prm_secteurs: secs
		    }, function () {
			$.post('/ajax/edit/groupe_info_secteurs_set.php', {
			    prm_token: $("#token").val(),
			    prm_grp_id: new_grp_id,
			    prm_inf_id: o.inf_id,
			    prm_secteurs: secs
			}, function () {
			    if (typeof o.return == 'function') {
				o.return.call (this, new_grp_id, nom);
			    }			
			    div.dialog('destroy');
			});
		    });
		});
	    });
	    $(".datepicker").datepicker ({
		showOn: "button",
		buttonImage: "/Images/datepicker.png",
		buttonImageOnly: true,
		showButtonPanel: true,
		changeYear: true,
		showWeek: true,
		gotoCurrent: true
	    });
	    
	    $.getJSON ("/ajax/etablissement_secteur_liste.php", { prm_token: $("#token").val(), prm_eta_id: o.eta_id, prm_est_prise_en_charge: 1, output: 'json2' }, function (data) {
		if (data) {
		    $.each (data, function (idx, val) {
			var ch = val.sec_id == o.secteur ? ' checked disabled' : '';
			$("#liste_roles").append('<input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'+val.sec_code+'" value="'+val.sec_code+'"'+ch+'></input><label for="ed_secteur_'+val.sec_code+'">'+val.sec_nom+'</label><br/>');		    
		    });
		}

		$.getJSON ("/ajax/etablissement_secteur_liste.php", { prm_token: $("#token").val(), prm_eta_id: o.eta_id, prm_est_prise_en_charge: 0, output: 'json2' }, function (data2) {
		    if (data2) {
			$.each (data2, function (idx2, val2) {
			    var ch = val2.sec_id == o.secteur ? ' checked disabled' : '';
			    $("#liste_besoins").append('<input class="ed_secteur_cb" type="checkbox" id="ed_secteur_'+val2.sec_code+'" value="'+val2.sec_code+'"'+ch+'></input><label for="ed_secteur_'+val2.sec_code+'">'+val2.sec_nom+'</label><br/>');
			});
		    }
		    
		    div.show ();
		    div.dialog ({
			title: o.title,
			width: 'auto',
			modal: true,
			resizable: true
		    });

		});
	    });
	});
    }}) (jQuery);
 