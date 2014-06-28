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
    $.fn.participantSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une personne",
	    'url': '/',
	    'return': null,
	    'type': ['usager', 'personnel', 'contact', 'famille'],
	    'secteur': null,
	    'lien_familial': false,
	    'ajout': false, // add a person from the dialog
	    'multi': false // multi-choice
	}
	var o = jQuery.extend (defaults, options);
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('participantselect-top');
	    div.empty().html('<div id="participantselect-frame"><div id="participantselect-typeper"></div></div>');
	    var i = 0;
	    $.each (o.type, function (idx, val) {
		    $('#participantselect-typeper').append ('<nobr><input type="radio" name="participantselect-type" id="participantselect-type-'+val+'" value="'+val+'"'+(i==0 ? ' checked' : '')+'></input> <label for="participantselect-type-'+val+'">'+val+'</label></nobr> ');
		    i++;
	    });
	    
	    $("#participantselect-typeper").buttonset ();

	    if (o.lien_familial) {
		$('#participantselect-frame').append ('<fieldset></fieldset>');
		$('#participantselect-frame fieldset').append ('<div><span class="label">Lien familial : </span><select id="participantselect-lfa"></select></div>');
		$('#participantselect-frame fieldset').append ('<div><strong>Autorité : </strong><br><input type="radio" name="autorite_parentale" value="1" id="autorite_parentale_1" checked="checked"></input><label for="autorite_parentale_1">Autorité parentale</label> <input type="radio" name="autorite_parentale" value="2" id="autorite_parentale_2"></input><label for="autorite_parentale_2">Tutelle</label> <input type="radio" name="autorite_parentale" value="0" id="autorite_parentale_0"></input><label for="autorite_parentale_0">Aucune</label></div>');
		$('#participantselect-frame fieldset').append ('<div><span class="label">Droits : </span><select id="participantselect-droits"></select></div>');
		$('#participantselect-frame fieldset').append ('<div><span class="label">Périodicité : </span><input type="text" size="20" id="participantselect-periodicite"></input></div>');
		$.getJSON ('/ajax/meta_lien_familial_liste.php', { 'prm_token': $("#token").val(), output: 'json2'}, function (data) {
		    $.each (data, function (idx, val) {
			$("#participantselect-lfa").append('<option value="'+val.lfa_id+'">'+val.lfa_nom+'</option>');
		    });
		});
		$("#participantselect-droits").append('<option value=""></option>');
		$.getJSON ('/ajax/lien_familial_droits_liste.php', { output: 'json2'}, function (data) {
		    $.each (data, function (idx, val) {
			$("#participantselect-droits").append('<option value="'+idx+'">'+val+'</option>');
		    });
		});
	    }
	    $('#participantselect-frame').append ('<br/><label class="etiq" for="participantselect-nom">Nom : </label><input type="text" id="participantselect-nom"><br/><label class="etiq" for="participantselect-prenom">Prénom : </label><input type="text" id="participantselect-prenom">');
            if ($('#participantselect-typeper label').first().text()==='usager'){
                $('#participantselect-frame').append('<br/><label class="etiq" for="participantselect-group">Groupe :</label><select name="rech_grp_id" id="participantselect-group"></select>');

                //Modifier le bouton Chercher puis le bouton ok et peut être le bouton tout sélectionner                
                $('#participantselect-group').append('<option value="">(tous groupes)</option>');
                
                $.getJSON('/ajax/groupe_liste_details.php', { prm_token: $("#token").val(), prm_eta_id: $('#eta_id').val(), prm_sec_id_role: '', prm_sec_id_besoin: '', prm_interne_seuls: true, output: 'json2'}, function(data){
                    $.each (data, function (idx, val) {
                        $('#participantselect-group').append('<option value="'+val.grp_id+'">'+val.grp_nom+'</option');
		    });
		});                
            }
	    $('#participantselect-frame').append ('<div id="participantselect-buttons" style="text-align: center; margin-top: 5px"><button id="participantselect-chercher">Chercher</button></div>');
	    if (o.ajout) {
		$("#participantselect-buttons").append('<button id="participantselect-ajout">Ajouter</button>');
	    }
	    div.append('<div id="participantselect-result"></div>');
	    if (o.multi) {
		div.append ('<div id="participantselect-buttons2" style="text-align: center; margin-top: 5px"><button id="participantselect-selectall">Tout sélectionner</button><button id="participantselect-ok">OK</button></div>');
		$("#participantselect-ok").button ({icons: {primary:'ui-icon-check'}}).click (function () {
		    if (typeof o.return == 'function') {
			var pers = new Array ();
			$("#participantselect-result ul input[checked]").each (function () {
			    var per = {};
			    per.id = $(this).parent('li').attr('id').substr (22);
			    per.text = $(this).parent('li').text();
			    pers.push (per);
			});
			var type = $("input[name=participantselect-type]:checked").val();
			o.return.call (this, type, pers,
				       $("#participantselect-lfa").val(), 
				       $("#participantselect-lfa option:selected").html(),
				       $("input[name=autorite_parentale]:checked").val(),
				       $("#participantselect-droits").val(),
				       $("#participantselect-periodicite").val()
				      );
			div.dialog('destroy');
		    }

		});
		$("#participantselect-selectall").button ({icons: {primary:'ui-icon-squaresmall-plus'}}).click (function () {
		    $("#participantselect-result ul input").attr('checked', true);
		});
	    }
	    $("#participantselect-chercher").button ({icons: {primary:'ui-icon-search'}}).click (function () {
		var type = $("input[name=participantselect-type]:checked").val();
		$.getJSON (o.url, { prm_token: $("#token").val(), prm_nom: $("#participantselect-nom").val(), prm_prenom: $("#participantselect-prenom").val(), prm_grp_id:$("#participantselect-group").val(), prm_type: type, prm_secteur: o.secteur, output: 'json' }, function (data) {
		    $("#participantselect-result").html ('<ul></ul>');
		    $.each (data, function (idx, val) {
			if (o.multi) {
			    $("#participantselect-result ul").append ('<li id="participantselect-per-'+val.per_id+'"><input style="pointer-events: none" type="checkbox"></input>'+val.nom_prenom+'</li>');
			} else {
			    $("#participantselect-result ul").append ('<li id="participantselect-per-'+val.per_id+'">'+val.nom_prenom+'</li>');
			}
		    });
		    $("#participantselect-result li").
			css ('cursor', 'pointer').
			click (function () {
			    if (o.multi) {
				var ch = $(this).children('input').attr('checked');
				$(this).children('input').attr('checked', !ch);
			    } else {
				var id = $(this).attr('id').substr (22);
				if (typeof o.return == 'function') {
				    o.return.call (this, id, type, $(this).text(), 
						   $("#participantselect-lfa").val(), 
						   $("#participantselect-lfa option:selected").html(),
						   $("input[name=autorite_parentale]:checked").val(),
						   $("#participantselect-droits").val(),
						   $("#participantselect-periodicite").val()
						  );
				    div.dialog('destroy');
				}
			    }
			});		    		    
		});
	    });
	    if (o.ajout) {
		$("#participantselect-ajout").button ({icons: {primary:'ui-icon-plus'}}).click (function () {
		    var nouveau_nom = $("#participantselect-nom").val();
		    var nouveau_prenom = $("#participantselect-prenom").val();
		    if (!nouveau_nom || !nouveau_prenom) {
			alert ('Vous devez saisir un nom et un prénom');
		    } else {
			var nouveau_type = $("input[name=participantselect-type]:checked").val();
			$.get('/ajax/edit/personne_ajoute_depuis_liste.php', { prm_ent_code: nouveau_type, prm_prenom: nouveau_prenom, prm_nom: nouveau_nom, prm_grp_id_prise_en_charge: null }, function (new_per_id) {
			    $("#participantselect-chercher").click();
			});
		    }
		});
	    }
	    
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
