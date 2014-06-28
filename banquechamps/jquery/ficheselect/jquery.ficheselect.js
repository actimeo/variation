(function ($) {
    $.fn.ficheSelect = function (options) {
	var defaults = {
	    "title": "Sélection d'une fiche",
	    'url': '/ajax/fiche_list.php?por=',
	    'return': null,
	}
	var o = jQuery.extend (defaults, options);
	return this.each (function () {
	    var div = $(this);
	    div.addClass ('ficheselect-top');
	    div.empty().html('<div id="ficheselect-frame"></div>');
	    $("#ficheselect-frame").load(o.url+o.por, {}, function () {
		$("#ficheselect-frame").jstree ({
		    "plugins": ['themes', 'html_data', 'ui', 'types'],
		    "types": {
			"types": {
			    "default": {
				"icon": {
				    "image": "/images/icons/jstree_page.gif"
				}
			    }
			}
		    }
		}).bind("select_node.jstree", function (event, data) {
		    var id = data.rslt.obj.attr("id");
		    if (id != undefined)  {
			o.return.call (this, id);
			div.dialog('destroy');			
		    }
		    }).bind ('dblclick.jstree', function (event) {
			var node = $(event.target).closest("li");
			$("#ficheselect-frame").jstree ("toggle_node", node);
		    })
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
