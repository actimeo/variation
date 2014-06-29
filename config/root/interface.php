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
<script type="text/javascript" src="jquery/jstree/jquery.jstree.js"></script>
<script type="text/javascript" src="jquery/senselect/jquery.senselect.js"></script>
<script type="text/javascript" src="jquery/grpselect/jquery.grpselect.js"></script>
<script type="text/javascript" src="jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="/jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="jquery/iconeselect/jquery.iconeselect.js"></script>
<link href="/jquery/iconeselect/jquery.iconeselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="jquery/genericselect/jquery.genericselect.js"></script>
<link href="/jquery/genericselect/jquery.genericselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
var choix_drop = 'champs';

$(document).ready (function () {
//    $("#outils").hide();
    $("#col2").hide();
    $("#col2principal").hide();
    $("#tree").jstree ({
	"json_data": {
	    "ajax": {
		"url": "/ajax/root_interface/t1.php"
	    }
	},
	"types": {
	    "types": {
		"categorie": {
		    "icon": {
			"image": "/Images/icons/jstree_cat.gif"
		    }
		},
		"portail": {
		    "icon": {
			"image": "/Images/icons/jstree_portail.gif"
		    }
		},
		"principal": {
		    "icon": {
			"image": "/Images/icons/jstree_principal.gif"
		    }
		},
		"topfiche": {
		    "icon": {
			"image": "/Images/icons/jstree_page.gif"
		    }
		},
		"entite": {
		    "icon": {
			"image": "/Images/icons/jstree_entite.gif"
		    }
		},
		"page": {
		    "icon": {
			"image": "/Images/icons/jstree_page.gif"
		    }
		}

	    }
	},
	"contextmenu": {
	    "items": getItems
	},
	"plugins": ["themes", "json_data", "ui", "types","contextmenu" ]
	  }).bind("select_node.jstree", function (event, data) {
	      // `data.rslt.obj` is the jquery extended node that was clicked
	      var rel = data.rslt.obj.attr("rel");
	      if (rel == 'page') {
		  var sme_id = data.rslt.obj.attr("id").substring (4);
		  load_sme (sme_id);
	      } else if (rel == 'topfiche') {
		  var tsm_id = data.rslt.obj.attr("id").substring (4);
		  load_tsm (tsm_id);
	      }
	  }).bind ('dblclick.jstree', function (event) {
	      var node = $(event.target).closest("li");
	      $("#tree").jstree ("toggle_node", node);	      
	  });


    $("#listechamps_rechercher").change (on_listechamps_rechercher_change);
    $("#listechamps_usedonly").change (on_listechamps_usedonly_change);
    $("#listechamps_update").click (on_listechamps_update_click);
    $("#listechamps").jstree ({
	"json_data": {
	    "ajax": {
		"url" : get_listechamps_url
	    }
	},
	"types": {
	    "types": {
		"champ_texte": {
		    "icon": {
			"image": "/Images/icons/jstree_type_texte.png"
		    }
		},
		"champ_selection": {
		    "icon": {
			"image": "/Images/icons/jstree_type_select.jpg"
		    }
		},
		"champ_date": {
		    "icon": {
			"image": "/Images/icons/jstree_type_date.png"
		    }
		},
		"champ_textelong": {
		    "icon": {
			"image": "/Images/icons/jstree_type_textarea.png"
		    }
		},
		"champ_coche": {
		    "icon": {
			"image": "/Images/icons/jstree_type_checkbox.jpg"
		    }
		},
		"champ_contact": {
		    "icon": {
			"image": "/Images/icons/jstree_type_contact.gif"
		    }
		},
		"champ_etablissement": {
		    "icon": {
			"image": "/Images/icons/jstree_type_etablissement.gif"
		    }
		},
		"champ_metier": {
		    "icon": {
			"image": "/Images/icons/jstree_type_metier.gif"
		    }
		},
		"champ_groupe": {
		    "icon": {
			"image": "/Images/icons/jstree_type_groupe.gif"
		    }
		},
		"champ_affectation": {
		    "icon": {
			"image": "/Images/icons/jstree_type_affectation.gif"
		    }
		},
		"champ_famille": {
		    "icon": {
			"image": "/Images/icons/jstree_type_famille.png"
		    }
		},
	    }
	},
	"contextmenu": {
	    "items": getCol3Items
	},
	"plugins": ["themes", "json_data", "ui","types","contextmenu"]
    }).bind("dblclick.jstree", function (event) {
	var node = $(event.target).closest("li");
	var nodetype = node.attr('rel');
	if (nodetype == undefined || nodetype.substring (0, 6) != 'champ_') {
	    $("#tree").jstree ("toggle_node", node);
	} else {
	    info_edite (node.attr('id'));
	}
      }).bind("reopen.jstree", function (event) {
	  $("#listechamps li[rel^='champ_']").draggable ({
	    connectToSortable: choix_drop == 'champs' ? "#lis_champs,.sortable" : ".liste_supp_ul,.sortable",
		helper: "clone",
		revert: "invalid"
		});    	  
	});
    
/*
    $.getJSON ('/ajax/root_interface/champs.php', null, function (data) {
	$("#listechamps").empty ().append ("<ul></ul>");
	$.each (data, function (key, val) {
	    $("#listechamps > ul").append ('<li class="detailchamp"><div id="inf_'+val.inf_id+'" ><h3>'+val.inf_libelle+' ('+val.inf_code+')</h3>'+val.int.int_libelle+'</div></li>');
	});
    });
    */
    
    $("#btn_blocs_fermer").click (function () {
	$(".grpsortable > li > ul").toggle ();
    });

    $("#btn_blocs_nouveau").click (function () {
	if (displayed_sme) {
	    var nom = prompt ("Nom du bloc");
	    if (nom != null) {
		$.post ('/ajax/root_interface/bloc_nouveau.php', { sme_id: displayed_sme, nom: nom }, function () {
		    load_sme (displayed_sme);
		});
	    }
	}
    });    

    $("#tsm_type").change (function () {
	var type = $("#tsm_type").val ();
	$(".tr_type").hide ();
	$(".tr_type_"+type).show ();
	$(".tr_details").hide ();
	$(".tr_details_"+type).show ();
    });

    $("#tsm_save").click (function () {
	var titre = $("#tsm_titre").val();
	var icone = $("#tsm_icone").val();
	var type = $("#tsm_type").val();
	var tsm_sme_id = $("#tsm_sme_id").val();
	var type_id = $("#tsm_type_"+type+"_id").val();
	$.post('/ajax/root_interface/topssmenu_update.php', { tsm_id: displayed_tsm, titre: titre, icone: icone, type: type, type_id: type_id, sme_id_lien_usager: tsm_sme_id });
    });

    $("#tsm_icone_change").click (function () {
	$("#dlg").iconeSelect ({
	  'return': function (path) {
	      $("#tsm_icone_img").attr ('src', path);
	      $("#tsm_icone").val (path);
	    }
	  });
      });
	
    $("#tsm_type_liste_id").change (function () {
	affiche_lis ($(this).val());
    });
    $("#tsm_type_documents_id").change (function () {
	affiche_dos ($(this).val());
    });
    $("#tsm_type_notes_id").change (function () {
	affiche_nos ($(this).val());
    });

    $("#lis_save").click (function () {
	var nom = $("#lis_nom").val();
	var code = $("#lis_code").val();
	var ent_id = $("#liste_ent_id").val();
	var inverse = $("#lis_inverse").is(':checked');
	var pagination_tout = $("#lis_pagination_tout").is(':checked');
	$.post('/ajax/root_interface/liste_update.php', { lis_id: displayed_lis_id, nom: nom, code: code, ent_id: ent_id, inverse: inverse, pagination_tout: pagination_tout }, function () {
	    tsm_type_liste_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#lis_supprime").click (function () {
	$.post('/ajax/root_interface/liste_supprime.php', { lis_id: displayed_lis_id }, function () {
	    tsm_type_liste_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#dos_save").click (function () {
	var nom = $("#dos_titre").val();
	var code = $("#dos_code").val();
	$.post('/ajax/root_interface/documents_update.php', { dos_id: displayed_dos_id, nom: nom, code: code, dty_id: $("#dos_dty_id").val() }, function () {
	    tsm_type_documents_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#dos_supprime").click (function () {
	$.post('/ajax/root_interface/documents_supprime.php', { dos_id: displayed_dos_id }, function () {
	    tsm_type_documents_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#dss_ajoute").click (function () {
	$("#dlg").secteurSelect ({
	    'url': '/ajax/meta_secteur_liste.php?prm_token='+$("#token").val()+'&prm_est_prise_en_charge=null&output=json',
	    'return': function (sec_id, sec_nom) {
		$.getJSON ('/ajax/root_interface/documents_secteur_ajoute.php', { dos_id: displayed_dos_id, sec_id: sec_id }, function () {
		    affiche_dos (displayed_dos_id);
		});
	    }
	});
    });

    $("#nos_save").click (function () {
	var nom = $("#nos_nom").val();
	var the_id = $("#nos_the_id").val();
	$.post('/ajax/root_interface/notes_update.php', { nos_id: displayed_nos_id, nom: nom, the_id: the_id }, function () {
	    tsm_type_notes_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#nos_supprime").click (function () {
	$.post('/ajax/root_interface/notes_supprime.php', { nos_id: displayed_nos_id }, function () {
	    tsm_type_notes_id_update ();
	    load_tsm (displayed_tsm);
	});
    });

    $("#perso_type").click (on_perso_type_click);

    $("#sme_icone_change").click (function () {
	$("#dlg").iconeSelect ({
	  'return': function (path) {
	      $("#sme_icone_img").attr ('src', path);
	      $("#sme_icone").val (path);
	    }
	  });
      });

    $("#sme_type_save").click (on_sme_type_save_click);
    $("#sme_type").change (on_sme_type_change);

    $.getJSON ('/ajax/document_document_type_liste_par_sec_ids.php', { prm_token: $("#token").val(), prm_sec_ids: '', prm_eta_id: '', output: 'json2' }, function (data) {
	$.each (data, function (idx, val) {
	    $("#dos_dty_id").append('<option value="'+val.dty_id+'">'+val.dty_nom+'</option>');
	  });
      });	       
    
    $("#choix_drop").buttonset ();
    $("#drop_champs").click (function () {
	choix_drop = 'champs';
	$("#listechamps li[rel^='champ_']").draggable ({
	  connectToSortable: "#lis_champs,.sortable",
	      helper: "clone",
	      revert: "invalid"
	      });    	      
      });
    $("#drop_champs_supp").click (function () {
	choix_drop = 'champs_supp';
	$("#listechamps li[rel^='champ_']").draggable ({
	  connectToSortable: ".liste_supp_ul,.sortable",
	      helper: "clone",
	      revert: "invalid"
	      });    	          
      });

  });

function tsm_type_liste_id_update () {
    $.getJSON ('/ajax/root_interface/liste_liste.php', {}, function (data) {
	$("#tsm_type_liste_id").empty ().append ('<option value=""></option>');
	$.each (data, function (key, val) {
	    $("#tsm_type_liste_id").append ('<option value="'+val.lis_id+'">'+val.lis_nom+'</option>');
	});
    });
}

function tsm_type_documents_id_update () {
    $.getJSON ('/ajax/root_interface/documents_liste.php', {}, function (data) {
	$("#tsm_type_documents_id").empty ().append ('<option value=""></option>');
	$.each (data, function (key, val) {
	    $("#tsm_type_documents_id").append ('<option value="'+val.dos_id+'">'+val.dos_titre+'</option>');
	});
    });
}

function tsm_type_notes_id_update () {
    $.getJSON ('/ajax/root_interface/notes_liste.php', {}, function (data) {
	$("#tsm_type_notes_id").empty ().append ('<option value=""></option>');
	$.each (data, function (key, val) {
	    $("#tsm_type_notes_id").append ('<option value="'+val.nos_id+'">'+val.nos_nom+'</option>');
	});
    });
}


function on_perso_type_click () {
  var evs_id = $("#tsm_type_event_id").val();
  var evs_nom = $("#tsm_type_event_id option:selected").text();
  $("#dlg").genericSelect ({
    'title': "Sélection d'un type",
	'url': '/ajax/events_event_type_list_par_evs.php?prm_token='+$("#token").val()+'&output=json2',
	'params': { prm_evs_id: evs_id },
	'return': function (id, nom) {
	$.getJSON('/ajax/events_events_copie_et_ajoute_type.php', { prm_token: $("#token").val(), prm_evs_id: evs_id, prm_ety_id: id, output: 'json2' },
		  function (data) {
		    var new_evs = data;
		    $("#tsm_type_event_id").append('<option value="'+new_evs+'">'+evs_nom+' '+nom+'</option>');
		    $("#tsm_type_event_id").val (new_evs);
		  });
      }
    });
}

function on_sme_type_change (v) {
    var sme_type = $("#sme_type").val();
    if (sme_type == '') {
	$("#sme_type_id_div").hide ();
    } else {
	$("#sme_type_id_div").show ();
	if (sme_type == 'documents') {
	    $.getJSON('/ajax/document_documents_liste.php', { prm_token: $("#token").val(), output: 'json2'}, function (data) {
		$("#sme_type_id").empty().append('<option value=""></option>');
		$.each (data, function (idx, val) {
		    var selected = val.dos_id == v ? 'selected ' : '';
		    $("#sme_type_id").append ('<option '+selected+'value="'+val.dos_id+'">'+val.dos_titre+'</option>');
		});
	    });
	} else if (sme_type == 'event') {
	  $.getJSON('/ajax/events_events_list.php', { prm_token: $("#token").val(), output: 'json2'}, function (data) {
		$("#sme_type_id").empty().append('<option value=""></option>');
		$.each (data, function (idx, val) {
		    var selected = val.evs_id == v ? 'selected ' : '';
		    $("#sme_type_id").append ('<option '+selected+'value="'+val.evs_id+'">'+val.evs_titre+'</option>');
		});
	    });	    
	} else if (sme_type == 'notes') {
	  $.getJSON('/ajax/notes_notes_liste.php', { prm_token: $("#token").val(), output: 'json2'}, function (data) {
		$("#sme_type_id").empty().append('<option value=""></option>');
		$.each (data, function (idx, val) {
		    var selected = val.nos_id == v ? 'selected ' : '';
		    $("#sme_type_id").append ('<option '+selected+'value="'+val.nos_id+'">'+val.nos_nom+'</option>');
		});
	    });	    
	}
    }
}

function on_sme_type_save_click () {
    $.getJSON('/ajax/root_interface/meta_sousmenu_set_type.php', { 
      prm_token: $("#token").val(),
	prm_sme_id: displayed_sme, 
	prm_type: $("#sme_type").val(),
	  prm_type_id: $("#sme_type_id").val(),
	  prm_icone: $("#sme_icone").val()
    }, function () {
	load_sme(displayed_sme);
    });
}

var displayed_sme = null;
function load_sme (sme_id) {
    displayed_sme = sme_id;
    $("#detailpage").empty();
    $("#col2principal").hide();
    $("#col2").show();
    $("#outils").show();

    $.getJSON('/ajax/meta_sousmenu_infos.php', { prm_token: $("#token").val(), prm_sme_id: sme_id, output: 'json2' }, function (sme) {
	$("#sme_icone").val (sme.sme_icone);
	if (sme.sme_icone) {
	  $("#sme_icone_img").attr ("src", "/"+sme.sme_icone);
	} else {
	  $("#sme_icone_img").attr ('src', '');
	}
	$("#sme_type").val (sme.sme_type);
	on_sme_type_change (sme.sme_type_id);
	if (sme.sme_type == null) {
	    $("#corbeille").show();
	    $("#btn_blocs_fermer").show();
	    $("#btn_blocs_nouveau").show();
	    $.getJSON('/ajax/root_interface/t2.php', { 'sme_id': sme_id}, function (data) {
		$("#detailpage").append ('<ul class="grpsortable"></ul>');
		$.each (data, function (key, val) {
		    $("#detailpage > ul").append ('<li id="topgin_'+val.gin_id+'"></li>');
		    $("#detailpage > ul > li:last").append ("<h2>"+val.gin_libelle+"</h2>");
		    $("#detailpage > ul > li:last").append ('<ul class="sortable" id="gin_'+val.gin_id+'"></ul>');
		    if (val.infos) {
			$.each (val.infos, function (key2, val2) {
			    var champs_supp = '';
			    var checked;
			    if (val2.int.int_code == 'texte' || 
				val2.int.int_code == 'date' || 
				val2.int.int_code == 'selection' || 
				val2.int.int_code == 'groupe' || 
				val2.int.int_code == 'metier' ||
				val2.int.int_code == 'famille') {
			      checked = val2.ing.ing_obligatoire ? ' checked' : '';
			      champs_supp += '<div><input class="ing_obligatoire" id="ing_obligatoire_'+val2.ing_id+'" type="checkbox"'+checked+'></input><label for="ing_obligatoire_'+val2.ing_id+'">Utiliser dans la popup d\'ajout de personne</label></div>';
			    }
			    if (val2.int.int_code == 'groupe') {
			      checked = val2.ing.ing__groupe_cycle ? ' checked' : '';
				champs_supp += '<div><input class="ing__groupe_cycle" id="ing__groupe_cycle_'+val2.ing_id+'" type="checkbox"'+checked+'></input><label for="ing__groupe_cycle_'+val2.ing_id+'">Utilisation du cycle</label></div>';
			    }
			    $("#detailpage > ul > li:last > .sortable").append ('<li id="ing_'+val2.ing_id+'"><div class="detailchamp"><h3>'+val2.inf_libelle+' ('+val2.inf_code+')</h3>'+val2.int.int_libelle+champs_supp+'</div></li>');
			    
			});
		    } else {
			$("#detailpage > ul > li:last > .sortable").append ('<li>&nbsp;</li>');
		    }
		});
		
		$(".ing_obligatoire").click (function () {
		    var ing_id = $(this).attr('id').substr (16);
		    var val = $(this).is(':checked');
		    $.post('/ajax/root_interface/ing_obligatoire_set.php', {
			ing_id: ing_id,
			val: val
		    });
		});

		$(".ing__groupe_cycle").click (function () {
		    var ing_id = $(this).attr('id').substr (18);
		    var val = $(this).is(':checked');
		    $.post('/ajax/root_interface/ing__groupe_cycle_set.php', {
			ing_id: ing_id,
			val: val
		    });
		});
		
		$(".grpsortable").sortable ({
		    revert: "invalid",
		    connectWith: $("#corbeille"),
		    update: function (event, ui) {
			$.post ('/ajax/root_interface/grpupdate.php', { 
			    sme_id: displayed_sme,
			    list: $(this).sortable('toArray').toString() }, function () {
				load_sme (displayed_sme);
			    });
		    }
		});
		
		$(".grpsortable > li > h2").dblclick (function () {
		    $(this).next('ul').toggle ();
		});
		
		$(".sortable").sortable ({
		    revert: "invalid",
		      placeholder: 'sortable_act',
		      forcePlaceholderSize: true,
		    connectWith: ".sortable",
		    update: function (event, ui) {
			if(this.id == 'corbeille') {
			    // Remove the element dropped on #corbeille
			    $('#'+ui.item.attr('id')).remove();
			    $.post('/ajax/root_interface/update.php', { gin_id: 0, list: ui.item.attr('id')}, function () {
				//load_sme (displayed_sme);
			    });
			} else {
			    if (ui.item.id == undefined) { // dragged & dropped depuis champs disponibles
				var inf_id = ui.item.attr('myid');
				ui.item.attr('id', inf_id);
			    }
			    // Update code for the actual sortable lists
			    $.post ('/ajax/root_interface/update.php', { 
				gin_id: this.id.substring (4),
				list: $(this).sortable('toArray').toString() }, function () {
				    load_sme (displayed_sme);
				});
			} 
		    }
		});

		$("#listechamps li[rel^='champ_']").draggable ({
		  connectToSortable: choix_drop == 'champs' ? "#lis_champs,.sortable" : ".liste_supp_ul,.sortable",
		    helper: "clone",
		    revert: "invalid"
		});    
	    });    
	} else {
	    $("#corbeille").hide();
	    $("#btn_blocs_fermer").hide();
	    $("#btn_blocs_nouveau").hide();

	}
    });
}

var displayed_tsm = null;
function load_tsm (tsm_id) {
    displayed_tsm = tsm_id;
    $("#col2").hide();
//    $("#outils").hide();
    $("#col2principal").show ();
    $.getJSON('/ajax/root_interface/t3.php', { 'tsm_id': tsm_id}, function (data) {
	$("#tsm_icone").val (data.tsm_icone);
	if (data.tsm_icone) {
	  $("#tsm_icone_img").attr ("src", "/"+data.tsm_icone);
	} else {
	  $("#tsm_icone_img").attr ('src', '');
	}
	$("#tsm_titre").val (data.tsm_titre);
	$("#tsm_type").val (data.tsm_type);
	$(".tr_type").hide ();
	$(".tr_type_"+data.tsm_type).show ();
	$(".tr_details").hide ();
	$(".tr_details_"+data.tsm_type).show ();
	
	$("#tsm_type_groupe_id").val ('');
	$("#tsm_type_liste_id").val ('');
	$("#tsm_type_event_id").val ('');
	$("#tsm_type_agressources_id").val ('');

	if (data.tsm_type == 'groupe') {
	    $("#tsm_type_groupe_id").val (data.tsm_type_id);
	} else if (data.tsm_type == 'liste') {
	    $("#tsm_type_liste_id").val (data.tsm_type_id);
	    var lis_id = data.tsm_type_id;
	    affiche_lis (lis_id);	    
	} else if (data.tsm_type == 'documents') {
	    $("#tsm_type_documents_id").val (data.tsm_type_id);
	    var dos_id = data.tsm_type_id;
	    affiche_dos (dos_id);	    
	} else if (data.tsm_type == 'event') {
	    $("#tsm_type_event_id").val (data.tsm_type_id);
	} else if (data.tsm_type == 'notes') {
	    $("#tsm_type_notes_id").val (data.tsm_type_id);
	    var nos_id = data.tsm_type_id;
	    affiche_nos (nos_id);	    
	} else if (data.tsm_type == 'agressources') {
	    $("#tsm_type_agressources_id").val (data.tsm_type_id);
	}

	$.getJSON('/ajax/meta_sousmenus_liste_depuis_topmenu.php', { prm_token: $("#token").val(), prm_tom_id: data.tom_id, prm_ent_code: 'usager', output: 'json2' }, function (data2) {
	    var ancien_men_id = 0;
	    $("#tsm_sme_id").html('<option value=""></option>');
	    $.each (data2, function (key, val) {
		if (val.men_id != ancien_men_id) {
		  $("#tsm_sme_id").append ('<optgroup label="'+val.men_libelle+'"></optgroup>');
		  ancien_men_id = val.men_id;
		}
		$("#tsm_sme_id optgroup:last-child").append ('<option value="'+val.sme_id+'">'+val.sme_libelle+'</option>');
	      });
	    $("#tsm_sme_id").val (data.sme_id_lien_usager);
	  });
    });
}

var displayed_lis_id = null;
function affiche_lis (lis_id) {
    $.getJSON ('/ajax/root_interface/liste_get.php', { lis_id: lis_id }, function (data) {
	displayed_lis_id = lis_id;
	$("#lis_nom").val (data.lis_nom);
	$("#lis_code").val (data.lis_code);
	$("#liste_ent_id").val (data.ent_id);
	if (data.lis_inverse) 
	    $("#lis_inverse").attr('checked', 'checked');
	else
	    $("#lis_inverse").removeAttr('checked');
	if (data.lis_pagination_tout) 
	    $("#lis_pagination_tout").attr('checked', 'checked');
	else
	    $("#lis_pagination_tout").removeAttr('checked');
    });
    $.getJSON ('/ajax/root_interface/liste_champs_liste.php', { lis_id: lis_id }, function (data) {
	$("#lis_champs").empty();
	if (data != null) {
	    $.each (data, function (key, val) {
		var str = '<li id="cha_'+val.cha_id+'"><div class="detailchamp">';
		str += '<b>'+val.inf_libelle+'</b> ('+val.int_libelle+') <span class="cha_supprimer" id="cha_supp_'+val.cha_id+'">enlever</span><br/>';
		str += 'Entête : '+(val.cha_libelle ? val.cha_libelle : '<i>identique</i>')+' <span class="cha_libelle_mod" id="cha_libelle_mod_'+val.cha_id+'">modifier</span><br/>';
		if (val.int_code == 'groupe') {
		    str += '<input type="checkbox" '+(val.cha__groupe_contact ? ' checked ' : '')+' class="cha_contact" id="cha_contact_'+val.cha_id+'"></input><label for="cha_contact_'+val.cha_id+'">Afficher contact</label><br/>';
		    str += '<input type="checkbox" '+(val.cha__groupe_cycle ? ' checked ' : '')+' class="cha_cycle" id="cha_cycle_'+val.cha_id+'"></input><label for="cha_cycle_'+val.cha_id+'">Afficher cycle</label><br/>';
		    str += '<input type="checkbox" '+(val.cha__groupe_dernier ? ' checked ' : '')+' class="cha_dernier" id="cha_dernier_'+val.cha_id+'"></input><label for="cha_dernier_'+val.cha_id+'">Afficher dernier uniquement</label><br/>';
		}
		if (val.int_code == 'famille') {
		    str += '<input type="checkbox" '+(val.cha__famille_details ? ' checked ' : '')+' class="cha_details" id="cha_details_'+val.cha_id+'"></input><label for="cha_details_'+val.cha_id+'">Afficher les droits</label><br/>';
		}

		if (val.int_code == 'selection' || val.int_code == 'statut_usager' || val.int_code == 'metier' || (val.inf_multiple == false && (val.int_code == 'texte' || val.int_code == 'groupe'))) {
		  str += '<input type="checkbox" '+(val.cha_filtrer ? 'checked' : '')+' class="cha_filtrer" id="cha_filtrer_'+val.cha_id+'"></input><label for="cha_filtrer_'+val.cha_id+'">Filtrer</label></br/>';
		  if (val.cha_filtrer && val.defauts != null) {
		    $.each (val.defauts, function (key2, val2) {
			switch (val.int_code) {
			case 'texte':
			  str += '<span class="defaut" id="def_'+val2.def_id+'"><nobr><span>'+val2.def_valeur_texte+'</span></nobr></span>';
			  break;
			case 'selection':
			case 'statut_usager':
			case 'metier':
			  str += '<span class="defaut" id="def_'+val2.def_id+'"><nobr><span>'+val2.def_valeur_selection+'</span></nobr></span>';
			  break;
			case 'groupe':
			  str += '<span class="defaut" id="def_'+val2.def_id+'"><nobr><span>'+val2.def_valeur_groupe+'</span></nobr></span>';
			  break;
			}
		      });
		  }
		  if (val.cha_filtrer) {
		    str += '<span id="def_ajout_'+val.cha_id+'" class="def_ajout def_ajout_'+val.int_code+'"><nobr>Ajouter val. par défaut</nobr></span><br/>';
		  }
		  if (val.cha_filtrer && val.defauts != null) {
		    str += '<input type="checkbox" '+(val.cha_verrouiller ? 'checked' : '')+' class="cha_verrouiller" id="cha_verrouiller_'+val.cha_id+'"></input><label for="cha_verrouiller_'+val.cha_id+'">Verrouiller</label>';
		  }
		  
		} 
		
		if (val.int_code == 'contact') {
		  
		  str += '<input type="checkbox" '+(val.cha_filtrer ? 'checked' : '')+' class="cha_filtrer" id="cha_filtrer_'+val.cha_id+'"></input><label for="cha_filtrer_'+val.cha_id+'">Filtrer</label></br/>';
                  if (val.cha_filtrer) {
		    str += '<input type="checkbox" '+(val.cha__contact_filtre_utilisateur ? 'checked' : '')+' class="cha__contact_filtre_utilisateur" id="cha__contact_filtre_utilisateur_'+val.cha_id+'"></input><label for="cha__contact_filtre_utilisateur_'+val.cha_id+'">valeur par défaut : utilisateur connecté</label></br/>';  
		  }
                }
		
		if (val.int_code == 'famille' || val.int_code == 'contact') {
		  suppstr = '';
		  if (val.supp != null) {
		    $.each (val.supp, function (key2, val2) {
			suppstr += '<li id="inf_'+val2.inf_id+'">'+val2.inf_libelle+' <span class="supp_supprimer" id="supp_supprimer_'+val.cha_id+'_'+val2.inf_id+'">enlever</span></li>';
		      });
		  }
		  str += '<input type="checkbox" '+(val.cha_champs_supp ? ' checked ' : '')+' class="cha_champs_supp" id="cha_champs_supp_'+val.cha_id+'"></input><label for="cha_champs_supp_'+val.cha_id+'">Afficher les détails</label><br/><div'+(val.cha_champs_supp ? '' : ' style="display: none"')+' class="liste_supp">Placer champs suppp ici<ul class="liste_supp_ul" id="liste_supp_'+val.cha_id+'">'+suppstr+'</ul></div>';
		}

		str += '</div></li>';
		
		$("#lis_champs").append (str);		
	      });
	    
	    $(".cha_champs_supp").change (function () {
		if ($(this).is(':checked')) {
		  $(this).nextAll('.liste_supp').show ();
		} else {
		  $(this).nextAll('.liste_supp').hide();
		}		
	      });
	    $(".liste_supp_ul").sortable ({
	      revert: "invalid",
		  placeholder: "liste_supp_act",
		  forcePlaceholderSize: true,
		  update: function (event, ui) {		
		    var inf_id = ui.item.attr('myid');
		    ui.item.attr('id', inf_id);
		    $.post ('/ajax/root_interface/supupdate.php', { 
		      cha_id: this.id.substring(11),
			  list: $(this).sortable('toArray').toString() }, function () {
			affiche_lis (displayed_lis_id);
		      });
		}
	      });		  
	    
	    $(".defaut").unbind('click').click (function () {
		$.getJSON('/ajax/root_interface/defaut_supprime.php', { prm_def_id: $(this).attr('id').substr (4) }, function () {
		    affiche_lis (displayed_lis_id);		    
		});
	    });
	    $(".def_ajout_texte").unbind('click').click (function () {
		var cha_id = $(this).attr('id').substr (10);
		var val;
		if ( (val = prompt ()) ) {
		    $.getJSON ('/ajax/root_interface/defaut_ajoute_texte.php', { prm_cha_id: cha_id, prm_val: val }, function () {
			affiche_lis (displayed_lis_id);
		    });
		}
	    });
	    $(".def_ajout_selection").unbind('click').click (function () {
		var cha_id = $(this).attr('id').substr (10);
		$("#dlg").senSelect ({
		    'cha_id': cha_id,
		    'return': function (sen_id) {
			$.getJSON ('/ajax/root_interface/defaut_ajoute_selection.php', { prm_cha_id: cha_id, prm_val: sen_id }, function () {
			    affiche_lis (displayed_lis_id);
			});
		    }
		});
	    });
	    $(".def_ajout_statut_usager").unbind('click').click (function () {
		var cha_id = $(this).attr('id').substr (10);
		$("#dlg").genericSelect ({
		  'title': "Sélection d'un statut",
		      'url': '/ajax/statuts_usager_liste_jquery.php',
		      'params': {},
		      'return': function (id, nom) {
		      $.getJSON ('/ajax/root_interface/defaut_ajoute_selection.php', { prm_cha_id: cha_id, prm_val: id }, function () {
			  affiche_lis (displayed_lis_id);
			});
		    }
		  });
	      });
	    $(".def_ajout_metier").unbind('click').click (function () {
		var cha_id = $(this).attr('id').substr (10);
		$("#dlg").secteurSelect ({
		      'url': '/ajax/meta_secteur_liste.php?prm_token='+$("#token").val()+'&prm_est_prise_en_charge=null&output=json',
		      'return': function (id, nom) {
		      $.getJSON ('/ajax/root_interface/defaut_ajoute_selection.php', { prm_cha_id: cha_id, prm_val: id }, function () {
			  affiche_lis (displayed_lis_id);
			});
		    }
		  });
	      });
	    $(".def_ajout_groupe").unbind('click').click (function () {
		var cha_id = $(this).attr('id').substr (10);
		$("#dlg").grpSelect ({
		    'cha_id': cha_id,
		    'return': function (eta_id, grp_id) {
			$.getJSON ('/ajax/root_interface/defaut_ajoute_groupe.php', { prm_cha_id: cha_id, prm_val: eta_id, prm_val2: grp_id }, function () {
			    affiche_lis (displayed_lis_id);
			});
		    }
		});
	    });
	    
	    $(".defaut > nobr > span").click (function () { return false; } ); // stop propagation
	}
	$("#lis_champs").sortable ({
	    revert: "invalid",
	      placeholder: 'sortable_act',
	      forcePlaceholderSize: true,
	    update: function (event, ui) {		
		if (ui.item.id == undefined) { // dragged & dropped depuis champs disponibles
		    var inf_id = ui.item.attr('myid');
		    ui.item.attr('id', inf_id);
		}
		$.post ('/ajax/root_interface/chaupdate.php', { 
		    lis_id: displayed_lis_id,
		    list: $(this).sortable('toArray').toString() }, function () {
			affiche_lis (displayed_lis_id);
		    });
	    }
	});
	$("#listechamps li[rel^='champ_']").draggable ({
	    connectToSortable: choix_drop == 'champs' ? "#lis_champs,.sortable" : ".liste_supp_ul,.sortable",
	    helper: "clone",
	    revert: "invalid"
	});
	$(".cha_supprimer").click (function () {
	    var cha_id = $(this).attr('id').substr (9);
	    if (confirm ('Vous allez enlever ce champ de la liste')) {
		$.get('/ajax/root_interface/liste_champs_supprime.php', { cha_id: cha_id }, function () {
		    affiche_lis (displayed_lis_id);
		});
	    }
	});
	$(".cha_libelle_mod").click (function () {
	    var cha_id = $(this).attr('id').substr (16);
	    var libelle = prompt ("Entête");
	    if (libelle) {
		$.post('/ajax/root_interface/liste_champs_set_libelle.php', { cha_id: cha_id, libelle: libelle }, function () {
		    affiche_lis (displayed_lis_id);
		});
	    }	    
	});
	$(".cha_contact").click (function () {
	    var cha_id = $(this).attr('id').substr (12);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_contact.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha_cycle").click (function () {
	    var cha_id = $(this).attr('id').substr (10);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_cycle.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha_dernier").click (function () {
	    var cha_id = $(this).attr('id').substr (12);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_dernier.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha_filtrer").click (function () {
	    var cha_id = $(this).attr('id').substr (12);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_filtrer.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha_verrouiller").click (function () {
	    var cha_id = $(this).attr('id').substr (16);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_verrouiller.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha_details").click (function () {
	    var cha_id = $(this).attr('id').substr (12);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_details.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".cha__contact_filtre_utilisateur").click (function () {
	    var cha_id = $(this).attr('id').substr (32);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_contact_filtre_utilisateur.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	      });     
	  });
	$(".cha_champs_supp").click (function () {
	    var cha_id = $(this).attr('id').substr (16);
	    var val = $(this).is(':checked');
	    $.post('/ajax/root_interface/liste_champs_set_champs_supp.php', { cha_id: cha_id, val: val }, function () {
		affiche_lis (displayed_lis_id);
	    });
	});
	$(".supp_supprimer").click (function () {
	    var parts = $(this).attr('id').substr (15);
	    var tab = parts.split('_');	    
	    if (confirm ('Vous allez enlever ce champ supplémentaire')) {
	      $.get('/ajax/liste_supp_supprime.php', { prm_token: $("#token").val(), prm_cha_id: tab[0], prm_inf_id: tab[1] }, function () {
		  affiche_lis (displayed_lis_id);
		});
	    }
	});
    });
}


var displayed_dos_id = null;
function affiche_dos (dos_id) {
    $.getJSON ('/ajax/root_interface/documents_get.php', { dos_id: dos_id }, function (data) {
	displayed_dos_id = dos_id;
	$("#dos_titre").val (data.dos_titre);
	$("#dos_code").val (data.dos_code);
	$("#dos_dty_id").val(data.dty_id);
    });
    $.getJSON ('/ajax/root_interface/documents_secteur_liste.php', { dos_id: dos_id }, function (data) {
	$("#dos_secteurs").empty ();
	$.each (data, function (idx, val) {
	    $("#dos_secteurs").append('<li id="dss_'+val.dss_id+'" class="secteur_dos"><nobr><span>'+val.sec_nom+'</span></nobr></li> ');
	});
	$(".secteur_dos").unbind('click').click (function () {
	    var dss_id = $(this).attr('id').substr (4);
	    $.getJSON ('/ajax/root_interface/documents_secteur_supprime.php', { dss_id: dss_id }, function () {
		affiche_dos (displayed_dos_id);
	    });
	});
	$(".secteur_dos > nobr > span").unbind('click').click (function () { return false; } ); // stop propagation
    });
}


var displayed_nos_id = null;
function affiche_nos (nos_id) {
  $.getJSON ('/ajax/root_interface/notes_get.php', { nos_id: nos_id }, function (data) {
	displayed_nos_id = nos_id;
	$("#nos_nom").val (data.nos_nom);
	$("#nos_the_id").val (data.the_id);
    });

}

var colle_inf_id = null; // Champ à coller
var colle_din_id = null; // Dossier à coller

function getItems (node) {
    var type = node.attr('rel');
    var items = {
	"rename": false,
	"ccp": false,
	"create": false,
	"remove": false
    }
    if (type == 'root') {
	items.exporter = {
	    "label": "Exporter projet",
	    "action": function () {
		window.open ('/export/accueil.php?basename=accueil', 'export', '');
	    }
	};
	items.nouvelle_cat = {
	    "label" : "Nouvelle catégorie",
	    "action": function () {
		var nom = prompt ("Nom de la catégorie");
		if (nom) {
		    $.post('/ajax/root_interface/categorie_nouvelle.php', { nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};
	items.importer_cat = {
	    "label" : "Importer catégorie",
	    "action": function () {
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'categorie\', \'\')">');
		$("#dlg").dialog ({
		    title: "Importer une catégorie"
		});
	    }
	};
    } else if (type == 'categorie') {
	items.exporter = {
	    "label": "Exporter catégorie",
	    "action": function () {
		window.open ('/export/accueil.php?basename=cat&id='+node.attr('id'), 'export', '');
	    }
	}
	items.renommer = {
	    "label" : "Renommer catégorie",
	    "action": function () {
		var cat = node.attr('id');
		var nom = prompt ("Nouveau nom de la catégorie", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/categorie_renommer.php', { cat: cat, nom: nom }, function () {
			$("#tree").jstree ('refresh', -1);
		    });
		}
	    }
	};
	items.supprimer = {
	    "label" : "Supprimer catégorie",
	    "action": function () {
	      if (confirm ('Vous allez supprimer la catégorie. Voulez-vous continuer ?')) {
		$.post('/ajax/root_interface/categorie_supprime.php', { cat: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		  });
	      }
	    }
	};
	items.nouveau_por = {
	    "label" : "Nouveau portail",
	    "action": function () {
		var nom = prompt ("Nom du portail");
		if (nom) {
		    $.post('/ajax/root_interface/portail_nouveau.php', { cat: node.attr('id'), nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};
    } else if (type == 'portail') {
	items.renommer = {
	    "label" : "Renommer portail",
	    "action": function () {
		var por = node.attr('id');
		var nom = prompt ("Nouveau nom du portail", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/portail_renommer.php', { por: por, nom: nom }, function () {
			$("#tree").jstree ('refresh', -1);
		    });
		}
	    }
	};
	items.supprimer = {
	    "label" : "Supprimer portail",
	    "action": function () {
		$.post('/ajax/root_interface/portail_supprime.php', { por: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		});
	    }
	};
	items.purger_por = {
	    "label" : "Purger portail",
	    "action": function () {
		$.post('/ajax/root_interface/portail_purger.php', { por: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		});
	    }
	};
    } else if (type == 'entite') {
	items.exporter = {
	    "label": "Exporter entité",
	    "action": function () {
		var por = node.parents('li').attr('id');
		var ent = node.attr('id').replace (/\d*$/, '');
		window.open ('/export/accueil.php?basename=entite&ent='+ent+'&por='+por, 'export', '');
	    }
	}
	items.nouveau_menu = {
	    "label" : "Nouveau menu",
	    "action": function () {
		var por = node.parents('li').attr('id');
		var ent = node.attr('id').replace (/\d*$/, '');
		var nom = prompt ("Nom du menu");
		if (nom) {
		    $.post('/ajax/root_interface/menu_nouveau.php', { por: por, ent: ent, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.importer_entite = {
	    "label" : "Importer entité",
	    "action": function () {
		var por = node.parents('li').attr('id');
		var ent = node.attr('id').replace (/\d*$/, '');
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'entite\', \''+ent+','+por+'\')">');
		$("#dlg").dialog ({
		    title: "Importer une entité"
		});
	    }
	};
	items.importer_menu = {
	    "label" : "Importer menu",
	    "action": function () {
		var por = node.parents('li').attr('id');
		var ent = node.attr('id').replace (/\d*$/, '');
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'menu\', \''+ent+','+por+'\')">');
		$("#dlg").dialog ({
		    title: "Importer un menu"
		});
	    }
	};
    } else if (type == 'principal') {
	items.exporter = {
	    "label": "Exporter fenêtre principale",
	    "action": function () {
		var por = node.parents('li').attr('id')
		window.open ('/export/accueil.php?basename=principal&por='+por, 'export', ''); // TODO
	    }
	}
	items.importer_principal = {
	    "label": "Importer fenêtre principale",
	    "action": function () {
		var por = node.parents('li').attr('id');
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'topmenus\', \''+por+'\')">');
		$("#dlg").dialog ({
		    title: "Importer un menu"
		});
	    }
	}
	items.nouveau_menu = {
	    "label" : "Nouveau menu",
	    "action": function () {
		var por = node.parents('li').attr('id')
		var nom = prompt ("Nom du menu");
		if (nom) {
		    $.post('/ajax/root_interface/principal_nouveau.php', { por: por, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.importer_menu = {
	    "label" : "Importer menu (x)",
	    "action": function () {
		var por = node.parents('li').attr('id')
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'topmenu\', \''+por+'\')">');
		$("#dlg").dialog ({
		    title: "Importer un menu"
		});
	    }
	};
    } else if (type == 'menu') {
	items.exporter = {
	    "label": "Exporter menu",
	    "action": function () {
		window.open ('/export/accueil.php?basename=menu&id='+node.attr('id'), 'export', '');
	    }
	};
	items.renommer = {
	    "label" : "Renommer menu",
	    "action": function () {
		var men = node.attr('id');
		var nom = prompt ("Nouveau nom du menu", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/menu_renommer.php', { men: men, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};
	items.supprimer = {
	    "label" : "Supprimer menu",
	    "action": function () {
		$.post('/ajax/root_interface/menu_supprime.php', { men: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		});
	    }
	};
	items.nouveau_ssmenu = {
	    "label" : "Nouvelle fiche",
	    "action": function () {
		var men = node.attr('id');
		var nom = prompt ("Nom de la fiche");
		if (nom) {
		    $.post('/ajax/root_interface/ssmenu_nouveau.php', { men: men, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.importer_ssmenu = {
	    "label" : "Importer fiche",
	    "action": function () {
		$("#dlg").html ('<p>Sélectionnez un fichier à importer : </p><input type="file" onchange="onFileSelected(this.files, \'sousmenu\', \''+node.attr('id')+'\')">');
		$("#dlg").dialog ({
		    title: "Importer une fiche"
		});
	    }
	};
	items.deplacer_haut = {
	    "label": "Déplacer vers le haut",
	    "action": function () {
		var men = node.attr('id');
		$.post('/ajax/root_interface/menu_deplacer_haut.php', {men: men}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
	items.deplacer_bas = {
	    "label": "Déplacer vers le bas",
	    "action": function () {
		var men = node.attr('id');
		$.post('/ajax/root_interface/menu_deplacer_bas.php', {men: men}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
    } else if (type == 'topmenu') {
	items.exporter = {
	    "label": "Exporter menu",
	    "action": function () {
		window.open ('/export/accueil.php?basename=topmenu&id='+node.attr('id'), 'export', '');
	    }
	};
	items.renommer = {
	    "label" : "Renommer menu",
	    "action": function () {
		var tom = node.attr('id');
		var nom = prompt ("Nouveau nom du menu", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/topmenu_renommer.php', { tom: tom, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};
	items.supprimer = {
	    "label" : "Supprimer menu",
	    "action": function () {
		$.post('/ajax/root_interface/topmenu_supprime.php', { tom: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		});
	    }
	};
	items.nouveau_topssmenu = {
	    "label" : "Nouvelle fiche",
	    "action": function () {
		var tom = node.attr('id');
		var nom = prompt ("Nom de la fiche");
		if (nom) {
		    $.post('/ajax/root_interface/topssmenu_nouveau.php', { tom: tom, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.deplacer_haut = {
	    "label": "Déplacer vers le haut",
	    "action": function () {
		var tom = node.attr('id');
		$.post('/ajax/root_interface/topmenu_deplacer_haut.php', {tom: tom}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
	items.deplacer_bas = {
	    "label": "Déplacer vers le bas",
	    "action": function () {
		var tom = node.attr('id');
		$.post('/ajax/root_interface/topmenu_deplacer_bas.php', {tom: tom}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
    } else if (type == "page") {
	items.exporter = {
	    "label": "Exporter fiche",
	    "action": function () {
		window.open ('/export/accueil.php?basename=sousmenu&id='+node.attr('id'), 'export', '');
	    }
	};
	items.renommer = {
	    "label" : "Renommer fiche",
	    "action": function () {
		var sme = node.attr('id');
		var nom = prompt ("Nouveau nom de la fiche", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/ssmenu_renommer.php', { sme: sme, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.supprimer = {
	    "label" : "Supprimer fiche",
	    "action": function () {
		$.post('/ajax/root_interface/ssmenu_supprime.php', { sme: node.attr('id') }, function () {
		    $("#tree").jstree('refresh', -1);
		});
	    }
	};	
	items.deplacer_haut = {
	    "label": "Déplacer vers le haut",
	    "action": function () {
		var sme = node.attr('id');
		$.post('/ajax/root_interface/ssmenu_deplacer_haut.php', {sme: sme}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
	items.deplacer_bas = {
	    "label": "Déplacer vers le bas",
	    "action": function () {
		var sme = node.attr('id');
		$.post('/ajax/root_interface/ssmenu_deplacer_bas.php', {sme: sme}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};

    } else if (type == "topfiche") {
	items.renommer = {
	    "label" : "Renommer fiche",
	    "action": function () {
		var tsm = node.attr('id');
		var nom = prompt ("Nouveau nom de la fiche", $("#tree").jstree ('get_text', '#'+node.attr('id')));
		if (nom) {
		    $.post('/ajax/root_interface/topssmenu_renommer.php', { tsm: tsm, nom: nom}, function () {
			$("#tree").jstree ("refresh", -1);
		    });
		}
	    }
	};	
	items.supprimer = {
	    "label" : "Supprimer fiche",
	    "action": function () {
		$.post('/ajax/root_interface/topssmenu_supprime.php', { tsm: node.attr('id') }, function () {
		    $("#tree").jstree ('refresh', -1);
		});
	    }
	};	
	items.deplacer_haut = {
	    "label": "Déplacer vers le haut",
	    "action": function () {
		var tsm = node.attr('id');
		$.post('/ajax/root_interface/topssmenu_deplacer_haut.php', {tsm: tsm}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};
	items.deplacer_bas = {
	    "label": "Déplacer vers le bas",
	    "action": function () {
		var tsm = node.attr('id');
		$.post('/ajax/root_interface/topssmenu_deplacer_bas.php', {tsm: tsm}, function () {
		    $("#tree").jstree("refresh", -1);
		});
	    }
	};

    }
    return items;
}

function getCol3Items (node) {
    var type = node.attr('rel');
    var items = {
	"rename": false,
	"ccp": false,
	"create": false,
	"remove": false
    }
    if (type.substring (0, 6) != 'champ_' && type != 'nonclasse') {

    }
    if (type.substring (0, 6) == 'champ_') {
	items.editer = {
	    "label": "Editer",
	    "action": function () {
		info_edite (node.attr('id'));
	    }
	};
	items.usager = {
	    "label": "Usage",
	    "action": function () {
	      info_usage (node.attr('id'))
	    }
	};
    }
    return items;
}

function onFileSelected (files, type, id) {
    if (files.length != 1) {
	alert ('bug');
	return;
    }
    uploadFile(files[0], type, id);
}

function uploadFile(file, type, id) {
    var xhr = new XMLHttpRequest();
    //on s'abonne à l'événement progress pour savoir où en est l'upload
    xhr.open("POST", "/ajax/root_interface/fileupload.php?type="+type+'&id='+id, true);

    // on s'abonne à tout changement de statut pour détecter
    // une erreur, ou la fin de l'upload
    xhr.onreadystatechange = onStateChange; 

    xhr.setRequestHeader("Content-Type", "multipart/form-data");
    xhr.setRequestHeader("X-File-Name", file.fileName);
    xhr.setRequestHeader("X-File-Size", file.fileSize);
    xhr.setRequestHeader("X-File-Type", file.type);

    xhr.send(file);
}

function onStateChange () {
    if (this.readyState==4 && this.status==200) {
	$("#dlg").dialog('close');
	$("#tree").jstree ("refresh", -1);
    }
}

function info_edite (id) {
    $.get ("/ajax/meta_info_get.php", { prm_token: $("#token").val(), prm_inf_id: id.substr (4) }, function (data) {
	$("#dlg").load ("/ajax/root_interface/info_edit.php?id="+id.substr(4));
	$("#dlg").dialog({
	    width: 500,
	    height: 550,
	    resizable: false,
	    title: "Edition du champ \""+ $(data).find('inf_libelle').text()+"\""
	});
    });
} 

function info_usage (id) {
  $.getJSON('/ajax/meta_info_usage.php', { prm_token: $("#token").val(), output: 'json2', prm_inf_id: id.substr (4) }, function (data) {
      var txt = '';
      if (data) {
	$.each (data, function (key, val) {
	    txt += val.cat_nom+' > '+val.por_libelle+' > '+val.ent_libelle+' > '+val.men_libelle+' > '+val.sme_libelle+'\n';
	  });
	alert (txt);
      } else {
	alert ('non utilisé');
      }
    });
}

function info_ajoute (dirid) {
    $("#dlg").load ("/ajax/root_interface/info_edit.php?id=0&dirid="+dirid);
    $("#dlg").dialog({
	width: 500,
	height: 500,
	resizable: false,
	title: "Ajout d'un champ"
    });	
}

function on_listechamps_rechercher_change () {
    $("#listechamps").jstree ("refresh", -1);
}

function on_listechamps_usedonly_change () {
  $("#listechamps").jstree ("refresh", -1);
}

function on_listechamps_update_click () {
  $.get('/ajax/root_interface/listechamps_update.php', function (ret) {
      alert (ret+' nouveaux champs téléchargés');
      $("#listechamps").jstree ("refresh", -1);      
    });
}

function get_listechamps_url () {
  var usedonly = $("#listechamps_usedonly").attr('checked') == 'checked' ? '1' : '0';
  return "/ajax/root_interface/champs.php?usedonly="+usedonly+"&str="+$("#listechamps_rechercher").val();
}
</script>
<div id="tree">
</div>
<!-- Edition des fiches personne -->
<div id="col2">
  Icône : <br/>
<input type="text" size="20" id="sme_icone"></input>
<img src="" id="sme_icone_img" align="middle"></img>
<input type="button" id="sme_icone_change" value="..."></input>
  <br/>Type de vue&nbsp;:<br/>
  <select id="sme_type">
    <option value="">Masque de données</option>
    <option value="documents">Documents</option>
    <option value="event">Événements</option>
    <option value="notes">Notes</option>
  </select>
  <div id="sme_type_id_div">
  Vue&nbsp;: <br>
  <select id="sme_type_id"></select>
  </div>
  <br/>
  <button id="sme_type_save">Enregistrer</button>
  <div id="detailpage">
  </div>
  <div id="corbeille" class="sortable">Corbeille</div>
  <button id="btn_blocs_fermer">Tout fermer/ouvrir</button>
  <button id="btn_blocs_nouveau">Ajouter un bloc</button>
</div>

<!-- Edition du menu principal -->
<div id="col2principal">
<h2>Fiche fenêtre principale</h2>
<div class="col2bloc">
Titre : <br/>
<input type="text" size="30" id="tsm_titre"></input><br/>

Icône : <br/>
<input type="text" size="20" id="tsm_icone"></input>
<img src="" id="tsm_icone_img" align="middle"></img>
<input type="button" id="tsm_icone_change" value="..."></input>
<br/>

Page de fiche Usager à ouvrir : <br/>
<select id="tsm_sme_id"></select><br/>

Type de vue : <br/>
<select id="tsm_type">
  <option value=""></option>
  <option value="documents">Documents</option>
  <option value="groupe">Gestion de groupes</option>
  <option value="liste">Liste de personnes</option>
  <option value="event">Évènements</option>
  <option value="agressources">Ressources</option>
  <option value="notes">Notes</option>
</select><br/>

<div class="tr_type tr_type_groupe">
Thématique : <br/>
<select id="tsm_type_groupe_id"><option value=""></option><?= affiche_liste_secteurs (); ?></select>
</div>

<div class="tr_type tr_type_liste">
Vue de liste : <br/>
<select id="tsm_type_liste_id"><option value=""></option><?= affiche_liste_listes (); ?></select>
</div>

<div class="tr_type tr_type_documents">
Vue de documents : <br/>
<select id="tsm_type_documents_id"><option value=""></option><?= affiche_liste_documents (); ?></select>
</div>

<div class="tr_type tr_type_event">
Vue d'évènements : <br/>
<select id="tsm_type_event_id"><option value=""></option><?= affiche_liste_events (); ?></select>
<button id="perso_type">Personnaliser par type</button>
</div>

<div class="tr_type tr_type_agressources">
Vue de ressources : <br/>
<select id="tsm_type_agressources_id"><option value=""></option><?= affiche_liste_agressources (); ?></select>
</div>

<div class="tr_type tr_type_notes">
  Vue de notes : <br/>
  <select id="tsm_type_notes_id"><option value=""></option><?= affiche_liste_notes (); ?></select>
</div>

<button id="tsm_save">Enregistrer</button>

</div>

<div class="col2bloc tr_details tr_details_liste">
<h2>Vue de liste</h2>
Nom :<br/>
<input type="text" size="30" id="lis_nom"></input><br/>

Code :<br/>
<input type="text" size="30" id="lis_code"></input><br/>

Entité : <br/>
<select id="liste_ent_id"><option value=""></option><?= affiche_entites (); ?></select><br/>

<input type="checkbox" id="lis_inverse"></input><label for="lis_inverse">Inverser lignes/colonnes</label><br/>

<input type="checkbox" id="lis_pagination_tout"></input><label for="lis_pagination_tout">Pagination : tout afficher</label><br/>

<button id="lis_save">Enregistrer</button>
<button id="lis_supprime">Supprimer</button>

<h3>Champs</h3>
<div id="choix_drop">
<input type="radio" name="choix_drop" checked id="drop_champs"><label for="drop_champs">Ajout champs</label>
<input type="radio" name="choix_drop" id="drop_champs_supp"><label for="drop_champs_supp">Ajout champs supp</label>
</div>
<ul id="lis_champs" class="chasortable">
</div>

<div class="col2bloc tr_details tr_details_documents">
<h2>Vue de documents</h2>
Nom :<br/>
<input type="text" size="30" id="dos_titre"></input><br/>

Code :<br/>
<input type="text" size="30" id="dos_code"></input><br/>

<button id="dos_save">Enregistrer</button>
<button id="dos_supprime">Supprimer</button>

<h3>Type</h3>
<select id="dos_dty_id"><option value=""></option></select>

<h3>Secteurs</h3>
<ul id="dos_secteurs">
</ul>
<button id="dss_ajoute">Ajouter une thématique</button>
</div>

<div class="col2bloc tr_details tr_details_notes">
<h2>Vue de notes</h2>
Nom :<br/>
<input type="text" size="30" id="nos_nom"></input><br/>

Boîte de notes : <br/>
<select id="nos_the_id"><option value=""></option><?= affiche_themes (); ?></select><br/>

<button id="nos_save">Enregistrer</button>
<button id="nos_supprime">Supprimer</button>

</div>




</div>

<div id="outils">
  <div>&nbsp;Rechercher champs : <input type="text" id="listechamps_rechercher"></input>
  </div>
  <div style="margin: 5px 0"><input type="checkbox" id="listechamps_usedonly"><label for="listechamps_usedonly">Champs utilisés seulement</label></div>
  <div style="margin: 5px 0"><input type="button" id="listechamps_update" value="Télécharger nouveaux"></input></div>
  <div id="listechamps"></div>
</div>


<div style="clear: both"></div>


<?php
function affiche_liste_secteurs () {
  global $base;
  $secs = $base->meta_secteur_liste ($_SESSION['token'], NULL);
  foreach ($secs as $sec) {
    echo '<option value="'.$sec['sec_id'].'">'.$sec['sec_nom'].'</option>';
  }
}

function affiche_liste_listes () {
  global $base;
  $liss = $base->liste_liste_all ($_SESSION['token']);
  foreach ($liss as $lis) {
    echo '<option value="'.$lis['lis_id'].'">'.$lis['lis_nom'].'</option>';
  }
}

function affiche_liste_documents () {
  global $base;
  $doss = $base->document_documents_liste ($_SESSION['token']);
  foreach ($doss as $dos) {
    echo '<option value="'.$dos['dos_id'].'">'.$dos['dos_titre'].'</option>';
  }
}

function affiche_liste_events () {
  global $base;
  $evss = $base->events_events_list ($_SESSION['token']);
  foreach ($evss as $evs) {
    echo '<option value="'.$evs['evs_id'].'">'.$evs['evs_titre'].'</option>';
  }
}

function affiche_liste_agressources () {
  global $base;
  $agrs = $base->events_agressources_list ($_SESSION['token']);
  foreach ($agrs as $agr) {
    echo '<option value="'.$agr['agr_id'].'">'.$agr['agr_titre'].'</option>';
  }
}

function affiche_liste_notes () {
  global $base;
  $noss = $base->notes_notes_liste ($_SESSION['token']);
  foreach ($noss as $nos) {
    echo '<option value="'.$nos['nos_id'].'">'.$nos['nos_nom'].'</option>';
  }
}

function affiche_entites () {
  global $base;
  $ents = $base->meta_entite_liste ($_SESSION['token']);
  foreach ($ents as $ent) {
    echo '<option value="'.$ent['ent_id'].'">'.$ent['ent_libelle'].'</option>';
  }
}

function affiche_themes () {
  global $base;
  $thes = $base->notes_theme_liste_details ($_SESSION['token'], NULL);
  echo '<option value=""></option>';
  foreach ($thes as $the) {
    echo '<option value="'.$the['the_id'].'">'.$the['the_nom'].'</option>';
  }
}
?>
