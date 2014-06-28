/* Affiche la liste des entrées d'une sélection, pour un champ de liste donné de type selection */
(function ($) {
    $.fn.senSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une valeur",
	    'url': '/ajax/meta_selection_entree_liste_par_cha.php',
	    return: null
	}
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {
		var div = $(this);
		div.empty().append('<ul>');
		$.getJSON (o.url, { prm_cha_id: o.cha_id, output: 'json' }, function (data) {
			$.each (data, function (idx, val) {
				div.find('ul').append ('<li id="sen_'+val.sen_id+'">'+val.sen_libelle+'</li>');
			    });
			div.find('li').css ('cursor', 'pointer');
			div.find('li').unbind('click').click (function () {
				var sen_id = $(this).attr('id').substr (4);
				if (typeof o.return == 'function') {
				    o.return.call (this, sen_id);
				    div.dialog('destroy');
				}
			    });
		    });

		div.dialog ({
			title: o.title,
			    width: 450,
			    height: 400,
			    modal: true,
			    resizable: true
		    });
	    });
    }
}) (jQuery);
