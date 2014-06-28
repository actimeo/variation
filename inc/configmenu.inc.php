<?php
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
?>
<?php
class TopConfigMenu {
  public $label;  
  public $submenus;
  public $isRoot;
  public $isAdmin;
  public function __construct ($label, $submenus) {
    $this->label = $label;
    $this->submenus = $submenus;
    $isRoot = false;
    $isAdmin = false;
    foreach ($submenus as $submenu) {
      if ($submenu->isRoot)
	$this->isRoot = true;
      if ($submenu->isAdmin)
	$this->isAdmin = true;
    }
  }

  public function display ($isRoot, $isAdmin) {
    if ( !(($isRoot && $this->isRoot) || ($isAdmin && $this->isAdmin))) {
      return;
    }
    echo '<h3>'.$this->label.'</h3>';
    echo '<div>';
    echo '<ul class="ultopsousmenu">';
    foreach ($this->submenus as $submenu) {
      $submenu->display ($isRoot, $isAdmin);
    }
    echo '</ul>';
    echo '</div>';    
  }
}

class ConfigMenu {
  public $script;
  public $label;
  public $icon;
  public $isRoot;
  public $isAdmin;
  public function __construct ($script, $label, $icon) {
    $this->script = $script;
    $this->label = $label;
    $this->icon = $icon;
    $this->isRoot = (substr ($script, 0, 5) == 'root/');
    $this->isAdmin = !$this->isRoot;
  }
  public function display ($isRoot, $isAdmin) {
    if ((!$isRoot && $this->isRoot) || (!$isAdmin && $this->isAdmin))
      return;
    echo '<li'.($this->script == $_SESSION['config'] ? ' class="selected"' : '').'><a href="?config='.$this->script.'"><span class="icone"><img src="'.$this->icon.'"></img></span><span class="label">'.$this->label.'</span></a></li>';
  }
}

$configmenus = array (
		      new TopConfigMenu ('Système', 
					 array(
					       new ConfigMenu ('root/secteurs', "Thématiques d'ensemble", 
							       '/Images/IS_Real_vista_Business/originals/png/NORMAL/32/pie_chart_32.png'),
					       /*new ConfigMenu ('root/nomenclature', "Catégories d'établissements", 
						 ''),*/
					       new ConfigMenu ('root/etablissements', "Établissements", 
							       '/Images/IS_real_vista_real_state/png/NORMAL/32/villa_32.png'),
					       new ConfigMenu ('root/events_types', "Types d'événements", 
							       '/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/time_sheet_32.png'),
					       new ConfigMenu ('root/document_types', "Types de documents", 
							       '/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/spread_sheet_32.png'),
					       new ConfigMenu ('root/themes_notes', "Boîtes de notes",
							       '/Images/IS_Real_vista_Communications/originals/png/NORMAL/32/mail_inbox_32.png'),
					       new ConfigMenu ('admin/metiers', "Métiers",
							       "/Images/IS_Real_vista_Jobs_icons/originals/png/NORMAL/32/nurse_32.png")
					       )),
		      
		      new TopConfigMenu ("Fonctionnement de l'établissement",
					 array (new ConfigMenu ("admin/events_types", "Fonctionnement événementiel", 
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/time_sheet_32.png"),
						new ConfigMenu ("admin/documents_types", "Fonctionnement documentaire",
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/spread_sheet_32.png"),
						new ConfigMenu ("admin/groupes", "Groupes des établissements",
								"/Images/IS_Real_vista_Networking/originals/png/NORMAL/32/sharing_32.png"),
						new ConfigMenu ("admin/vue_types", "Vue d'ensemble",
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/time_sheet_32.png"),
						)),
		      new TopConfigMenu ('Gestion des utilisateurs',
					 array (new ConfigMenu ("admin/grouputils", "Groupes d'utitilisateurs",
								"/Images/IS_Real_vista_Business/originals/png/NORMAL/32/niche_32.png"),
						new ConfigMenu ("admin/utilisateurs", "Utilisateurs",
								"/Images/IS_Real_vista_Business/originals/png/NORMAL/32/focus_group_32.png"),
						)),
		      new TopConfigMenu ("Champs",
					 array (/*new ConfigMenu ("root/champs", "Champs",
						  ''),*/
						new ConfigMenu ("root/selections", "Listes de sélections",
								"/Images/IS_Real_vista_Text/originals/png/NORMAL/32/bullets_32.png"),
						new ConfigMenu ("root/localise", "Intitulés",
								"/Images/IS_Real_vista_Mail_icons/originals/png/NORMAL/32/blacklist_32.png"),
						)),
		      new TopConfigMenu ("Vues",
					 array (/*new ConfigMenu ("root/vues_listes", "Vues listes",
						  ""),*/
						new ConfigMenu ("root/vues_evts", "Vues d'événements",
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/time_sheet_32.png"),
						new ConfigMenu ("root/vues_documents", "Vues de documents",
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/spread_sheet_32.png"),
						new ConfigMenu ("root/vues_themes", "Vues de ressources",
								"/Images/IS_Real_vista_Video_production/originals/png/NORMAL/32/digital_projector_32.png"),
						/*new ConfigMenu ("root/vues_notes", "Vues de notes",
						  "")*/

						)),
		      new TopConfigMenu ("Portails",
					 array (
						new ConfigMenu ("root/interface", "Éditeur de portails",
								"/Images/IS_Real_vista_Construction/originals/png/NORMAL/32/men_working_sign_32.png"),
						)),
		      new TopConfigMenu ("Droits", 
					 array (new ConfigMenu ("root/permissions", 'Fiches',
								"/Images/IS_Real_vista_Database/originals/png/NORMAL/32/primary_key_32.png"),
						new ConfigMenu ("admin/etablissements", "Prestations fournies",
								"/Images/IS_real_vista_real_state/png/NORMAL/32/villa_32.png"),
						new ConfigMenu ("admin/secteurs_besoins", "Prestations croisées (besoins)",
								"/Images/IS_Real_vista_3d_graphics/originals/png/NORMAL/32/figure_32.png"),
						new ConfigMenu ("admin/secteurs_roles", "Prestations croisées (rôles)",
								"/Images/IS_Real_vista_Accounting/originals/png/NORMAL/32/collection_account_32.png"),
						)),
		      new TopConfigMenu ("Données",
					 array (new ConfigMenu ("admin/reseau", "Partenaires",
								"/Images/IS_Real_vista_Medical/originals/png/NORMAL/32/appointment_32.png"),
						new ConfigMenu ("admin/ressources", "Ressources",
								"/Images/IS_Real_vista_Video_production/originals/png/NORMAL/32/digital_projector_32.png"),
						new ConfigMenu ("admin/procedures", "Procédures",
								"/Images/IS_real_vista_project_managment/png/NORMAL/32/task_notes_32.png"),
						new ConfigMenu ("admin/personnes", "Personnes",
								"/Images/IS_Real_vista_Web_design/originals/png/NORMAL/32/our_team_32.png"),
						)),
		      new TopConfigMenu ("Outils",
					 array (new ConfigMenu ("root/imports", "Imports",
								"/Images/IS_Real_vista_Database/originals/png/NORMAL/32/insert_table_32.png"),
						new ConfigMenu ("root/debug", "Debug",
								"/Images/IS_Real_vista_Social/originals/png/NORMAL/32/report_bug_32.png"),
						)),
		      );
?>
