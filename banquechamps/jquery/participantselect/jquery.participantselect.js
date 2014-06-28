(function ($) {
    $.fn.participantSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une personne",
	    'url': '/',
	    'return': null,
	    'type': ['usager', 'personnel', 'contact', 'famille'],
	    'secteur': null,
	    'lien_familial': false
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
		$.getJSON ('/ajax/meta_lien_familial_liste.php', { output: 'json2'}, function (data) {
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
	    $('#participantselect-frame').append ('<div style="text-align: center; margin-top: 5px"><button id="participantselect-chercher">Chercher</button></div>');
	    div.append('<div id="participantselect-result"></div>');
	    $("#participantselect-chercher").button ({icons: {primary:'ui-icon-search'}}).click (function () {
		var type = $("input[name=participantselect-type]:checked").val();
		$.getJSON (o.url, { prm_nom: $("#participantselect-nom").val(), prm_prenom: $("#participantselect-prenom").val(), prm_type: type, prm_secteur: o.secteur, output: 'json' }, function (data) {
		    $("#participantselect-result").html ('<ul></ul>');
		    $.each (data, function (idx, val) {
			$("#participantselect-result ul").append ('<li id="participantselect-per-'+val.per_id+'">'+val.nom_prenom+'</li>');
		    });
		    $("#participantselect-result li").
			css ('cursor', 'pointer').
			click (function () {
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
			    });
	    

		    });
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
