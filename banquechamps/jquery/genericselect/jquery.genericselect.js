(function ($) {
    $.fn.genericSelect = function (options) {
	var defaults = {
	    "title": "Sélection",
	    'url': '/',
	    'params': null,
	    'return': null
	};
	
	var o = jQuery.extend (defaults, options);
	
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('genericselect-top');
	    div.empty ().html ('<ul></ul>');
	    $.getJSON (o.url, o.params, function (data) {
		$.each (data, function (idx, val) {
		    div.children("ul").append ('<li><div id="genericselect-divgeneric-'+val.id+'" class="genericselect-divgeneric">'+val.nom+'</div></li>');
		});
		$('.genericselect-divgeneric').click (function () {
		    if (typeof o.return == 'function') {
			o.return.call (this, $(this).attr('id').substr (25), $(this).text());
			div.dialog('destroy');
		    }
		});
		div.dialog ({
		    title: o.title,
		    width: 370,
		    height: 400,
		    modal: true,
		    resizable: true
		});
		
	    });
	});
    }
}) (jQuery);
