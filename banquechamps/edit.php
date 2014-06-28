<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="fr">
  <head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <title>Accueil</title>
    <link href="jquery/css/theme/jquery-ui.css" rel="stylesheet" type="text/css" />
    <link href="jquery/css/theme/jquery-ui-timepicker-addon.css" rel="stylesheet" type="text/css" />

    <script src="jquery/js/jquery.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery.ui.datepicker-fr.js" type="text/javascript"></script>     
    <script src="jquery/js/jquery-ui-timepicker-addon.js" type="text/javascript"></script>

    <script type="text/javascript">
   $(document).ready (function () {
       var n = $("h3").index($(".ultopsousmenu > li.selected").parent('ul').parent('div').prev('h3'));
       $(".acctopmenu").accordion ({ icons: false, collapsible: true, autoHeight: false, animated: false});
       if (n>0) {
	 $(".acctopmenu").accordion ('option', 'active', n);
       }
       //      $(".acctopmenu").accordion ('option', 'animated', 'slide');
     });
    </script>
  <script type="text/javascript" src="jquery/jstree/jquery.jstree.js"></script>
<script type="text/javascript" src="jquery/senselect/jquery.senselect.js"></script>
<script type="text/javascript" src="jquery/grpselect/jquery.grpselect.js"></script>
<script type="text/javascript" src="jquery/secteurselect/jquery.secteurselect.js"></script>
<link href="jquery/secteurselect/jquery.secteurselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="jquery/genericselect/jquery.genericselect.js"></script>
<link href="jquery/genericselect/jquery.genericselect.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
$(document).ready (function () {
    $("#listechamps_rechercher").change (on_listechamps_rechercher_change);
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
			"image": "images/icons/jstree_type_texte.png"
		    }
		},
		"champ_selection": {
		    "icon": {
			"image": "images/icons/jstree_type_select.jpg"
		    }
		},
		"champ_date": {
		    "icon": {
			"image": "images/icons/jstree_type_date.png"
		    }
		},
		"champ_textelong": {
		    "icon": {
			"image": "images/icons/jstree_type_textarea.png"
		    }
		},
		"champ_coche": {
		    "icon": {
			"image": "images/icons/jstree_type_checkbox.jpg"
		    }
		},
		"champ_contact": {
		    "icon": {
			"image": "images/icons/jstree_type_contact.gif"
		    }
		},
		"champ_etablissement": {
		    "icon": {
			"image": "images/icons/jstree_type_etablissement.gif"
		    }
		},
		"champ_metier": {
		    "icon": {
			"image": "images/icons/jstree_type_metier.gif"
		    }
		},
		"champ_groupe": {
		    "icon": {
			"image": "images/icons/jstree_type_groupe.gif"
		    }
		},
		"champ_affectation": {
		    "icon": {
			"image": "images/icons/jstree_type_affectation.gif"
		    }
		},
		"champ_famille": {
		    "icon": {
			"image": "images/icons/jstree_type_famille.png"
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
	  $("#listechamps").jstree ("toggle_node", node);
	} else {
	    info_edite (node.attr('id'));
	}
    });
  });


var colle_inf_id = null; // Champ à coller
var colle_din_id = null; // Dossier à coller

function getCol3Items (node) {
    var type = node.attr('rel');
    var items = {
	"rename": false,
	"ccp": false,
	"create": false,
	"remove": false
    }
    if (type.substring (0, 6) != 'champ_' && type != 'nonclasse') {
	items.ajout = {
	    "label": "Ajouter sous-dossier",
	    "action": function () {
		var din = node.attr('id');
		var nom = prompt ('Nom du dossier');
		if (nom) {
		    $.post('ajax/root_interface/din_nouveau.php', { din: din, nom: nom }, function () {
			$('#listechamps').jstree('refresh', -1);
		    });
		}
	    }
	};
	items.ajout_champ = {
	    "label": "Ajouter champ",
	    "action": function () {
		info_ajoute (node.attr('id'));
	    }
	}

	if (node.attr('id') != 'din_0') {
	    items.renommer = {
		"label": "Renommer",
		"action": function () {
		    var din = node.attr('id');
		    var nom = prompt ("Noveau nom du dossier", $("#listechamps").jstree ('get_text', '#'+node.attr('id')));
		    if (nom != null) {
			$.post("ajax/root_interface/din_update.php", {din: din, nom: nom}, function () {
			    $('#listechamps').jstree('refresh', -1);			    
			});
		    }
		}
	    }

	    items.couper_dossier = {
		"label": "Couper",
		"action": function () {
		    colle_din_id = node.attr('id');
		    colle_inf_id = null;
		}
	    }

	    items.supprimer = {
		"label": "Supprimer",
		"action": function () {
		    var din = node.attr('id');
		    $.post('ajax/root_interface/din_supprime.php', { din: din }, function () {
			$('#listechamps').jstree('refresh', -1);
		    });
		}
	    }
	    
	    items.coller_inf = {
		"label": "Coller champ",
		"_disabled": true
	    };
	    if (colle_inf_id != null) {
		items.coller_inf._disabled = false;
		items.coller_inf.action = function () {
		    $.post('ajax/root_interface/din_colle.php', 
			   { din: node.attr('id'), inf: colle_inf_id }, 
			   function () {
			       colle_inf_id = null;
			       $('#listechamps').jstree('refresh', -1);
			   });
		}
	    };	    
	}

	items.coller_dossier = {
	    "label": "Coller dossier",
	    "_disabled": true
	};
	if (colle_din_id != null) {
	    items.coller_dossier._disabled = false;
	    items.coller_dossier.action = function () {
		$.post('ajax/root_interface/din_colle.php', 
		       { din: node.attr('id'), din2: colle_din_id }, 
		       function () {
			   colle_din_id = null;
			   $('#listechamps').jstree('refresh', -1);
		       });
	    }
	};


    }
    if (type.substring (0, 6) == 'champ_') {
	items.couper = {
	    "label": "Couper",
	    "action": function () {
		colle_inf_id = node.attr('id');
		colle_din_id = null;
	    }
	};
	items.editer = {
	    "label": "Editer",
	    "action": function () {
		info_edite (node.attr('id'));
	    }
	};
    }
    return items;
}

function info_edite (id) {
    $.get ("ajax/meta_info_get.php", { prm_inf_id: id.substr (4) }, function (data) {
	$("#dlg").load ("ajax/root_interface/info_edit.php?id="+id.substr(4));
	$("#dlg").dialog({
	    width: 'auto',
	    resizable: false,
	    title: "Edition du champ \""+ $(data).find('inf_libelle').text()+"\""
	});
    });
} 

function info_ajoute (dirid) {
    $("#dlg").load ("ajax/root_interface/info_edit.php?id=0&dirid="+dirid);
    $("#dlg").dialog({
	width: 'auto',
	resizable: false,
	title: "Ajout d'un champ"
    });	
}

function on_listechamps_rechercher_change () {
    $("#listechamps").jstree ("refresh", -1);
}

function get_listechamps_url () {
    return "ajax/root_interface/champs.php?str="+$("#listechamps_rechercher").val();
}
</script>
</head>
<body>
<div id="outils">
  <div>&nbsp;Rechercher champs : <input type="text" id="listechamps_rechercher"></input>
  </div>
  <div id="listechamps"></div>
</div>
<div id="dlg"></div>
<div id="dlg2"></div>
</body>
</html>
