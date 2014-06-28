(function ($) {
    $.fn.secteurSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'un secteur",
	    'url': '/',
	    'return': null
	};

	var o = jQuery.extend (defaults, options);
	
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('secteurselect-top');
	    div.empty ().html ('<ul></ul>');
	    $.getJSON (o.url, {}, function (data) {
		$.each (data, function (idx, val) {
		    div.children("ul").append ('<li><div id="secteurselect-divsecteur-'+val.sec_id+'" class="secteurselect-divsecteur"><img width="64" src="'+val.sec_icone.replace (/%d/g, '64')+'"><br/><span>'+val.sec_nom+'</span></div></li>');
		});
		$('.secteurselect-divsecteur').click (function () {
		    if (typeof o.return == 'function') {
			o.return.call (this, $(this).attr('id').substr (25), $(this).children ("span").text());
			div.dialog('destroy');
		    }
		});
		div.dialog ({
		  title: o.title,
		  width: "670px",
		  autoResize: true,
		  modal: true,
			resizable: false
		});
		
	    });
	});
    }
}) (jQuery);
