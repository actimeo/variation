(function ($) {
    $.fn.etablissementSelect = function (options) {
	var defaults = {
	    title: 'Choisissez un établissement',
	    url: '/ajax/etablissement_liste.php',
	    sec_code: '',
	    interne: null
	};
	
	var o = jQuery.extend (defaults, options);

	return this.each (function () {
	    var div = $(this);
	    div.empty().html ('<div style="margin: 10px"><ul id="etablissementselect-ul"></ul></div>');
	    $.getJSON (o.url, { prm_interne: o.interne, prm_secteur: o.sec_code != null ? o.sec_code : '', output: 'json2' }, function (res) {
			$.each (res, function (idx, val) {
				$("#etablissementselect-ul").append('<li id="etablissementselect-res-'+val.eta_id+'" class="etablissementselect-res">'+val.eta_nom+'</li>');
			    });
			div.find('li').click (function () {
				var id = $(this).attr('id').substr (24);
				if (typeof o.return == 'function') {
				    o.return.call (this, id, $(this).text());
				    div.dialog('destroy');
				}
			    });
		    });
		
		div.dialog ({
			title: o.title,
			    width: 300,
			    height: 300,
			    modal: true,
			    resizable: false
			    });
		
	    });
    }
}) (jQuery);
