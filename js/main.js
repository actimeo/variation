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
	$(".boutonhisto").click (on_boutonhisto_click);

	/* Edition d'un champ de tpe Lien */
	$(".selectcontact").click (on_selectcontact_click);
	$(".supprimecontact").click (on_supprimecontact_click);
	$(".select2contact").dblclick (on_select2contact_dblclick);

	/* Edition d'un champ de type Groupe */
	$(".info_groupe_edit").click (on_info_groupe_edit);
	$(".info_groupe_del").click (on_info_groupe_del);
	$(".info_groupe_add").click (on_info_groupe_add);

	$(".lienpersonne").click (on_lienpersonne_click);

	/* Edition d'un champ de type Famille */
	$(".membrefam").click (on_membrefam_del_click);
	$(".membrefam nobr").click (on_membrefam_click);
	$(".membrefam_ajout").click (on_membrefam_ajout);
	$(".membrefam_ro nobr").click (on_membrefam_click);

	/* Edition d'un champ de type Etablissement */
	$(".infoetab").click (on_infoetab_del_click);
	$(".infoetab nobr").click (on_infoetab_click);
	$(".infoetab_ajout").click (on_infoetab_ajout);
	$(".infoetab1 nobr").click (function () { return false });
	$(".infoetab1").click (on_infoetab1_click);

	/* Edition d'un champ de type Lien (contact) */
	$(".infocontact").click (on_infocontact_del_click);
	$(".infocontact nobr").click (on_infocontact_click);
	$(".infocontact_ajout").click (on_infocontact_ajout);
	$(".infocontact1 nobr").click (function () { return false });
	$(".infocontact1").click (on_infocontact1_click);

	/* Edition d'un champ de type Affectation personnel (affectation) */
	$(".infoaffectation").click (on_infoaffectation_del_click);
	$(".infoaffectation nobr").click (on_infoaffectation_click);
	$(".infoaffectation_ajout").click (on_infoaffectation_ajout);


    var n = $("h3").index($(".ultopsousmenu > li.selected").parent('ul').parent('div').prev('h3'));
    $(".accmenu").accordion( { icons: false, collapsible: true, autoHeight: false, animated: false });
    if (n>0) {
	$(".accmenu").accordion ('option', 'active', n);
    }

    // Chargement d'une photo
    $("#photo_change").click (on_photo_change_click);
    
});

function on_boutonhisto_click () {
    var parts = $(this).attr('id').split(':');
    var type = parts[1];
    var per = parts[2];
    var code = parts[3];
    $.post ('/ajax/personne_info_'+type+'_get_histo.php',
	    { prm_token: $("#token").val(), prm_per_id: per, prm_inf_code: code, output: 'json' }, function (data){
		var txt = '';
		$.each (data, function (idx, val) {
		    txt += val.debut+' -> '+(val.fin ? val.fin : '(en cours)')+' : '+val.valeur+" ("+val.utilisateur+")\n";
		    });
		alert (txt);
	    });
}

/* Contact */
function on_selectcontact_click () {
    $(this).nextAll('.contact_select').toggle ();
}

function on_supprimecontact_click () {
    $(this).nextAll(".hiddencontact").val ('');
    $(this).prevAll(".reperecontact").html ('');
    $(this).nextAll('.contact_select').hide ();
}

function on_select2contact_dblclick () {
    var sel = $(this).children("option:selected");
    $(this).parent('.contact_select').prevAll (".hiddencontact").val(sel.val());
    $(this).parent('.contact_select').prevAll (".reperecontact").html (sel.html());
    $(this).parent('.contact_select').hide ();
}


/* Affectation */
function on_info_groupe_edit () {
    var str = $(this).attr('id').substr (10);
    var parts = str.split ('_');
    var peg_id = parts[0];
    var ing_id = parts[1];
    $("#editdlg").load ('/ajax/edit/info_groupe_edit.php', {
	    ing_id: ing_id,
		peg_id: peg_id}, function () {
	    $("#editdlg").dialog ({
		    width: 'auto',
			autoResize: true,
			modal: true,
			resizable: false,
			title: 'Édition'
			});
	});
    
}

function on_info_groupe_del () {
    var peg_id = $(this).attr('id').substr (9);
    var nom = $(this).parent('td').parent('tr').children('td:first-child').text();
    var ok = confirm ("Voulez-vous supprimer l'appartenance au groupe \""+nom+"\" ?");
    if (ok) {
	$.post('/ajax/edit/personne_groupe_supprime.php', {
	    prm_token: $("#token").val(),
		prm_peg_id: peg_id
	    }, function () {
		location.reload ();
	    });
    }
}

function on_info_groupe_add () {
    var str = $(this).attr('id').substr (9);
    var parts = str.split ('_');
    var per_id = parts[0];
    var ing_id = parts[1];
    $("#editdlg").hide().load ('/ajax/edit/info_groupe_edit.php', {
	    ing_id: ing_id,
		per_id: per_id
		}, function () {
	    $("#editdlg").dialog ({
		    width: 'auto',
			autoResize: true,
			modal: true,
			resizable: false,
			title: 'Édition'	    
			});	    
	});
    
}

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
    parent.on_lien_personne (ent, per, titre, changeTab);
}

/* Famille */
function on_membrefam_click (e) {
    e.stopPropagation();
    var parts = $(this).text ().split (' : ');    
    var pif_id = $(this).parent('span').attr('id').substr (4);
    $.getJSON ('/ajax/personne_info_lien_familial_get_par_id.php', { prm_token: $("#token").val(), prm_pif_id: pif_id, output: 'json2' }, function (res) {
	    on_lien_personne ('famille', res.per_id_parent, parts[1], !e.shiftKey);
	});
}

function on_membrefam_del_click () {
    var ok = confirm ("Voulez-vous supprimer ce lien ?");
    if (!ok)
	return;
    var pif_id = $(this).attr('id').substr (4);
    var toremove = $(this);
    $.getJSON ('/ajax/edit/personne_info_lien_familial_delete.php', { prm_token: $("#token").val(), prm_pif_id: pif_id }, function () {
	    toremove.remove ();
	});
}

function on_membrefam_ajout () {
    var inf_code = $(this).attr('id').substr (16);
    var per_id = $("#per_id").val();
    $("#editdlg").participantSelect ({
	    title: "Sélection d'un membre de la famille",
		url: '/ajax/personne_cherche.php',
	return: function (id, type, nom, lfa, lfanom, autorite_parentale, droits, periodicite) {
		$.getJSON ('/ajax/edit/personne_info_lien_familial_set.php', {
		    prm_token: $("#token").val(), 
		    prm_per_id: per_id,
		    prm_inf_code: inf_code,
		    prm_per_id_parent: id,
		    prm_lfa_id: lfa,
		    prm_autorite_parentale: autorite_parentale,
		    prm_droits: droits,
		    prm_periodicite: periodicite,
		    output: 'json2'}, function (data) {
			$("#"+inf_code+"_list").append('<span id="lfa_'+data+'" class="membrefam"><nobr>'+lfanom+' : '+nom+'</nobr></span> ');
			$(".membrefam").unbind('click').click (on_membrefam_del_click);
			$(".membrefam nobr").unbind('click').click (on_membrefam_click);

		    });
	    },
		type: ['famille'],
	lien_familial: true,
	ajout: false
	});
}

/* Etablissement */
function on_infoetab1_click () {
    var inf_code = $(this).attr('id').substr (10);
    var per_id = $("#per_id").val();
    var clicked = $(this);
    $.getJSON ('/ajax/meta_info_get_par_code.php', { prm_token: $("#token").val(), prm_inf_code: inf_code, output: 'json2' }, function (res) {
	    $("#editdlg").etablissementSelect ({ 
		    interne: res.inf__etablissement_interne ? 1 : 0,
		    sec_code: res.inf__etablissement_secteur,
			return: function (id, nom) {
			$.getJSON ('/ajax/edit/personne_info_integer_set.php', {
			    prm_token: $("#token").val(), 
			    prm_per_id: per_id,
				    prm_inf_code: inf_code,
				    prm_valeur: id,
			            prm_uti_id: $("#uti_id").val(),
				    output: 'json2'
				    }, function (data) {
				clicked.html ('<nobr>'+nom+'</nobr>');
			    });
		    }
		});
	});    
}

function on_infoetab_click (e) {
    return false;
}

function on_infoetab_del_click () {
    var ok = confirm ("Voulez-vous supprimer ce lien ?");
    if (!ok)
	return;
    var pii_id = $(this).attr('id').substr (4);
    var toremove = $(this);
    $.getJSON ('/ajax/edit/personne_info_integer_delete.php', { prm_token: $("#token").val(), prm_pii_id: pii_id }, function () {
	    toremove.remove ();
	});
}

function on_infoetab_ajout () {
    var inf_code = $(this).attr('id').substr (15);    
    var per_id = $("#per_id").val();
    $.getJSON ('/ajax/meta_info_get_par_code.php', { prm_token: $("#token").val(), prm_inf_code: inf_code, output: 'json2' }, function (res) {
	    $("#editdlg").etablissementSelect ({ 
		    interne: res.inf__etablissement_interne ? 1 : 0,
		    sec_code: res.inf__etablissement_secteur,
			return: function (id, nom) {
			$.getJSON ('/ajax/edit/personne_info_integer_set.php', {
			    prm_token: $("#token").val(), 
			    prm_per_id: per_id,
				    prm_inf_code: inf_code,
				    prm_valeur: id,
			            prm_uti_id: $("#uti_id").val(),
				    output: 'json2'
				    }, function (data) {
				$("#"+inf_code+"_list").append('<span id="pii_'+data+'" class="infoetab"><nobr>'+nom+'</nobr></span> ');
				$(".infoetab").unbind('click').click (on_infoetab_del_click);
				$(".infoetab nobr").unbind('click').click (on_infoetab_click);
			    });
		    }
		});
	});
}

/* Lien (contact) */
function on_infocontact1_click () {
    var inf_code = $(this).attr('id').substr (13);
    var per_id = $("#per_id").val();
    var clicked = $(this);
    $.getJSON ('/ajax/meta_info_get_par_code.php', { prm_token: $("#token").val(), prm_inf_code: inf_code, output: 'json2' }, function (res) {
	    $("#editdlg").participantSelect ({
		    title: "Sélection d'une personne",
			url: '/ajax/personne_cherche.php',
			type: [ res.inf__contact_filtre ],
			return: function (id, type, nom, lfa, lfanom) {
			$.getJSON ('/ajax/edit/personne_info_integer_set.php', {
			    prm_token: $("#token").val(), 
			    prm_per_id: per_id,
				    prm_inf_code: inf_code,
				    prm_valeur: id,
			            prm_uti_id: $("#uti_id").val(),
				    output: 'json2'
				    }, function (data) {
				clicked.html ('<nobr>'+nom+'</nobr>');
			    });

		    }
		});
	});    
}

function on_infocontact_click (e) {
    return false;
}

function on_infocontact_del_click () {
    var ok = confirm ("Voulez-vous supprimer ce lien ?");
    if (!ok)
	return;
    var pii_id = $(this).attr('id').substr (4);
    var toremove = $(this);
    $.getJSON ('/ajax/edit/personne_info_integer_delete.php', { prm_token: $("#token").val(), prm_pii_id: pii_id }, function () {
	    toremove.remove ();
	});
}

function on_infocontact_ajout () {
    var inf_code = $(this).attr('id').substr (18);  
    var per_id = $("#per_id").val();
    $.getJSON ('/ajax/meta_info_get_par_code.php', { prm_token: $("#token").val(), prm_inf_code: inf_code, output: 'json2' }, function (res) {
	    $("#editdlg").participantSelect ({ 
		    title: "Sélection d'une personne",
			url: '/ajax/personne_cherche2.php',
			type: [ res.inf__contact_filtre ],
			secteur: res.inf__contact_secteur,
			return: function (id, type, nom, lfa, lfanom) {
			$.getJSON ('/ajax/edit/personne_info_integer_set.php', {
			    prm_token: $("#token").val(),
			    prm_per_id: per_id,
			    prm_inf_code: inf_code,
			    prm_valeur: id,
			    prm_uti_id: $("#uti_id").val(),
			    output: 'json2'
			}, function (data) {
			    $("#"+inf_code+"_list").append('<span id="pii_'+data+'" class="infocontact"><nobr>'+nom+'</nobr></span> ');
			    $(".infocontact").unbind('click').click (on_infocontact_del_click);
			    $(".infocontact nobr").unbind('click').click (on_infocontact_click);
			});
			}
	    });
    });
}

/* Affectation personnel (affectation) */
function on_infoaffectation_click (e) {
    return false;
}

function on_infoaffectation_del_click () {
    var ok = confirm ("Voulez-vous supprimer cette affectation ?");
    if (!ok)
	return;
    var pij_id = $(this).attr('id').substr (4);
    var toremove = $(this);
    $.getJSON ('/ajax/edit/personne_info_integer2_delete.php', { prm_token: $("#token").val(), prm_pij_id: pij_id }, function () {
	    toremove.remove ();
	});
}

function on_infoaffectation_ajout () {
    var inf_code = $(this).attr('id').substr (22);
    var per_id = $("#per_id").val();
    $.getJSON ('/ajax/meta_info_get_par_code.php', { prm_token: $("#token").val(), prm_inf_code: inf_code, output: 'json2' }, function (res) {
	    $("#editdlg").grpSelect ({ 
		    title: "Sélection d'une affectation",
		return: function (the_eta_id, the_grp_id, retnom) {
			$.getJSON ('/ajax/edit/personne_info_integer2_set.php', {
			    prm_token: $("#token").val(), 
			    prm_per_id: per_id,
			    prm_inf_code: inf_code,
			    prm_valeur1: the_eta_id,
			    prm_valeur2: the_grp_id,
			    prm_uti_id: $("#uti_id").val(),
			    output: 'json2'
			}, function (data) {
			    $("#"+inf_code+"_list").append('<span id="pij_'+data+'" class="infoaffectation"><nobr>'+retnom+'</nobr></span> ');
			    $(".infoaffectation").unbind('click').click (on_infoaffectation_del_click);
			    $(".infoaffectation nobr").unbind('click').click (on_infoaffectation_click);
			});
		    }
		});
	});
}

function on_photo_change_click () {
    $("#editdlg").load ('/dlgs/photo.php?per_id='+$("#per_id").val(), {}, function () {
	$("#editdlg").dialog ({
	    width: 'auto',
	    autoResize: true,
	    modal: true,
	    resizable: false,
	    title: 'Modifier photo'
	});
    });    
}
