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
    $(".datepicker").datepicker ({
	showOn: "button",
	buttonImage: "/Images/datepicker.png",
	buttonImageOnly: true,
	showButtonPanel: true,
	changeYear: true,
	showWeek: true,
	gotoCurrent: true,
	yearRange: "c-64:c+10"
    });
    
    $(".datetimepicker").datetimepicker ({
	showOn: "button",
	buttonImage: "/Images/datepicker.png",
	buttonImageOnly: true,
	showButtonPanel: true,
	changeYear: true,
	showWeek: true,
	gotoCurrent: true,
	yearRange: "c-64:c+10"
    });

    $(".procedure").click (function () {
	var pro_id = $(this).attr('id').substr (4);
	var titre = $(this).html ();
	// window.parent retourne window pour la fenêtre principale
	window.parent.$("#dlg_aide").dialog ({ 
	    modal: false,
	    width: 800,
	    height: 400,
	    title: titre
		});
	window.parent.$("#dlg_aide").html ('<div id="aide_contenu"></div>');
	window.parent.$("#aide_contenu").load('/ajax/procedure.php?id='+pro_id);
    });

    $(".qtipable").qtip ({ position: {
  	corner: {
	    target: 'topMiddle',
	    tooltip: 'bottomMiddle'
	}
    },
			   style: {
			       name: 'light',
			       tip: "bottomMiddle"
			   }
			 });
});
