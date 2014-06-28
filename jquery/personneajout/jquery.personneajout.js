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
    $.fn.personneAjout = function (options) {
	var defaults = {
	    "title": "Ajout d'une personne",
	    "type": 'usager',
	    "por_id": null,
	    "eta_id": null,
	    'return': null
	}
	var o = jQuery.extend (defaults, options);
	var libelle = { 'usager': "d'un usager",
			'contact': "d'un contact",
			'personnel': "d'un membre du personnel",
			'famille': "d'un membre familial" };
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('personneajout-top');
	    if (o.droit) {
		div.empty().html('<table id="personneajout-champs" width="100%"></table>');
		$.getJSON('/ajax/meta_infos_type_liste.php', {'prm_token': $("#token").val(), 'output': 'json2'}, function (data) {		
		    var inftype = new Array();
		    $.each (data, function (idx, val) {
			inftype[val.int_id] = val.int_code;
		    });
		    $.getJSON('/ajax/meta_info_groupe_obligatoire_liste.php', { 'prm_token': $("#token").val(), 'prm_por_id': o.por_id, 'prm_ent_code': o.type, 'output': 'json2' },
			      function (data) {
				  $.each (data, function (idx, val) {
				      if (inftype[val.int_id] == 'texte') {
					  chp = '<input id="personneajout_info_'+val.inf_code+'" class="personneajout_info_texte personneajout_info" type="text"></input>';
					  
				      } else if (inftype[val.int_id] == 'date') {
					  chp = '<input id="personneajout_info_'+val.inf_code+'" class="personneajout_info_date personneajout_info datepicker" type="text"></input>';
					  
				      } else if (inftype[val.int_id] == 'selection') {
					  chp = '<select id="personneajout_info_'+val.inf_code+'" class="personneajout_info_selection personneajout_info"><option value=""></option></select>';
					  $.getJSON('/ajax/meta_selection_entree_liste.php', { 'prm_token': $("#token").val(), 'prm_sel_id': val.inf__selection_code, 'output': 'json2' }, function (data) {
					      $.each (data, function (idx2, val2) {
						  $("#personneajout_info_"+val.inf_code).append('<option value="'+val2.sen_id+'">'+val2.sen_libelle+'</option>');
					      });
					      div.dialog("option", "position", "center");
					  });
					  
				      } else if (inftype[val.int_id] == 'groupe') {
					  chp = '<select id="personneajout_info_'+val.inf_code+'" class="personneajout_info_groupe personneajout_info"><option value=""></option></select>';
					  if (val.inf__groupe_type == 'prise_en_charge') {
					      $.getJSON('/ajax/prise_en_charge_select.php', { 'prm_token': $("#token").val(), 'prm_eta_id': o.eta_id, 'output': 'json2' }, function (data) {
						  $.each (data, function (idx2, val2) {
						      $("#personneajout_info_"+val.inf_code).append('<option value="'+val2.id+'">'+val2.nom+'</option>');
						  });
						  div.dialog("option", "position", "center");
					      });
					  } else {
					      $.getJSON('/ajax/groupe_filtre.php', { prm_token: $("#token").val(), prm_secteur: val.inf__groupe_type, prm_sec_id: "", prm_interne: true, 'prm_eta_id': o.eta_id, 'output': 'json2' }, function (data) {
						  $.each (data, function (idx2, val2) {
						      $("#personneajout_info_"+val.inf_code).append('<option value="'+val2.grp_id+'">'+val2.grp_nom+'</option>');
						  });
						  div.dialog("option", "position", "center");
					      });					      
					  }
					  chp += ' depuis <input id="personneajout_info_'+val.inf_code+'_depuis" type="text" size="10" class="datepicker">';
					  if (val.ing__groupe_cycle) {
					      chp += ' statut : <select id="personneajout_info_'+val.inf_code+'_statut"></select>';
					  }
					  $.getJSON('/ajax/cycle_statuts.php', {}, function (data) {
					      $.each (data, function (idx2, val2) {
						  $("#personneajout_info_"+val.inf_code+"_statut").append('<option value="'+idx2+'">'+val2+'</option>');
					      });
					  });
				      } else if (inftype[val.int_id] == 'metier') {
					  chp = '<select id="personneajout_info_'+val.inf_code+'" class="personneajout_info_metier personneajout_info"><option value=""></option></select>';
					  $.getJSON('/ajax/metier_liste.php', { 'prm_token': $("#token").val(), 'prm_ent_code': o.type, 'output': 'json2' }, function (data) {
					      $.each (data, function (idx2, val2) {
						  $("#personneajout_info_"+val.inf_code).append('<option value="'+val2.met_id+'">'+val2.met_nom+'</option>');
					      });
					      div.dialog("option", "position", "center");
					  });
					  
				      } else if (inftype[val.int_id] == 'famille') {
					  chp = '<select id="personneajout_info_'+val.inf_code+'" class="personneajout_info_famille personneajout_info"><option value=""></option></select><br>de <select id="personneajout_info_'+val.inf_code+'_usager"><option value=""></option></select>';
					  $.getJSON('/ajax/meta_lien_familial_liste.php', { 'prm_token': $("#token").val(), 'output': 'json2' }, function (data) {
					      $.each (data, function (idx2, val2) {
						  $("#personneajout_info_"+val.inf_code).append('<option value="'+val2.lfa_id+'">'+val2.lfa_nom+'</option>');
					      });					      
					  });
					  $.getJSON('/ajax/personne_cherche.php', { 'prm_token': $("#token").val(), 'prm_nom': '', 'prm_prenom': '', 'prm_type': 'usager', 'output': 'json2' }, function (data) {
					      $.each (data, function (idx2, val2) {
						  $("#personneajout_info_"+val.inf_code+"_usager").append('<option value="'+val2.per_id+'">'+val2.nom_prenom+'</option>');
					      });					      
					  });

				      } else {
					  chp = inftype[val.int_id];
				      }
				      $("#personneajout-champs").append('<tr><td align="right">'+val.inf_libelle+'&nbsp;:</td><td>'+chp+'</td></tr>');
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
				  div.append('<p class="personneajout-erreur">Vous devez renseigner toutes les informations</p>');
				  div.append ('<div class="personneajout-buttons"><button id="personneajout-ajouter">Ajouter</button></div>');
				  $("#personneajout-ajouter").click (function () {
				      var ok = true;
				      var vals = {};
				      $(".personneajout_info").each (function () {
					  var inf_code = $(this).attr('id').substr(19);
					  if ($("#personneajout_info_"+inf_code+"_depuis").length) {
					      // groupe
					      var val = {}
					      val['grp_id'] = $(this).val();
					      val['depuis'] = $("#personneajout_info_"+inf_code+"_depuis").val();
					      if ($("#personneajout_info_"+inf_code+"_statut").length) {
						  // Uniquement si cycle
						  val['statut'] = $("#personneajout_info_"+inf_code+"_statut").val();
					      }
					      if (val['grp_id'] == '' || val['depuis'] == '') {
						  ok = false;
					      } else {
						  vals[inf_code] = val;
					      }
					  } else if ($("#personneajout_info_"+inf_code+"_usager").length) {
					      // famille
					      var val = {}
					      val['lfa_id'] = $(this).val();
					      val['usager'] = $("#personneajout_info_"+inf_code+"_usager").val();
					      if (val['lfa_id'] == '' || val['usager'] == '') {
						  ok = false;
					      } else {
						  vals[inf_code] = val;
					      }
					  } else {
					      var val = $(this).val();
					      if (val == '') {
						  ok = false;
					      } else {
						  vals[inf_code] = val;
					      }
					  }
				      });
				      if (ok) {
					  $.ajax ({ type: 'POST', url: '/ajax/edit/personne_ajoute.php?type='+o.type, data: vals }).done(function () {
					      if (typeof o.return == 'function') {
						  o.return.call (this);
						  div.dialog('destroy');
					      }
					  });
				      } else {
					  $(".personneajout-erreur").show();
				      }
				  });
				  //
				  div.dialog ({
				      title: o.title,
				      width: 'auto',
				      autoResize: true,
				      modal: true,
				      resizable: false,
				  });
			      });
		});   
	    } else {
		// !o.droit
		div.empty().html('<p class="personneajout-texte">Vous ne disposez pas des droits nécessaires à la déclaration '+libelle[o.type]+'.</p><div class="personneajout-buttons"><button id="personneajout-ok">OK</button></div>');
		$("#personneajout-ok").click (function () { div.dialog('destroy'); });
	    }
	});
    }
}) (jQuery);
