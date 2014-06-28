-- This file is part of Variation.

-- Variation is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as published
-- by the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- Variation is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.

-- You should have received a copy of the GNU Affero General Public License
-- along with Variation.  If not, see <http://www.gnu.org/licenses/>.
-- --------------------------------------------------------------------------------
-- Ce fichier fait partie de Variation.

-- Variation est un logiciel libre ; vous pouvez le redistribuer ou le modifier 
-- suivant les termes de la GNU Affero General Public License telle que publiée 
-- par la Free Software Foundation ; soit la version 3 de la licence, soit 
-- (à votre gré) toute version ultérieure.

-- Variation est distribué dans l'espoir qu'il sera utile, 
-- mais SANS AUCUNE GARANTIE ; sans même la garantie tacite de 
-- QUALITÉ MARCHANDE ou d'ADÉQUATION à UN BUT PARTICULIER. Consultez la 
-- GNU Affero General Public License pour plus de détails.

-- Vous devez avoir reçu une copie de la GNU Affero General Public License 
-- en même temps que Variation ; si ce n'est pas le cas, 
-- consultez <http://www.gnu.org/licenses>.
-- --------------------------------------------------------------------------------
-- Copyright (c) 2014 Kavarna SARL

SET search_path = admin, pg_catalog;

DROP FUNCTION IF EXISTS admin_supprime_tout();
CREATE OR REPLACE FUNCTION admin_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM admin.admin_document_supprime_tout(prm_token);
	PERFORM admin.admin_event_supprime_tout(prm_token);
	PERFORM admin.admin_fiche_supprime_tout();
	PERFORM admin.admin_note_supprime_tout(prm_token);
	PERFORM admin.admin_ressource_supprime_tout();
	PERFORM admin.admin_utilisateur_supprime_tout(prm_token);
	PERFORM admin.admin_grouputil_supprime_tout();
	PERFORM admin.admin_personne_supprime_tout(prm_token);
	PERFORM admin.admin_groupe_supprime_tout(prm_token);
	PERFORM admin.admin_event_type_etablissement_supprime_tout();
	PERFORM admin.admin_etablissement_supprime_tout(prm_token);
	RETURN 1;
END;
$$;

DROP FUNCTION IF EXISTS admin_categorie_supprime_tout();
CREATE OR REPLACE FUNCTION admin_categorie_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	cat integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM meta.categorie;
	FOR cat IN SELECT cat_id FROM meta.categorie LOOP
		PERFORM meta.meta_categorie_delete (prm_token, cat);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_document_supprime_tout();
CREATE OR REPLACE FUNCTION admin_document_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	doc integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM document.document;
	FOR doc IN SELECT doc_id FROM document.document LOOP
		PERFORM document.document_document_supprime (prm_token, doc);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_document_type_supprime_tout();
CREATE OR REPLACE FUNCTION admin_document_type_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	dty integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM document.document_type;
	FOR dty IN SELECT dty_id FROM document.document_type LOOP
		PERFORM document.document_document_type_supprime (prm_token, dty);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_documents_supprime_tout();
CREATE OR REPLACE FUNCTION admin_documents_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	dos integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM document.documents;
	FOR dos IN SELECT dos_id FROM document.documents LOOP
		PERFORM document.document_documents_supprime (prm_token, dos);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_etablissement_supprime_tout();
CREATE OR REPLACE FUNCTION admin_etablissement_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	eta integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM public.etablissement;
	FOR eta IN SELECT eta_id FROM public.etablissement LOOP
		PERFORM public.etablissement_supprime (prm_token, eta);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_event_supprime_tout();
CREATE OR REPLACE FUNCTION admin_event_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	eve integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM events.event;
	FOR eve IN SELECT eve_id FROM events.event LOOP
		PERFORM events.events_event_supprime (prm_token, eve);
	END LOOP;	
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_event_type_supprime_tout();
CREATE OR REPLACE FUNCTION admin_event_type_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	ety integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM events.event_type;
	FOR ety IN SELECT ety_id FROM events.event_type LOOP
		PERFORM events.events_event_type_supprime (prm_token, ety);
	END LOOP;	
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_events_supprime_tout();
CREATE OR REPLACE FUNCTION admin_events_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	evs integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM events.events;
	FOR evs IN SELECT evs_id FROM events.events LOOP
		PERFORM events.events_events_supprime (prm_token, evs);
	END LOOP;	
	RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION admin_event_type_etablissement_supprime_tout() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM events.event_type_etablissement;
	DELETE FROM events.event_type_etablissement;
	RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION admin_fiche_supprime_tout() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM lock.fiche;
	DELETE FROM lock.fiche;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_groupe_supprime_tout();
CREATE OR REPLACE FUNCTION admin_groupe_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	grp integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM public.groupe;
	FOR grp IN SELECT grp_id FROM public.groupe LOOP
		PERFORM public.groupe_supprime (prm_token, grp);
	END LOOP;
	RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION admin_grouputil_supprime_tout() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	gut integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM login.grouputil;
	FOR gut IN SELECT gut_id FROM login.grouputil LOOP
		PERFORM login.login_grouputil_supprime (gut);
	END LOOP;
	RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION admin_info_supprime_tout () RETURNS void 
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM meta.info_aide;
	DELETE FROM meta.info;	
	DELETE FROM meta.selection_entree;
	DELETE FROM meta.selection;
	DELETE FROM meta.dirinfo;
END;
$$;

DROP FUNCTION IF EXISTS admin_liste_supprime_tout();
CREATE OR REPLACE FUNCTION admin_liste_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	lis integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM liste.liste;
	FOR lis IN SELECT lis_id FROM liste.liste LOOP
		PERFORM liste.liste_liste_supprime (prm_token, lis);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_metier_supprime_tout();
CREATE OR REPLACE FUNCTION admin_metier_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	met integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM meta.metier;
	FOR met IN SELECT met_id FROM meta.metier LOOP
		PERFORM meta.metier_supprime (prm_token, met);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_note_supprime_tout();
CREATE OR REPLACE FUNCTION admin_note_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	no integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM notes.note;
	FOR no IN SELECT not_id FROM notes.note LOOP
		PERFORM notes.notes_note_supprime (prm_token, no);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_notes_supprime_tout();
CREATE OR REPLACE FUNCTION admin_notes_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	nos integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM notes.notes;
	FOR nos IN SELECT nos_id FROM notes.notes LOOP
		PERFORM notes.notes_notes_supprime (prm_token, nos);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_personne_supprime_tout();
CREATE OR REPLACE FUNCTION admin_personne_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	per integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM personne;
	FOR per IN SELECT per_id FROM personne LOOP
		PERFORM personne_supprime (prm_token, per);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin.admin_portail_supprime_tout();
CREATE OR REPLACE FUNCTION admin.admin_portail_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	por integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM meta.portail;
	FOR por IN SELECT por_id FROM meta.portail LOOP
	    PERFORM meta.meta_portail_delete_rec (prm_token, por);
	    END LOOP;
	    RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_procedure_supprime_tout();
CREATE OR REPLACE FUNCTION admin_procedure_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	pro integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM procedure.procedure;
	FOR pro IN SELECT pro_id FROM procedure.procedure LOOP
		PERFORM procedure.procedure_procedure_supprime (prm_token, pro);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_ressource_supprime_tout();
CREATE OR REPLACE FUNCTION admin_ressource_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	res integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM ressource.ressource;
	FOR res IN SELECT res_id FROM ressource.ressource LOOP
		PERFORM ressource.ressource_supprime (prm_token, res);
	END LOOP;
	RETURN ret;
END;
$$;

CREATE OR REPLACE FUNCTION admin_secteur_infos_supprime_tout () RETURNS void 
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM public.secteur_infos;
END;
$$;

DROP FUNCTION IF EXISTS admin_terme_supprime_tout();
CREATE OR REPLACE FUNCTION admin_terme_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	ter integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM localise.terme;
	FOR ter IN SELECT ter_id FROM localise.terme LOOP
		PERFORM localise.localise_terme_supprime (prm_token, ter);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_theme_supprime_tout();
CREATE OR REPLACE FUNCTION admin_theme_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	the integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM notes.theme;
	FOR the IN SELECT the_id FROM notes.theme LOOP
		PERFORM notes.notes_theme_supprime (prm_token, the);
	END LOOP;
	RETURN ret;
END;
$$;

DROP FUNCTION IF EXISTS admin_utilisateur_supprime_tout();
CREATE OR REPLACE FUNCTION admin_utilisateur_supprime_tout(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	uti integer;
BEGIN
	SELECT COUNT(*) INTO ret FROM login.utilisateur;
	FOR uti IN SELECT uti_id FROM login.utilisateur LOOP
		PERFORM login.utilisateur_supprime (prm_token, uti);
	END LOOP;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION admin_utilisateur_supprime_tout(prm_token integer) IS
'Supprime tous les utilisateurs.
Entrée : 
 - prm_token : Token d''authentification
Remarques :
Nécessite les droits à la configuration "Établissement"
';