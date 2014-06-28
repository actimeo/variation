(function ($) {
    $.fn.ressourceSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une ressource",
	    'url': '/',
	    return: null
	}
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {		
		var div = $(this);
		div.empty().html ('<div style="margin: 10px"><ul id="ressourceselect-ul"></ul></div>');
		var sec_ids = new Array();
		$(".secteur_event").each (function () {
			sec_ids.push ($(this).attr('id').substr (14));
		    });		
		$(".secteur_event_ro").each (function () {
			sec_ids.push ($(this).attr('id').substr (14));
		    });		
		$.getJSON (o.url, { prm_sec_id: sec_ids, output: 'json'}, function (data) {
			$.each (data, function (idx, val) {
				$("#ressourceselect-ul").append('<li id="ressourceselect-res-'+val.res_id+'" class="ressourceselect-res">'+val.res_nom+'</li>');
			    });
			div.find('li').click (function () {
				var id = $(this).attr('id').substr (20);
				if (typeof o.return == 'function') {
				    o.return.call (this, id, $(this).text());
				    div.dialog('destroy');
				}
			    });
			div.dialog ({
			    title: o.title,
			    width: 300,
				    autoResize: true,				    
			    modal: true,
			    resizable: false
		    });

		});
	    });
    };
}) (jQuery);
