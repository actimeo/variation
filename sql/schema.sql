--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: admin; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA admin;


--
-- Name: cron; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA cron;


--
-- Name: document; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA document;


--
-- Name: SCHEMA document; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA document IS 'Données des documents rattachés aux usagers.
Il est possible de rattacher des documents à des usagers, et de les classifier par secteur (thème) et par type de document. 
Il est possible de définir des types de documents et des les affecter à des secteurs (thèmes) particuliers. Chacun de ces types de documents pourront être utilisés ou non par chacun des établissements du réseau.
';


--
-- Name: events; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA events;


--
-- Name: SCHEMA events; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA events IS 'Données des événements rattachés aux usagers.
Il est possible de définir des pages événements, spécialisables par secteur et par catégories d''événements.
Il est possible de créer des événements et de les rattacher à des personnes (usager, personnel, contact, famille) et des secteurs. On peut lui spécifier un type d''événement (d''où découle une catégorie), et y affecter des ressources (voir schéma ressource).
Il est possible de définir des types d''événements (classifiés en catégories) et de les affecter à des secteurs. Chacun de ces types d''événements pourra être utilisé ou non par chacun des établissements du réseau.
Il est possible de définir des pages Agenda ressource, résumant l''utilisation des ressources affectées aux événements.
';


--
-- Name: liste; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA liste;


--
-- Name: SCHEMA liste; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA liste IS 'Configuration des pages liste.
Une page liste est définie par une liste de champs usager, personnel, contact ou famille.';


--
-- Name: localise; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA localise;


--
-- Name: SCHEMA localise; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA localise IS 'Système de localisation. A ce point, il est possible de localiser un terme pour un secteur particulier.';


--
-- Name: lock; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA lock;


--
-- Name: SCHEMA lock; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA lock IS 'Système de verrouillage de fiches.';


--
-- Name: login; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA login;


--
-- Name: SCHEMA login; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA login IS 'Procédures d''authentification de l''utilisateur. Gestion des utilisateurs et groupes d''utilisateurs.
L''utilisateur s''authentifie auprès du webservice avec son login et mot de passe à l''aide de la fonction utilisateur.utilisateur_login2 (prm_login, prm_mdp)
Cette fonction retourne :
 - son identifiant
 - un token d''authentification
 - les droits de l''utilisateur à configurer le réseau et/ou l''établissement
 - la liste des paires (etablissement/portail) auxquels l''utilisateur a droit de se connecter
 - si son mot de passe est provisoire

Le token d''authentification, qui devra être utilisé dans toute fonction à accès restreint, permet d''authentifier de nouveau l''utilisateur sans avoir à envoyer de nouveau le login et mot de passe.
Le token est valable durant un laps de temps configurable, et au plus tard jusqu''à la déconnexion de l''utilisateur.

Les droits de l''utilisateur à configurer le réseau et/ou l''établissement sont donnés pour information. L''interface graphique pourra par exemple, selon ces droits, afficher ou non les menus correspondants. Les fonctions de configuration du réseau et de l''établissement ont un accès restreint (un token devra être donné). Elles retourneront une erreur en cas d''accès illicite, et une alerte de sécurité pourra être levée.

Un certain nombre de fonctions demandent un établissement et/ou portail en paramètre. Ces paramètres devront être renseignés avec des établissement/portail auxquels l''utilisateur a accès. Elles retourneront une erreur en cas d''accès illicite à un établissement/portail. Si ces paramètres ne sont pas renseignés lors de l''appel à la fonction, celle-ci agira sur tous les établissements/portails auxquels à accès l''utilisateur.

Un mot de passe provisoire est stocké en clair dans la base de données. Un utilisateur ayant droit de configuration de l''établissement a accès en lecture à ces mots de passe provisoires, et a le droit d''écraser un mot de passe non provisoire avec un nouveau mot de passe provisoire. Un utilisateur peut à tout moment définir un nouveau mot de passe pour son compte, qui devient alors non provisoire.';


--
-- Name: meta; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA meta;


--
-- Name: SCHEMA meta; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA meta IS 'Informations de construction de l''interface. Informations de base.';


--
-- Name: notes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA notes;


--
-- Name: SCHEMA notes; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA notes IS 'Données des notes écrites par les utilisateurs.
Les utilisateurs peuvent écrire des notes. Ces notes, peuvent, indépendemment :
 - être rattachées à un ou plusieurs usagers
 - être rattachées à un ou plusieurs groupes d''usagers
 - être explicitement à destination d''autres utilisateurs, pour information ou pour action
 - être classifiées dans des boîtes thématiques.
L''utilisateur qui a écrit une note peut à tout moment savoir si les utilisateurs destinataires de cette note pour information respectivement action ont marqué cette note comme lue resp. faite.
';


--
-- Name: permission; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA permission;


--
-- Name: SCHEMA permission; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA permission IS 'Enregistrement des diverses permissions.';


--
-- Name: procedure; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA procedure;


--
-- Name: SCHEMA procedure; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA procedure IS 'Documentations à afficher sur diverses pages.';


--
-- Name: ressource; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ressource;


--
-- Name: SCHEMA ressource; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA ressource IS 'Ressources à affecter à des événements.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

--CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

--CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

--COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = document, pg_catalog;

--
-- Name: document_document_secteur_liste_details; Type: TYPE; Schema: document; Owner: -
--

CREATE TYPE document_document_secteur_liste_details AS (
	dse_id integer,
	sec_id integer,
	sec_nom character varying
);


--
-- Name: document_documents_groupe_liste; Type: TYPE; Schema: document; Owner: -
--

CREATE TYPE document_documents_groupe_liste AS (
	grp_id integer,
	grp_nom character varying,
	eta_id integer,
	eta_nom character varying
);


--
-- Name: document_documents_secteur_liste_details; Type: TYPE; Schema: document; Owner: -
--

CREATE TYPE document_documents_secteur_liste_details AS (
	dss_id integer,
	sec_id integer,
	sec_nom character varying,
	sec_icone character varying
);


SET search_path = events, pg_catalog;

--
-- Name: events_document_liste; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_document_liste AS (
	doc_id integer,
	doc_titre character varying,
	doc_description character varying,
	d integer,
	doc_icone character varying,
	usagers character varying
);


--
-- Name: events_echeance_liste; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_echeance_liste AS (
	per_id integer,
	inf_id integer,
	inf_libelle character varying,
	inf_libelle_complet character varying,
	nom character varying,
	prenom character varying,
	d integer,
	inf__date_echeance_icone character varying
);


--
-- Name: events_event_avec_ressource_liste; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_event_avec_ressource_liste AS (
	eve_id integer,
	res_id integer,
	res_nom character varying,
	eve_intitule character varying,
	eve_debut integer,
	eve_fin integer
);


--
-- Name: events_event_liste; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_event_liste AS (
	eve_id integer,
	eca_id integer,
	eve_intitule character varying,
	eve_debut integer,
	eve_fin integer,
	sec_icone character varying,
	eve__depenses_montant numeric
);


--
-- Name: events_event_type_list_all; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_event_type_list_all AS (
	eca_nom character varying,
	ety_id integer,
	eca_id integer,
	ety_intitule character varying,
	ety_intitule_individuel boolean
);


--
-- Name: events_event_type_list_par_evs; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_event_type_list_par_evs AS (
	id integer,
	nom character varying
);


--
-- Name: events_groupe_liste; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_groupe_liste AS (
	per_id integer,
	nom character varying,
	prenom character varying,
	valeur integer,
	grp_nom character varying,
	sec_icone character varying
);


--
-- Name: events_groupe_liste2; Type: TYPE; Schema: events; Owner: -
--

CREATE TYPE events_groupe_liste2 AS (
	grp_id integer,
	grp_nom character varying,
	eta_id integer,
	eta_nom character varying
);


SET search_path = liste, pg_catalog;

--
-- Name: liste_champ_liste_details; Type: TYPE; Schema: liste; Owner: -
--

CREATE TYPE liste_champ_liste_details AS (
	cha_id integer,
	cha__groupe_contact boolean,
	cha__groupe_cycle boolean,
	cha__groupe_dernier boolean,
	cha_libelle character varying,
	cha_ordre integer,
	cha_filtrer boolean,
	cha_verrouiller boolean,
	cha__famille_details boolean,
	cha_champs_supp boolean,
	inf_libelle character varying,
	int_code character varying,
	int_libelle character varying,
	inf_multiple boolean,
	cha__contact_filtre_utilisateur boolean
);


SET search_path = localise, pg_catalog;

--
-- Name: localise_terme_liste_details; Type: TYPE; Schema: localise; Owner: -
--

CREATE TYPE localise_terme_liste_details AS (
	ter_id integer,
	ter_code character varying,
	ter_commentaire character varying,
	defaut character varying
);


SET search_path = login, pg_catalog;

--
-- Name: utilisateur_liste_details_configuration; Type: TYPE; Schema: login; Owner: -
--

CREATE TYPE utilisateur_liste_details_configuration AS (
	uti_id integer,
	uti_login character varying,
	uti_prenom character varying,
	uti_nom character varying
);


--
-- Name: utilisateur_login2; Type: TYPE; Schema: login; Owner: -
--

CREATE TYPE utilisateur_login2 AS (
	uti_id integer,
	tok_token integer,
	uti_root boolean,
	uti_config boolean,
	eta_id integer,
	por_id integer,
	uti_pwd_provisoire boolean
);


--
-- Name: utilisateur_usagers_liste; Type: TYPE; Schema: login; Owner: -
--

CREATE TYPE utilisateur_usagers_liste AS (
	per_id integer,
	libelle character varying
);


SET search_path = meta, pg_catalog;

--
-- Name: meta_info_groupe_liste; Type: TYPE; Schema: meta; Owner: -
--

CREATE TYPE meta_info_groupe_liste AS (
	ing_id integer,
	ing_ordre integer,
	ing__groupe_cycle boolean,
	inf_id integer,
	int_id integer,
	inf_code character varying,
	inf_libelle character varying,
	inf__textelong_nblignes integer,
	inf__selection_code integer,
	inf_etendu boolean,
	inf_historique boolean,
	inf_multiple boolean,
	inf__groupe_type character varying,
	inf__contact_filtre character varying,
	inf__metier_secteur character varying,
	inf__contact_secteur character varying,
	inf__etablissement_interne boolean,
	din_id integer,
	inf__groupe_soustype integer
);


--
-- Name: meta_info_usage; Type: TYPE; Schema: meta; Owner: -
--

CREATE TYPE meta_info_usage AS (
	cat_nom character varying,
	por_libelle character varying,
	ent_libelle character varying,
	men_libelle character varying,
	sme_libelle character varying
);


--
-- Name: meta_sousmenus_liste_depuis_topmenu; Type: TYPE; Schema: meta; Owner: -
--

CREATE TYPE meta_sousmenus_liste_depuis_topmenu AS (
	men_id integer,
	men_libelle character varying,
	sme_id integer,
	sme_libelle character varying
);


--
-- Name: metier_liste_details; Type: TYPE; Schema: meta; Owner: -
--

CREATE TYPE metier_liste_details AS (
	met_id integer,
	met_nom character varying,
	secteurs character varying,
	entites character varying
);


SET search_path = notes, pg_catalog;

--
-- Name: note_destinataire_derniers_par_utilisateur; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE note_destinataire_derniers_par_utilisateur AS (
	per_id integer,
	libelle character varying
);


--
-- Name: note_destinataires_liste; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE note_destinataires_liste AS (
	libelle character varying,
	nde_pour_action boolean,
	nde_pour_information boolean,
	nde_action_faite boolean,
	nde_information_lue boolean,
	nde_supprime boolean
);


--
-- Name: note_usagers_liste; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE note_usagers_liste AS (
	per_id integer,
	libelle character varying
);


--
-- Name: notes_note_boite_envoi_liste; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE notes_note_boite_envoi_liste AS (
	not_id integer,
	not_date_saisie timestamp with time zone,
	not_date_evenement timestamp with time zone,
	not_objet character varying,
	not_texte text,
	eta_id_auteur integer
);


--
-- Name: notes_note_boite_reception_liste; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE notes_note_boite_reception_liste AS (
	not_id integer,
	not_date_saisie timestamp with time zone,
	not_date_evenement timestamp with time zone,
	not_objet character varying,
	not_texte text,
	uti_id_auteur integer,
	eta_id_auteur integer,
	nde_id integer,
	nde_pour_action boolean,
	nde_pour_information boolean,
	nde_action_faite boolean,
	nde_information_lue boolean
);


--
-- Name: notes_note_mesnotes; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE notes_note_mesnotes AS (
	not_id integer,
	not_date_saisie timestamp with time zone,
	not_date_evenement timestamp with time zone,
	not_objet character varying,
	not_texte text,
	uti_id_auteur integer,
	eta_id_auteur integer
);


--
-- Name: notes_theme_liste_details; Type: TYPE; Schema: notes; Owner: -
--

CREATE TYPE notes_theme_liste_details AS (
	the_id integer,
	the_nom character varying,
	portails character varying
);


SET search_path = procedure, pg_catalog;

--
-- Name: procedure_procedure_details; Type: TYPE; Schema: procedure; Owner: -
--

CREATE TYPE procedure_procedure_details AS (
	pro_id integer,
	pro_titre character varying,
	n_affectations integer
);


SET search_path = public, pg_catalog;

--
-- Name: contact_recherche; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE contact_recherche AS (
	per_id integer,
	per_libelle character varying,
	inf_libelle character varying
);


--
-- Name: etablissement_liste_details; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE etablissement_liste_details AS (
	eta_id integer,
	eta_nom character varying,
	roles character varying,
	besoins character varying
);


--
-- Name: famille_recherche; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE famille_recherche AS (
	per_id integer,
	per_libelle character varying,
	lfa_id integer,
	pif_autorite_parentale boolean,
	pif_droits character varying,
	pif_periodicite character varying
);


--
-- Name: groupe_cherche; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE groupe_cherche AS (
	eta_id integer,
	grp_id integer
);


--
-- Name: groupe_liste; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE groupe_liste AS (
	peg_id integer,
	grp_id integer,
	eta_id integer,
	eta_nom character varying,
	grp_nom character varying,
	peg_debut date,
	peg_fin date,
	peg_notes text,
	peg_cycle_statut integer,
	peg_cycle_date_demande date,
	peg_cycle_date_demande_renouvellement date,
	peg__hebergement_chambre character varying,
	peg__decideur_financeur integer
);


--
-- Name: groupe_liste_details; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE groupe_liste_details AS (
	grp_id integer,
	eta_nom character varying,
	grp_nom character varying,
	roles character varying,
	besoins character varying,
	grp_debut date,
	grp_fin date
);


--
-- Name: integer2; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE integer2 AS (
	valeur1 integer,
	valeur2 integer,
	pij_id integer
);


--
-- Name: personne_cherche; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_cherche AS (
	per_id integer,
	nom_prenom character varying
);


--
-- Name: personne_contact_liste; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_contact_liste AS (
	per_id integer,
	libelle character varying
);


--
-- Name: personne_info_boolean_histo; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_boolean_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur character varying
);


--
-- Name: personne_info_contact_histo; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_contact_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur character varying
);


--
-- Name: personne_info_date_histo; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_date_histo AS (
	debut date,
	fin date,
	valeur date,
	utilisateur character varying
);


--
-- Name: personne_info_integer_get_multiple_details; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_integer_get_multiple_details AS (
	pii_id integer,
	pii_valeur integer
);


--
-- Name: personne_info_integer_histo; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_integer_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur character varying
);


--
-- Name: personne_info_varchar_histo; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE personne_info_varchar_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur character varying
);


--
-- Name: pgprocedures_search_arguments; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE pgprocedures_search_arguments AS (
	argnames character varying[],
	argtypes oidvector
);


--
-- Name: pgprocedures_search_function; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE pgprocedures_search_function AS (
	proc_nspname name,
	proargtypes oidvector,
	prorettype oid,
	ret_typtype character(1),
	ret_typname name,
	ret_nspname name,
	proretset boolean
);


--
-- Name: prise_en_charge_select; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE prise_en_charge_select AS (
	id integer,
	nom character varying
);


SET search_path = ressource, pg_catalog;

--
-- Name: ressource_liste_details; Type: TYPE; Schema: ressource; Owner: -
--

CREATE TYPE ressource_liste_details AS (
	res_id integer,
	res_nom character varying,
	secteurs character varying
);


SET search_path = admin, pg_catalog;

--
-- Name: admin_categorie_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_categorie_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_document_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_document_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_document_type_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_document_type_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_documents_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_documents_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_etablissement_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_etablissement_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_event_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_event_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_event_type_etablissement_supprime_tout(); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_event_type_etablissement_supprime_tout() RETURNS integer
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


--
-- Name: admin_event_type_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_event_type_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_events_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_events_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_fiche_supprime_tout(); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_fiche_supprime_tout() RETURNS integer
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


--
-- Name: admin_groupe_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_groupe_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_grouputil_supprime_tout(); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_grouputil_supprime_tout() RETURNS integer
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


--
-- Name: admin_info_supprime_tout(); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_info_supprime_tout() RETURNS void
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


--
-- Name: admin_liste_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_liste_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_metier_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_metier_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_note_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_note_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_notes_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_notes_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_personne_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_personne_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_portail_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_portail_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_procedure_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_procedure_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_ressource_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_ressource_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_secteur_infos_supprime_tout(); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_secteur_infos_supprime_tout() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM public.secteur_infos;
END;
$$;


--
-- Name: admin_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_terme_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_terme_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_theme_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_theme_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: admin_utilisateur_supprime_tout(integer); Type: FUNCTION; Schema: admin; Owner: -
--

CREATE FUNCTION admin_utilisateur_supprime_tout(prm_token integer) RETURNS integer
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


--
-- Name: FUNCTION admin_utilisateur_supprime_tout(prm_token integer); Type: COMMENT; Schema: admin; Owner: -
--

COMMENT ON FUNCTION admin_utilisateur_supprime_tout(prm_token integer) IS 'Supprime tous les utilisateurs.
Entrée : 
 - prm_token : Token d''authentification
Remarques :
Nécessite les droits à la configuration "Établissement"
';


SET search_path = cron, pg_catalog;

--
-- Name: cron_jour(); Type: FUNCTION; Schema: cron; Owner: -
--

CREATE FUNCTION cron_jour() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
	tmp integer;
BEGIN
	FOR row IN
		SELECT per_id FROM personne WHERE ent_code = 'usager'
	LOOP
		SELECT * INTO tmp FROM meta.meta_statut_usager_calcule ('statut_usager', row.per_id);
	END LOOP;
END;
$$;


SET search_path = document, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: document; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document (
    doc_id integer NOT NULL,
    per_id_responsable integer,
    dty_id integer,
    doc_titre character varying,
    doc_statut integer,
    doc_date_obtention date,
    doc_date_realisation date,
    doc_date_validite date,
    doc_description text,
    doc_fichier character varying,
    doc_date_creation timestamp with time zone,
    uti_id_creation integer
);


--
-- Name: TABLE document; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document IS 'Les documents';


--
-- Name: document_document_get(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_get(prm_token integer, prm_doc_id integer) RETURNS document
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret document.document;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM document.document WHERE doc_id = prm_doc_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_document_get(prm_token integer, prm_doc_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_get(prm_token integer, prm_doc_id integer) IS 'Retourne les informations concernant un document.
Entrées :
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document';


--
-- Name: document_document_liste(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_liste(prm_token integer, prm_dos_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF document
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document;
	p_start timestamp;
	p_end timestamp;

BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	
	FOR row IN
		SELECT DISTINCT document.* 
			FROM document.document
			INNER JOIN document.document_secteur USING(doc_id)
			INNER JOIN document.documents_secteur USING(sec_id)
			INNER JOIN document.documents USING(dos_id)
			INNER JOIN document.document_usager USING(doc_id)
			LEFT JOIN personne_groupe on personne_groupe.per_id = document_usager.per_id_usager
			WHERE dos_id = prm_dos_id 
			AND (documents.dty_id ISNULL OR documents.dty_id = document.dty_id)
			AND (prm_per_id ISNULL OR prm_per_id = per_id_usager)
			AND ((prm_start ISNULL AND prm_end ISNULL) OR doc_date_obtention BETWEEN p_start AND p_end OR doc_date_realisation BETWEEN p_start AND p_end OR doc_date_validite BETWEEN p_start AND p_end)
 			AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)
			AND (prm_per_ids ISNULL OR document_usager.per_id_usager = ANY (prm_per_ids))
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_liste(prm_token integer, prm_dos_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_liste(prm_token integer, prm_dos_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne une liste de documents, filtrée selon plusieurs paramètres.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dos_id : Identifaint de la configuration d''une page de documents, pour utiliser les filtres de cette page
 - prm_per_id : Retourne uniquement les documents rattachés à cet usager
 - prm_start : Date de début de recherche
 - prm_end : Date de fin de recherche
 - prm_grp_id : Retourne uniquement les documents rattachés aux usagers de ce groupe
 - prm_per_ids : Retourne uniquement les documents rattachés à ces usagers';


--
-- Name: document_document_save(integer, integer, integer, integer, character varying, integer, date, date, date, text); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_save(prm_token integer, prm_doc_id integer, prm_per_id_responsable integer, prm_dty_id integer, prm_titre character varying, prm_statut integer, prm_date_obtention date, prm_date_realisation date, prm_date_validite date, prm_description text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	IF prm_doc_id NOTNULL THEN
	   	-- TODO modif uti_id_modif ...
		UPDATE document.document SET
			per_id_responsable = prm_per_id_responsable,
			dty_id = prm_dty_id,
			doc_titre = prm_titre,
			doc_statut = prm_statut,
			doc_date_obtention = prm_date_obtention,
			doc_date_realisation = prm_date_realisation,
			doc_date_validite = prm_date_validite,
			doc_description = prm_description
			WHERE doc_id = prm_doc_id;
		RETURN prm_doc_id;
	ELSE
		INSERT INTO document.document (per_id_responsable, dty_id, doc_titre, doc_statut, doc_date_obtention, doc_date_realisation, doc_date_validite, doc_description, doc_date_creation, uti_id_creation) 
			VALUES (prm_per_id_responsable, prm_dty_id, prm_titre, prm_statut, prm_date_obtention, prm_date_realisation, prm_date_validite, prm_description, CURRENT_TIMESTAMP, uti)
			RETURNING doc_id INTO ret;
		RETURN ret;
	END IF;
END;
$$;


--
-- Name: FUNCTION document_document_save(prm_token integer, prm_doc_id integer, prm_per_id_responsable integer, prm_dty_id integer, prm_titre character varying, prm_statut integer, prm_date_obtention date, prm_date_realisation date, prm_date_validite date, prm_description text); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_save(prm_token integer, prm_doc_id integer, prm_per_id_responsable integer, prm_dty_id integer, prm_titre character varying, prm_statut integer, prm_date_obtention date, prm_date_realisation date, prm_date_validite date, prm_description text) IS 'Crée un nouveau document ou modifie les informations d''un document existant.
Entrées : 
 - prm_token : Token d''authentification, le créateur du document sera l''utilisateur authentifié par ce token lors de la création d''un document
 - prm_doc_id : Identifiant du document à modifier, ou NULL pour créer un document
 - prm_per_id_responsable : Identifiant du personnel responsable
 - prm_dty_id : Identifiant du type de document
 - prm_titre : Intitulé du document
 - prm_statut : Statut du document : 1=À faire, 2=Demandé, 3=Existant
 - prm_date_obtention : Date d''obtention du document
 - prm_date_realisation : Date de réalisation du document
 - prm_date_validite : Date de validité du document
 - prm_description : Description du document';


--
-- Name: document_document_secteur_liste_details(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_secteur_liste_details(prm_token integer, prm_doc_id integer) RETURNS SETOF document_document_secteur_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_document_secteur_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT dse_id, sec_id, sec_nom 
		FROM document.document_secteur
		INNER JOIN meta.secteur USING(sec_id)
		WHERE doc_id = prm_doc_id
	LOOP
		RETURN NEXT row;
	END LOOP;		
END;
$$;


--
-- Name: FUNCTION document_document_secteur_liste_details(prm_token integer, prm_doc_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_secteur_liste_details(prm_token integer, prm_doc_id integer) IS 'Retourne la liste des secteurs (thèmes) auxquels un document est rattaché.
Entrées :
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document
Retour : 
 - dse_id : Identifiant du rattachement du document au secteur 
 - sec_id : Identifiant du secteur
 - sec_nom : nom du secteur
';


--
-- Name: document_document_secteur_save(integer, integer, integer[]); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_secteur_save(prm_token integer, prm_doc_id integer, prm_sec_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM document.document_secteur WHERE doc_id = prm_doc_id 
	LOOP
		IF NOT row.sec_id = ANY (prm_sec_ids) THEN
			DELETE FROM document.document_secteur WHERE dse_id = row.dse_id;
		END IF;
	END LOOP;
	FOR i IN 1 .. array_upper (prm_sec_ids, 1) LOOP
		IF NOT EXISTS (SELECT 1 FROM document.document_secteur WHERE doc_id = prm_doc_id AND sec_id = prm_sec_ids[i]) THEN
			INSERT INTO document.document_secteur (doc_id, sec_id) VALUES (prm_doc_id, prm_sec_ids[i]);
		END IF;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_secteur_save(prm_token integer, prm_doc_id integer, prm_sec_ids integer[]); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_secteur_save(prm_token integer, prm_doc_id integer, prm_sec_ids integer[]) IS 'Rattache un document à une liste de secteurs (thèmes).
Entrées : 
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document
 - prm_sec_ids : Tableau d''identifants de secteurs';


--
-- Name: document_document_set_fichier(integer, integer, character varying); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_set_fichier(prm_token integer, prm_doc_id integer, prm_fichier character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE document.document SET doc_fichier = prm_fichier WHERE doc_id = prm_doc_id;
END;
$$;


--
-- Name: FUNCTION document_document_set_fichier(prm_token integer, prm_doc_id integer, prm_fichier character varying); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_set_fichier(prm_token integer, prm_doc_id integer, prm_fichier character varying) IS 'Rattache un fichier à un document.
Entrées :
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document
 - prm_fichier : Nom du fichier à rattacher au document
';


--
-- Name: document_document_supprime(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_supprime(prm_token integer, prm_doc_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM document.document_secteur WHERE doc_id = prm_doc_id;
	DELETE FROM document.document_usager WHERE doc_id = prm_doc_id;
	DELETE FROM document.document WHERE doc_id = prm_doc_id;
END;
$$;


--
-- Name: FUNCTION document_document_supprime(prm_token integer, prm_doc_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_supprime(prm_token integer, prm_doc_id integer) IS 'Supprime un document.
Entrées : 
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document à supprimer';


--
-- Name: document_document_type_ajoute(integer, character varying); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_ajoute(prm_token integer, prm_nom character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	INSERT INTO document.document_type (dty_nom) VALUES (prm_nom) RETURNING dty_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_document_type_ajoute(prm_token integer, prm_nom character varying); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_ajoute(prm_token integer, prm_nom character varying) IS 'Ajoute un nouveau type de document.
Entrées : 
 - prm_token : Token d''authentification
 - prm_nom : Nom du nouveau type de document
Retour : 
 - Identifiant du type de document créé
Remarques : 
Nécessite les droits à la configuration "Réseau"
';


--
-- Name: document_document_type_etablissement_get(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_etablissement_get(prm_token integer, prm_dty_id integer, prm_eta_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	RETURN EXISTS (SELECT 1 FROM document.document_type_etablissement WHERE dty_id = prm_dty_id AND eta_id = prm_eta_id);
END;
$$;


--
-- Name: FUNCTION document_document_type_etablissement_get(prm_token integer, prm_dty_id integer, prm_eta_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_etablissement_get(prm_token integer, prm_dty_id integer, prm_eta_id integer) IS 'Retourne TRUE si un type de document est affecté à un établissement, FALSE sinon.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document
 - prm_eta_id : Identifiant de l''établissement
Remarques : 
Nécessite les droits à la configuration "Établissement".
';


--
-- Name: document_document_type_etablissement_set(integer, integer, integer, boolean); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_etablissement_set(prm_token integer, prm_dty_id integer, prm_eta_id integer, prm_b boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	IF EXISTS (SELECT 1 FROM document.document_type_etablissement WHERE dty_id = prm_dty_id AND eta_id = prm_eta_id) AND NOT prm_b THEN
		DELETE FROM document.document_type_etablissement WHERE dty_id = prm_dty_id AND eta_id = prm_eta_id;
	ELSIF NOT EXISTS (SELECT 1 FROM document.document_type_etablissement WHERE dty_id = prm_dty_id AND eta_id = prm_eta_id) AND prm_b THEN
		INSERT INTO document.document_type_etablissement (dty_id, eta_id) VALUES (prm_dty_id, prm_eta_id);
	END IF;
END;
$$;


--
-- Name: FUNCTION document_document_type_etablissement_set(prm_token integer, prm_dty_id integer, prm_eta_id integer, prm_b boolean); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_etablissement_set(prm_token integer, prm_dty_id integer, prm_eta_id integer, prm_b boolean) IS 'Indique si un type de document est affecté à un établissement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document
 - prm_eta_id : Identifiant de l''établissement
 - prm_b : TRUE si le type de document est affecté à l''établissement, FALSE sinon
Remarques : 
Nécessite les droits à la configuration "Établissement".';


--
-- Name: document_type; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document_type (
    dty_id integer NOT NULL,
    dty_nom character varying
);


--
-- Name: TABLE document_type; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document_type IS 'Types de documents';


--
-- Name: document_document_type_get(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_get(prm_token integer, prm_dty_id integer) RETURNS document_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret document.document_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM document.document_type WHERE dty_id = prm_dty_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_document_type_get(prm_token integer, prm_dty_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_get(prm_token integer, prm_dty_id integer) IS 'Retourne les informations d''un type de document.
Entrées :
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document';


--
-- Name: document_document_type_liste(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_liste(prm_token integer, prm_doc_id integer, prm_eta_id integer) RETURNS SETOF document_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT document_type.* 
			FROM document.document_type
			INNER JOIN document.document_type_secteur USING(dty_id)
			INNER JOIN document.document_secteur USING(sec_id)
			INNER JOIN document.document_type_etablissement USING(dty_id)
			WHERE doc_id = prm_doc_id AND (prm_eta_id ISNULL OR eta_id = prm_eta_id)
			group by document_type.dty_id
			having array_agg(sec_id) = (select array_agg(DISTINCT sec_id) FROM document.document_secteur where doc_id = prm_doc_id)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_type_liste(prm_token integer, prm_doc_id integer, prm_eta_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_liste(prm_token integer, prm_doc_id integer, prm_eta_id integer) IS 'Retourne la liste des types de documents applicables à un document, étant donné les secteurs auxquels est rattaché le document et un établissement.
Entrées :
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document
 - prm_eta_id : Identifiant de l''établissement (les types de documents étant affectés ou non à un établissement)';


--
-- Name: document_document_type_liste_par_sec_ids(integer, integer[], integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_liste_par_sec_ids(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) RETURNS SETOF document_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	IF prm_sec_ids ISNULL THEN
		FOR row IN
			SELECT DISTINCT document_type.* 
				FROM document.document_type
				LEFT JOIN document.document_type_etablissement USING(dty_id)
				WHERE (prm_eta_id ISNULL OR eta_id = prm_eta_id)
				ORDER BY dty_nom
		LOOP
			RETURN NEXT row;
		END LOOP;
	ELSE
		FOR row IN
			SELECT DISTINCT document_type.* 
				FROM document.document_type
				INNER JOIN document.document_type_secteur USING(dty_id)
				LEFT JOIN document.document_type_etablissement USING(dty_id)
				WHERE (prm_eta_id ISNULL OR eta_id = prm_eta_id)
				GROUP BY document_type.dty_id
				HAVING array_agg(sec_id) @> prm_sec_ids
				ORDER BY dty_nom
		LOOP
			RETURN NEXT row;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION document_document_type_liste_par_sec_ids(prm_token integer, prm_sec_ids integer[], prm_eta_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_liste_par_sec_ids(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) IS 'Retourne la liste des types de documents rattachés à certains secteurs, et affectés à un établissement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_sec_ids : Tableau d''identifiant de secteurs (les types de documents listés seront ceux affectés à TOUS ces secteurs) OU NULL pour retourner tous les types de documents
 - prm_eta_id : Identifiant de l''établissement auquel sont rattachés les types de documents, ou NULL pour retourner tous les types de documents
';


--
-- Name: document_document_type_secteur_ajoute(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_secteur_ajoute(prm_token integer, prm_dty_id integer, prm_sec_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	INSERT INTO document.document_type_secteur (dty_id, sec_id) VALUES (prm_dty_id, prm_sec_id) RETURNING dts_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_document_type_secteur_ajoute(prm_token integer, prm_dty_id integer, prm_sec_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_secteur_ajoute(prm_token integer, prm_dty_id integer, prm_sec_id integer) IS 'Affecte un type de document à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document 
 - prm_sec_id : Identifiant du secteur
Remarques : 
Nécessite les droits à la configuration "Réseau".';


SET search_path = meta, pg_catalog;

--
-- Name: secteur; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE secteur (
    sec_id integer NOT NULL,
    sec_code character varying,
    sec_nom character varying,
    sec_est_prise_en_charge boolean,
    sec_icone character varying
);


--
-- Name: TABLE secteur; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE secteur IS 'Liste des secteurs de métiers';


SET search_path = document, pg_catalog;

--
-- Name: document_document_type_secteur_list(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_secteur_list(prm_token integer, prm_dty_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
			INNER JOIN document.document_type_secteur USING(sec_id)
			WHERE dty_id = prm_dty_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_type_secteur_list(prm_token integer, prm_dty_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_secteur_list(prm_token integer, prm_dty_id integer) IS 'Retourne la liste des secteurs auxquels est affecté un type de document.
Entrées :
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document 
Remarques : 
Nécessite les droits à la configuration "Établissement" ou "Réseau".';


--
-- Name: document_document_type_secteur_supprime(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_secteur_supprime(prm_token integer, prm_dty_id integer, prm_sec_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM document.document_type_secteur WHERE dty_id = prm_dty_id AND sec_id = prm_sec_id;
END;
$$;


--
-- Name: FUNCTION document_document_type_secteur_supprime(prm_token integer, prm_dty_id integer, prm_sec_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_secteur_supprime(prm_token integer, prm_dty_id integer, prm_sec_id integer) IS 'Supprime l''affectation un type de document à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document 
 - prm_sec_id : Identifiant du secteur
Remarques : 
Nécessite les droits à la configuration "Réseau".';


--
-- Name: document_document_type_set_nom(integer, integer, character varying); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_set_nom(prm_token integer, prm_dty_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE document.document_type SET dty_nom = prm_nom WHERE dty_id = prm_dty_id;
END;
$$;


--
-- Name: FUNCTION document_document_type_set_nom(prm_token integer, prm_dty_id integer, prm_nom character varying); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_set_nom(prm_token integer, prm_dty_id integer, prm_nom character varying) IS 'Modifie le nom d''un type de document.
Entrées :
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document 
 - prm_nom : Nouveau nom du type de document
Remarques : 
Nécessite les droits à la configuration "Réseau".';


--
-- Name: document_document_type_supprime(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_type_supprime(prm_token integer, prm_dty_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM document.document_type_secteur WHERE dty_id = prm_dty_id;
	DELETE FROM document.document_type WHERE dty_id = prm_dty_id;
END;
$$;


--
-- Name: FUNCTION document_document_type_supprime(prm_token integer, prm_dty_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_type_supprime(prm_token integer, prm_dty_id integer) IS 'Supprime un type de document.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dty_id : Identifiant du type de document à supprimer.
Remarques : 
Nécessite les droits à la configuration "Réseau"
';


--
-- Name: document_usager; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document_usager (
    dus_id integer NOT NULL,
    doc_id integer,
    per_id_usager integer
);


--
-- Name: TABLE document_usager; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document_usager IS 'Rattachement d''un document à des usagers';


--
-- Name: document_document_usager_liste(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_usager_liste(prm_token integer, prm_doc_id integer) RETURNS SETOF document_usager
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_usager;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM document.document_usager WHERE doc_id = prm_doc_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_usager_liste(prm_token integer, prm_doc_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_usager_liste(prm_token integer, prm_doc_id integer) IS 'Retourne la liste des usagers auxquels est rattaché un document.
Entrées : 
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document';


--
-- Name: document_document_usager_save(integer, integer, integer[]); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_document_usager_save(prm_token integer, prm_doc_id integer, prm_per_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_usager;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM document.document_usager WHERE doc_id = prm_doc_id 
	LOOP
		IF NOT row.per_id_usager = ANY (prm_per_ids) THEN
			DELETE FROM document.document_usager WHERE dus_id = row.dus_id;
		END IF;
	END LOOP;
	FOR i IN 1 .. array_upper (prm_per_ids, 1) LOOP
		IF NOT EXISTS (SELECT 1 FROM document.document_usager WHERE doc_id = prm_doc_id AND per_id_usager = prm_per_ids[i]) THEN
			INSERT INTO document.document_usager (doc_id, per_id_usager) VALUES (prm_doc_id, prm_per_ids[i]);
		END IF;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_document_usager_save(prm_token integer, prm_doc_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_document_usager_save(prm_token integer, prm_doc_id integer, prm_per_ids integer[]) IS 'Modifie la liste des usagers auxquels est rattaché un document.
Entrées : 
 - prm_token : Token d''authentification
 - prm_doc_id : Identifiant du document
 - prm_per_ids : Tableau d''identifiants d''usagers';


--
-- Name: documents; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE documents (
    dos_id integer NOT NULL,
    dos_titre character varying,
    dty_id integer
);


--
-- Name: TABLE documents; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE documents IS 'Configuration des pages de documents disponibles pour placer dans le menu princiapl ou usager';


--
-- Name: document_documents_get(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_get(prm_token integer, prm_dos_id integer) RETURNS documents
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret document.documents;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM document.documents WHERE dos_id = prm_dos_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_documents_get(prm_token integer, prm_dos_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_get(prm_token integer, prm_dos_id integer) IS 'Retourne les informations de configuration d''une page de documents.
Entrées :
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page de documents';


--
-- Name: document_documents_groupe_liste(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_groupe_liste(prm_token integer, prm_dos_id integer) RETURNS SETOF document_documents_groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_documents_groupe_liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		select DISTINCT groupe.grp_id, groupe.grp_nom, eta_id, eta_nom
			FROM groupe 
			INNER JOIN etablissement USING(eta_id)
			INNER JOIN groupe_secteur USING (grp_id)
			INNER JOIN document.documents_secteur USING (sec_id)
			where documents_secteur.dos_id = prm_dos_id 
			ORDER BY eta_nom, grp_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_documents_groupe_liste(prm_token integer, prm_dos_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_groupe_liste(prm_token integer, prm_dos_id integer) IS 'Retourne la liste des groupes en relation avec une page de documents (en considérant les secteurs du groupe et les secteurs de la configuration de la page).
Entrées :
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page de documents.
';


--
-- Name: document_documents_liste(integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_liste(prm_token integer) RETURNS SETOF documents
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.documents;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM document.documents ORDER BY dos_titre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION document_documents_liste(prm_token integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_liste(prm_token integer) IS 'Retourne la liste des configurations de pages de documents.
Entrées : 
 - prm_token : Token d''authentification
Remarques : 
Nécessite les droits de configuration de l''interface.
';


--
-- Name: document_documents_save(integer, integer, character varying, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_save(prm_token integer, prm_dos_id integer, prm_titre character varying, prm_dty_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	IF prm_dos_id ISNULL THEN
		INSERT INTO document.documents (dos_titre, dty_id) VALUES (prm_titre, prm_dty_id) 
		       RETURNING dos_id INTO ret;
		RETURN ret;
	ELSE
		UPDATE document.documents SET dos_titre = prm_titre, dty_id = prm_dty_id WHERE dos_id = prm_dos_id;
		RETURN prm_dos_id;
	END IF;
END;
$$;


--
-- Name: FUNCTION document_documents_save(prm_token integer, prm_dos_id integer, prm_titre character varying, prm_dty_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_save(prm_token integer, prm_dos_id integer, prm_titre character varying, prm_dty_id integer) IS 'Modifie les informations de configuration d''une page de documents ou crée une nouvelle configuration.
Entrées :
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page à modifier ou NULL pour créer une nouvelle configuration
 - prm_titre : Nouveau nom de page
 - prm_dty_id : Identifiant du type de document permettant de filtrer les documents sur cette page
Remarque :
Nécessite le droit de configuration de l''interface';


--
-- Name: document_documents_secteur_ajoute(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_secteur_ajoute(prm_token integer, prm_dos_id integer, prm_sec_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO document.documents_secteur (dos_id, sec_id) VALUES (prm_dos_id, prm_sec_id) 
		RETURNING dss_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION document_documents_secteur_ajoute(prm_token integer, prm_dos_id integer, prm_sec_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_secteur_ajoute(prm_token integer, prm_dos_id integer, prm_sec_id integer) IS 'Ajoute un secteur à la spécialisation de la page de documents par secteur.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page de documents
 - prm_sec_id : Identifiant du secteur
Remarques : 
Nécessite les droits de configuration de l''interface.
';


--
-- Name: document_documents_secteur_liste_details_etab(integer, integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_secteur_liste_details_etab(prm_token integer, prm_dos_id integer, prm_eta_id integer) RETURNS SETOF document_documents_secteur_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row document.document_documents_secteur_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT dss_id, sec_id, sec_nom, sec_icone 
		FROM document.documents_secteur
		INNER JOIN meta.secteur USING(sec_id)
		LEFT JOIN etablissement_secteur USING(sec_id)
		WHERE dos_id = prm_dos_id AND (prm_eta_id ISNULL OR eta_id = prm_eta_id)
	LOOP
		RETURN NEXT row;
	END LOOP;		
END;
$$;


--
-- Name: FUNCTION document_documents_secteur_liste_details_etab(prm_token integer, prm_dos_id integer, prm_eta_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_secteur_liste_details_etab(prm_token integer, prm_dos_id integer, prm_eta_id integer) IS 'Retourne la liste des secteurs sur lesquels est spécialisée une page de documents.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page de documents
 - prm_eta_id : Identifiant de l''établissement sur lequel filtrer les secteurs';


--
-- Name: document_documents_secteur_supprime(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_secteur_supprime(prm_token integer, prm_dss_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM document.documents_secteur WHERE dss_id = prm_dss_id;
END;
$$;


--
-- Name: FUNCTION document_documents_secteur_supprime(prm_token integer, prm_dss_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_secteur_supprime(prm_token integer, prm_dss_id integer) IS 'Enlève un secteur à la spécialisation de la page de documents par secteur.
Entrées : 
 - prm_token : Token d''authentification
 - prm_dss_id : Identifiant de la spécialisation de la page de documents par un secteur
Remarques : 
Nécessite les droits de configuration de l''interface.
';


--
-- Name: document_documents_supprime(integer, integer); Type: FUNCTION; Schema: document; Owner: -
--

CREATE FUNCTION document_documents_supprime(prm_token integer, prm_dos_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM document.documents_secteur WHERE dos_id = prm_dos_id;
	DELETE FROM document.documents WHERE dos_id = prm_dos_id;
END;
$$;


--
-- Name: FUNCTION document_documents_supprime(prm_token integer, prm_dos_id integer); Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON FUNCTION document_documents_supprime(prm_token integer, prm_dos_id integer) IS 'Supprime une configuration de page de documents.
Entrées :
 - prm_token : Token d''authentification
 - prm_dos_id : Identifiant de la configuration de page de documents
Remarque :
Nécessite le droit de configuration de l''interface';


SET search_path = events, pg_catalog;

--
-- Name: agressources; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE agressources (
    agr_id integer NOT NULL,
    agr_code character varying,
    agr_titre character varying
);


--
-- Name: TABLE agressources; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE agressources IS 'Configuration des pages d''agenda de ressources';


--
-- Name: events_agressources_get(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_agressources_get(prm_token integer, prm_agr_id integer) RETURNS agressources
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.agressources;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.agressources WHERE agr_id = prm_agr_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_agressources_get(prm_token integer, prm_agr_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_agressources_get(prm_token integer, prm_agr_id integer) IS 'Retourne les informations de configuration d''une page agenda de ressources.
Entrées :
 - prm_token : Token d''authentification
 - prm_agr_id : Identifiant de la configuration de page agenda de ressources';


--
-- Name: events_agressources_get_par_code(integer, character varying); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_agressources_get_par_code(prm_token integer, prm_agr_code character varying) RETURNS agressources
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.agressources;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.agressources WHERE agr_code = prm_agr_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_agressources_get_par_code(prm_token integer, prm_agr_code character varying); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_agressources_get_par_code(prm_token integer, prm_agr_code character varying) IS 'Retourne les informations de configuration d''une page agenda de ressources.
Entrées :
 - prm_token : Token d''authentification
 - prm_agr_code : Code de la configuration de page agenda de ressources';


--
-- Name: events_agressources_list(integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_agressources_list(prm_token integer) RETURNS SETOF agressources
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.agressources;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM events.agressources ORDER BY agr_titre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_agressources_list(prm_token integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_agressources_list(prm_token integer) IS 'Retourne la liste des informations de configuration de pages d''agenda de ressources, à placer dans le menu principal ou usager.
Remarque : 
Nécessite le droit de configuration de l''interface';


--
-- Name: events_categorie; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE events_categorie (
    eca_id integer NOT NULL,
    eca_nom character varying,
    eca_code character varying,
    eca_icone character varying
);


--
-- Name: TABLE events_categorie; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE events_categorie IS 'Catégories d''évenements';


--
-- Name: events_categorie_events_liste(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_categorie_events_liste(prm_token integer, prm_evs_id integer) RETURNS SETOF events_categorie
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_categorie;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT events_categorie.* FROM events.events_categorie
		INNER JOIN events.categorie_events USING (eca_id)
		WHERE evs_id = prm_evs_id
		ORDER BY eca_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_categorie_events_liste(prm_token integer, prm_evs_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_categorie_events_liste(prm_token integer, prm_evs_id integer) IS 'Retourne la liste des catégories d''événements sur lesquelles une page d''événements est spécialisée.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identifiant de la configuration de page d''événement';


--
-- Name: events_document_liste_obtention(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_document_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	FOR row IN
		SELECT DISTINCT doc_id, doc_titre, doc_description, EXTRACT (EPOCH FROM doc_date_obtention),
		(SELECT sec_icone FROM meta.secteur INNER JOIN document.document_secteur USING(sec_id) WHERE document_secteur.doc_id = document.doc_id ORDER BY dse_id LIMIT 1),
		(SELECT concatenate(personne_get_libelle_initiale(prm_token, per_id_usager)) FROM document.document_usager du WHERE du.doc_id = document.doc_id)
		FROM document.document 
		INNER JOIN document.document_usager USING(doc_id)
		INNER JOIN document.document_secteur USING(doc_id)
		INNER JOIN events.secteur_events USING(sec_id)
		INNER JOIN personne_groupe on personne_groupe.per_id = document_usager.per_id_usager AND 
			doc_date_obtention BETWEEN COALESCE(personne_groupe.peg_debut, '-Infinity'::timestamp) AND COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)
		WHERE
			secteur_events.evs_id = prm_evs_id
			AND doc_date_obtention between p_start AND p_end 
			AND (prm_per_id ISNULL OR prm_per_id = document_usager.per_id_usager)
			AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)
			AND (prm_per_ids ISNULL OR document_usager.per_id_usager = ANY (prm_per_ids))
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événement la liste des documents dont la date d''obtention est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';


--
-- Name: events_document_liste_realisation(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_document_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	
	FOR row IN
		SELECT DISTINCT doc_id, doc_titre, doc_description, EXTRACT (EPOCH FROM doc_date_realisation),
		(SELECT sec_icone FROM meta.secteur INNER JOIN document.document_secteur USING(sec_id) WHERE document_secteur.doc_id = document.doc_id ORDER BY dse_id LIMIT 1),
		(SELECT concatenate(personne_get_libelle_initiale(prm_token, per_id_usager)) FROM document.document_usager du WHERE du.doc_id = document.doc_id)
		FROM document.document 
		INNER JOIN document.document_usager USING(doc_id)
		INNER JOIN document.document_secteur USING(doc_id)
		INNER JOIN events.secteur_events USING(sec_id)
		INNER JOIN personne_groupe on personne_groupe.per_id = document_usager.per_id_usager AND 
			doc_date_realisation BETWEEN COALESCE(personne_groupe.peg_debut, '-Infinity'::timestamp) AND COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)
		WHERE
			secteur_events.evs_id = prm_evs_id
			AND doc_date_realisation between p_start AND p_end 
			AND (prm_per_id ISNULL OR prm_per_id = document_usager.per_id_usager)
			AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)	
			AND (prm_per_ids ISNULL OR document_usager.per_id_usager = ANY(prm_per_ids))
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événement la liste des documents dont la date de réalisation est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';


--
-- Name: events_document_liste_validite(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_document_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	FOR row IN
		SELECT DISTINCT doc_id, doc_titre, doc_description, EXTRACT (EPOCH FROM doc_date_validite),
		(SELECT sec_icone FROM meta.secteur INNER JOIN document.document_secteur USING(sec_id) WHERE document_secteur.doc_id = document.doc_id ORDER BY dse_id LIMIT 1),
		(SELECT concatenate(personne_get_libelle_initiale(prm_token, per_id_usager)) FROM document.document_usager du WHERE du.doc_id = document.doc_id)
		FROM document.document 
		INNER JOIN document.document_usager USING(doc_id)
		INNER JOIN document.document_secteur USING(doc_id)
		INNER JOIN events.secteur_events USING(sec_id)
		INNER JOIN personne_groupe on personne_groupe.per_id = document_usager.per_id_usager AND 
			doc_date_validite BETWEEN COALESCE(personne_groupe.peg_debut, '-Infinity'::timestamp) AND COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)
		WHERE
			secteur_events.evs_id = prm_evs_id
			AND doc_date_validite between p_start AND p_end 
			AND (prm_per_id ISNULL OR prm_per_id = document_usager.per_id_usager)
			AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)	
			AND (prm_per_ids ISNULL OR document_usager.per_id_usager = ANY(prm_per_ids))	
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événement la liste des documents dont la date de validité est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';


--
-- Name: events_echeance_liste(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_echeance_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_echeance_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	FOR row IN
		SELECT DISTINCT 
			personne_info.per_id,
			info.inf_id,
			inf_libelle,
			inf_libelle_complet,
			personne_info_varchar_get (prm_token, personne_info.per_id, 'nom'),
			personne_info_varchar_get (prm_token, personne_info.per_id, 'prenom'),
			EXTRACT (EPOCH FROM personne_info_date_get (prm_token, personne_info.per_id, inf_code) ),
			inf__date_echeance_icone
			FROM personne_info_date
			INNER JOIN personne_info USING (pin_id)
			INNER JOIN meta.info USING(inf_code)
			INNER JOIN meta.secteur ON info.inf__date_echeance_secteur = secteur.sec_code
			INNER JOIN events.secteur_events USING(sec_id)
			INNER JOIN personne_groupe ON personne_groupe.per_id = personne_info.per_id 
				AND personne_info_date_get (prm_token, personne_info.per_id, inf_code) BETWEEN COALESCE (personne_groupe.peg_debut, '-Infinity'::timestamp) AND COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)
			WHERE inf__date_echeance
			AND pid_valeur BETWEEN p_start AND p_end
			AND (prm_per_id ISNULL OR personne_info.per_id = prm_per_id)
			AND evs_id = prm_evs_id
			AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)
			AND (prm_per_ids ISNULL OR personne_info.per_id = ANY(prm_per_ids))
			LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événement la liste des échéances arrivées à terme lors d''une période donnée.
Une échéance est définie par un champ usager de format date marquée comme échéance.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les champs échéance du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux échéances de cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux échéances des usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux échéances d''un de ces usagers au moins';


--
-- Name: events_event_avec_ressource_liste(integer, date, date, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_avec_ressource_liste(prm_token integer, prm_start date, prm_end date, prm_agr_id integer) RETURNS SETOF events_event_avec_ressource_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_event_avec_ressource_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
	FOR row IN
	    SELECT DISTINCT eve_id, res_id, res_nom, eve_intitule, EXTRACT(EPOCH FROM eve_debut), EXTRACT(EPOCH FROM eve_fin)
	       FROM events.event
	       inner join events.event_ressource using(eve_id)
	       inner join ressource.ressource_secteur using(res_id)
	       inner join ressource.ressource USING(res_id)
	       inner join events.agressources_secteur using(sec_id)
	       WHERE agr_id = prm_agr_id AND
		(eve_debut BETWEEN p_start AND p_end OR eve_fin BETWEEN p_start AND p_end)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_avec_ressource_liste(prm_token integer, prm_start date, prm_end date, prm_agr_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_avec_ressource_liste(prm_token integer, prm_start date, prm_end date, prm_agr_id integer) IS 'Retourne sous forme d''événement la liste des ressources utilisées lors d''événements
Entrées : 
 - prm_token : Token d''authentification
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_agr_id : Identification de la configuration de page d''agenda de ressources (pour trier sur les ressources du même secteur que la page)
';


--
-- Name: event; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event (
    eve_id integer NOT NULL,
    eve_intitule character varying,
    eve_debut timestamp with time zone,
    eve_fin timestamp with time zone,
    eve__depenses_montant numeric,
    uti_id_creation integer,
    eca_id integer,
    ety_id integer,
    eve_date_creation timestamp with time zone
);


--
-- Name: TABLE event; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event IS 'Les événements';


--
-- Name: events_event_get(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_get(prm_token integer, prm_eve_id integer) RETURNS event
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.event;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.event WHERE eve_id = prm_eve_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_event_get(prm_token integer, prm_eve_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_get(prm_token integer, prm_eve_id integer) IS 'Retourne les informations sur un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';


--
-- Name: events_event_liste(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_event_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_event_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	set enable_seqscan to false;
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;
--	RAISE NOTICE '% %', p_start, p_end;
	FOR row IN
		SELECT DISTINCT 
			event.eve_id,
			event.eca_id,
			eve_intitule,
			EXTRACT(EPOCH FROM eve_debut),
			EXTRACT(EPOCH FROM eve_fin),
			CASE WHEN eca_icone NOTNULL THEN eca_icone ELSE (SELECT sec_icone FROM meta.secteur INNER JOIN events.secteur_event USING(sec_id) WHERE secteur_event.eve_id = event.eve_id ORDER BY sev_id LIMIT 1) END,
			eve__depenses_montant
			FROM events.event
		INNER JOIN events.event_type_secteur USING (ety_id)
		INNER JOIN events.secteur_events ON event_type_secteur.sec_id = secteur_events.sec_id
		INNER JOIN events.events USING(evs_id)
		INNER JOIN events.categorie_events USING (evs_id)
		LEFT JOIN events.events_categorie ON event.eca_id = events_categorie.eca_id
		INNER  JOIN events.event_personne USING(eve_id)
		LEFT JOIN personne_groupe ON personne_groupe.per_id = event_personne.per_id AND (COALESCE (personne_groupe.peg_debut, '-Infinity'::timestamp), COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)) OVERLAPS (COALESCE(event.eve_debut, '-Infinity'::timestamp), COALESCE (event.eve_fin, 'Infinity'::timestamp)) 
		WHERE secteur_events.evs_id = prm_evs_id AND categorie_events.eca_id = event.eca_id
		AND (prm_per_id ISNULL OR event_personne.per_id = prm_per_id) AND
		(eve_debut BETWEEN p_start AND p_end OR eve_fin BETWEEN p_start AND p_end)
		AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)
		AND (prm_per_ids ISNULL OR event_personne.per_id = ANY(prm_per_ids))
		AND (events.ety_id ISNULL OR events.ety_id = event.ety_id)
	LOOP
		RETURN NEXT row;
	END LOOP;
	set enable_seqscan to true;
END;
$$;


--
-- Name: FUNCTION events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne la liste des événements d''une période donnée.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les événements du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux événements liés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux événements liés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux événements liés à un de ces usagers au moins';


--
-- Name: events_event_memo_get(integer, integer, character varying); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_memo_get(prm_token integer, prm_eve_id integer, prm_type character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT eme_texte INTO ret FROM events.event_memo WHERE eve_id = prm_eve_id AND eme_type = prm_type ORDER BY eme_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_event_memo_get(prm_token integer, prm_eve_id integer, prm_type character varying); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_memo_get(prm_token integer, prm_eve_id integer, prm_type character varying) IS 'Retourne un texte (objet, compte-rendu) d''un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_type : Type du mémo : description (Objet) ou bilan (Compte-rendu)';


--
-- Name: event_personne; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_personne (
    epe_id integer NOT NULL,
    eve_id integer,
    per_id integer
);


--
-- Name: TABLE event_personne; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_personne IS 'Rattachement de personnes (usager, personnel, contact, famille) aux événements';


--
-- Name: events_event_personne_list(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_personne_list(prm_token integer, prm_eve_id integer) RETURNS SETOF event_personne
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.event_personne;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM events.event_personne WHERE eve_id = prm_eve_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_personne_list(prm_token integer, prm_eve_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_personne_list(prm_token integer, prm_eve_id integer) IS 'Retourne la liste des personnes rattachées à un événement.';


--
-- Name: events_event_personnes_save(integer, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_personnes_save(prm_token integer, prm_eve_id integer, prm_per_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.event_personne;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM events.event_personne WHERE eve_id = prm_eve_id 
	LOOP
		IF prm_per_ids ISNULL OR NOT row.per_id = ANY (prm_per_ids) THEN
			DELETE FROM events.event_personne WHERE epe_id = row.epe_id;
		END IF;
	END LOOP;
	IF prm_per_ids NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_per_ids, 1) LOOP
			IF NOT EXISTS (SELECT 1 FROM events.event_personne WHERE eve_id = prm_eve_id AND per_id = prm_per_ids[i]) THEN
				INSERT INTO events.event_personne (eve_id, per_id) VALUES (prm_eve_id, prm_per_ids[i]);
			END IF;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION events_event_personnes_save(prm_token integer, prm_eve_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_personnes_save(prm_token integer, prm_eve_id integer, prm_per_ids integer[]) IS 'Modifie les personnes rattachées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_per_ids : Tableau d''identifiants de personnes à rattacher';


SET search_path = ressource, pg_catalog;

--
-- Name: ressource; Type: TABLE; Schema: ressource; Owner: -; Tablespace: 
--

CREATE TABLE ressource (
    res_id integer NOT NULL,
    res_nom character varying
);


--
-- Name: TABLE ressource; Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON TABLE ressource IS 'Les ressources.';


SET search_path = events, pg_catalog;

--
-- Name: events_event_ressource_list(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_ressource_list(prm_token integer, prm_eve_id integer) RETURNS SETOF ressource.ressource
    LANGUAGE plpgsql
    AS $$
DECLARE
	row ressource.ressource;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT ressource.* FROM ressource.ressource INNER JOIN events.event_ressource USING(res_id) WHERE eve_id = prm_eve_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_ressource_list(prm_token integer, prm_eve_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_ressource_list(prm_token integer, prm_eve_id integer) IS 'Retourne la liste des ressources affectées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';


--
-- Name: events_event_ressources_save(integer, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_ressources_save(prm_token integer, prm_eve_id integer, prm_res_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.event_ressource;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM events.event_ressource WHERE eve_id = prm_eve_id 
	LOOP
		IF prm_res_ids ISNULL OR NOT row.res_id = ANY (prm_res_ids) THEN
			DELETE FROM events.event_ressource WHERE ere_id = row.ere_id;
		END IF;
	END LOOP;
	IF prm_res_ids NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_res_ids, 1) LOOP
			IF NOT EXISTS (SELECT 1 FROM events.event_ressource WHERE eve_id = prm_eve_id AND res_id = prm_res_ids[i]) THEN
				INSERT INTO events.event_ressource (eve_id, res_id) VALUES (prm_eve_id, prm_res_ids[i]);
			END IF;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION events_event_ressources_save(prm_token integer, prm_eve_id integer, prm_res_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_ressources_save(prm_token integer, prm_eve_id integer, prm_res_ids integer[]) IS 'Modifie les ressources rattachées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_res_ids : Tableau d''identifiants de ressources à rattacher';


--
-- Name: events_event_save_all(integer, integer, character varying, integer, timestamp with time zone, timestamp with time zone, numeric, text, text, integer[], integer[], integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_eve_id integer;
	uti integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	IF prm_eve_id NOTNULL THEN
		UPDATE events.event SET 
			eve_intitule = prm_intitule,
			eca_id = (SELECT eca_id FROM events.event_type WHERE ety_id = prm_ety_id),
			ety_id = CASE WHEN prm_ety_id <> 0 THEN prm_ety_id ELSE NULL END,
			eve_debut = prm_debut,
			eve_fin = prm_fin,
			eve__depenses_montant = prm__depenses_montant
			WHERE eve_id = prm_eve_id;
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
		new_eve_id = prm_eve_id;
	ELSE
		INSERT INTO events.event (eve_intitule, eca_id, ety_id, eve_debut, eve_fin, eve__depenses_montant, uti_id_creation, eve_date_creation) VALUES (prm_intitule, (SELECT eca_id FROM events.event_type WHERE ety_id = prm_ety_id), prm_ety_id, prm_debut, prm_fin, prm__depenses_montant, uti, CURRENT_TIMESTAMP) RETURNING eve_id INTO new_eve_id;
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
	END IF;
	IF prm_per_ids <> '{0}' THEN
		PERFORM events.events_event_personnes_save (prm_token, new_eve_id, prm_per_ids);		
	ELSE
		PERFORM events.events_event_personnes_save (prm_token, new_eve_id, NULL);			
	END IF;
	IF prm_res_ids <> '{0}' THEN
		PERFORM events.events_event_ressources_save (prm_token, new_eve_id, prm_res_ids);
	ELSE
		PERFORM events.events_event_ressources_save (prm_token, new_eve_id, NULL);
	END IF;
	IF prm_sec_ids <> '{0}' THEN
		PERFORM events.events_event_secteurs_save (prm_token, new_eve_id, prm_sec_ids);
	ELSE
		PERFORM events.events_event_secteurs_save (prm_token, new_eve_id, NULL);
	END IF;
	RETURN new_eve_id;
END;
$$;


--
-- Name: FUNCTION events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]) IS 'Modifie un crée un événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement à modifier, ou NULL pour créer un nouvel événement
 - prm_intitule : Titre de l''événement
 - prm_ety_id : Identifiant du type d''événement
 - prm_debut : Date de début de l''événement
 - prm_fin : Date de fin de l''événement
 - prm__depenses_montant : Pour un événement de catégorie Dépenses, montant de la dépense
 - prm_description : Objet de l''événement
 - prm_bilan : Compte-rendu de l''événement
 - prm_per_ids : Tableau d''identifiants de personnes liées à l''événement
 - prm_res_ids : Tableau d''identifiants de ressources associées à l''événement
 - prm_sec_ids : Tableau d''identifiants de secteurs auxquel est affecté l''événement';


--
-- Name: events_event_secteurs_save(integer, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_secteurs_save(prm_token integer, prm_eve_id integer, prm_sec_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.secteur_event;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM events.secteur_event WHERE eve_id = prm_eve_id 
	LOOP
		IF prm_sec_ids ISNULL OR NOT row.sec_id = ANY (prm_sec_ids) THEN
			DELETE FROM events.secteur_event WHERE set_id = row.set_id;
		END IF;
	END LOOP;
	IF prm_sec_ids NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_sec_ids, 1) LOOP
			IF NOT EXISTS (SELECT 1 FROM events.secteur_event WHERE eve_id = prm_eve_id AND sec_id = prm_sec_ids[i]) THEN
				INSERT INTO events.secteur_event (eve_id, sec_id) VALUES (prm_eve_id, prm_sec_ids[i]);
			END IF;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION events_event_secteurs_save(prm_token integer, prm_eve_id integer, prm_sec_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_secteurs_save(prm_token integer, prm_eve_id integer, prm_sec_ids integer[]) IS 'Modifie les secteurs auxquels est affecté un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_sec_ids : Tableau d''identifiants de secteurs';


--
-- Name: events_event_supprime(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_supprime(prm_token integer, prm_eve_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM events.secteur_event WHERE eve_id = prm_eve_id;
	DELETE FROM events.event_personne WHERE eve_id = prm_eve_id;
	DELETE FROM events.event_ressource WHERE eve_id = prm_eve_id;
	DELETE FROM events.event_memo WHERE eve_id = prm_eve_id;
	DELETE FROM events.event WHERE eve_id = prm_eve_id;
END;
$$;


--
-- Name: FUNCTION events_event_supprime(prm_token integer, prm_eve_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_supprime(prm_token integer, prm_eve_id integer) IS 'Supprime un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';


--
-- Name: events_event_type_ajoute(integer, integer, character varying); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_ajoute(prm_token integer, prm_eca_id integer, prm_intitule character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	INSERT INTO events.event_type (eca_id, ety_intitule) VALUES (prm_eca_id, prm_intitule) RETURNING ety_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_event_type_ajoute(prm_token integer, prm_eca_id integer, prm_intitule character varying); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_ajoute(prm_token integer, prm_eca_id integer, prm_intitule character varying) IS 'Ajoute un type d''événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eca_id : Catégorie d''événement à laquelle appartient le type
 - prm_intitule : Intitulé du type
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_event_type_etablissement_get(integer, integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_etablissement_get(prm_token integer, prm_ety_id integer, prm_eta_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	RETURN EXISTS (SELECT 1 FROM events.event_type_etablissement WHERE ety_id = prm_ety_id AND eta_id = prm_eta_id);
END;
$$;


--
-- Name: FUNCTION events_event_type_etablissement_get(prm_token integer, prm_ety_id integer, prm_eta_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_etablissement_get(prm_token integer, prm_ety_id integer, prm_eta_id integer) IS 'Retourne TRUE si un établissement utilise un type d''événement donné, FALSE sinon.
Entrées : 
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement 
 - prm_eta_id : Identifiant de l''établissement
Remarques :
Nécessite les droits à la configuration "Établissement"';


--
-- Name: events_event_type_etablissement_set(integer, integer, integer, boolean); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_etablissement_set(prm_token integer, prm_ety_id integer, prm_eta_id integer, prm_b boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	IF EXISTS (SELECT 1 FROM events.event_type_etablissement WHERE ety_id = prm_ety_id AND eta_id = prm_eta_id) AND NOT prm_b THEN
		DELETE FROM events.event_type_etablissement WHERE ety_id = prm_ety_id AND eta_id = prm_eta_id;
	ELSIF NOT EXISTS (SELECT 1 FROM events.event_type_etablissement WHERE ety_id = prm_ety_id AND eta_id = prm_eta_id) AND prm_b THEN
		INSERT INTO events.event_type_etablissement (ety_id, eta_id) VALUES (prm_ety_id, prm_eta_id);
	END IF;
END;
$$;


--
-- Name: FUNCTION events_event_type_etablissement_set(prm_token integer, prm_ety_id integer, prm_eta_id integer, prm_b boolean); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_etablissement_set(prm_token integer, prm_ety_id integer, prm_eta_id integer, prm_b boolean) IS 'Indique si un établissement utilise un type d''événement donné.
Entrées : 
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement 
 - prm_eta_id : Identifiant de l''établissement
 - prm_b : TRUE si l''établissement utilise le type, FALSE sinon.
Remarques :
Nécessite les droits à la configuration "Établissement"';


--
-- Name: event_type; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_type (
    ety_id integer NOT NULL,
    eca_id integer,
    ety_intitule character varying,
    ety_intitule_individuel boolean
);


--
-- Name: TABLE event_type; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_type IS 'Types d''événements (sous-niveau de catégories d''événements)';


--
-- Name: events_event_type_get(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_get(prm_token integer, prm_ety_id integer) RETURNS event_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.event_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.event_type WHERE ety_id = prm_ety_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_event_type_get(prm_token integer, prm_ety_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_get(prm_token integer, prm_ety_id integer) IS 'Retourne les informations sur un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement';


--
-- Name: events_event_type_list(integer, integer, integer[], integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer) RETURNS SETOF events_event_type_list_all
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_event_type_list_all;
	req varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	IF prm_eca_id ISNULL THEN
		RETURN;
	END IF;
	req = 'SELECT DISTINCT eca_nom, event_type.* FROM events.event_type INNER JOIN events.events_categorie USING(eca_id) LEFT JOIN events.event_type_etablissement USING (ety_id) ';

	IF prm_sec_ids NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_sec_ids, 1) LOOP
			req = req || 'INNER JOIN events.event_type_secteur ets' || i || ' ON ets' || i || '.ety_id = event_type.ety_id AND ets' || i || '.sec_id = ' || prm_sec_ids[i] || ' ';

		END LOOP;
	END IF;
	
	req = req || 'where eca_id = ' || prm_eca_id;
	IF prm_eta_id NOTNULL THEN
		req = req || ' AND eta_id = ' || prm_eta_id;
	END IF;
	req = req || ' ORDER BY event_type.ety_intitule';
	FOR row IN
		EXECUTE req
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer) IS 'Retourne les types d''événements filtrés par établissement, catégorie et secteurs.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eca_id : Catégorie d''événements, seuls les types de cette catégorie seront retournés (non NULL)
 - prm_sec_ids : Secteurs, seuls les types utilisés dans tous ces secteurs seront retournés
 - prm_eta_id : Identifiant d''établissement, seuls les types utilisés par cet établissement seront retournés, ou NULL';


--
-- Name: events_event_type_list_all(integer, integer[], integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) RETURNS SETOF events_event_type_list_all
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_event_type_list_all;
	req varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	req = 'SELECT DISTINCT eca_nom, event_type.ety_id, event_type.eca_id, event_type.ety_intitule COLLATE "C", event_type.ety_intitule_individuel FROM events.event_type INNER JOIN events.events_categorie USING(eca_id) LEFT JOIN events.event_type_etablissement USING (ety_id) ';

	IF prm_sec_ids NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_sec_ids, 1) LOOP
			req = req || 'INNER JOIN events.event_type_secteur ets' || i || ' ON ets' || i || '.ety_id = event_type.ety_id AND ets' || i || '.sec_id = ' || prm_sec_ids[i] || ' ';

		END LOOP;
	END IF;
	
	IF prm_eta_id NOTNULL THEN
		req = req || ' AND eta_id = ' || prm_eta_id;
	END IF;
	req = req || ' ORDER BY event_type.eca_id, event_type.ety_intitule COLLATE "C"';
	FOR row IN
		EXECUTE req
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) IS 'Retourne les types d''événements filtrés par établissement et secteurs, toutes catégories confondues.
Entrées : 
 - prm_token : Token d''authentification
 - prm_sec_ids : Secteurs, seuls les types utilisés dans tous ces secteurs seront retournés
 - prm_eta_id : Identifiant d''établissement, seuls les types utilisés par cet établissement seront retournés, ou NULL';


--
-- Name: events_event_type_list_par_evs(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_list_par_evs(prm_token integer, prm_evs_id integer) RETURNS SETOF events_event_type_list_par_evs
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_event_type_list_par_evs;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT event_type.ety_id, ety_intitule FROM events.event_type 
		LEFT JOIN events.categorie_events USING(eca_id)
		LEFT JOIN events.event_type_secteur USING(ety_id)
		LEFT JOIN events.secteur_events USING(sec_id)
		WHERE categorie_events.evs_id = prm_evs_id AND secteur_events.evs_id = prm_evs_id
		ORDER BY ety_intitule
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_type_list_par_evs(prm_token integer, prm_evs_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_list_par_evs(prm_token integer, prm_evs_id integer) IS 'Retourne la liste d''événements filtrés par catégories et secteurs de la configuration d''une page d''événements.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identifiant de la configuration de page d''événements';


--
-- Name: events_event_type_secteur_ajoute(integer, integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_secteur_ajoute(prm_token integer, prm_ety_id integer, prm_sec_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	INSERT INTO events.event_type_secteur (ety_id, sec_id) VALUES (prm_ety_id, prm_sec_id) RETURNING ets_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_event_type_secteur_ajoute(prm_token integer, prm_ety_id integer, prm_sec_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_secteur_ajoute(prm_token integer, prm_ety_id integer, prm_sec_id integer) IS 'Affecte un type d''événement à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_sec_id : Identifiant du secteur
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_event_type_secteur_list(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_secteur_list(prm_token integer, prm_ety_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
			INNER JOIN events.event_type_secteur USING(sec_id)
			WHERE ety_id = prm_ety_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_event_type_secteur_list(prm_token integer, prm_ety_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_secteur_list(prm_token integer, prm_ety_id integer) IS 'Retourne la liste des secteurs auxquels est affecté un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement';


--
-- Name: events_event_type_secteur_supprime(integer, integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_secteur_supprime(prm_token integer, prm_ety_id integer, prm_sec_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.event_type_secteur WHERE ety_id = prm_ety_id AND sec_id = prm_sec_id;
END;
$$;


--
-- Name: FUNCTION events_event_type_secteur_supprime(prm_token integer, prm_ety_id integer, prm_sec_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_secteur_supprime(prm_token integer, prm_ety_id integer, prm_sec_id integer) IS 'Suprime l''affectation d''un type d''événement à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_sec_id : Identifiant du secteur
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_event_type_set_intitule(integer, integer, character varying); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_set_intitule(prm_token integer, prm_ety_id integer, prm_intitule character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE events.event_type SET ety_intitule = prm_intitule WHERE ety_id = prm_ety_id;
END;
$$;


--
-- Name: FUNCTION events_event_type_set_intitule(prm_token integer, prm_ety_id integer, prm_intitule character varying); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_set_intitule(prm_token integer, prm_ety_id integer, prm_intitule character varying) IS 'Modifie l''intitulé d''un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_intitule : Nouvel intitulé
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_event_type_set_intitule_individuel(integer, integer, boolean); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_set_intitule_individuel(prm_token integer, prm_ety_id integer, prm_intitule_individuel boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE events.event_type SET ety_intitule_individuel = prm_intitule_individuel WHERE ety_id = prm_ety_id;
END;
$$;


--
-- Name: FUNCTION events_event_type_set_intitule_individuel(prm_token integer, prm_ety_id integer, prm_intitule_individuel boolean); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_set_intitule_individuel(prm_token integer, prm_ety_id integer, prm_intitule_individuel boolean) IS 'Indique si l''intitulé d''un événement ce ce type peut être personnalisé.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_intitule_individuel : TRUE si l''intitulé peut être personnalisé 
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_event_type_supprime(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_event_type_supprime(prm_token integer, prm_ety_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.event_type_secteur WHERE ety_id = prm_ety_id;
	DELETE FROM events.event_type WHERE ety_id = prm_ety_id;
END;
$$;


--
-- Name: FUNCTION events_event_type_supprime(prm_token integer, prm_ety_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_event_type_supprime(prm_token integer, prm_ety_id integer) IS 'Supprime un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
Remarques :
Nécessite les droits à la configuration "Réseau"';


--
-- Name: events_events_categorie_list(integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_categorie_list(prm_token integer) RETURNS SETOF events_categorie
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_categorie;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM events.events_categorie ORDER BY eca_nom 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_events_categorie_list(prm_token integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_categorie_list(prm_token integer) IS 'Retourne la liste des catégories d''événements';


--
-- Name: events_events_copie_et_ajoute_type(integer, integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_copie_et_ajoute_type(prm_token integer, prm_evs_id integer, prm_ety_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO events.events (evs_titre, evs_code, ety_id) 
		SELECT evs_titre || ' ' || ety_intitule, evs_code || '_' || prm_ety_id, prm_ety_id FROM events.events, events.event_type
			WHERE evs_id = prm_evs_id AND event_type.ety_id = prm_ety_id
		RETURNING evs_id INTO ret;
	FOR id IN SELECT DISTINCT eca_id FROM events.categorie_events WHERE evs_id = prm_evs_id LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (id, ret);
	END LOOP;
	FOR id IN SELECT DISTINCT sec_id FROM events.secteur_events WHERE evs_id = prm_evs_id LOOP
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (id, ret);
	END LOOP;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_events_copie_et_ajoute_type(prm_token integer, prm_evs_id integer, prm_ety_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_copie_et_ajoute_type(prm_token integer, prm_evs_id integer, prm_ety_id integer) IS 'Crée une nouvelle configuration de page d''événements en copiant une configuration existante et en y appliquant un type comme filtre.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : L''identifiant de la configuration de page événement à copier
 - prm_ety_id : Identifiant du type d''événement à appliquer à la nouvelle configuration
Remarques :
Nécessite les droits à la configuration de l''interface';


--
-- Name: events; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE events (
    evs_id integer NOT NULL,
    evs_titre character varying,
    evs_code character varying,
    ety_id integer
);


--
-- Name: TABLE events; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE events IS 'Configuration des pages d''événements disponibles pour placer dans le menu principal ou usager';


--
-- Name: events_events_get(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_get(prm_token integer, prm_id integer) RETURNS events
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.events;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.events WHERE evs_id = prm_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_events_get(prm_token integer, prm_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_get(prm_token integer, prm_id integer) IS 'Retourne les informations d''une configuration de page événement';


--
-- Name: events_events_get_par_code(integer, character varying); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_get_par_code(prm_token integer, prm_code character varying) RETURNS events
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret events.events;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM events.events WHERE evs_code = prm_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION events_events_get_par_code(prm_token integer, prm_code character varying); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_get_par_code(prm_token integer, prm_code character varying) IS 'Retourne les informations d''une configuration de page événement, par son code';


--
-- Name: events_events_list(integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_list(prm_token integer) RETURNS SETOF events
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM events.events ORDER BY evs_titre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_events_list(prm_token integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_list(prm_token integer) IS 'Retourne la liste des configurations de page événement.
Remarques :
Nécessite les droits à la configuration de l''interface';


--
-- Name: events_events_supprime(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_events_supprime(prm_token integer, prm_evs_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM events.categorie_events WHERE evs_id = prm_evs_id;
	DELETE FROM events.secteur_events WHERE evs_id = prm_evs_id;
	DELETE FROM events.events WHERE evs_id = prm_evs_id;
END;
$$;


--
-- Name: FUNCTION events_events_supprime(prm_token integer, prm_evs_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_events_supprime(prm_token integer, prm_evs_id integer) IS 'Supprime une configuration de page événement.
Remarques :
Nécessite les droits à la configuration de l''interface';


--
-- Name: events_groupe_liste(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_groupe_liste(prm_token integer, prm_evs_id integer) RETURNS SETOF events_groupe_liste2
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_groupe_liste2;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		select DISTINCT groupe.grp_id, groupe.grp_nom, eta_id, eta_nom
			FROM groupe 
			INNER JOIN etablissement USING(eta_id)
			INNER JOIN groupe_secteur USING (grp_id)
			INNER JOIN events.secteur_events USING (sec_id)
			where secteur_events.evs_id = prm_evs_id 
			ORDER BY eta_nom, grp_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_groupe_liste(prm_token integer, prm_evs_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_groupe_liste(prm_token integer, prm_evs_id integer) IS 'Retourne la liste des groupes affectés à un des secteurs de la page d''événement.';


--
-- Name: events_groupe_liste_debut(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_groupe_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;	
	FOR row IN
		select DISTINCT personne_groupe.per_id,
			personne_info_varchar_get (prm_token, personne_groupe.per_id, 'nom'),
			personne_info_varchar_get (prm_token, personne_groupe.per_id, 'prenom'),
			EXTRACT (EPOCH FROM personne_groupe.peg_debut ),
			grp_nom,
			(SELECT sec_icone FROM meta.secteur INNER JOIN groupe_secteur USING(sec_id) WHERE grp_id = groupe.grp_id ORDER BY grs_id LIMIT 1)
			FROM personne_groupe
			INNER JOIN groupe USING (grp_id)
			INNER JOIN groupe_secteur USING (grp_id)
--			INNER JOIN meta.secteur USING (sec_id)
			INNER JOIN events.secteur_events USING (sec_id)
			INNER JOIN personne_groupe groupef ON groupef.per_id = personne_groupe.per_id AND (COALESCE (personne_groupe.peg_debut, '-Infinity'::timestamp), COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)) OVERLAPS (COALESCE(groupef.peg_debut, '-Infinity'::timestamp), COALESCE (groupef.peg_fin, 'Infinity'::timestamp)) 
			where secteur_events.evs_id = prm_evs_id AND 
			personne_groupe.peg_debut between p_start AND p_end AND 
			(prm_per_id ISNULL OR personne_groupe.per_id = prm_per_id) 
			AND (prm_grp_id ISNULL OR prm_grp_id = groupef.grp_id)
			AND (prm_per_ids ISNULL OR personne_groupe.per_id = ANY(prm_per_ids))
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événements les entrées d''usagers dans des groupes.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les groupes du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche à un de ces usagers au moins';


--
-- Name: events_groupe_liste_fin(integer, integer, integer, date, date, integer, integer[]); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_groupe_liste;
	p_start timestamp;
	p_end timestamp;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	if prm_start NOTNULL THEN
		p_start = prm_start;
	ELSE
		p_start = timestamp '-INFINITY';
	END IF;
	if prm_end NOTNULL THEN
		p_end = prm_end;
	ELSE
		p_end = timestamp 'INFINITY';
	END IF;	
	FOR row IN
		select DISTINCT personne_groupe.per_id,
			personne_info_varchar_get (prm_token, personne_groupe.per_id, 'nom'),
			personne_info_varchar_get (prm_token, personne_groupe.per_id, 'prenom'),
			EXTRACT (EPOCH FROM personne_groupe.peg_fin ),
			grp_nom,
			(SELECT sec_icone FROM meta.secteur INNER JOIN groupe_secteur USING(sec_id) WHERE grp_id = groupe.grp_id ORDER BY grs_id LIMIT 1)
			FROM personne_groupe
			INNER JOIN groupe USING (grp_id)
			INNER JOIN groupe_secteur USING (grp_id)
--			INNER JOIN meta.secteur USING (sec_id)
			INNER JOIN events.secteur_events USING (sec_id)
			INNER JOIN personne_groupe groupef ON groupef.per_id = personne_groupe.per_id AND (COALESCE (personne_groupe.peg_debut, '-Infinity'::timestamp), COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)) OVERLAPS (COALESCE(groupef.peg_debut, '-Infinity'::timestamp), COALESCE (groupef.peg_fin, 'Infinity'::timestamp)) 
			where secteur_events.evs_id = prm_evs_id AND 
			personne_groupe.peg_fin between p_start AND p_end AND 
			(prm_per_id ISNULL OR personne_groupe.per_id = prm_per_id)
			AND (prm_grp_id ISNULL OR prm_grp_id = groupef.grp_id)
			AND (prm_per_ids ISNULL OR personne_groupe.per_id = ANY(prm_per_ids))
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS 'Retourne sous forme d''événement les sorties de groupes d''usagers.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les groupes du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche à un de ces usagers au moins';


--
-- Name: events_secteur_event_liste(integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_secteur_event_liste(prm_token integer, prm_eve_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur 
		INNER JOIN events.secteur_event USING (sec_id)
		WHERE eve_id = prm_eve_id
		ORDER BY sec_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_secteur_event_liste(prm_token integer, prm_eve_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_secteur_event_liste(prm_token integer, prm_eve_id integer) IS 'Retourne la liste des secteurs auxquels est affecté un événement.';


--
-- Name: events_secteur_events_liste(integer, integer, integer); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION events_secteur_events_liste(prm_token integer, prm_evs_id integer, prm_eta_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur 
		INNER JOIN events.secteur_events USING (sec_id)
		INNER JOIN etablissement_secteur USING(sec_id)
		WHERE evs_id = prm_evs_id AND eta_id = prm_eta_id
		ORDER BY sec_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION events_secteur_events_liste(prm_token integer, prm_evs_id integer, prm_eta_id integer); Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON FUNCTION events_secteur_events_liste(prm_token integer, prm_evs_id integer, prm_eta_id integer) IS 'Retourne la liste des secteurs sur lequels une page d''événements est spécialisée, filtrée sur la liste des secteurs pris en charge par un établissement';


--
-- Name: tmp_cree_agressources(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_agressources() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	rowsec meta.secteur;
	new_agr_id integer;
BEGIN
	-- Ajot agenda tous secteurs
	INSERT INTO events.agressources (agr_code, agr_titre) 
	    	   VALUES ('ressources_tous_secteurs', 'Ressources tous secteurs')
		   RETURNING agr_id INTO new_agr_id;
	FOR rowsec IN SELECT * FROM meta.secteur LOOP
	    INSERT INTO events.agressources_secteur (agr_id, sec_id) VALUES (new_agr_id, rowsec.sec_id);
	END LOOP;

	-- Ajout 1 agenda par secteur
	FOR rowsec IN SELECT * FROM meta.secteur LOOP
	    INSERT INTO events.agressources (agr_code, agr_titre) 
	    	   VALUES ('ressources_'||rowsec.sec_code, 'Ressources ' || rowsec.sec_nom)
		   RETURNING agr_id INTO new_agr_id;
	    INSERT INTO events.agressources_secteur (agr_id, sec_id) VALUES (new_agr_id, rowsec.sec_id);
	END LOOP;
END;
$$;


--
-- Name: tmp_cree_events(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN
/*
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		FOR row_secteurs IN
			SELECT * FROM meta.secteur 
		LOOP
			INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' ' || row_secteurs.sec_nom, row_cats.eca_nom  || '_' || row_secteurs.sec_nom) RETURNING evs_id INTO new_evs_id;
			INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
			INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		END LOOP;
	END LOOP;

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' (tous secteurs)', row_cats.eca_nom  || '_tous_secteurs') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		FOR row_secteurs IN
			SELECT * FROM meta.secteur 
		LOOP
			INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
		END LOOP;
	END LOOP;

	FOR row_secteurs IN
		SELECT * FROM meta.secteur 
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) ' || row_secteurs.sec_nom, 'toutes_categories_' || row_secteurs.sec_nom) RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
		FOR row_cats IN
			select * FROM events.events_categorie
		LOOP
			INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		END LOOP;
	END LOOP;
*/
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) (tous secteurs)', 'toutes_categories_tous_secteurs') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	FOR row_secteurs IN
		SELECT * FROM meta.secteur 
	LOOP
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
	END LOOP;	
END;
$$;


--
-- Name: tmp_cree_events_administration(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_administration() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Administration', row_cats.eca_nom  || '_administration') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (11, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (20, new_evs_id);
	END LOOP;
	
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Administration', 'toutes_categories_administration') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (11, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (20, new_evs_id);

END;
$$;


--
-- Name: tmp_cree_events_aide_financiere_directe(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_aide_financiere_directe() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Aide financière directe', row_cats.eca_nom  || '_aide_financiere_directe') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (26, new_evs_id);
	END LOOP;
	
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Aide financière directe', 'toutes_categories_aide_financiere_directe') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (26, new_evs_id);
END;
$$;


--
-- Name: tmp_cree_events_famille(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_famille() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Famille', row_cats.eca_nom  || '_famille') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (28, new_evs_id);
	END LOOP;
	
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Famille', 'toutes_categories_famille') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (28, new_evs_id);
END;
$$;


--
-- Name: tmp_cree_events_projet(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_projet() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Projet individuel', row_cats.eca_nom  || '_projet_individuel') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (29, new_evs_id);
	END LOOP;
	
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Projet individuel', 'toutes_categories_projet') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (29, new_evs_id);
END;
$$;


--
-- Name: tmp_cree_events_sejour(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_sejour() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN

	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Séjour et excursions', row_cats.eca_nom  || '_sejour') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (30, new_evs_id);
	END LOOP;
	
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Séjour et excursions', 'toutes_categories_sejour') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (30, new_evs_id);
END;
$$;


--
-- Name: tmp_cree_events_vie_quotidienne(); Type: FUNCTION; Schema: events; Owner: -
--

CREATE FUNCTION tmp_cree_events_vie_quotidienne() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_cats events.events_categorie;
	row_secteurs meta.secteur;
	new_evs_id integer;
BEGIN
/*
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Vie quotidienne', row_cats.eca_nom  || '_vie_quotidienne') RETURNING evs_id INTO new_evs_id;
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (21, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (8, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (9, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (7, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (23, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (10, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (1, new_evs_id);
		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (24, new_evs_id);
	END LOOP;
	*/
	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Vie quotidienne', 'toutes_categories_vie_quotidienne') RETURNING evs_id INTO new_evs_id;
	FOR row_cats IN
		select * FROM events.events_categorie
	LOOP
		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
	END LOOP;
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (21, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (8, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (9, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (7, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (23, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (10, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (1, new_evs_id);
	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (24, new_evs_id);

END;
$$;


SET search_path = liste, pg_catalog;

--
-- Name: jours_avant_anniversaire(integer, date); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION jours_avant_anniversaire(prm_token integer, prm_date date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT extract (doy FROM prm_date) - extract (doy FROM CURRENT_TIMESTAMP) INTO ret;
	IF ret < 0 THEN
		ret = ret + 365;
	END IF;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION jours_avant_anniversaire(prm_token integer, prm_date date); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION jours_avant_anniversaire(prm_token integer, prm_date date) IS 'Retourne le nombre de jours avant le prochain anniversaire de la date donnée.';


--
-- Name: liste_champ_add(integer, integer, integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_add(prm_token integer, prm_lis_id integer, prm_inf_id integer, prm_ordre integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO liste.champ (lis_id, inf_id, cha_ordre) VALUES (prm_lis_id, prm_inf_id, prm_ordre) RETURNING cha_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_champ_add(prm_token integer, prm_lis_id integer, prm_inf_id integer, prm_ordre integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_add(prm_token integer, prm_lis_id integer, prm_inf_id integer, prm_ordre integer) IS 'Ajoute un champ à une configuration de page liste.';


--
-- Name: champ; Type: TABLE; Schema: liste; Owner: -; Tablespace: 
--

CREATE TABLE champ (
    cha_id integer NOT NULL,
    lis_id integer,
    inf_id integer,
    cha__groupe_cycle boolean,
    cha__groupe_dernier boolean,
    cha_libelle character varying,
    cha_ordre integer,
    cha_filtrer boolean DEFAULT false NOT NULL,
    cha__groupe_contact boolean,
    cha_verrouiller boolean DEFAULT false,
    cha__famille_details boolean DEFAULT false NOT NULL,
    cha_champs_supp boolean DEFAULT false,
    cha__contact_filtre_utilisateur boolean
);


--
-- Name: TABLE champ; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON TABLE champ IS 'Les champs constituant une page liste';


--
-- Name: COLUMN champ.cha_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_id IS 'Identifiant';


--
-- Name: COLUMN champ.lis_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.lis_id IS 'Configuration de liste';


--
-- Name: COLUMN champ.inf_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.inf_id IS 'Champ personne';


--
-- Name: COLUMN champ.cha__groupe_cycle; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha__groupe_cycle IS 'Pour un champ groupe, afficher infos de cycle';


--
-- Name: COLUMN champ.cha__groupe_dernier; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha__groupe_dernier IS 'Pour un champ groupe, afficher uniquement dernière appartenance';


--
-- Name: COLUMN champ.cha_libelle; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_libelle IS 'Libellé dans la liste';


--
-- Name: COLUMN champ.cha_ordre; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_ordre IS 'Ordre dans la liste';


--
-- Name: COLUMN champ.cha_filtrer; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_filtrer IS 'Proposer de filtrer sur ce champ';


--
-- Name: COLUMN champ.cha__groupe_contact; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha__groupe_contact IS 'Pour un champ groupe, afficher le contact';


--
-- Name: COLUMN champ.cha_verrouiller; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_verrouiller IS 'Si valeurs par défaut, verrouiller ces valeurs';


--
-- Name: COLUMN champ.cha__famille_details; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha__famille_details IS 'Pour champ famille, afficher les détails';


--
-- Name: COLUMN champ.cha_champs_supp; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha_champs_supp IS 'Pour champ Lien ou Famille, indique si on veut afficher des champs supplémentaires';


--
-- Name: COLUMN champ.cha__contact_filtre_utilisateur; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN champ.cha__contact_filtre_utilisateur IS 'Pour un champ Contact, filtre par défaut sur l''utilisateur connecté';


--
-- Name: liste_champ_get(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_get(prm_token integer, prm_cha_id integer) RETURNS champ
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret liste.champ;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM liste.champ WHERE cha_id = prm_cha_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_champ_get(prm_token integer, prm_cha_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_get(prm_token integer, prm_cha_id integer) IS 'Retourne la configuration d''un champ dans une page liste';


--
-- Name: liste_champ_liste(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_liste(prm_token integer, prm_lis_id integer) RETURNS SETOF champ
    LANGUAGE plpgsql
    AS $$
DECLARE
	row liste.champ;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM liste.champ WHERE lis_id = prm_lis_id ORDER BY cha_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION liste_champ_liste(prm_token integer, prm_lis_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_liste(prm_token integer, prm_lis_id integer) IS 'Retourne la liste des configurations de page liste';


--
-- Name: liste_champ_liste_details(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_liste_details(prm_token integer, prm_lis_id integer) RETURNS SETOF liste_champ_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row liste.liste_champ_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT 
			champ.cha_id, 
			champ.cha__groupe_contact,
			champ.cha__groupe_cycle ,
			champ.cha__groupe_dernier ,
			cha_libelle ,
			cha_ordre ,
			cha_filtrer,
			cha_verrouiller,
			cha__famille_details,
			cha_champs_supp,
			info.inf_libelle,
			infos_type.int_code,
			infos_type.int_libelle,
			info.inf_multiple,
			cha__contact_filtre_utilisateur
		FROM liste.champ 
		INNER JOIN meta.info USING(inf_id)
		INNER JOIN meta.infos_type USING (int_id)
		WHERE lis_id = prm_lis_id
		ORDER BY cha_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION liste_champ_liste_details(prm_token integer, prm_lis_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_liste_details(prm_token integer, prm_lis_id integer) IS 'Retourne la liste détaillée des configurations de page liste.';


--
-- Name: liste_champ_set_champs_supp(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_champs_supp(prm_token integer, prm_cha_id integer, prm_champs_supp boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha_champs_supp = prm_champs_supp WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_champs_supp(prm_token integer, prm_cha_id integer, prm_champs_supp boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_champs_supp(prm_token integer, prm_cha_id integer, prm_champs_supp boolean) IS 'Indique si des champs supplémentaires seront affichés dans ce champs.';


--
-- Name: liste_champ_set_contact(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_contact(prm_token integer, prm_cha_id integer, prm_contact boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha__groupe_contact = prm_contact WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_contact(prm_token integer, prm_cha_id integer, prm_contact boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_contact(prm_token integer, prm_cha_id integer, prm_contact boolean) IS 'Pour un champ groupe, indique si le contact doit être affiché.';


--
-- Name: liste_champ_set_contact_filtre_utilisateur(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_contact_filtre_utilisateur(prm_token integer, prm_cha_id integer, prm_filtre_utilisateur boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha__contact_filtre_utilisateur = prm_filtre_utilisateur WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_contact_filtre_utilisateur(prm_token integer, prm_cha_id integer, prm_filtre_utilisateur boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_contact_filtre_utilisateur(prm_token integer, prm_cha_id integer, prm_filtre_utilisateur boolean) IS 'Indique si un champ Contact filtré le sera par défaut sur l''utilisateur connecté.';


--
-- Name: liste_champ_set_cycle(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_cycle(prm_token integer, prm_cha_id integer, prm_cycle boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha__groupe_cycle = prm_cycle WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_cycle(prm_token integer, prm_cha_id integer, prm_cycle boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_cycle(prm_token integer, prm_cha_id integer, prm_cycle boolean) IS 'Pour un champ groupe, indique si les informations de cycle doivent être affichées.';


--
-- Name: liste_champ_set_dernier(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_dernier(prm_token integer, prm_cha_id integer, prm_dernier boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha__groupe_dernier = prm_dernier WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_dernier(prm_token integer, prm_cha_id integer, prm_dernier boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_dernier(prm_token integer, prm_cha_id integer, prm_dernier boolean) IS 'Pour un champ groupe, indique si uniquement la dernière appartenance doit être affichée.';


--
-- Name: liste_champ_set_details(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_details(prm_token integer, prm_cha_id integer, prm_details boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha__famille_details = prm_details WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_details(prm_token integer, prm_cha_id integer, prm_details boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_details(prm_token integer, prm_cha_id integer, prm_details boolean) IS 'Pour un champ famille, indique si les détails du lien familial doivent être affichés.';


--
-- Name: liste_champ_set_filtrer(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_filtrer(prm_token integer, prm_cha_id integer, prm_filtrer boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha_filtrer = prm_filtrer WHERE cha_id = prm_cha_id;
	IF NOT prm_filtrer THEN
		UPDATE liste.champ SET cha_verrouiller = FALSE WHERE cha_id = prm_cha_id;
	END IF;
	DELETE FROM liste.defaut WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_filtrer(prm_token integer, prm_cha_id integer, prm_filtrer boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_filtrer(prm_token integer, prm_cha_id integer, prm_filtrer boolean) IS 'Indique s''il est possible de filtrer sur ce champ.';


--
-- Name: liste_champ_set_libelle(integer, integer, character varying); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_libelle(prm_token integer, prm_cha_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha_libelle = prm_libelle WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_libelle(prm_token integer, prm_cha_id integer, prm_libelle character varying); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_libelle(prm_token integer, prm_cha_id integer, prm_libelle character varying) IS 'Modifie le libellé du champ dans la liste.';


--
-- Name: liste_champ_set_ordre(integer, integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_ordre(prm_token integer, prm_cha_id integer, prm_ordre integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha_ordre = prm_ordre WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_ordre(prm_token integer, prm_cha_id integer, prm_ordre integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_ordre(prm_token integer, prm_cha_id integer, prm_ordre integer) IS 'Modifie l''ordre du champ dans la liste.';


--
-- Name: liste_champ_set_verrouiller(integer, integer, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_set_verrouiller(prm_token integer, prm_cha_id integer, prm_verrouiller boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.champ SET cha_verrouiller = prm_verrouiller WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_set_verrouiller(prm_token integer, prm_cha_id integer, prm_verrouiller boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_set_verrouiller(prm_token integer, prm_cha_id integer, prm_verrouiller boolean) IS 'Indique si les valeurs de filtrage par défaut sont verrouillées.';


--
-- Name: liste_champ_supprime(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_champ_supprime(prm_token integer, prm_cha_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM liste.champ WHERE cha_id = prm_cha_id;
END;
$$;


--
-- Name: FUNCTION liste_champ_supprime(prm_token integer, prm_cha_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_champ_supprime(prm_token integer, prm_cha_id integer) IS 'Supprime un champ d''une page liste.';


--
-- Name: liste_defaut_ajoute_groupe(integer, integer, integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_defaut_ajoute_groupe(prm_token integer, prm_cha_id integer, prm_val integer, prm_val2 integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO liste.defaut (cha_id, def_valeur_int, def_valeur_int2) VALUES (prm_cha_id, prm_val, prm_val2)
		RETURNING def_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_defaut_ajoute_groupe(prm_token integer, prm_cha_id integer, prm_val integer, prm_val2 integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_defaut_ajoute_groupe(prm_token integer, prm_cha_id integer, prm_val integer, prm_val2 integer) IS 'Ajoute une valeur par défaut à un champ de type affectation, etc';


--
-- Name: liste_defaut_ajoute_selection(integer, integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_defaut_ajoute_selection(prm_token integer, prm_cha_id integer, prm_val integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO liste.defaut (cha_id, def_valeur_int) VALUES (prm_cha_id, prm_val)
		RETURNING def_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_defaut_ajoute_selection(prm_token integer, prm_cha_id integer, prm_val integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_defaut_ajoute_selection(prm_token integer, prm_cha_id integer, prm_val integer) IS 'Ajoute une valeur par défaut à un champ de type sélection, etc';


--
-- Name: liste_defaut_ajoute_texte(integer, integer, character varying); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_defaut_ajoute_texte(prm_token integer, prm_cha_id integer, prm_val character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO liste.defaut (cha_id, def_valeur_texte) VALUES (prm_cha_id, prm_val)
		RETURNING def_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_defaut_ajoute_texte(prm_token integer, prm_cha_id integer, prm_val character varying); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_defaut_ajoute_texte(prm_token integer, prm_cha_id integer, prm_val character varying) IS 'Ajoute une valeur par défaut à un champ de type texte, etc';


--
-- Name: defaut; Type: TABLE; Schema: liste; Owner: -; Tablespace: 
--

CREATE TABLE defaut (
    def_id integer NOT NULL,
    cha_id integer,
    def_valeur_texte character varying,
    def_valeur_int integer,
    def_valeur_int2 integer,
    def_ordre integer
);


--
-- Name: TABLE defaut; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON TABLE defaut IS 'Valeurs de filtre d''un champ par défaut';


--
-- Name: COLUMN defaut.def_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.def_id IS 'Identifiant';


--
-- Name: COLUMN defaut.cha_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.cha_id IS 'Champ dans liste auquel est rattachée cette valeur par défaut';


--
-- Name: COLUMN defaut.def_valeur_texte; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.def_valeur_texte IS 'Valeur par défaut pour champ de type texte, etc';


--
-- Name: COLUMN defaut.def_valeur_int; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.def_valeur_int IS 'Valeur par défaut pour champ de type liste de sélection, etc';


--
-- Name: COLUMN defaut.def_valeur_int2; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.def_valeur_int2 IS 'Valeur par défaut pour champ de type affectation, etc';


--
-- Name: COLUMN defaut.def_ordre; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN defaut.def_ordre IS 'Ordre de la valeur par défaut';


--
-- Name: liste_defaut_liste(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_defaut_liste(prm_token integer, prm_cha_id integer) RETURNS SETOF defaut
    LANGUAGE plpgsql
    AS $$
DECLARE
	row liste.defaut;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM liste.defaut WHERE cha_id = prm_cha_id ORDER BY def_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION liste_defaut_liste(prm_token integer, prm_cha_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_defaut_liste(prm_token integer, prm_cha_id integer) IS 'Retourne la liste des valeurs de filtrage par défaut d''un champ dans la liste.';


--
-- Name: liste_defaut_supprime(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_defaut_supprime(prm_token integer, prm_def_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	cha integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT cha_id INTO cha FROM liste.defaut WHERE def_id = prm_def_id;
	DELETE FROM liste.defaut WHERE def_id = prm_def_id;
	IF NOT EXISTS (SELECT 1 FROM liste.defaut WHERE cha_id = cha) THEN
		UPDATE liste.champ SET cha_verrouiller = FALSE WHERE cha_id = cha;
	END IF;
END;
$$;


--
-- Name: FUNCTION liste_defaut_supprime(prm_token integer, prm_def_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_defaut_supprime(prm_token integer, prm_def_id integer) IS 'Supprime une valeur de filtrage par défaut pour un champ dans la liste.';


--
-- Name: liste; Type: TABLE; Schema: liste; Owner: -; Tablespace: 
--

CREATE TABLE liste (
    lis_id integer NOT NULL,
    lis_nom character varying,
    ent_id integer,
    lis_inverse boolean,
    lis_pagination_tout boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE liste; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON TABLE liste IS 'Les configurations de page liste.';


--
-- Name: COLUMN liste.lis_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN liste.lis_id IS 'Identifiant';


--
-- Name: COLUMN liste.lis_nom; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN liste.lis_nom IS 'Nom de la page';


--
-- Name: COLUMN liste.ent_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN liste.ent_id IS 'Identifiant du type d''entité décrit par la liste (usager, personnel, etc)';


--
-- Name: COLUMN liste.lis_inverse; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN liste.lis_inverse IS 'TRUE pour placer les libellés des champs à gauche plutôt qu''en haut du tableau.';


--
-- Name: COLUMN liste.lis_pagination_tout; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN liste.lis_pagination_tout IS 'TRUE pour tout afficher par défaut';


--
-- Name: liste_liste_all(integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_liste_all(prm_token integer) RETURNS SETOF liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row liste.liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM liste.liste 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION liste_liste_all(prm_token integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_liste_all(prm_token integer) IS 'Retourne la liste des configurations de pages liste.';


--
-- Name: liste_liste_create(integer, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_liste_create(prm_token integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO liste.liste (lis_nom, ent_id, lis_inverse, lis_pagination_tout) VALUES (prm_nom, prm_ent_id, prm_inverse, prm_pagination_tout) RETURNING lis_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_liste_create(prm_token integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_liste_create(prm_token integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean) IS 'Crée une nouvelle configuration de page liste.';


--
-- Name: liste_liste_get(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_liste_get(prm_token integer, prm_lis_id integer) RETURNS liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret liste.liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM liste.liste WHERE lis_id = prm_lis_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION liste_liste_get(prm_token integer, prm_lis_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_liste_get(prm_token integer, prm_lis_id integer) IS 'Retourne les informations d''une configuration de page liste.';


--
-- Name: liste_liste_supprime(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_liste_supprime(prm_token integer, prm_lis_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.topsousmenu SET tsm_type_id = NULL WHERE tsm_type = 'liste' AND tsm_type_id = prm_lis_id;
	DELETE FROM liste.defaut WHERE cha_id IN (SELECT cha_id FROM liste.champ WHERE lis_id = prm_lis_id);
	DELETE FROM liste.champ WHERE lis_id = prm_lis_id;
	DELETE FROM liste.liste WHERE lis_id = prm_lis_id;
END;
$$;


--
-- Name: FUNCTION liste_liste_supprime(prm_token integer, prm_lis_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_liste_supprime(prm_token integer, prm_lis_id integer) IS 'Supprime une configuration de page liste.';


--
-- Name: liste_liste_update(integer, integer, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_liste_update(prm_token integer, prm_lis_id integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE liste.liste SET lis_nom = prm_nom, ent_id = prm_ent_id, lis_inverse = prm_inverse, lis_pagination_tout = prm_pagination_tout WHERE lis_id = prm_lis_id;
END;
$$;


--
-- Name: FUNCTION liste_liste_update(prm_token integer, prm_lis_id integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_liste_update(prm_token integer, prm_lis_id integer, prm_nom character varying, prm_ent_id integer, prm_inverse boolean, prm_pagination_tout boolean) IS 'Modifie les informations d''une configuration de page liste.';


--
-- Name: liste_supp_edit(integer, integer, integer[]); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_supp_edit(prm_token integer, prm_cha_id integer, prm_inf_ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM liste.supp WHERE cha_id = prm_cha_id;
	FOR i IN 1 .. array_upper(prm_inf_ids, 1) LOOP
	    INSERT INTO liste.supp (cha_id, inf_id, sup_ordre) 
	    	   VALUES (prm_cha_id, prm_inf_ids[i], i-1);
	END LOOP;	
END;
$$;


--
-- Name: FUNCTION liste_supp_edit(prm_token integer, prm_cha_id integer, prm_inf_ids integer[]); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_supp_edit(prm_token integer, prm_cha_id integer, prm_inf_ids integer[]) IS 'Indique la liste des champs à afficher pour détailler une colonne de tableau donnée.';


SET search_path = meta, pg_catalog;

--
-- Name: info; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE info (
    inf_id integer NOT NULL,
    int_id integer,
    inf_code character varying,
    inf_libelle character varying,
    inf__textelong_nblignes integer,
    inf__selection_code integer,
    inf_etendu boolean DEFAULT false NOT NULL,
    inf_historique boolean DEFAULT false NOT NULL,
    inf_multiple boolean DEFAULT false NOT NULL,
    inf__groupe_type character varying,
    inf__contact_filtre character varying,
    inf__metier_secteur character varying,
    inf__contact_secteur character varying,
    inf__etablissement_interne boolean,
    din_id integer,
    inf__groupe_soustype integer,
    inf_libelle_complet character varying,
    inf__date_echeance boolean,
    inf__date_echeance_icone character varying,
    inf__date_echeance_secteur character varying,
    inf__etablissement_secteur character varying
);


--
-- Name: TABLE info; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE info IS 'Champ d''édition d''une personne';


SET search_path = liste, pg_catalog;

--
-- Name: liste_supp_list(integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_supp_list(prm_token integer, prm_cha_id integer) RETURNS SETOF meta.info
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.info;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT info.* FROM liste.supp
	    	   INNER JOIN meta.info USING(inf_id)
		   WHERE (prm_cha_id ISNULL OR cha_id = prm_cha_id)
		   ORDER BY sup_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION liste_supp_list(prm_token integer, prm_cha_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_supp_list(prm_token integer, prm_cha_id integer) IS 'Retourne la liste des champs afficher pour détailler une colonne de tableau.';


--
-- Name: liste_supp_supprime(integer, integer, integer); Type: FUNCTION; Schema: liste; Owner: -
--

CREATE FUNCTION liste_supp_supprime(prm_token integer, prm_cha_id integer, prm_inf_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM liste.supp WHERE cha_id = prm_cha_id AND inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION liste_supp_supprime(prm_token integer, prm_cha_id integer, prm_inf_id integer); Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON FUNCTION liste_supp_supprime(prm_token integer, prm_cha_id integer, prm_inf_id integer) IS 'Supprime un champs supplémentaire.';


SET search_path = localise, pg_catalog;

--
-- Name: localise_par_code_secteur(integer, character varying, character varying); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_par_code_secteur(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	select loc_valeur INTO ret from localise.localisation_secteur
	inner join localise.terme using(ter_id)
	left join meta.secteur using(sec_id)
	WHERE ter_code = prm_ter_code AND (sec_code = prm_sec_code OR sec_code ISNULL)
	ORDER BY sec_code LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION localise_par_code_secteur(prm_token integer, prm_ter_code character varying, prm_sec_code character varying); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_par_code_secteur(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) IS 'Retourne un terme localisé pour un secteur donné.';


--
-- Name: localise_par_code_secteur_set(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_par_code_secteur_set(prm_token integer, prm_ter_code character varying, prm_sec_code character varying, prm_valeur character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE localise.localisation_secteur 
	       SET loc_valeur = prm_valeur 
	       WHERE 
	       	     ter_id = (SELECT ter_id FROM localise.terme WHERE ter_code = prm_ter_code) AND 
		     ( (prm_sec_code ISNULL AND sec_id ISNULL) OR 
		       sec_id = (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code) );
	IF NOT FOUND THEN
	   INSERT INTO localise.localisation_secteur (ter_id, loc_valeur, sec_id) 
	   	  VALUES ((SELECT ter_id FROM localise.terme WHERE ter_code = prm_ter_code),
		          prm_valeur,
			  (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code) );
	END IF;
END;
$$;


--
-- Name: FUNCTION localise_par_code_secteur_set(prm_token integer, prm_ter_code character varying, prm_sec_code character varying, prm_valeur character varying); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_par_code_secteur_set(prm_token integer, prm_ter_code character varying, prm_sec_code character varying, prm_valeur character varying) IS 'Modifie la localisation d''un terme pour un secteur particulier.
Entrées :
 - prm_token : Token d''authentification
 - prm_ter_code : Code du terme
 - prm_sec_code : Code du secteur ou NULL pour modifier la valeur par défaut
 - prm_valeur : Valeur de la localisation
';


--
-- Name: localise_par_code_secteur_supprime(integer, character varying, character varying); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_par_code_secteur_supprime(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	DELETE FROM localise.localisation_secteur 
	WHERE 
	      sec_id = (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code) AND
	      ter_id = (SELECT ter_id FROM localise.terme WHERE ter_code = prm_ter_code);
END;
$$;


--
-- Name: FUNCTION localise_par_code_secteur_supprime(prm_token integer, prm_ter_code character varying, prm_sec_code character varying); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_par_code_secteur_supprime(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) IS 'Suppime la localisation d''un terme pour un secteur donné.';


--
-- Name: terme; Type: TABLE; Schema: localise; Owner: -; Tablespace: 
--

CREATE TABLE terme (
    ter_id integer NOT NULL,
    ter_code character varying,
    ter_commentaire character varying
);


--
-- Name: TABLE terme; Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON TABLE terme IS 'Terme à localiser.';


--
-- Name: localise_terme_get(integer, integer); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_terme_get(prm_token integer, prm_id integer) RETURNS terme
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret localise.terme;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	SELECT * INTO ret FROM localise.terme WHERE ter_id = prm_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION localise_terme_get(prm_token integer, prm_id integer); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_terme_get(prm_token integer, prm_id integer) IS 'Retourne les détails d''un terme à localiser.';


--
-- Name: localise_terme_liste_details(integer); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_terme_liste_details(prm_token integer) RETURNS SETOF localise_terme_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row localise.localise_terme_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	FOR row IN 
	    SELECT ter_id, ter_code, ter_commentaire, localise.localise_par_code_secteur(prm_token, ter_code, NULL) FROM localise.terme ORDER BY ter_id 
	LOOP
	    RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION localise_terme_liste_details(prm_token integer); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_terme_liste_details(prm_token integer) IS 'Retourne le détail des termes à localiser.';


--
-- Name: localise_terme_set(integer, integer, character varying); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_terme_set(prm_token integer, prm_id integer, prm_commentaire character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE localise.terme SET ter_commentaire = prm_commentaire WHERE ter_id = prm_id;
END;
$$;


--
-- Name: FUNCTION localise_terme_set(prm_token integer, prm_id integer, prm_commentaire character varying); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_terme_set(prm_token integer, prm_id integer, prm_commentaire character varying) IS 'Modifie les détails d''un terme à localiser.';


--
-- Name: localise_terme_supprime(integer, integer); Type: FUNCTION; Schema: localise; Owner: -
--

CREATE FUNCTION localise_terme_supprime(prm_token integer, prm_ter_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM localise.localisation_secteur WHERE ter_id = prm_ter_id;
	DELETE FROM localise.terme WHERE ter_id = prm_ter_id;
END;
$$;


--
-- Name: FUNCTION localise_terme_supprime(prm_token integer, prm_ter_id integer); Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON FUNCTION localise_terme_supprime(prm_token integer, prm_ter_id integer) IS 'Supprime un terme à localiser.';


SET search_path = lock, pg_catalog;

--
-- Name: fiche_lock(integer, integer, boolean); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION fiche_lock(prm_token integer, prm_per_id integer, prm_force boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	DELETE FROM lock.fiche WHERE  AGE(CURRENT_TIMESTAMP, loc_date) > '5 min';
	IF NOT prm_force THEN
		IF EXISTS (SELECT 1 FROM lock.fiche WHERE per_id = prm_per_id AND uti_id <> uti) THEN
			SELECT uti_id INTO ret FROM lock.fiche WHERE per_id = prm_per_id AND uti_id <> uti LIMIT 1;
			RETURN -ret;
		ELSIF EXISTS (SELECT 1 FROM lock.fiche WHERE per_id = prm_per_id AND uti_id = uti) THEN
			DELETE FROM lock.fiche WHERE per_id = prm_per_id AND uti_id = uti;
		END IF;

		INSERT INTO lock.fiche (uti_id, per_id, loc_date) VALUES (uti, prm_per_id, CURRENT_TIMESTAMP)
			RETURNING loc_id INTO ret;
		RETURN ret;
	ELSE
		INSERT INTO lock.fiche (uti_id, per_id, loc_date) VALUES (uti, prm_per_id, CURRENT_TIMESTAMP)
			RETURNING loc_id INTO ret;
		RETURN ret;

	END IF;
END;
$$;


--
-- Name: FUNCTION fiche_lock(prm_token integer, prm_per_id integer, prm_force boolean); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION fiche_lock(prm_token integer, prm_per_id integer, prm_force boolean) IS 'Verouille une fiche.';


--
-- Name: fiche_touch(integer, integer); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION fiche_touch(prm_token integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	UPDATE lock.fiche SET loc_date = CURRENT_TIMESTAMP WHERE uti_id = uti AND per_id = prm_per_id;
END;
$$;


--
-- Name: FUNCTION fiche_touch(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION fiche_touch(prm_token integer, prm_per_id integer) IS 'Rafraîchit la date de dernière consultation d''une fiche.';


--
-- Name: fiche_unlock(integer, integer); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION fiche_unlock(prm_token integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	DELETE FROM lock.fiche WHERE uti_id = uti AND per_id = prm_per_id;
END;
$$;


--
-- Name: FUNCTION fiche_unlock(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION fiche_unlock(prm_token integer, prm_per_id integer) IS 'Déverouille une fiche.';


--
-- Name: fiche_unlock_tout(integer); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION fiche_unlock_tout(prm_token integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	DELETE FROM lock.fiche WHERE uti_id = uti;
END;
$$;


--
-- Name: FUNCTION fiche_unlock_tout(prm_token integer); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION fiche_unlock_tout(prm_token integer) IS 'Déverouille toutes les fichers verrouillées par l''utilisateur authentifié.';


--
-- Name: fiche; Type: TABLE; Schema: lock; Owner: -; Tablespace: 
--

CREATE TABLE fiche (
    loc_id integer NOT NULL,
    uti_id integer,
    per_id integer,
    loc_date timestamp with time zone,
    sme_id integer
);


--
-- Name: TABLE fiche; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON TABLE fiche IS 'Fiche verrouillée.';


--
-- Name: COLUMN fiche.loc_id; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON COLUMN fiche.loc_id IS 'Identifiant';


--
-- Name: COLUMN fiche.uti_id; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON COLUMN fiche.uti_id IS 'Utilisateur ayant verrouillé la fiche';


--
-- Name: COLUMN fiche.per_id; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON COLUMN fiche.per_id IS 'Identifiant de la personne affichée par la fiche';


--
-- Name: COLUMN fiche.loc_date; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON COLUMN fiche.loc_date IS 'Date de dernière consultation de la fiche par l''utilisateur';


--
-- Name: COLUMN fiche.sme_id; Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON COLUMN fiche.sme_id IS 'Dernier menu visité dans la fiche';


--
-- Name: lock_fiche_liste(integer); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION lock_fiche_liste(prm_token integer) RETURNS SETOF fiche
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row lock.fiche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	DELETE FROM lock.fiche WHERE uti_id = uti AND AGE(CURRENT_TIMESTAMP, loc_date) > '5 min';
	FOR row IN
		SELECT * FROM lock.fiche WHERE uti_id = uti ORDER BY loc_date DESC
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION lock_fiche_liste(prm_token integer); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION lock_fiche_liste(prm_token integer) IS 'Retourne la liste des fiches verrouillées par l''utilisateur authentifié.';


--
-- Name: lock_fiche_set_sme(integer, integer, integer); Type: FUNCTION; Schema: lock; Owner: -
--

CREATE FUNCTION lock_fiche_set_sme(prm_per_id integer, prm_token integer, prm_sme_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE 
	uti integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	UPDATE lock.fiche SET sme_id = prm_sme_id WHERE per_id = prm_per_id AND uti_id = uti;
END;
$$;


--
-- Name: FUNCTION lock_fiche_set_sme(prm_per_id integer, prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: lock; Owner: -
--

COMMENT ON FUNCTION lock_fiche_set_sme(prm_per_id integer, prm_token integer, prm_sme_id integer) IS 'Modifie le dernier menu visité.';


SET search_path = login, pg_catalog;

--
-- Name: _token_assert(integer, boolean, boolean); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION _token_assert(prm_token integer, prm_config boolean, prm_root boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	util login.utilisateur;
BEGIN
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	IF NOT FOUND THEN
	    RAISE EXCEPTION USING ERRCODE = 'insufficient_privilege';
	END IF;
	IF uti ISNULL THEN -- C'est le token de l'éditeur
	   RETURN;
	END IF;
	IF prm_config AND prm_root THEN
	    SELECT * INTO util FROM login.utilisateur WHERE uti_id = uti;
	    IF util.uti_config IS DISTINCT FROM TRUE OR util.uti_root IS DISTINCT FROM TRUE THEN
	        RAISE EXCEPTION USING ERRCODE = 'insufficient_privilege';
	    END IF;
	ELSIF prm_config THEN
	    SELECT * INTO util FROM login.utilisateur WHERE uti_id = uti;
	    IF util.uti_config IS DISTINCT FROM TRUE THEN
	        RAISE EXCEPTION USING ERRCODE = 'insufficient_privilege';
	    END IF;
	ELSIF prm_root THEN
	    SELECT * INTO util FROM login.utilisateur WHERE uti_id = uti;
	    IF util.uti_root IS DISTINCT FROM TRUE THEN
	        RAISE EXCEPTION USING ERRCODE = 'insufficient_privilege';
	    END IF;
	END IF;
END;
$$;


--
-- Name: FUNCTION _token_assert(prm_token integer, prm_config boolean, prm_root boolean); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION _token_assert(prm_token integer, prm_config boolean, prm_root boolean) IS '[INTERNE] Vérifie la validité d''un token et ses droits de configuratiuon "Établissement" et "Réseau".

Entrée :
 - prm_token  : Token à vérifier
 - prm_config : Vérifie le droit de configuration "Etablissement"
 - prm_root   : Vérifie le droit de configuration "Réseau"
Lève une exception "insufficient_privilege" si le token est invalide ou si une demande de vérification config ou root échoue.';


--
-- Name: _token_assert_interface(integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION _token_assert_interface(prm_token integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	util login.utilisateur;
BEGIN
	-- TODO : Vérifier les droits de config de l'interface
END;
$$;


--
-- Name: FUNCTION _token_assert_interface(prm_token integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION _token_assert_interface(prm_token integer) IS '[INTERNE] Vérifie les droits de configuration de l''inteface pour un token';


--
-- Name: _token_create(integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION _token_create(prm_uti_id integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	tok integer DEFAULT NULL;
	trouve BOOLEAN DEFAULT true;
BEGIN
	DELETE FROM login.token WHERE uti_id = prm_uti_id AND AGE(CURRENT_TIMESTAMP, tok_date_creation) > '8 hours';
	SELECT tok_token INTO tok FROM login.token WHERE uti_id = prm_uti_id;
        IF tok NOTNULL THEN
	    RETURN tok;
	ELSE
	    WHILE trouve LOOP
	      tok = (RANDOM()*1000000000)::int;
	      IF NOT EXISTS (SELECT 1 FROM login.token WHERE tok_token = tok) THEN
	          trouve = false;
 	      END IF;
	    END LOOP;
	    INSERT INTO login.token (uti_id, tok_token, tok_date_creation)
	       VALUES (prm_uti_id, tok, CURRENT_TIMESTAMP);
	    RETURN tok;
	END IF;
END;
$$;


--
-- Name: FUNCTION _token_create(prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION _token_create(prm_uti_id integer) IS '[INTERNE] Crée un token d''authentification pour un utilisateur donné.
Retourne la valeur du token, à utiliser dans tout appel de fonction sécurisée';


--
-- Name: login_grouputil_add(integer, character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_add(prm_token integer, prm_nom character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	INSERT INTO login.grouputil (gut_nom) VALUES (prm_nom) RETURNING gut_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION login_grouputil_add(prm_token integer, prm_nom character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_add(prm_token integer, prm_nom character varying) IS 'Ajoute un nouveau groupe d''utilisateurs.

Entrée : 
 - prm_token : token d''authentification
 - prm_nom   : Nom du groupe
Retour : 
 - Id du groupe d''utilisateurs créé
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: grouputil; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE grouputil (
    gut_id integer NOT NULL,
    gut_nom character varying
);


--
-- Name: TABLE grouputil; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE grouputil IS 'Liste des groupes d''utilisateurs.';


--
-- Name: COLUMN grouputil.gut_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil.gut_id IS 'Identifiant du groupe d''utilisateurs';


--
-- Name: COLUMN grouputil.gut_nom; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil.gut_nom IS 'Nom du groupe';


--
-- Name: login_grouputil_get(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_get(prm_token integer, prm_gut_id integer) RETURNS grouputil
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret login.grouputil;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	SELECT * INTO ret FROM login.grouputil WHERE gut_id = prm_gut_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION login_grouputil_get(prm_token integer, prm_gut_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_get(prm_token integer, prm_gut_id integer) IS 'Retourne les informations sur un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour : 
 - gut_id  : Id du groupe
 - gut_nom : Nom du groupe d''utilisateurs
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: grouputil_groupe; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE grouputil_groupe (
    ggr_id integer NOT NULL,
    gut_id integer,
    grp_id integer
);


--
-- Name: TABLE grouputil_groupe; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE grouputil_groupe IS 'Groupes d''usagers auxquels un groupe d''utilisateurs a accès';


--
-- Name: COLUMN grouputil_groupe.ggr_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_groupe.ggr_id IS 'Identifiant de la relation';


--
-- Name: COLUMN grouputil_groupe.gut_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_groupe.gut_id IS 'Identifiant du groupe d''utilisateurs';


--
-- Name: COLUMN grouputil_groupe.grp_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_groupe.grp_id IS 'Identifiant du groupe d''usagers';


--
-- Name: login_grouputil_groupe_liste(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_groupe_liste(prm_token integer, prm_gut_id integer) RETURNS SETOF grouputil_groupe
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.grouputil_groupe;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN SELECT * FROM login.grouputil_groupe WHERE gut_id = prm_gut_id LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION login_grouputil_groupe_liste(prm_token integer, prm_gut_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_groupe_liste(prm_token integer, prm_gut_id integer) IS 'Retourne la liste des groupes d''usagers accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour (multiple) : 
 - gut_id : Id du groupe d''utilisateurs
 - grp_id : Id du groupe d''usagers
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_grouputil_groupe_set(integer, integer, integer[]); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_groupe_set(prm_token integer, prm_gut_id integer, prm_groupes integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.grouputil_groupe WHERE gut_id = prm_gut_id;
	IF prm_groupes NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_groupes, 1) LOOP
			INSERT INTO login.grouputil_groupe(gut_id, grp_id) VALUES (prm_gut_id, prm_groupes[i]);
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION login_grouputil_groupe_set(prm_token integer, prm_gut_id integer, prm_groupes integer[]); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_groupe_set(prm_token integer, prm_gut_id integer, prm_groupes integer[]) IS 'Définit la liste des groupes d''usagers accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token     : token d''authentification
 - prm_gut_id    : Id du groupe d''utilisateurs
 - prm_groupes[] : tableau d''identifiants de groupes d''usagers
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_grouputil_liste(integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_liste(prm_token integer) RETURNS SETOF grouputil
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.grouputil;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN SELECT * FROM login.grouputil ORDER BY gut_nom LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION login_grouputil_liste(prm_token integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_liste(prm_token integer) IS 'Retourne la liste des groupe d''utilisateurs.

Entrée :
 - prm_token : token d''authentification
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: grouputil_portail; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE grouputil_portail (
    gpo_id integer NOT NULL,
    gut_id integer,
    por_id integer
);


--
-- Name: TABLE grouputil_portail; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE grouputil_portail IS 'Portails auxquels un groupe d''utilisateurs a accès';


--
-- Name: COLUMN grouputil_portail.gpo_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_portail.gpo_id IS 'Identifiant de la relation';


--
-- Name: COLUMN grouputil_portail.gut_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_portail.gut_id IS 'Identifiant du groupe d''utilisateurs';


--
-- Name: COLUMN grouputil_portail.por_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN grouputil_portail.por_id IS 'Identifiant du portail';


--
-- Name: login_grouputil_portail_liste(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_portail_liste(prm_token integer, prm_gut_id integer) RETURNS SETOF grouputil_portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.grouputil_portail;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN SELECT * FROM login.grouputil_portail WHERE gut_id = prm_gut_id LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION login_grouputil_portail_liste(prm_token integer, prm_gut_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_portail_liste(prm_token integer, prm_gut_id integer) IS 'Retourne la liste des portails accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour (multiple) : 
 - gut_id : Id du groupe d''utilisateurs
 - por_id : Id du portail
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_grouputil_portail_set(integer, integer, integer[]); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_portail_set(prm_token integer, prm_gut_id integer, prm_portails integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.grouputil_portail WHERE gut_id = prm_gut_id;
	IF prm_portails NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_portails, 1) LOOP
			INSERT INTO login.grouputil_portail(gut_id, por_id) VALUES (prm_gut_id, prm_portails[i]);
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION login_grouputil_portail_set(prm_token integer, prm_gut_id integer, prm_portails integer[]); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_portail_set(prm_token integer, prm_gut_id integer, prm_portails integer[]) IS 'Définit la liste des portails accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token      : token d''authentification
 - prm_gut_id     : Id du groupe d''utilisateurs
 - prm_portails[] : tableau d''identifiants de portails
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_grouputil_supprime(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_supprime(prm_token integer, prm_gut_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.grouputil_groupe WHERE gut_id = prm_gut_id;
	DELETE FROM login.grouputil_portail WHERE gut_id = prm_gut_id;
	DELETE FROM login.grouputil WHERE gut_id = prm_gut_id;
END;
$$;


--
-- Name: FUNCTION login_grouputil_supprime(prm_token integer, prm_gut_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_supprime(prm_token integer, prm_gut_id integer) IS 'Supprime un groupe d''utilisateurs.
 - prm_token  : token d''authentification
 - prm_gut_id : Identifiant du groupe d''utilisateurs
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_grouputil_update(integer, integer, character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_grouputil_update(prm_token integer, prm_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE login.grouputil SET gut_nom = prm_nom WHERE gut_id = prm_id;
END;
$$;


--
-- Name: FUNCTION login_grouputil_update(prm_token integer, prm_id integer, prm_nom character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_grouputil_update(prm_token integer, prm_id integer, prm_nom character varying) IS 'Met à jour les informations d''un groupe d''utilisateurs.

Entrée :
 - prm_token : token d''authentification
 - prm_id    : Identifiant du groupe d''utilisateurs
 - prm_nom   : nom du groupe à mettre à jour
Nécessite les droits à la configuration "Etablissement"';


--
-- Name: login_utilisateur_acces_personne(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION login_utilisateur_acces_personne(prm_token integer, prm_per_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);	
	RETURN EXISTS (SELECT 1 FROM login.utilisateur_grouputil
		INNER JOIN login.grouputil_groupe USING (gut_id)
		INNER JOIN personne_groupe USING (grp_id)
		INNER JOIN login.token USING(uti_id)
		WHERE tok_token = prm_token AND per_id = prm_per_id);
END;
$$;


--
-- Name: FUNCTION login_utilisateur_acces_personne(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION login_utilisateur_acces_personne(prm_token integer, prm_per_id integer) IS 'Vérifie que le token donne accès à un usager donné.
L''accès est validé si l''usager fait partie d''un groupe d''usagers auquel le groupe d''utilisateurs de l''utilisateur (identifié par le token) a accès.

Entrée :
 - prm_token : token d''authentification
 - prm_per_id : Identifiant de l''usager';


--
-- Name: utilisateur_add(integer, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_add(prm_token integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	mdp varchar;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);	
	mdp = LPAD((random()*1000000)::varchar, 6, '0');
	INSERT INTO login.utilisateur (uti_login, per_id, uti_salt, uti_pwd, uti_config, uti_root) VALUES (prm_login, prm_per_id, crypt (mdp, gen_salt('des')), mdp, prm_uti_config, prm_uti_root) RETURNING uti_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION utilisateur_add(prm_token integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_add(prm_token integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) IS 'Ajoute un utilisateur.

Entrée :
 - prm_token : Token d''authentification
 - prm_login : Login du nouvel utilisateur
 - prm_per_id : Id du personnel lié à l''utilisateur
 - prm_uti_config : l''utilisateur a-t-il droit à la config "Etablissement" ?
 - prm_uti_root : l''utilisateur a-t-il droit à la config "Réseau" ?
Retour :
 - L''identifiant de l''utilisateur créé
Remarques :
Un mot de passe temporaire est généré. Il peut être connu avec la fonction utilisateur_get.
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE utilisateur (
    uti_id integer NOT NULL,
    uti_login character varying,
    uti_salt character varying,
    uti_root boolean,
    uti_config boolean,
    per_id integer,
    uti_pwd character varying,
    uti_digest character varying
);


--
-- Name: TABLE utilisateur; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE utilisateur IS 'Utilisateurs de l''application';


--
-- Name: COLUMN utilisateur.uti_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_id IS 'Identifiant de l''utilisateur';


--
-- Name: COLUMN utilisateur.uti_login; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_login IS 'Login de connexion';


--
-- Name: COLUMN utilisateur.uti_salt; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_salt IS 'Mot de passe crypté';


--
-- Name: COLUMN utilisateur.uti_root; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_root IS 'Droit de configuration "Réseau"';


--
-- Name: COLUMN utilisateur.uti_config; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_config IS 'Droit de configuration "Etablissement"';


--
-- Name: COLUMN utilisateur.per_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.per_id IS 'Identifiant du personnel associé à l''utilisateur';


--
-- Name: COLUMN utilisateur.uti_pwd; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_pwd IS 'Mot de passe temporaire en clair';


--
-- Name: COLUMN utilisateur.uti_digest; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur.uti_digest IS 'Mot de passe crypté pour connexion par webdav';


--
-- Name: utilisateur_get(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_get(prm_token integer, prm_uti_id integer) RETURNS utilisateur
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret login.utilisateur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT utilisateur.* INTO ret FROM login.utilisateur WHERE uti_id = prm_uti_id;
	ret.uti_salt = NULL;
	ret.uti_digest = NULL;
	BEGIN
	    PERFORM login._token_assert (prm_token, TRUE, FALSE);
	    RETURN ret;
        EXCEPTION WHEN insufficient_privilege THEN
	    ret.uti_login = NULL;
	    ret.uti_root = NULL;
	    ret.uti_config = NULL;
	    ret.uti_pwd = NULL;
	    RETURN ret;	   
        END;
END;
$$;


--
-- Name: FUNCTION utilisateur_get(prm_token integer, prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_get(prm_token integer, prm_uti_id integer) IS 'Retourne les informations d''un utilisateur.
 - uti_id     : Id de l''utilisateur
 - uti_login  : login de l''utilisateur, NULL si pas droit de config Établissement
 - uti_salt   : toujours NULL
 - uti_root   : Vrai si l''utilisateur a droit de config "Réseau", NULL si pas droit de config Établissement
 - uti_config : Vrai si l''utilisateur a droit de config "Établissement", NULL si pas droit de config Établissement
 - per_id     : Id du personnel relié à l''utilisateur
 - uti_pwd    : Mot de passe (si temporaire), NULL si pas droit de config Établissement
 - uti_digest : toujours NULL';


--
-- Name: utilisateur_get_digest_hash(character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_get_digest_hash(prm_uti_login character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	SELECT utilisateur.uti_digest INTO ret FROM login.utilisateur WHERE uti_login = prm_uti_login;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION utilisateur_get_digest_hash(prm_uti_login character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_get_digest_hash(prm_uti_login character varying) IS 'TODO: utilisé par webdav';


--
-- Name: utilisateur_get_par_login(character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_get_par_login(prm_uti_login character varying) RETURNS utilisateur
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret login.utilisateur;
BEGIN
	SELECT utilisateur.* INTO ret FROM login.utilisateur WHERE uti_login = prm_uti_login;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION utilisateur_get_par_login(prm_uti_login character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_get_par_login(prm_uti_login character varying) IS 'TODO : utilisé par imports temporaires';


SET search_path = public, pg_catalog;

--
-- Name: groupe; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groupe (
    grp_id integer NOT NULL,
    grp_nom character varying,
    grp_complet boolean DEFAULT false NOT NULL,
    eta_id integer,
    grp_debut date,
    grp_fin date,
    grp_hebergement_adresse character varying,
    grp_hebergement_cp character varying,
    grp_hebergement_ville character varying,
    grp_pedagogie_type integer,
    grp_pedagogie_niveau integer,
    grp_pedagogie_contact integer,
    grp_notes character varying,
    grp_sante_contact integer,
    grp_emploi_contact integer,
    grp_culture_contact integer,
    grp_education_contact integer,
    grp_hebergement_contact integer,
    grp_justice_contact integer,
    grp_social_contact integer,
    grp_sport_contact integer,
    grp_transport_contact integer,
    grp_decideur_contact integer,
    grp_financeur_contact integer,
    grp_prise_en_charge_contact integer,
    grp_divertissement_contact integer,
    grp_protection_juridique_contact integer,
    grp_restauration_contact integer,
    grp_entretien_contact integer,
    grp_aide_a_la_personne_contact integer,
    grp_social_type integer,
    grp_education_type integer,
    grp_sante_type integer,
    grp_justice_type integer,
    grp_emploi_type integer,
    grp_sport_type integer,
    grp_culture_type integer,
    grp_transport_type integer,
    grp_decideur_type integer,
    grp_hebergement_type integer,
    grp_financeur_type integer,
    grp_prise_en_charge_type integer,
    grp_divertissement_type integer,
    grp_protection_juridique_type integer,
    grp_restauration_type integer,
    grp_entretien_type integer,
    grp_aide_a_la_personne_type integer,
    grp_aide_financiere_directe_contact integer,
    grp_aide_financiere_directe_type integer,
    grp_equipement_personnel_contact integer,
    grp_equipement_personnel_type integer,
    grp_famille_contact integer,
    grp_famille_type integer,
    grp_projet_contact integer,
    grp_projet_type integer,
    grp_sejour_contact integer,
    grp_sejour_type integer
);


--
-- Name: TABLE groupe; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE groupe IS 'Groupe d''usagers';


--
-- Name: COLUMN groupe.grp_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_id IS 'Identifiant du groupe';


--
-- Name: COLUMN groupe.grp_nom; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_nom IS 'Nom du groupe';


--
-- Name: COLUMN groupe.grp_complet; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_complet IS 'Indique s''il est possible d''affecter des usagers à ce groupe (non utilisé)';


--
-- Name: COLUMN groupe.eta_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.eta_id IS 'Identifiant de l''établissement/partenaire auquel appartient ce groupe';


--
-- Name: COLUMN groupe.grp_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_debut IS 'Date de début d''activité du groupe';


--
-- Name: COLUMN groupe.grp_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_fin IS 'Date de fin d''activité du groupe';


--
-- Name: COLUMN groupe.grp_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe.grp_notes IS 'Notes sur le groupe';


SET search_path = login, pg_catalog;

--
-- Name: utilisateur_groupe_liste(integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_groupe_liste(prm_token integer) RETURNS SETOF public.groupe
    LANGUAGE plpgsql
    AS $$
DECLARE
	row public.groupe;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT groupe.* FROM groupe
			INNER JOIN login.grouputil_groupe USING(grp_id)
			INNER JOIN login.utilisateur_grouputil USING (gut_id)
			INNER JOIN login.token USING(uti_id)
			WHERE tok_token = prm_token
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_groupe_liste(prm_token integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_groupe_liste(prm_token integer) IS 'Retourne la liste des groupes d''usagers accessibles par l''utilisateur authentifié.

Entrées :
 - prm_token : Token d''authentification';


--
-- Name: utilisateur_grouputil_liste(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_grouputil_liste(prm_token integer, prm_uti_id integer) RETURNS SETOF grouputil
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.grouputil;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT grouputil.* FROM login.grouputil
			INNER JOIN login.utilisateur_grouputil USING(gut_id)
			WHERE uti_id = prm_uti_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_grouputil_liste(prm_token integer, prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_grouputil_liste(prm_token integer, prm_uti_id integer) IS 'Liste des groupes d''utilisateurs auxquels est affecté un utilisateur.

Entrée : 
 - prm_token : Token d''authentification
 - prm_uti_id : Id de l''utilisateur concerné
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur_grouputil_set(integer, integer, integer[]); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_grouputil_set(prm_token integer, prm_uti_id integer, prm_grouputils integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.utilisateur_grouputil WHERE uti_id = prm_uti_id;
	IF prm_grouputils NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_grouputils, 1) LOOP
			INSERT INTO login.utilisateur_grouputil(uti_id, gut_id) VALUES (prm_uti_id, prm_grouputils[i]);
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION utilisateur_grouputil_set(prm_token integer, prm_uti_id integer, prm_grouputils integer[]); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_grouputil_set(prm_token integer, prm_uti_id integer, prm_grouputils integer[]) IS 'Modifie les groupes d''utilisateurs auxquels est affecté un utilisateur.

Entrée :
 - prm_token : Token d''authentification
 - prm_uti_id : Id de l''Utilisateur à modifier
 - prm_grouputils : Tableau d''identifiants de groupes d''utilisateurs
Remarques :
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur_liste_details_configuration(integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_liste_details_configuration(prm_token integer) RETURNS SETOF utilisateur_liste_details_configuration
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.utilisateur_liste_details_configuration;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT uti_id, uti_login, personne_info_varchar_get (prm_token, per_id, 'prenom'), personne_info_varchar_get (prm_token, per_id, 'nom') FROM login.utilisateur
		WHERE per_id NOTNULL
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_liste_details_configuration(prm_token integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_liste_details_configuration(prm_token integer) IS 'Liste le détail des utilisateurs.

Entrée :
 - prm_token : Token d''authentification
Remarques :
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur_login2(character varying, character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_login2(prm_login character varying, prm_mdp character varying) RETURNS SETOF utilisateur_login2
    LANGUAGE plpgsql
    AS $$
DECLARE
	row login.utilisateur_login2;
	uti integer;
	tok integer;
BEGIN
	SELECT uti_id INTO uti FROM login.utilisateur
	    WHERE uti_login = prm_login AND crypt (prm_mdp, SUBSTRING(uti_salt FROM 1 FOR 2)) = uti_salt;
	IF NOT FOUND THEN 
	    RETURN; 
	END IF;
	SELECT * INTO tok FROM login._token_create (uti);
	IF prm_login = 'kavarna' THEN
	   SELECT DISTINCT uti_id, tok, uti_root, uti_config, NULL, NULL, (uti_pwd NOTNULL) INTO row FROM login.utilisateur
		WHERE uti_id = uti;
	    RETURN NEXT row;
	    RETURN;
	END IF;
	FOR row IN
		select DISTINCT uti_id, tok, uti_root, uti_config, groupe.eta_id, por_id, (uti_pwd NOTNULL) FROM login.utilisateur
		INNER JOIN login.utilisateur_grouputil USING(uti_id)
		INNER JOIN login.grouputil USING (gut_id)
		INNER JOIN login.grouputil_portail USING(gut_id)
		INNER JOIN login.grouputil_groupe USING (gut_id)
	        INNER JOIN meta.portail USING(por_id) 
		INNER JOIN groupe USING(grp_id)
		INNER JOIN etablissement USING(eta_id)
		WHERE 
		      uti_id = uti 
		      AND portail.cat_id = etablissement.cat_id  
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_login2(prm_login character varying, prm_mdp character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_login2(prm_login character varying, prm_mdp character varying) IS 'Authentifie un utilisateur à partir d''un login et mot de passe.
Retourne un ensemble de :
 - uti_id : l''identifiant de l''utilisateur 
 - tok_token : token d''authentification à utiliser dans tout appel de fonction sécurisée
 - uti_root : l''utilisateur a accès à la configuration du réseau
 - uti_config : l''utilisateur a accès à la configuration de l''établissement
 - eta_id / por_id : paire établissement/portail auxquels l''utilisateur a droit
 - uti_pwd_provisoire (booléen) : indique si le mot de passe est provisoire (stocké en clair en base et visible dans la configuration de l''utilisateur)

Les données autres que eta_id et por_id sont répétées à l''identique sur toutes les lignes de la réponse. 
';


--
-- Name: utilisateur_login_digest(character varying, character varying, character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_login_digest(prm_login character varying, prm_hash character varying, prm_response character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	digest varchar;
	myresponse varchar;
	tok integer;
BEGIN
	SELECT uti_digest INTO digest FROM login.utilisateur WHERE uti_login = prm_login;
	IF NOT FOUND THEN 
 	    RETURN NULL; 
	END IF;
	SELECT md5 (digest || ':' || prm_hash) INTO myresponse;
	IF myresponse = prm_response THEN	
	    SELECT * INTO tok FROM login._token_create ((SELECT uti_id  FROM login.utilisateur WHERE uti_login = prm_login));
	    RETURN tok;
	ELSE
	    RETURN NULL;
        END IF;
END;
$$;


--
-- Name: utilisateur_mdp_change(integer, character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_mdp_change(prm_token integer, prm_mdp character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE login.utilisateur SET uti_salt = crypt (prm_mdp, gen_salt('des')), uti_pwd = NULL 
	       WHERE uti_id = (SELECT uti_id FROM login.token WHERE tok_token = prm_token);
	UPDATE login.utilisateur SET uti_digest = md5 (uti_login || ':Accueil:' || prm_mdp) 
	       WHERE uti_id = (SELECT uti_id FROM login.token WHERE tok_token = prm_token);
END;
$$;


--
-- Name: FUNCTION utilisateur_mdp_change(prm_token integer, prm_mdp character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_mdp_change(prm_token integer, prm_mdp character varying) IS 'Modifie le mot de passe de l''utilisateur identifié.

Entrée :
 - prm_token : Token d''authentification
 - prm_mdp   : Nouveau mot de passe
Remarques :
Seul l''utilisateur connecté peut modifier son mot de passe.
Il est possible pour un utilisateur ayant les droits de configuration "Etablissement" de générer un mot de passe temporaire avec utilisateur_mdp_genere pour tout autre utilisateur, mais seul l''utilisateur lui-même peut saisir un nouveau mot de passe.';


--
-- Name: utilisateur_mdp_genere(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_mdp_genere(prm_token integer, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	mdp varchar;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	mdp = LPAD((random()*1000000)::int::varchar, 6, '0');
	UPDATE login.utilisateur SET uti_salt = crypt (mdp, gen_salt('des')), uti_pwd = mdp 
	       WHERE uti_id = prm_uti_id;
	UPDATE login.utilisateur SET uti_digest = md5 (uti_login || ':Accueil:' || uti_pwd) 
	       WHERE uti_id = prm_uti_id;
END;
$$;


--
-- Name: FUNCTION utilisateur_mdp_genere(prm_token integer, prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_mdp_genere(prm_token integer, prm_uti_id integer) IS 'Génére un nouveau mot de passe aléatoire pour un utilisateur.

Entrée : 
 - prm_token  : Token d''authentification
 - prm_uti_id : Id de l''utilisateur pour qui générer un nouveau mot de passe
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur_portail_liste(character varying); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_portail_liste(prm_login character varying) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	FOR row IN
		select DISTINCT por_id FROM login.utilisateur
		INNER JOIN login.utilisateur_grouputil USING(uti_id)
		INNER JOIN login.grouputil USING (gut_id)
		INNER JOIN login.grouputil_portail USING(gut_id)
		INNER JOIN login.grouputil_groupe USING (gut_id)
		INNER JOIN groupe USING(grp_id)
		WHERE uti_login = prm_login
	LOOP
		RETURN NEXT row.por_id;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_portail_liste(prm_login character varying); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_portail_liste(prm_login character varying) IS 'TODO : Utilisé par webdav';


--
-- Name: utilisateur_prenon_nom(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_prenon_nom(prm_token integer, prm_uti_id integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT personne_get_libelle (prm_token, per_id) INTO ret FROM personne INNER JOIN login.utilisateur USING(per_id) WHERE uti_id = prm_uti_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION utilisateur_prenon_nom(prm_token integer, prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_prenon_nom(prm_token integer, prm_uti_id integer) IS 'Retourne le nom et prénom d''un utilisateur';


--
-- Name: utilisateur_supprime(integer, integer); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_supprime(prm_token integer, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.utilisateur_grouputil WHERE uti_id = prm_uti_id;
	DELETE FROM login.utilisateur WHERE uti_id = prm_uti_id;
END;
$$;


--
-- Name: FUNCTION utilisateur_supprime(prm_token integer, prm_uti_id integer); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_supprime(prm_token integer, prm_uti_id integer) IS 'Supprime un utilisateur.

Entrée : 
 - prm_token  : Token d''authentification
 - prm_uti_id : Id de l''utilisateur à supprimer
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';


--
-- Name: utilisateur_update(integer, integer, character varying, integer, boolean, boolean); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_update(prm_token integer, prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE login.utilisateur SET uti_login = prm_login, per_id = prm_per_id, uti_config = prm_uti_config, uti_root = prm_uti_root WHERE uti_id = prm_uti_id;
END;
$$;


--
-- Name: FUNCTION utilisateur_update(prm_token integer, prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_update(prm_token integer, prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) IS 'Met à jour les informations d''un utilisateur.

Entrée : 
 - prm_token      : Token d''authentification
 - prm_uti_id     : Id de l''utilisateur à mettre à jour
 - prm_login      : Nouveau login
 - prm_per_id     : Nouveau lien vers personnel
 - prm_uti_config : Nouveau droit de configuration "Établissement"
 - prm_uti_root   : Nouveau droit de configuration "Réseau"
';


--
-- Name: utilisateur_usagers_liste(integer, integer, boolean); Type: FUNCTION; Schema: login; Owner: -
--

CREATE FUNCTION utilisateur_usagers_liste(prm_token integer, prm_grp_id integer, prm_presents boolean) RETURNS SETOF utilisateur_usagers_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row login.utilisateur_usagers_liste;
BEGIN
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN
		SELECT DISTINCT personne.per_id, personne_get_libelle (prm_token, personne.per_id)
			FROM personne
			inner join personne_groupe using(per_id)
			inner join groupe_secteur using(grp_id)
			inner join meta.secteur using(sec_id)
			inner join login.grouputil_groupe USING(grp_id)
			inner join login.utilisateur_grouputil using(gut_id)
			where uti_id = uti
			-- and sec_code = 'prise_en_charge' 
			and ent_code = 'usager'
			AND (prm_grp_id ISNULL OR grp_id = prm_grp_id)
			and (prm_presents ISNULL OR NOT prm_presents OR personne_info_integer_get (prm_token, per_id, 'statut_usager') = 4)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION utilisateur_usagers_liste(prm_token integer, prm_grp_id integer, prm_presents boolean); Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON FUNCTION utilisateur_usagers_liste(prm_token integer, prm_grp_id integer, prm_presents boolean) IS 'Retourne la liste des usagers en relation avec l''utilisateur authentifié par le token.

Entrée :
 - prm_token : token d''authentification
 - prm_grp_id : Identifiant du groupe auquel doivent appartenir les usagers, ou NULL pour rechercher parmi tous les groupes
 - prm_presents : TRUS pour retourner les usagers présents uniquement, FALSE sinon
';


SET search_path = meta, pg_catalog;

--
-- Name: _tmp_numerote_sousmenus(); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION _tmp_numerote_sousmenus() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	-- Enlève la numérotation existante
	UPDATE meta.sousmenu SET sme_libelle = substring(sme_libelle from '[0-9]+.[0-9]+ - #"%#"' for '#')
	       WHERE sme_libelle SIMILAR TO '[0-9]+.[0-9]+ - %';
	       -- Réordonne les menus
	       FOR row IN 
	       	   SELECT * FROM meta.portail 
		   LOOP
			PERFORM meta.meta_menus_reordonne (row.por_id, 1);
			END LOOP;
			-- Réordonne les sous-menus
			FOR row IN
			    SELECT * FROM meta.menu 
			    LOOP
				PERFORM meta.meta_sousmenus_reordonne(row.men_id);
				END LOOP;
				-- Ajoute la numérotation
 				UPDATE meta.sousmenu 
				       SET sme_libelle=(SELECT men_ordre FROM meta.menu WHERE men_id = sousmenu.men_id) || '.' || (sme_ordre) || ' - ' || sme_libelle
				       	   WHERE men_id in (select men_id from meta.menu where ent_id = 1);
END;
$$;


--
-- Name: _tmp_numerote_topsousmenus(); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION _tmp_numerote_topsousmenus() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	-- Enlève la numérotation existante
	UPDATE meta.topsousmenu SET tsm_libelle = substring(tsm_libelle from '[0-9]+.[0-9]+ - #"%#"' for '#')
	       WHERE tsm_libelle SIMILAR TO '[0-9]+.[0-9]+ - %';
	       -- Réordonne les menus
	       FOR row IN 
	       	   SELECT * FROM meta.portail 
		   LOOP
			PERFORM meta.meta_topmenus_reordonne (row.por_id);
			END LOOP;
			-- Réordonne les sous-menus
			FOR row IN
			    SELECT * FROM meta.topmenu 
			    LOOP
				PERFORM meta.meta_topsousmenus_reordonne(row.tom_id);
				END LOOP;
				-- Ajoute la numérotation
 				UPDATE meta.topsousmenu 
				       SET tsm_libelle=(SELECT tom_ordre FROM meta.topmenu WHERE tom_id = topsousmenu.tom_id) || '.' || (tsm_ordre) || ' - ' || tsm_libelle;
END;
$$;


--
-- Name: adminsousmenu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE adminsousmenu (
    asm_id integer NOT NULL,
    asm_libelle character varying,
    asm_ordre integer,
    asm_icone character varying,
    asm_script character varying
);


--
-- Name: TABLE adminsousmenu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE adminsousmenu IS 'Sous-menu de la configuration "Établissement"';


--
-- Name: meta_adminsousmenu_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_adminsousmenu_liste(prm_token integer) RETURNS SETOF adminsousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.adminsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.adminsousmenu ORDER BY asm_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_adminsousmenu_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_adminsousmenu_liste(prm_token integer) IS 'Retourne la liste des sous-menus du menu de configuration "Établissement".';


--
-- Name: meta_categorie_add(integer, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_categorie_add(prm_token integer, prm_nom character varying, prm_code character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	code varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.categorie (cat_nom, cat_code) 
	       VALUES (prm_nom, COALESCE (prm_code, pour_code(prm_nom))) 
	       RETURNING cat_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_categorie_add(prm_token integer, prm_nom character varying, prm_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_categorie_add(prm_token integer, prm_nom character varying, prm_code character varying) IS 'Ajoute une nouvelle catégorie d''établissement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_nom : Nom de la catégorie
 - prm_code : Code de la catégorie, ou NULL pour une affectation automatique selon le nom';


--
-- Name: meta_categorie_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_categorie_delete(prm_token integer, prm_cat_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
--	DELETE FROM meta.info_groupe WHERE gin_id IN (SELECT gin_id FROM meta.groupe_infos WHERE sme_id IN (SELECT sme_id FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id))));
--	DELETE FROM meta.groupe_infos WHERE sme_id IN (SELECT sme_id FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id)));
--	DELETE FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id));
--	DELETE FROM meta.menu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id);

--	DELETE FROM meta.topsousmenu WHERE tom_id IN (SELECT tom_id FROM meta.topmenu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id));
--	DELETE FROM meta.topmenu WHERE por_id IN (SELECT por_id FROM meta.portail WHERE cat_id = prm_cat_id);
	
--	DELETE FROM meta.portail WHERE cat_id = prm_cat_id;

	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.categorie WHERE cat_id = prm_cat_id;
END;
$$;


--
-- Name: FUNCTION meta_categorie_delete(prm_token integer, prm_cat_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_categorie_delete(prm_token integer, prm_cat_id integer) IS 'Supprime une catégorie de manière non récursive (les portails de la catégorie doivent être supprimés auparavant).';


--
-- Name: categorie; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE categorie (
    cat_id integer NOT NULL,
    cat_nom character varying,
    cat_code character varying
);


--
-- Name: TABLE categorie; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE categorie IS 'Catégorie d''établissement';


--
-- Name: meta_categorie_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_categorie_liste(prm_token integer) RETURNS SETOF categorie
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.categorie;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.categorie ORDER BY cat_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_categorie_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_categorie_liste(prm_token integer) IS 'Retourne la liste des catégories.';


--
-- Name: meta_categorie_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_categorie_rename(prm_token integer, prm_cat_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.categorie SET cat_nom = prm_nom WHERE cat_id = prm_cat_id;
END;
$$;


--
-- Name: FUNCTION meta_categorie_rename(prm_token integer, prm_cat_id integer, prm_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_categorie_rename(prm_token integer, prm_cat_id integer, prm_nom character varying) IS 'Renomme une catégorie.';


--
-- Name: meta_dirinfo_add_avec_id(integer, integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_dirinfo_add_avec_id(prm_token integer, prm_id integer, prm_din_id_parent integer, prm_libelle character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.dirinfo (din_id, din_id_parent, din_libelle) VALUES (prm_id, prm_din_id_parent, prm_libelle)
		RETURNING din_id INTO ret;
	PERFORM setval ('meta.dirinfo_din_id_seq', coalesce((select max(din_id)+1 from meta.dirinfo), 1), false);
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_dirinfo_add_avec_id(prm_token integer, prm_id integer, prm_din_id_parent integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_dirinfo_add_avec_id(prm_token integer, prm_id integer, prm_din_id_parent integer, prm_libelle character varying) IS 'Ajoute un nouveau répertoire de champs (utilisé avec la banque de champs).';


--
-- Name: meta_dirinfo_dernier(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_dirinfo_dernier(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(din_id) INTO ret FROM meta.dirinfo;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_dirinfo_dernier(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_dirinfo_dernier(prm_token integer) IS 'Retourne l''identifiant du dernier répertoire de champ présent (utilisé avec la banque de champs).';


--
-- Name: dirinfo; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE dirinfo (
    din_id integer NOT NULL,
    din_id_parent integer,
    din_libelle character varying
);


--
-- Name: TABLE dirinfo; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE dirinfo IS 'Banque de champs : répertoire contenant les champs';


--
-- Name: meta_dirinfo_list(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_dirinfo_list(prm_token integer, prm_din_id_parent integer) RETURNS SETOF dirinfo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.dirinfo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM meta.dirinfo WHERE (prm_din_id_parent ISNULL AND din_id_parent ISNULL) OR (din_id_parent = prm_din_id_parent)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_dirinfo_list(prm_token integer, prm_din_id_parent integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_dirinfo_list(prm_token integer, prm_din_id_parent integer) IS 'Retourne la liste des répertoires de champs inclus dans un répertoire donné.';


--
-- Name: entite; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE entite (
    ent_id integer NOT NULL,
    ent_code character varying,
    ent_libelle character varying
);


--
-- Name: TABLE entite; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE entite IS 'Type de personne';


--
-- Name: meta_entite_infos_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_entite_infos_par_code(prm_token integer, prm_code character varying) RETURNS entite
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.entite%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.entite WHERE ent_code = prm_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_entite_infos_par_code(prm_token integer, prm_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_entite_infos_par_code(prm_token integer, prm_code character varying) IS 'Retourne les informations sur un type de personne.';


--
-- Name: meta_entite_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_entite_liste(prm_token integer) RETURNS SETOF entite
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.entite ORDER BY ent_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_entite_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_entite_liste(prm_token integer) IS 'Retourne la liste des types de personnes.';


--
-- Name: meta_groupe_infos_add_end(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_groupe_infos_add_end(prm_token integer, prm_sme_id integer, prm_libelle character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	int_ordre integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(gin_ordre) + 1 INTO int_ordre FROM meta.groupe_infos WHERE sme_id = prm_sme_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.groupe_infos(sme_id, gin_libelle, gin_ordre) VALUES (prm_sme_id, prm_libelle, int_ordre) RETURNING gin_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_groupe_infos_add_end(prm_token integer, prm_sme_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_groupe_infos_add_end(prm_token integer, prm_sme_id integer, prm_libelle character varying) IS 'Ajoute un groupe de champs à la fin d''une page de champs.';


--
-- Name: meta_groupe_infos_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_groupe_infos_delete(prm_token integer, prm_gin_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.info_groupe WHERE gin_id = prm_gin_id;
	DELETE FROM meta.groupe_infos WHERE gin_id = prm_gin_id;
END;
$$;


--
-- Name: FUNCTION meta_groupe_infos_delete(prm_token integer, prm_gin_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_groupe_infos_delete(prm_token integer, prm_gin_id integer) IS 'Supprime un groupe de champs.';


--
-- Name: groupe_infos; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE groupe_infos (
    gin_id integer NOT NULL,
    sme_id integer,
    gin_libelle character varying,
    gin_ordre integer
);


--
-- Name: TABLE groupe_infos; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE groupe_infos IS 'Groupe de champs dans un sous-menu (édition de personnes)';


--
-- Name: meta_groupe_infos_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_groupe_infos_liste(prm_token integer, prm_sme_id integer) RETURNS SETOF groupe_infos
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.groupe_infos%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.groupe_infos WHERE sme_id = prm_sme_id ORDER BY gin_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_groupe_infos_liste(prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_groupe_infos_liste(prm_token integer, prm_sme_id integer) IS 'Retourne la liste des groupes de champs d''une page de champs.';


--
-- Name: meta_groupe_infos_update(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_groupe_infos_update(prm_token integer, prm_gin_id integer, prm_ordre integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.groupe_infos SET 
		gin_ordre = prm_ordre
		WHERE gin_id = prm_gin_id;
END;
$$;


--
-- Name: FUNCTION meta_groupe_infos_update(prm_token integer, prm_gin_id integer, prm_ordre integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_groupe_infos_update(prm_token integer, prm_gin_id integer, prm_ordre integer) IS 'Modifie l''ordre d''apparition d''un groupe de champs.';


--
-- Name: meta_info_add_avec_id(integer, integer, integer, character varying, character varying, integer, integer, boolean, boolean, boolean, character varying, character varying, character varying, character varying, boolean, integer, integer, character varying, boolean, character varying, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_add_avec_id(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm__textelong_nblignes integer, prm__selection_code integer, prm_etendu boolean, prm_historique boolean, prm_multiple boolean, prm__groupe_type character varying, prm__contact_filtre character varying, prm__metier_secteur character varying, prm__contact_secteur character varying, prm__etablissement_interne boolean, prm_din_id integer, prm__groupe_soustype integer, prm_libelle_complet character varying, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying, prm__etablissement_secteur character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.info(inf_id, int_id, inf_code, inf_libelle, inf__textelong_nblignes, inf__selection_code, inf_etendu, inf_historique, inf_multiple, inf__groupe_type, inf__contact_filtre, inf__metier_secteur, inf__contact_secteur, inf__etablissement_interne, din_id, inf__groupe_soustype, inf_libelle_complet, inf__date_echeance, inf__date_echeance_icone, inf__date_echeance_secteur, inf__etablissement_secteur) VALUES (prm_inf_id, prm_int_id, prm_code, prm_libelle, prm__textelong_nblignes, prm__selection_code, prm_etendu, prm_historique, prm_multiple, prm__groupe_type, prm__contact_filtre, prm__metier_secteur, prm__contact_secteur, prm__etablissement_interne, prm_din_id,   prm__groupe_soustype, prm_libelle_complet, prm__date_echeance, prm__date_echeance_icone, prm__date_echeance_secteur, prm__etablissement_secteur) RETURNING inf_id INTO ret;
	PERFORM setval ('meta.info_inf_id_seq', coalesce((select max(inf_id)+1 from meta.info), 1), false);
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_add_avec_id(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm__textelong_nblignes integer, prm__selection_code integer, prm_etendu boolean, prm_historique boolean, prm_multiple boolean, prm__groupe_type character varying, prm__contact_filtre character varying, prm__metier_secteur character varying, prm__contact_secteur character varying, prm__etablissement_interne boolean, prm_din_id integer, prm__groupe_soustype integer, prm_libelle_complet character varying, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying, prm__etablissement_secteur character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_add_avec_id(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm__textelong_nblignes integer, prm__selection_code integer, prm_etendu boolean, prm_historique boolean, prm_multiple boolean, prm__groupe_type character varying, prm__contact_filtre character varying, prm__metier_secteur character varying, prm__contact_secteur character varying, prm__etablissement_interne boolean, prm_din_id integer, prm__groupe_soustype integer, prm_libelle_complet character varying, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying, prm__etablissement_secteur character varying) IS 'Ajoute un champ dans la bibliothèque de champs disponibles.';


--
-- Name: meta_info_aide_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_aide_get(prm_token integer, prm_inf_id integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT ina_aide INTO ret FROM meta.info_aide WHERE inf_id = prm_inf_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_aide_get(prm_token integer, prm_inf_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_aide_get(prm_token integer, prm_inf_id integer) IS 'Retourne le message d''aide d''un champ.';


--
-- Name: meta_info_aide_set(integer, integer, text); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_aide_set(prm_token integer, prm_inf_id integer, prm_aide text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	IF prm_aide ISNULL THEN
		DELETE FROM meta.info_aide WHERE inf_id = prm_inf_id;
	ELSE
		UPDATE meta.info_aide SET ina_aide = prm_aide WHERE inf_id = prm_inf_id;
		IF NOT FOUND THEN
			INSERT INTO meta.info_aide (inf_id, ina_aide) VALUES (prm_inf_id, prm_aide);
		END IF;
	END IF;
END;
$$;


--
-- Name: FUNCTION meta_info_aide_set(prm_token integer, prm_inf_id integer, prm_aide text); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_aide_set(prm_token integer, prm_inf_id integer, prm_aide text) IS 'Modifie le message d''aide d''un champ.';


--
-- Name: meta_info_dernier(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_dernier(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(inf_id) INTO ret FROM meta.info;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_dernier(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_dernier(prm_token integer) IS 'Retourne l''identifiant du dernier champ dans la bibliothèque de champs locale.';


--
-- Name: meta_info_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_get(prm_token integer, prm_inf_id integer) RETURNS info
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.info;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.info WHERE inf_id = prm_inf_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_get(prm_token integer, prm_inf_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_get(prm_token integer, prm_inf_id integer) IS 'Retourne les informations sur un champ.';


--
-- Name: meta_info_get_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_get_par_code(prm_token integer, prm_inf_code character varying) RETURNS info
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.info;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.info WHERE inf_code = prm_inf_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_get_par_code(prm_token integer, prm_inf_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_get_par_code(prm_token integer, prm_inf_code character varying) IS 'Retourne les informations sur un champ, à partir de son code.';


--
-- Name: meta_info_get_type_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_get_type_par_code(prm_token integer, prm_code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT int_code INTO ret FROM meta.info
		INNER JOIN meta.infos_type USING(int_id)
		WHERE inf_code = prm_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_get_type_par_code(prm_token integer, prm_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_get_type_par_code(prm_token integer, prm_code character varying) IS 'Retourne le type d''un champ.';


--
-- Name: meta_info_groupe_add_by_id(integer, integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_add_by_id(prm_token integer, prm_inf_id integer, prm_gin_id integer, prm_gin_ordre integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.info_groupe (inf_id, gin_id, ing_ordre) VALUES 
		(prm_inf_id, prm_gin_id, prm_gin_ordre)
		RETURNING ing_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_add_by_id(prm_token integer, prm_inf_id integer, prm_gin_id integer, prm_gin_ordre integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_add_by_id(prm_token integer, prm_inf_id integer, prm_gin_id integer, prm_gin_ordre integer) IS 'Ajoute un champ à une page (en le rajoutant à un groupe de champs).';


--
-- Name: meta_info_groupe_add_end(integer, character varying, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_add_end(prm_token integer, prm_inf_code character varying, prm_gin_id integer, prm__groupe_cycle boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	int_ordre integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(ing_ordre) + 1 INTO int_ordre FROM meta.info_groupe WHERE gin_id = prm_gin_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.info_groupe (inf_id, gin_id, ing_ordre, ing__groupe_cycle) VALUES 
		((SELECT inf_id FROM meta.info WHERE inf_code = prm_inf_code), prm_gin_id, int_ordre, prm__groupe_cycle)
		RETURNING ing_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_add_end(prm_token integer, prm_inf_code character varying, prm_gin_id integer, prm__groupe_cycle boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_add_end(prm_token integer, prm_inf_code character varying, prm_gin_id integer, prm__groupe_cycle boolean) IS 'Ajoute un champ à un groupe de champs, en le plaçant à la fin.';


--
-- Name: meta_info_groupe_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_delete(prm_token integer, prm_ing_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.info_groupe where ing_id = prm_ing_id;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_delete(prm_token integer, prm_ing_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_delete(prm_token integer, prm_ing_id integer) IS 'Retire un champ d''un groupe de champs.';


--
-- Name: info_groupe; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE info_groupe (
    ing_id integer NOT NULL,
    inf_id integer,
    gin_id integer,
    ing_ordre integer,
    ing__groupe_cycle boolean,
    ing_obligatoire boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE info_groupe; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE info_groupe IS 'Assignation d''un champ dans un groupe de champs';


--
-- Name: meta_info_groupe_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_get(prm_token integer, prm_ing_id integer) RETURNS info_groupe
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.info_groupe;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO row FROM meta.info_groupe WHERE ing_id = prm_ing_id;
	RETURN row;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_get(prm_token integer, prm_ing_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_get(prm_token integer, prm_ing_id integer) IS 'Retourne les caractéristiques de l''affectation d''un champ à un groupe.';


--
-- Name: meta_info_groupe_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_liste(prm_token integer, prm_gin_id integer) RETURNS SETOF meta_info_groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.meta_info_groupe_liste%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT info_groupe.ing_id, info_groupe.ing_ordre, info_groupe.ing__groupe_cycle, info.* FROM meta.info
		INNER JOIN meta.info_groupe USING(inf_id) WHERE gin_id = prm_gin_id ORDER BY ing_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_liste(prm_token integer, prm_gin_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_liste(prm_token integer, prm_gin_id integer) IS 'Retourne les informations sur les champs affectés à un groupe de champs (dont les caractéristiques d''affectation).';


--
-- Name: meta_info_groupe_obligatoire_liste(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_obligatoire_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying) RETURNS SETOF meta_info_groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.meta_info_groupe_liste%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT info_groupe.ing_id, info_groupe.ing_ordre, info_groupe.ing__groupe_cycle, info.* 
    	    FROM meta.info
	    INNER JOIN meta.info_groupe USING(inf_id) 
	    INNER JOIN meta.groupe_infos USING(gin_id)
	    INNER JOIN meta.sousmenu USING(sme_id)
	    INNER JOIN meta.menu USING(men_id)
	    INNER JOIN meta.entite USING(ent_id)
	    WHERE por_id = prm_por_id AND ent_code = prm_ent_code AND ing_obligatoire ORDER BY men_ordre, sme_ordre, gin_ordre, ing_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_obligatoire_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_obligatoire_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying) IS 'Retourne les informations sur les champs obligatoires à la création d''une personne d''un type donné sur un portail donné.';


--
-- Name: meta_info_groupe_update(integer, integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_groupe_update(prm_token integer, prm_ing_id integer, prm_gin_id integer, prm_ordre integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info_groupe SET gin_id = prm_gin_id, ing_ordre = prm_ordre WHERE ing_id = prm_ing_id;
END;
$$;


--
-- Name: FUNCTION meta_info_groupe_update(prm_token integer, prm_ing_id integer, prm_gin_id integer, prm_ordre integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_groupe_update(prm_token integer, prm_ing_id integer, prm_gin_id integer, prm_ordre integer) IS 'Modifie les informations d''affectation d''un champ à un groupe.';


--
-- Name: meta_info_liste(integer, character varying, boolean, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_liste(prm_token integer, str character varying, usedonly boolean, prm_int_code character varying) RETURNS SETOF info
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.info;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	IF usedonly THEN
		FOR row IN
			SELECT DISTINCT info.* FROM meta.info 
			   INNER JOIN meta.info_groupe USING(inf_id) 
			   INNER JOIN meta.infos_type USING(int_id)
			   WHERE (str ISNULL OR inf_code ilike '%'||str||'%' OR inf_libelle ilike '%'||str||'%')
			   AND (prm_int_code ISNULL OR prm_int_code = infos_type.int_code)
			   ORDER BY inf_libelle
		LOOP
			RETURN NEXT row;
		END LOOP;
	ELSE
		FOR row IN
		    SELECT info.* FROM meta.info 
		       INNER JOIN meta.infos_type USING(int_id)
		       WHERE (str ISNULL OR inf_code ilike '%'||str||'%' OR inf_libelle ilike '%'||str||'%') 
		       AND (prm_int_code ISNULL OR prm_int_code = infos_type.int_code)
		       ORDER BY inf_libelle
		LOOP
		    RETURN NEXT row;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION meta_info_liste(prm_token integer, str character varying, usedonly boolean, prm_int_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_liste(prm_token integer, str character varying, usedonly boolean, prm_int_code character varying) IS 'Retourne la liste des champs dans le nom ou le code contient une chaîne, parmi tous les champs disponibles ou seulement ceux utilisés.';


--
-- Name: meta_info_liste_champs_par_secteur_categorie(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_liste_champs_par_secteur_categorie(prm_token integer, prm_cat_id integer, prm_sec_code character varying) RETURNS SETOF info
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.info;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		select distinct info.* FROM meta.info 
		inner join meta.infos_type using(int_id)
		inner join meta.info_groupe using(inf_id)
		inner join meta.groupe_infos using(gin_id)
		inner join meta.sousmenu using(sme_id)
		inner join meta.menu using(men_id)
		inner join meta.portail using(por_id)
		where int_code = 'groupe' 
		AND cat_id = prm_cat_id
		AND inf__groupe_type = prm_sec_code
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_info_liste_champs_par_secteur_categorie(prm_token integer, prm_cat_id integer, prm_sec_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_liste_champs_par_secteur_categorie(prm_token integer, prm_cat_id integer, prm_sec_code character varying) IS 'Retourne la liste des champs de type "groupe" couvrant le secteur donné affectés dans une fiche du portail';


--
-- Name: meta_info_update(integer, integer, integer, character varying, character varying, character varying, boolean, boolean, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_update(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm_libelle_complet character varying, prm_etendu boolean, prm_historique boolean, prm_multiple boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		int_id = prm_int_id,
		inf_code = prm_code, 
		inf_libelle = prm_libelle, 
		inf_libelle_complet = prm_libelle_complet, 
		inf_etendu = prm_etendu, 
		inf_historique = prm_historique, 
		inf_multiple = prm_multiple 
	WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_info_update(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm_libelle_complet character varying, prm_etendu boolean, prm_historique boolean, prm_multiple boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_update(prm_token integer, prm_inf_id integer, prm_int_id integer, prm_code character varying, prm_libelle character varying, prm_libelle_complet character varying, prm_etendu boolean, prm_historique boolean, prm_multiple boolean) IS 'Modifie les informations d''un champ.';


--
-- Name: meta_info_usage(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_info_usage(prm_token integer, prm_inf_id integer) RETURNS SETOF meta_info_usage
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.meta_info_usage;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
	    select cat_nom, por_libelle, ent_libelle, men_libelle, sme_libelle FROM meta.info 
	    	   inner join meta.info_groupe using(inf_id)
		   inner join meta.groupe_infos using(gin_id)
		   inner join meta.sousmenu using(sme_id)
		   inner join meta.menu using(men_id)
		   inner join meta.entite using(ent_id)
		   inner join meta.portail using(por_id)
		   inner join meta.categorie using(cat_id)
		   where inf_id = prm_inf_id
        LOOP
	    RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_info_usage(prm_token integer, prm_inf_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_info_usage(prm_token integer, prm_inf_id integer) IS 'Retourne les pages sur lesquelles est utilisé un champ.';


--
-- Name: meta_infos_contact_update(integer, integer, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_contact_update(prm_token integer, prm_inf_id integer, prm_filtre character varying, prm_secteur character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__contact_filtre = prm_filtre,
		inf__contact_secteur = prm_secteur
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_contact_update(prm_token integer, prm_inf_id integer, prm_filtre character varying, prm_secteur character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_contact_update(prm_token integer, prm_inf_id integer, prm_filtre character varying, prm_secteur character varying) IS 'Modifie les informations spécifiques d''un champ de type "contact".';


--
-- Name: meta_infos_date_update(integer, integer, boolean, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_date_update(prm_token integer, prm_inf_id integer, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__date_echeance = prm__date_echeance,
		inf__date_echeance_icone = prm__date_echeance_icone,
		inf__date_echeance_secteur = prm__date_echeance_secteur
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_date_update(prm_token integer, prm_inf_id integer, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_date_update(prm_token integer, prm_inf_id integer, prm__date_echeance boolean, prm__date_echeance_icone character varying, prm__date_echeance_secteur character varying) IS 'Modifie les informations spécifiques d''un champ de type "date".';


--
-- Name: meta_infos_etablissement_update(integer, integer, boolean, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_etablissement_update(prm_token integer, prm_inf_id integer, prm_interne boolean, prm__etablissement_secteur character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__etablissement_interne = prm_interne,
		inf__etablissement_secteur = prm__etablissement_secteur
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_etablissement_update(prm_token integer, prm_inf_id integer, prm_interne boolean, prm__etablissement_secteur character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_etablissement_update(prm_token integer, prm_inf_id integer, prm_interne boolean, prm__etablissement_secteur character varying) IS 'Modifie les informations spécifiques d''un champ de type "etablissement".';


--
-- Name: meta_infos_groupe_update(integer, integer, character varying, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_groupe_update(prm_token integer, prm_inf_id integer, prm_type character varying, prm_soustype integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__groupe_type = prm_type,
		inf__groupe_soustype = prm_soustype
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_groupe_update(prm_token integer, prm_inf_id integer, prm_type character varying, prm_soustype integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_groupe_update(prm_token integer, prm_inf_id integer, prm_type character varying, prm_soustype integer) IS 'Modifie les informations spécifiques d''un champ de type "etablissement".';


--
-- Name: meta_infos_metier_update(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_metier_update(prm_token integer, prm_inf_id integer, prm_secteur character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__metier_secteur = prm_secteur
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_metier_update(prm_token integer, prm_inf_id integer, prm_secteur character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_metier_update(prm_token integer, prm_inf_id integer, prm_secteur character varying) IS 'Modifie les informations spécifiques d''un champ de type "metier".';


--
-- Name: meta_infos_selection_update(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_selection_update(prm_token integer, prm_inf_id integer, prm_code integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__selection_code = prm_code
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_selection_update(prm_token integer, prm_inf_id integer, prm_code integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_selection_update(prm_token integer, prm_inf_id integer, prm_code integer) IS 'Modifie les informations spécifiques d''un champ de type "selection".';


--
-- Name: meta_infos_textelong_update(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_textelong_update(prm_token integer, prm_inf_id integer, prm_nblignes integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info SET 
		inf__textelong_nblignes = prm_nblignes
		WHERE inf_id = prm_inf_id;
END;
$$;


--
-- Name: FUNCTION meta_infos_textelong_update(prm_token integer, prm_inf_id integer, prm_nblignes integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_textelong_update(prm_token integer, prm_inf_id integer, prm_nblignes integer) IS 'Modifie les informations spécifiques d''un champ de type "textelong".';


--
-- Name: infos_type; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE infos_type (
    int_id integer NOT NULL,
    int_code character varying,
    int_libelle character varying,
    int_multiple boolean,
    int_historique boolean
);


--
-- Name: TABLE infos_type; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE infos_type IS 'Types de champs (édition des personnes)';


--
-- Name: meta_infos_type_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_infos_type_liste(prm_token integer) RETURNS SETOF infos_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.infos_type%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.infos_type 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_infos_type_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_infos_type_liste(prm_token integer) IS 'Retourne la liste des types de champs.';


--
-- Name: meta_ing__groupe_cycle_set(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_ing__groupe_cycle_set(prm_token integer, prm_ing_id integer, prm_val boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info_groupe SET ing__groupe_cycle = prm_val WHERE ing_id = prm_ing_id;
END;
$$;


--
-- Name: FUNCTION meta_ing__groupe_cycle_set(prm_token integer, prm_ing_id integer, prm_val boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_ing__groupe_cycle_set(prm_token integer, prm_ing_id integer, prm_val boolean) IS 'Indique si un champ de type "groupe" utilise le cycle.';


--
-- Name: meta_ing_obligatoire_set(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_ing_obligatoire_set(prm_token integer, prm_ing_id integer, prm_val boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.info_groupe SET ing_obligatoire = prm_val WHERE ing_id = prm_ing_id;
END;
$$;


--
-- Name: FUNCTION meta_ing_obligatoire_set(prm_token integer, prm_ing_id integer, prm_val boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_ing_obligatoire_set(prm_token integer, prm_ing_id integer, prm_val boolean) IS 'Indique si un champ doit être rempli à la création d''une personne.';


--
-- Name: lien_familial; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE lien_familial (
    lfa_id integer NOT NULL,
    lfa_nom character varying
);


--
-- Name: TABLE lien_familial; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE lien_familial IS 'Types de liens familiaux';


--
-- Name: meta_lien_familial_cherche(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_lien_familial_cherche(prm_token integer, prm_lfa_nom character varying) RETURNS lien_familial
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.lien_familial;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.lien_familial WHERE lfa_nom ilike prm_lfa_nom;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_lien_familial_cherche(prm_token integer, prm_lfa_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_lien_familial_cherche(prm_token integer, prm_lfa_nom character varying) IS 'Recherche un lien familial par son nom.';


--
-- Name: meta_lien_familial_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_lien_familial_get(prm_token integer, prm_lfa_id integer) RETURNS lien_familial
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.lien_familial;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.lien_familial WHERE lfa_id = prm_lfa_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_lien_familial_get(prm_token integer, prm_lfa_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_lien_familial_get(prm_token integer, prm_lfa_id integer) IS 'Retourne les informations d''un lien familial.';


--
-- Name: meta_lien_familial_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_lien_familial_liste(prm_token integer) RETURNS SETOF lien_familial
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.lien_familial;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.lien_familial ORDER BY lfa_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_lien_familial_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_lien_familial_liste(prm_token integer) IS 'Retourne la liste des liens familiaux.';


--
-- Name: meta_menu_add_end(integer, integer, character varying, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying, prm_ent_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	int_ordre integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(men_ordre) + 1 INTO int_ordre FROM meta.menu WHERE por_id = prm_por_id AND ent_id = prm_ent_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.menu(por_id, men_libelle, men_ordre, ent_id) VALUES (prm_por_id, prm_libelle, int_ordre, prm_ent_id) RETURNING men_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_menu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying, prm_ent_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying, prm_ent_id integer) IS 'Ajoute une entrée de menu à un portail pour un type de personne.';


--
-- Name: meta_menu_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_delete(prm_token integer, prm_men_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.menu WHERE men_id = prm_men_id;
END;
$$;


--
-- Name: FUNCTION meta_menu_delete(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_delete(prm_token integer, prm_men_id integer) IS 'Supprime une entrée de menu.';


--
-- Name: meta_menu_deplacer_bas(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_deplacer_bas(prm_token integer, prm_men_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_menus_reordonne (prm_token,
					   (SELECT por_id FROM meta.menu WHERE men_id = prm_men_id),
					   (SELECT ent_id FROM meta.menu WHERE men_id = prm_men_id) );
	IF (SELECT men_ordre FROM meta.menu WHERE men_id = prm_men_id) = (SELECT MAX(men_ordre) FROM meta.menu WHERE
	 		por_id = (SELECT por_id FROM meta.menu WHERE men_id = prm_men_id) AND 
			ent_id = (SELECT ent_id FROM meta.menu WHERE men_id = prm_men_id))
	THEN RETURN; END IF;
	UPDATE meta.menu SET men_ordre = men_ordre + 1 WHERE men_id = prm_men_id;
	UPDATE meta.menu SET men_ordre = men_ordre - 1 WHERE 
		por_id = (SELECT por_id FROM meta.menu WHERE men_id = prm_men_id) AND 
		ent_id = (SELECT ent_id FROM meta.menu WHERE men_id = prm_men_id) AND 
		men_ordre = (SELECT men_ordre FROM meta.menu WHERE men_id = prm_men_id) AND
		men_id <> prm_men_id;
END;
$$;


--
-- Name: FUNCTION meta_menu_deplacer_bas(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_deplacer_bas(prm_token integer, prm_men_id integer) IS 'Déplace une entrée de menu vers le bas.';


--
-- Name: meta_menu_deplacer_haut(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_deplacer_haut(prm_token integer, prm_men_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_menus_reordonne (prm_token,
					   (SELECT por_id FROM meta.menu WHERE men_id = prm_men_id),
					   (SELECT ent_id FROM meta.menu WHERE men_id = prm_men_id) );
	IF (SELECT men_ordre FROM meta.menu WHERE men_id = prm_men_id) = 1 THEN RETURN; END IF;
	UPDATE meta.menu SET men_ordre = men_ordre - 1 WHERE men_id = prm_men_id;
	UPDATE meta.menu SET men_ordre = men_ordre + 1 WHERE 
		por_id = (SELECT por_id FROM meta.menu WHERE men_id = prm_men_id) AND 
		ent_id = (SELECT ent_id FROM meta.menu WHERE men_id = prm_men_id) AND 
		men_ordre = (SELECT men_ordre FROM meta.menu WHERE men_id = prm_men_id) AND
		men_id <> prm_men_id;
END;
$$;


--
-- Name: FUNCTION meta_menu_deplacer_haut(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_deplacer_haut(prm_token integer, prm_men_id integer) IS 'Déplace une entrée de menu vers le haut.';


--
-- Name: menu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE menu (
    men_id integer NOT NULL,
    men_libelle character varying,
    men_ordre integer,
    ent_id integer,
    por_id integer
);


--
-- Name: TABLE menu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE menu IS 'Menu du dialogue d''édition d''une personne';


--
-- Name: meta_menu_infos(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_infos(prm_token integer, prm_men_id integer) RETURNS menu
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.menu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.menu WHERE men_id = prm_men_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_menu_infos(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_infos(prm_token integer, prm_men_id integer) IS 'Retourne les informations d''une entrée de menu de fiche personne.';


--
-- Name: meta_menu_liste(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying) RETURNS SETOF menu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.menu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.menu WHERE por_id = prm_por_id AND ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code) ORDER BY men_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_menu_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_liste(prm_token integer, prm_por_id integer, prm_ent_code character varying) IS 'Retourne la liste des menus pour un portail et un type de personne donnés.';


--
-- Name: meta_menu_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_rename(prm_token integer, prm_men_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.menu SET men_libelle = prm_libelle WHERE men_id = prm_men_id;
END;
$$;


--
-- Name: FUNCTION meta_menu_rename(prm_token integer, prm_men_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_rename(prm_token integer, prm_men_id integer, prm_libelle character varying) IS 'Renomme une entrée de menu.';


--
-- Name: meta_menu_un_seul_niveau(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menu_un_seul_niveau(prm_token integer, prm_por_id integer, prm_ent_code character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret boolean;
	mens meta.menu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR mens IN 
		SELECT men_id FROM meta.menu WHERE por_id = prm_por_id AND ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code)
	LOOP
		IF (SELECT COUNT(*) FROM meta.sousmenu WHERE men_id = mens.men_id) > 1 THEN
			RETURN FALSE;
		END IF;
	END LOOP;
	RETURN TRUE;
END;
$$;


--
-- Name: FUNCTION meta_menu_un_seul_niveau(prm_token integer, prm_por_id integer, prm_ent_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menu_un_seul_niveau(prm_token integer, prm_por_id integer, prm_ent_code character varying) IS 'Retourne TRUE si le menu d''une fiche personne est à un seul niveau.';


--
-- Name: meta_menus_reordonne(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menus_reordonne(prm_token integer, prm_por_id integer, prm_ent_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	i integer;
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	i = 1;
	FOR row IN
		SELECT men_id FROM meta.menu WHERE por_id = prm_por_id AND ent_id = prm_ent_id ORDER BY men_ordre
	LOOP
		UPDATE meta.menu SET men_ordre = i WHERE men_id = row.men_id;
		i = i + 1;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_menus_reordonne(prm_token integer, prm_por_id integer, prm_ent_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menus_reordonne(prm_token integer, prm_por_id integer, prm_ent_id integer) IS 'Réordonne les entrées de menu d''un portail pour un type de personne.';


--
-- Name: meta_menus_supprime_recursif(integer, character varying, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_menus_supprime_recursif(prm_token integer, prm_ent_code character varying, prm_por_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.info_groupe WHERE gin_id IN (SELECT gin_id FROM meta.groupe_infos WHERE sme_id IN (SELECT sme_id FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code) AND por_id = prm_por_id)));
	DELETE FROM meta.groupe_infos WHERE sme_id IN (SELECT sme_id FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code) AND por_id = prm_por_id));
	DELETE FROM meta.sousmenu WHERE men_id IN (SELECT men_id FROM meta.menu WHERE ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code) AND por_id = prm_por_id);
	DELETE FROM meta.menu WHERE ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code) AND por_id = prm_por_id;
END;
$$;


--
-- Name: FUNCTION meta_menus_supprime_recursif(prm_token integer, prm_ent_code character varying, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_menus_supprime_recursif(prm_token integer, prm_ent_code character varying, prm_por_id integer) IS 'Supprime un menu de fiche personne et toutes ses fiches.';


--
-- Name: meta_portail_add(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_add(prm_token integer, prm_cat_id integer, prm_libelle character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	row meta.entite;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.portail (cat_id, por_libelle) VALUES (prm_cat_id, prm_libelle) RETURNING por_id INTO ret;
	FOR row IN SELECT * FROM meta.entite LOOP
		INSERT INTO permission.droit_ajout_entite_portail (ent_code, por_id, daj_droit) VALUES (row.ent_code, ret, TRUE);
	END LOOP;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_portail_add(prm_token integer, prm_cat_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_add(prm_token integer, prm_cat_id integer, prm_libelle character varying) IS 'Ajoute un portail.';


--
-- Name: meta_portail_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_delete(prm_token integer, prm_por_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM permission.droit_ajout_entite_portail WHERE por_id = prm_por_id;
	DELETE FROM meta.portail WHERE por_id = prm_por_id;
END;
$$;


--
-- Name: FUNCTION meta_portail_delete(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_delete(prm_token integer, prm_por_id integer) IS 'Supprime un portail.';


--
-- Name: meta_portail_delete_rec(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_delete_rec(prm_token integer, prm_por_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_ent meta.entite;
	row_tom meta.topmenu;
	row_tsm meta.topsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row_ent IN SELECT * FROM meta.entite LOOP
		PERFORM meta.meta_menus_supprime_recursif (prm_token, row_ent.ent_code, prm_por_id);
	END LOOP; 
	FOR row_tom IN SELECT * FROM meta.topmenu WHERE por_id = prm_por_id LOOP
		FOR row_tsm IN SELECT * FROM meta.topsousmenu WHERE tom_id = row_tom.tom_id LOOP
			PERFORM meta.meta_topsousmenu_delete (prm_token, row_tsm.tsm_id);
		END LOOP;
		PERFORM meta.meta_topmenu_delete (prm_token, row_tom.tom_id);
	END LOOP; 
	DELETE FROM permission.droit_ajout_entite_portail WHERE por_id = prm_por_id;
	DELETE FROM notes.theme_portail WHERE por_id = prm_por_id;
	DELETE FROM meta.portail WHERE por_id = prm_por_id;
END;
$$;


--
-- Name: FUNCTION meta_portail_delete_rec(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_delete_rec(prm_token integer, prm_por_id integer) IS 'Supprime un portail et tout ce qu''il contient.';


--
-- Name: portail; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE portail (
    por_id integer NOT NULL,
    cat_id integer,
    por_libelle character varying
);


--
-- Name: TABLE portail; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE portail IS 'Liste des portails';


--
-- Name: meta_portail_get(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_get(prm_token integer, prm_cat_id integer, prm_por_id integer) RETURNS portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.portail;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.portail WHERE cat_id = prm_cat_id AND por_id = prm_por_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_portail_get(prm_token integer, prm_cat_id integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_get(prm_token integer, prm_cat_id integer, prm_por_id integer) IS 'Retourne les informations sur un portail.';


--
-- Name: meta_portail_infos(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_infos(prm_token integer, prm_por_id integer) RETURNS portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.portail;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.portail WHERE por_id = prm_por_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_portail_infos(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_infos(prm_token integer, prm_por_id integer) IS 'Retourne les informations sur un portail.';


--
-- Name: meta_portail_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_liste(prm_token integer, prm_cat_id integer) RETURNS SETOF portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.portail;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.portail WHERE (prm_cat_id ISNULL OR cat_id = prm_cat_id) ORDER BY por_libelle
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_portail_liste(prm_token integer, prm_cat_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_liste(prm_token integer, prm_cat_id integer) IS 'Retourne la liste des portails définis pour une catégorie donnée.';


--
-- Name: meta_portail_purge(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_purge(prm_token integer, prm_por_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row_ent meta.entite;
	row_tom meta.topmenu;
	row_tsm meta.topsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row_ent IN SELECT * FROM meta.entite LOOP
		PERFORM meta.meta_menus_supprime_recursif (prm_token, row_ent.ent_code, prm_por_id);
	END LOOP; 
	FOR row_tom IN SELECT * FROM meta.topmenu WHERE por_id = prm_por_id LOOP
		FOR row_tsm IN SELECT * FROM meta.topsousmenu WHERE tom_id = row_tom.tom_id LOOP
			PERFORM meta.meta_topsousmenu_delete (prm_token, row_tsm.tsm_id);
		END LOOP;
		PERFORM meta.meta_topmenu_delete (prm_token, row_tom.tom_id);
	END LOOP; 
END;
$$;


--
-- Name: FUNCTION meta_portail_purge(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_purge(prm_token integer, prm_por_id integer) IS 'Vide un portail de ses menus.';


--
-- Name: meta_portail_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_portail_rename(prm_token integer, prm_por_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.portail SET por_libelle = prm_libelle WHERE por_id = prm_por_id;
END;
$$;


--
-- Name: FUNCTION meta_portail_rename(prm_token integer, prm_por_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_portail_rename(prm_token integer, prm_por_id integer, prm_libelle character varying) IS 'Renomme un portail.';


--
-- Name: rootsousmenu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE rootsousmenu (
    rsm_id integer NOT NULL,
    rsm_libelle character varying,
    rsm_ordre integer,
    rsm_icone character varying,
    rsm_script character varying
);


--
-- Name: TABLE rootsousmenu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE rootsousmenu IS 'Sous-menu de la configuration "Réseau"';


--
-- Name: meta_rootsousmenu_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_rootsousmenu_liste(prm_token integer) RETURNS SETOF rootsousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.rootsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.rootsousmenu ORDER BY rsm_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_rootsousmenu_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_rootsousmenu_liste(prm_token integer) IS 'Retourne la liste des entrées du menu de configuration "Réseau".';


--
-- Name: meta_secteur_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_get(prm_token integer, prm_sec_id integer) RETURNS secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.secteur WHERE sec_id = prm_sec_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_secteur_get(prm_token integer, prm_sec_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_get(prm_token integer, prm_sec_id integer) IS 'Retourne les informations sur un secteur.';


--
-- Name: meta_secteur_get_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_get_par_code(prm_token integer, prm_sec_code character varying) RETURNS secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.secteur WHERE sec_code = prm_sec_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_secteur_get_par_code(prm_token integer, prm_sec_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_get_par_code(prm_token integer, prm_sec_code character varying) IS 'Retourne les informations sur un secteur à partir de son code.';


--
-- Name: meta_secteur_liste(integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_liste(prm_token integer, prm_est_prise_en_charge boolean) RETURNS SETOF secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.secteur WHERE (prm_est_prise_en_charge ISNULL OR sec_est_prise_en_charge = prm_est_prise_en_charge) ORDER BY sec_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_secteur_liste(prm_token integer, prm_est_prise_en_charge boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_liste(prm_token integer, prm_est_prise_en_charge boolean) IS 'Retourne la liste des secteurs.';


--
-- Name: meta_secteur_save(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_save(prm_token integer, prm_code character varying, prm_nom character varying, prm_icone character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE meta.secteur SET sec_nom = prm_nom, sec_icone = prm_icone WHERE sec_code = prm_code;
END;
$$;


--
-- Name: FUNCTION meta_secteur_save(prm_token integer, prm_code character varying, prm_nom character varying, prm_icone character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_save(prm_token integer, prm_code character varying, prm_nom character varying, prm_icone character varying) IS 'Modifie les informations d''un secteur.';


--
-- Name: meta_secteur_type_add(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_type_add(prm_token integer, prm_sec_id integer, prm_nom character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret INTEGER;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	INSERT INTO meta.secteur_type (sec_id, set_nom) VALUES (prm_sec_id, prm_nom) RETURNING set_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_secteur_type_add(prm_token integer, prm_sec_id integer, prm_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_type_add(prm_token integer, prm_sec_id integer, prm_nom character varying) IS 'Ajoute un type à un secteur.';


--
-- Name: meta_secteur_type_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_type_delete(prm_token integer, prm_set_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	DELETE FROM meta.secteur_type WHERE set_id = prm_set_id;
END;
$$;


--
-- Name: FUNCTION meta_secteur_type_delete(prm_token integer, prm_set_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_type_delete(prm_token integer, prm_set_id integer) IS 'Supprime un type d''un secteur.';


--
-- Name: secteur_type; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE secteur_type (
    set_id integer NOT NULL,
    sec_id integer,
    set_nom character varying
);


--
-- Name: TABLE secteur_type; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE secteur_type IS 'Sous-catégorie des secteurs';


--
-- Name: meta_secteur_type_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_type_liste(prm_token integer, prm_sec_id integer) RETURNS SETOF secteur_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.secteur_type WHERE sec_id = prm_sec_id ORDER BY set_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_secteur_type_liste(prm_token integer, prm_sec_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_type_liste(prm_token integer, prm_sec_id integer) IS 'Retourne la liste des types d''un secteur.';


--
-- Name: meta_secteur_type_liste_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_type_liste_par_code(prm_token integer, prm_sec_code character varying) RETURNS SETOF secteur_type
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur_type;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT meta.secteur_type.* FROM meta.secteur_type 
		INNER JOIN meta.secteur USING(sec_id)
		WHERE sec_code = prm_sec_code ORDER BY set_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_secteur_type_liste_par_code(prm_token integer, prm_sec_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_type_liste_par_code(prm_token integer, prm_sec_code character varying) IS 'Retourne la liste des types d''un secteur, à partir du code du secteur.';


--
-- Name: meta_secteur_type_update(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_secteur_type_update(prm_token integer, prm_set_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	UPDATE meta.secteur_type SET set_nom = prm_nom WHERE set_id = prm_set_id;
END;
$$;


--
-- Name: FUNCTION meta_secteur_type_update(prm_token integer, prm_set_id integer, prm_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_secteur_type_update(prm_token integer, prm_set_id integer, prm_nom character varying) IS 'Modifie les informations d''un type d''un secteur.';


--
-- Name: meta_selection_add_avec_id(integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_add_avec_id(prm_token integer, prm_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.selection (sel_id, sel_code, sel_libelle, sel_info) VALUES (prm_id, prm_code, prm_libelle, prm_info) 
		RETURNING sel_id INTO ret;
	PERFORM setval ('meta.selection_sel_id_seq', coalesce((select max(sel_id)+1 from meta.selection), 1), false);
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_add_avec_id(prm_token integer, prm_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_add_avec_id(prm_token integer, prm_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying) IS 'Ajoute une liste de sélection (utilisé avec la banque de champs).';


--
-- Name: meta_selection_dernier(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_dernier(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(sel_id) INTO ret FROM meta.selection;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_dernier(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_dernier(prm_token integer) IS 'Retourne la dernière liste de sélection en base (utilisé avec la banque de champs).';


--
-- Name: meta_selection_entree_add(integer, integer, character varying, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_add(prm_token integer, prm_sel_id integer, prm_libelle character varying, prm_ordre integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	INSERT INTO meta.selection_entree (sel_id, sen_libelle, sen_ordre) VALUES (prm_sel_id, prm_libelle, prm_ordre) 
		RETURNING sen_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_add(prm_token integer, prm_sel_id integer, prm_libelle character varying, prm_ordre integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_add(prm_token integer, prm_sel_id integer, prm_libelle character varying, prm_ordre integer) IS 'Ajoute une entrée à une liste de sélection.';


--
-- Name: selection_entree; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE selection_entree (
    sen_id integer NOT NULL,
    sel_id integer,
    sen_libelle character varying,
    sen_ordre integer
);


--
-- Name: TABLE selection_entree; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE selection_entree IS 'Valeurs des listes de sélection';


--
-- Name: meta_selection_entree_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_get(prm_token integer, prm_sen_id integer) RETURNS selection_entree
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.selection_entree;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.selection_entree WHERE sen_id = prm_sen_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_get(prm_token integer, prm_sen_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_get(prm_token integer, prm_sen_id integer) IS 'Retourne les informations sur une entrée de liste de sélection.';


--
-- Name: meta_selection_entree_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_liste(prm_token integer, prm_sel_id integer) RETURNS SETOF selection_entree
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.selection_entree%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.selection_entree WHERE sel_id = prm_sel_id ORDER BY sen_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_liste(prm_token integer, prm_sel_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_liste(prm_token integer, prm_sel_id integer) IS 'Retourne les entrées d''une liste de sélection.';


--
-- Name: meta_selection_entree_liste_par_cha(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_liste_par_cha(prm_token integer, prm_cha_id integer) RETURNS SETOF selection_entree
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.selection_entree%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT selection_entree.* FROM meta.selection_entree 
		INNER JOIN meta.info ON info.inf__selection_code = sel_id
		INNER JOIN liste.champ USING (inf_id)
		WHERE cha_id = prm_cha_id ORDER BY sen_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_liste_par_cha(prm_token integer, prm_cha_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_liste_par_cha(prm_token integer, prm_cha_id integer) IS 'Retourne les entrées d''une liste de sélection d''après l''identifiant du champ de type sélection.';


--
-- Name: meta_selection_entree_liste_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_liste_par_code(prm_token integer, prm_sel_code character varying) RETURNS SETOF selection_entree
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.selection_entree%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.selection_entree WHERE sel_id = (SELECT sel_id FROM meta.selection WHERE sel_code = prm_sel_code) ORDER BY sen_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_liste_par_code(prm_token integer, prm_sel_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_liste_par_code(prm_token integer, prm_sel_code character varying) IS 'Retourne les entrées d''une liste de sélection à partir du code de la liste.';


--
-- Name: meta_selection_entree_set_ordre(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_set_ordre(prm_token integer, prm_sen_id integer, prm_ordre integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.selection_entree SET sen_ordre = prm_ordre WHERE sen_id = prm_sen_id;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_set_ordre(prm_token integer, prm_sen_id integer, prm_ordre integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_set_ordre(prm_token integer, prm_sen_id integer, prm_ordre integer) IS 'Modifie l''ordre d''apparition d''une entrée dans la liste de sélection.';


--
-- Name: meta_selection_entree_supprime(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_entree_supprime(prm_token integer, prm_sen_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.selection_entree WHERE sen_id = prm_sen_id;
END;
$$;


--
-- Name: FUNCTION meta_selection_entree_supprime(prm_token integer, prm_sen_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_entree_supprime(prm_token integer, prm_sen_id integer) IS 'Supprime une entrée de liste de sélection.';


--
-- Name: selection; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE selection (
    sel_id integer NOT NULL,
    sel_code character varying,
    sel_libelle character varying,
    sel_info character varying
);


--
-- Name: TABLE selection; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE selection IS 'Liste des sélection (pour les champs sélection d''édition des personnes)';


--
-- Name: meta_selection_infos(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_infos(prm_token integer, prm_sel_id integer) RETURNS selection
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.selection%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.selection WHERE sel_id = prm_sel_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_infos(prm_token integer, prm_sel_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_infos(prm_token integer, prm_sel_id integer) IS 'Retourne les infos d''une liste de sélection.';


--
-- Name: meta_selection_infos_par_code(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_infos_par_code(prm_token integer, prm_sel_code character varying) RETURNS selection
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.selection%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.selection WHERE sel_code = prm_sel_code;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_selection_infos_par_code(prm_token integer, prm_sel_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_infos_par_code(prm_token integer, prm_sel_code character varying) IS 'Retourne les infos d''une liste de sélection à partir de son code.';


--
-- Name: meta_selection_liste(integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_liste(prm_token integer) RETURNS SETOF selection
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.selection;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN
		SELECT * FROM meta.selection ORDER BY sel_libelle
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_selection_liste(prm_token integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_liste(prm_token integer) IS 'Retourne la liste des listes de sélection.';


--
-- Name: meta_selection_update(integer, integer, character varying, character varying, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_selection_update(prm_token integer, prm_sel_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE meta.selection SET 
		sel_code = prm_code, 
		sel_libelle = prm_libelle, 
		sel_info = prm_info
		WHERE sel_id = prm_sel_id; 
END;
$$;


--
-- Name: FUNCTION meta_selection_update(prm_token integer, prm_sel_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_selection_update(prm_token integer, prm_sel_id integer, prm_code character varying, prm_libelle character varying, prm_info character varying) IS 'Modifie les informations d''une liste de sélection.';


--
-- Name: meta_sousmenu_add_end(integer, integer, character varying, character varying, integer, boolean, boolean, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_add_end(prm_token integer, prm_men_id integer, prm_libelle character varying, prm_type character varying, prm_type_id integer, prm_droit_modif boolean, prm_droit_suppression boolean, prm_icone character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	int_ordre integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(sme_ordre) + 1 INTO int_ordre FROM meta.sousmenu WHERE men_id = prm_men_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.sousmenu(men_id, sme_libelle, sme_ordre, sme_type, sme_type_id, sme_droit_modif, sme_droit_suppression, sme_icone) VALUES (prm_men_id, prm_libelle, int_ordre, prm_type, prm_type_id, prm_droit_modif, prm_droit_suppression, prm_icone) RETURNING sme_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_add_end(prm_token integer, prm_men_id integer, prm_libelle character varying, prm_type character varying, prm_type_id integer, prm_droit_modif boolean, prm_droit_suppression boolean, prm_icone character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_add_end(prm_token integer, prm_men_id integer, prm_libelle character varying, prm_type character varying, prm_type_id integer, prm_droit_modif boolean, prm_droit_suppression boolean, prm_icone character varying) IS 'Ajoute une fiche à un menu personne.';


--
-- Name: meta_sousmenu_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_delete(prm_token integer, prm_sme_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM procedure.procedure_affectation WHERE sme_id = prm_sme_id;
	DELETE FROM meta.sousmenu WHERE sme_id = prm_sme_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_delete(prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_delete(prm_token integer, prm_sme_id integer) IS 'Supprime une fiche d''un menu personne.';


--
-- Name: meta_sousmenu_deplacer_bas(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_deplacer_bas(prm_token integer, prm_sme_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_sousmenus_reordonne (prm_token, (SELECT men_id FROM meta.sousmenu WHERE sme_id = prm_sme_id));
	IF (SELECT sme_ordre FROM meta.sousmenu WHERE sme_id = prm_sme_id) = (SELECT MAX(sme_ordre) FROM meta.sousmenu WHERE
	 		men_id = (SELECT men_id FROM meta.sousmenu WHERE sme_id = prm_sme_id))
	THEN RETURN; END IF;
	UPDATE meta.sousmenu SET sme_ordre = sme_ordre + 1 WHERE sme_id = prm_sme_id;
	UPDATE meta.sousmenu SET sme_ordre = sme_ordre - 1 WHERE 
		men_id = (SELECT men_id FROM meta.sousmenu WHERE sme_id = prm_sme_id) AND 
		sme_ordre = (SELECT sme_ordre FROM meta.sousmenu WHERE sme_id = prm_sme_id) AND
		sme_id <> prm_sme_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_deplacer_bas(prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_deplacer_bas(prm_token integer, prm_sme_id integer) IS 'Déplace vers le bas une fiche d''un menu personne.';


--
-- Name: meta_sousmenu_deplacer_haut(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_deplacer_haut(prm_token integer, prm_sme_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_sousmenus_reordonne (prm_token, (SELECT men_id FROM meta.sousmenu WHERE sme_id = prm_sme_id));
	IF (SELECT sme_ordre FROM meta.sousmenu WHERE sme_id = prm_sme_id) = 1 THEN RETURN; END IF;
	UPDATE meta.sousmenu SET sme_ordre = sme_ordre - 1 WHERE sme_id = prm_sme_id;
	UPDATE meta.sousmenu SET sme_ordre = sme_ordre + 1 WHERE 
		men_id = (SELECT men_id FROM meta.sousmenu WHERE sme_id = prm_sme_id) AND 
		sme_ordre = (SELECT sme_ordre FROM meta.sousmenu WHERE sme_id = prm_sme_id) AND
		sme_id <> prm_sme_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_deplacer_haut(prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_deplacer_haut(prm_token integer, prm_sme_id integer) IS 'Déplace vers le haut une fiche d''un menu personne.';


--
-- Name: sousmenu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE sousmenu (
    sme_id integer NOT NULL,
    men_id integer,
    sme_libelle character varying,
    sme_ordre integer,
    sme_type character varying,
    sme_type_id integer,
    sme_droit_modif boolean DEFAULT true,
    sme_droit_suppression boolean DEFAULT true,
    sme_icone character varying
);


--
-- Name: TABLE sousmenu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE sousmenu IS 'Sous-menu du dialogue d''édition d''une personne';


--
-- Name: meta_sousmenu_infos(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_infos(prm_token integer, prm_sme_id integer) RETURNS sousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.sousmenu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.sousmenu WHERE sme_id = prm_sme_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_infos(prm_token integer, prm_sme_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_infos(prm_token integer, prm_sme_id integer) IS 'Retourne les informations sur une fiche d''un menu personne.';


--
-- Name: meta_sousmenu_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_liste(prm_token integer, prm_men_id integer) RETURNS SETOF sousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.sousmenu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.sousmenu WHERE men_id = prm_men_id ORDER BY sme_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_liste(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_liste(prm_token integer, prm_men_id integer) IS 'Retourne la liste des fiches d''un menu personne.';


--
-- Name: meta_sousmenu_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_rename(prm_token integer, prm_sme_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.sousmenu SET sme_libelle = prm_libelle WHERE sme_id = prm_sme_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_rename(prm_token integer, prm_sme_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_rename(prm_token integer, prm_sme_id integer, prm_libelle character varying) IS 'Renomme une fiche de menu personne.';


--
-- Name: meta_sousmenu_set_droit_modif(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE meta.sousmenu SET sme_droit_modif = prm_droit_modif WHERE sme_id = prm_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean) IS 'Indique si l''utilisateur a droit de modification sur cette fiche.';


--
-- Name: meta_sousmenu_set_droit_suppression(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE meta.sousmenu SET sme_droit_suppression = prm_droit_suppression WHERE sme_id = prm_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean) IS 'Indique si l''utilisateur a droit de suppression sur cette fiche.';


--
-- Name: meta_sousmenu_set_type(integer, integer, character varying, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenu_set_type(prm_token integer, prm_sme_id integer, prm_type character varying, prm_type_id integer, prm_icone character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.sousmenu SET sme_type = prm_type, sme_type_id = prm_type_id, sme_icone = prm_icone WHERE sme_id = prm_sme_id;
END;
$$;


--
-- Name: FUNCTION meta_sousmenu_set_type(prm_token integer, prm_sme_id integer, prm_type character varying, prm_type_id integer, prm_icone character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenu_set_type(prm_token integer, prm_sme_id integer, prm_type character varying, prm_type_id integer, prm_icone character varying) IS 'Modifie le type d''une fiche de menu personne.';


--
-- Name: meta_sousmenus_liste_depuis_topmenu(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenus_liste_depuis_topmenu(prm_token integer, prm_tom_id integer, prm_ent_code character varying) RETURNS SETOF meta_sousmenus_liste_depuis_topmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.meta_sousmenus_liste_depuis_topmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN SELECT men_id, menu.men_libelle, sousmenu.sme_id, sousmenu.sme_libelle FROM meta.sousmenu
		INNER JOIN meta.menu USING(men_id) 
		WHERE ent_id = (SELECT ent_id FROM meta.entite WHERE ent_code = prm_ent_code)
		  AND por_id = (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id)
		  ORDER BY men_ordre, sme_ordre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_sousmenus_liste_depuis_topmenu(prm_token integer, prm_tom_id integer, prm_ent_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenus_liste_depuis_topmenu(prm_token integer, prm_tom_id integer, prm_ent_code character varying) IS 'Retourne la liste des fiches d''un type de personne accessible dans un portail.';


--
-- Name: meta_sousmenus_reordonne(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_sousmenus_reordonne(prm_token integer, prm_men_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	i integer;
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	i = 1;
	FOR row IN
		SELECT sme_id FROM meta.sousmenu WHERE men_id = prm_men_id ORDER BY sme_ordre
	LOOP
		UPDATE meta.sousmenu SET sme_ordre = i WHERE sme_id = row.sme_id;
		i = i + 1;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_sousmenus_reordonne(prm_token integer, prm_men_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_sousmenus_reordonne(prm_token integer, prm_men_id integer) IS 'Réordonne des fiches m''un menu personne.';


--
-- Name: meta_statut_usager_calcule(character varying, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_statut_usager_calcule(prm_inf_code character varying, prm_per_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	pin integer;
	pii integer;
BEGIN
	SELECT pin_id INTO pin FROM personne_info WHERE inf_code = prm_inf_code AND per_id = prm_per_id;
	IF NOT FOUND THEN
		INSERT INTO personne_info (inf_code, per_id) VALUES (prm_inf_code, prm_per_id) RETURNING pin_id INTO pin;
	END IF;

	SELECT pii_id INTO pii FROM personne_info_integer WHERE pin_id = pin;
	IF NOT FOUND THEN
		INSERT INTO personne_info_integer (pin_id) VALUES (pin) RETURNING pii_id INTO pii;
	END IF;

	ret = 5;
	IF EXISTS (SELECT 1 FROM personne_groupe WHERE per_id = prm_per_id AND peg_cycle_statut = 3) THEN -- Terminé
		ret = 1; -- Sorti
	END IF;
	IF EXISTS (SELECT 1 FROM personne_groupe WHERE per_id = prm_per_id AND peg_cycle_statut = 1) THEN -- Demandé
		ret = 2; -- Pré-admission
	END IF;
	IF EXISTS (SELECT 1 FROM personne_groupe WHERE per_id = prm_per_id AND peg_cycle_statut = 2 AND (peg_debut ISNULL OR peg_debut > CURRENT_TIMESTAMP)) THEN -- Accepté, pas encore présent
		ret = 3; -- Admission
	END IF;
	IF EXISTS (SELECT 1 FROM personne_groupe WHERE per_id = prm_per_id AND peg_cycle_statut = 2 AND (peg_debut ISNULL OR peg_debut < CURRENT_TIMESTAMP)) THEN -- Accepté, présent
		ret = 4; -- Présent
	END IF;

	UPDATE personne_info_integer SET pii_valeur = ret WHERE pii_id = pii;
--	RAISE WARNING 'statut % : %', prm_per_id, ret;
	RETURN ret;
END;
$$;


--
-- Name: meta_topmenu_add_end(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	int_ordre integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(tom_ordre) + 1 INTO int_ordre FROM meta.topmenu WHERE por_id = prm_por_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.topmenu (por_id, tom_libelle, tom_ordre) VALUES (prm_por_id, prm_libelle, int_ordre)
		RETURNING tom_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_add_end(prm_token integer, prm_por_id integer, prm_libelle character varying) IS 'Ajoute une entrée dans un menu principal.';


--
-- Name: meta_topmenu_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_delete(prm_token integer, prm_tom_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM meta.topmenu WHERE tom_id = prm_tom_id;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_delete(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_delete(prm_token integer, prm_tom_id integer) IS 'Supprime une entrée dans un menu principal.';


--
-- Name: meta_topmenu_deplacer_bas(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_deplacer_bas(prm_token integer, prm_tom_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_topmenus_reordonne (prm_token, (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id));
	IF (SELECT tom_ordre FROM meta.topmenu WHERE tom_id = prm_tom_id) = (SELECT MAX(tom_ordre) FROM meta.topmenu WHERE
	 		por_id = (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id))
	THEN RETURN; END IF;
	UPDATE meta.topmenu SET tom_ordre = tom_ordre + 1 WHERE tom_id = prm_tom_id;
	UPDATE meta.topmenu SET tom_ordre = tom_ordre - 1 WHERE 
		por_id = (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id) AND 
		tom_ordre = (SELECT tom_ordre FROM meta.topmenu WHERE tom_id = prm_tom_id) AND
		tom_id <> prm_tom_id;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_deplacer_bas(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_deplacer_bas(prm_token integer, prm_tom_id integer) IS 'Déplace une entrée de menu principal vers le bas.';


--
-- Name: meta_topmenu_deplacer_haut(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_deplacer_haut(prm_token integer, prm_tom_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_topmenus_reordonne (prm_token, (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id));
	IF (SELECT tom_ordre FROM meta.topmenu WHERE tom_id = prm_tom_id) = 1 THEN RETURN; END IF;
	UPDATE meta.topmenu SET tom_ordre = tom_ordre - 1 WHERE tom_id = prm_tom_id;
	UPDATE meta.topmenu SET tom_ordre = tom_ordre + 1 WHERE 
		por_id = (SELECT por_id FROM meta.topmenu WHERE tom_id = prm_tom_id) AND 
		tom_ordre = (SELECT tom_ordre FROM meta.topmenu WHERE tom_id = prm_tom_id) AND
		tom_id <> prm_tom_id;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_deplacer_haut(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_deplacer_haut(prm_token integer, prm_tom_id integer) IS 'Déplace une entrée de menu principal vers le haut.';


--
-- Name: topmenu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE topmenu (
    tom_id integer NOT NULL,
    tom_libelle character varying,
    tom_ordre integer,
    por_id integer
);


--
-- Name: TABLE topmenu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE topmenu IS 'Menu principal';


--
-- Name: meta_topmenu_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_get(prm_token integer, prm_tom_id integer) RETURNS topmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.topmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.topmenu WHERE tom_id = prm_tom_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_get(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_get(prm_token integer, prm_tom_id integer) IS 'Retourne les informations d''une entrée de menu principal (pour webdav).';


--
-- Name: meta_topmenu_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_liste(prm_token integer, prm_por_id integer) RETURNS SETOF topmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.topmenu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.topmenu WHERE por_id = prm_por_id ORDER BY tom_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_liste(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_liste(prm_token integer, prm_por_id integer) IS 'Retourne la liste des entrées de menu principal d''un portail donné.';


--
-- Name: meta_topmenu_liste_contenant_type(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_liste_contenant_type(prm_token integer, prm_por_id integer, prm_type character varying) RETURNS SETOF topmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.topmenu%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT topmenu.* FROM meta.topmenu
 	        INNER JOIN meta.topsousmenu USING(tom_id)
		INNER JOIN liste.liste ON liste.lis_id = tsm_type_id
		INNER JOIN meta.entite USING(ent_id)		
	        WHERE tsm_type = 'liste' AND ent_code = prm_type AND por_id = prm_por_id ORDER BY tom_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_liste_contenant_type(prm_token integer, prm_por_id integer, prm_type character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_liste_contenant_type(prm_token integer, prm_por_id integer, prm_type character varying) IS 'Retourne la liste des entrées de menu contenant des fiches de type liste pour une catégorie de personne donnée (pour webdav).';


--
-- Name: meta_topmenu_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenu_rename(prm_token integer, prm_tom_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.topmenu SET tom_libelle = prm_libelle WHERE tom_id = prm_tom_id;
END;
$$;


--
-- Name: FUNCTION meta_topmenu_rename(prm_token integer, prm_tom_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenu_rename(prm_token integer, prm_tom_id integer, prm_libelle character varying) IS 'Renomme une entrée de menu principal.';


--
-- Name: meta_topmenus_reordonne(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topmenus_reordonne(prm_token integer, prm_por_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	i integer;
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	i = 1;
	FOR row IN
		SELECT tom_id FROM meta.topmenu WHERE por_id = prm_por_id ORDER BY tom_ordre
	LOOP
		UPDATE meta.topmenu SET tom_ordre = i WHERE tom_id = row.tom_id;
		i = i + 1;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topmenus_reordonne(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topmenus_reordonne(prm_token integer, prm_por_id integer) IS 'Réordonne les entrées du menu principal d''un portail donné.';


--
-- Name: meta_topsousmenu_add_end(integer, integer, character varying, character varying, character varying, integer, character varying, boolean, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_add_end(prm_token integer, prm_tom_id integer, prm_libelle character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_titre character varying, prm_droit_modif boolean, prm_droit_suppression boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	int_ordre integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	SELECT MAX(tsm_ordre) + 1 INTO int_ordre FROM meta.topsousmenu WHERE tom_id = prm_tom_id;
	IF int_ordre ISNULL THEN int_ordre = 0; END IF;
	INSERT INTO meta.topsousmenu (tom_id, tsm_libelle, tsm_ordre,tsm_icone, tsm_type, tsm_type_id, tsm_titre, tsm_droit_modif, tsm_droit_suppression) VALUES (prm_tom_id, prm_libelle, int_ordre, prm_icone, prm_type, prm_type_id, prm_titre, prm_droit_modif, prm_droit_suppression)
		RETURNING tsm_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_add_end(prm_token integer, prm_tom_id integer, prm_libelle character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_titre character varying, prm_droit_modif boolean, prm_droit_suppression boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_add_end(prm_token integer, prm_tom_id integer, prm_libelle character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_titre character varying, prm_droit_modif boolean, prm_droit_suppression boolean) IS 'Rajoute une fiche de menu principal.';


--
-- Name: meta_topsousmenu_delete(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_delete(prm_token integer, prm_tsm_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM procedure.procedure_affectation WHERE tsm_id = prm_tsm_id;
	DELETE FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_delete(prm_token integer, prm_tsm_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_delete(prm_token integer, prm_tsm_id integer) IS 'Supprime une fiche de menu principal.';


--
-- Name: meta_topsousmenu_deplacer_bas(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_deplacer_bas(prm_token integer, prm_tsm_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_topsousmenus_reordonne (prm_token, (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id));
	IF (SELECT tsm_ordre FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) = (SELECT MAX(tsm_ordre) FROM meta.topsousmenu WHERE
	 		tom_id = (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id))
	THEN RETURN; END IF;
	UPDATE meta.topsousmenu SET tsm_ordre = tsm_ordre + 1 WHERE tsm_id = prm_tsm_id;
	UPDATE meta.topsousmenu SET tsm_ordre = tsm_ordre - 1 WHERE 
		tom_id = (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) AND 
		tsm_ordre = (SELECT tsm_ordre FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) AND
		tsm_id <> prm_tsm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_deplacer_bas(prm_token integer, prm_tsm_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_deplacer_bas(prm_token integer, prm_tsm_id integer) IS 'Déplace une fiche de menu principal vers le bas.';


--
-- Name: meta_topsousmenu_deplacer_haut(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_deplacer_haut(prm_token integer, prm_tsm_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	PERFORM meta.meta_topsousmenus_reordonne (prm_token, (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id));
	IF (SELECT tsm_ordre FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) = 1 THEN RETURN; END IF;
	UPDATE meta.topsousmenu SET tsm_ordre = tsm_ordre - 1 WHERE tsm_id = prm_tsm_id;
	UPDATE meta.topsousmenu SET tsm_ordre = tsm_ordre + 1 WHERE 
		tom_id = (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) AND 
		tsm_ordre = (SELECT tsm_ordre FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id) AND
		tsm_id <> prm_tsm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_deplacer_haut(prm_token integer, prm_tsm_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_deplacer_haut(prm_token integer, prm_tsm_id integer) IS 'Déplace une fiche de menu principal vers le haut.';


--
-- Name: topsousmenu; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE topsousmenu (
    tsm_id integer NOT NULL,
    tom_id integer,
    tsm_libelle character varying,
    tsm_ordre integer,
    tsm_icone character varying,
    tsm_script character varying,
    tsm_type character varying,
    tsm_type_id integer,
    tsm_titre character varying,
    tsm_droit_modif boolean DEFAULT true,
    tsm_droit_suppression boolean DEFAULT true,
    sme_id_lien_usager integer
);


--
-- Name: TABLE topsousmenu; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE topsousmenu IS 'Sous-menus du menu principal';


--
-- Name: meta_topsousmenu_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_get(prm_token integer, prm_tsm_id integer) RETURNS topsousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.topsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.topsousmenu WHERE tsm_id = prm_tsm_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_get(prm_token integer, prm_tsm_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_get(prm_token integer, prm_tsm_id integer) IS 'Retourne les informations d''une fiche de menu principal.';


--
-- Name: meta_topsousmenu_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_liste(prm_token integer, prm_tom_id integer) RETURNS SETOF topsousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.topsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT * FROM meta.topsousmenu WHERE tom_id = prm_tom_id ORDER BY tsm_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_liste(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_liste(prm_token integer, prm_tom_id integer) IS 'Retourne la liste des fiches d''une entrée de menu principal.';


--
-- Name: meta_topsousmenu_liste_type(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_liste_type(prm_token integer, prm_tom_id integer, prm_type character varying) RETURNS SETOF topsousmenu
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.topsousmenu;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT topsousmenu.* FROM meta.topsousmenu 
		INNER JOIN liste.liste ON liste.lis_id = tsm_type_id
		INNER JOIN meta.entite USING(ent_id)
		WHERE tsm_type = 'liste' AND ent_code = prm_type AND tom_id = prm_tom_id ORDER BY tsm_ordre 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_liste_type(prm_token integer, prm_tom_id integer, prm_type character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_liste_type(prm_token integer, prm_tom_id integer, prm_type character varying) IS 'Retourne la liste des fiches de type liste pour une catégorie de personne donnée d''une entrée de menu principal d''un type donné (webdav).';


--
-- Name: meta_topsousmenu_rename(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_rename(prm_token integer, prm_tsm_id integer, prm_libelle character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.topsousmenu SET tsm_libelle = prm_libelle WHERE tsm_id = prm_tsm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_rename(prm_token integer, prm_tsm_id integer, prm_libelle character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_rename(prm_token integer, prm_tsm_id integer, prm_libelle character varying) IS 'Renomme une fiche de menu principal.';


--
-- Name: meta_topsousmenu_set_droit_modif(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE meta.topsousmenu SET tsm_droit_modif = prm_droit_modif WHERE tsm_id = prm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_set_droit_modif(prm_token integer, prm_id integer, prm_droit_modif boolean) IS 'Indique si l''utilisateur a droit de modification sur cette fiche.';


--
-- Name: meta_topsousmenu_set_droit_suppression(integer, integer, boolean); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE meta.topsousmenu SET tsm_droit_suppression = prm_droit_suppression WHERE tsm_id = prm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_set_droit_suppression(prm_token integer, prm_id integer, prm_droit_suppression boolean) IS 'Indique si l''utilisateur a droit de suppression sur cette fiche.';


--
-- Name: meta_topsousmenu_update(integer, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenu_update(prm_token integer, prm_tsm_id integer, prm_titre character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_sme_id_lien_usager integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	UPDATE meta.topsousmenu SET tsm_icone = prm_icone, tsm_type = prm_type, tsm_type_id = prm_type_id, tsm_titre = prm_titre, sme_id_lien_usager = prm_sme_id_lien_usager WHERE tsm_id = prm_tsm_id;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenu_update(prm_token integer, prm_tsm_id integer, prm_titre character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_sme_id_lien_usager integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenu_update(prm_token integer, prm_tsm_id integer, prm_titre character varying, prm_icone character varying, prm_type character varying, prm_type_id integer, prm_sme_id_lien_usager integer) IS 'Modifie les informations d''une fiche de menu principal.';


--
-- Name: meta_topsousmenus_reordonne(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION meta_topsousmenus_reordonne(prm_token integer, prm_tom_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	i integer;
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	i = 1;
	FOR row IN
		SELECT tsm_id FROM meta.topsousmenu WHERE tom_id = prm_tom_id ORDER BY tsm_ordre
	LOOP
		UPDATE meta.topsousmenu SET tsm_ordre = i WHERE tsm_id = row.tsm_id;
		i = i + 1;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION meta_topsousmenus_reordonne(prm_token integer, prm_tom_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION meta_topsousmenus_reordonne(prm_token integer, prm_tom_id integer) IS 'Réordonne les fiches d''une entrée de menu principal.';


--
-- Name: metier_add(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_add(prm_token integer, prm_nom character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	INSERT INTO meta.metier (met_nom) VALUES (prm_nom) RETURNING met_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION metier_add(prm_token integer, prm_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_add(prm_token integer, prm_nom character varying) IS 'Ajoute un métier.';


--
-- Name: metier_entite_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_entite_liste(prm_token integer, prm_met_id integer) RETURNS SETOF entite
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.entite;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT entite.* FROM meta.entite
		INNER JOIN meta.metier_entite USING(ent_id)
		WHERE met_id = prm_met_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION metier_entite_liste(prm_token integer, prm_met_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_entite_liste(prm_token integer, prm_met_id integer) IS 'Retourne la liste des types de personnes auxquels est affecté un métier.';


--
-- Name: metier_entites_set(integer, integer, character varying[]); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_entites_set(prm_token integer, prm_met_id integer, prm_entites character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM meta.metier_entite WHERE met_id = prm_met_id;
	IF prm_entites NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_entites, 1) LOOP
			INSERT INTO meta.metier_entite (met_id, ent_id) VALUES (prm_met_id, (SELECT ent_id FROM meta.entite WHERE ent_code = prm_entites[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION metier_entites_set(prm_token integer, prm_met_id integer, prm_entites character varying[]); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_entites_set(prm_token integer, prm_met_id integer, prm_entites character varying[]) IS 'Affecte un métier à des types de personnes.';


--
-- Name: metier; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE metier (
    met_id integer NOT NULL,
    met_nom character varying
);


--
-- Name: TABLE metier; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE metier IS 'Liste des métiers';


--
-- Name: metier_get(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_get(prm_token integer, prm_met_id integer) RETURNS metier
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret meta.metier;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM meta.metier WHERE met_id = prm_met_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION metier_get(prm_token integer, prm_met_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_get(prm_token integer, prm_met_id integer) IS 'Retourne les informations d''un métier.';


--
-- Name: metier_liste(integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_liste(prm_token integer, prm_ent_code character varying) RETURNS SETOF metier
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.metier;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT metier.* FROM meta.metier 
			INNER JOIN meta.metier_entite USING(met_id)
			INNER JOIN meta.entite USING(ent_id) 
			WHERE ent_code = prm_ent_code
			ORDER BY metier.met_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION metier_liste(prm_token integer, prm_ent_code character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_liste(prm_token integer, prm_ent_code character varying) IS 'Retourne la liste des métiers affectés à un type de personne.';


--
-- Name: metier_liste_details(integer, integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_liste_details(prm_token integer, prm_ent_id integer, prm_sec_id integer) RETURNS SETOF metier_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.metier_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT met_id, met_nom, concatenate (DISTINCT sec_nom), concatenate (DISTINCT ent_libelle)
		FROM meta.metier
		LEFT JOIN meta.metier_secteur USING(met_id)
		LEFT JOIN meta.secteur USING(sec_id)
		LEFT JOIN meta.metier_entite USING(met_id)
		LEFT JOIN meta.entite USING(ent_id)
		WHERE (prm_ent_id ISNULL OR ent_id = prm_ent_id)
		AND (prm_sec_id ISNULL OR sec_id = prm_sec_id)
		GROUP BY met_id, met_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION metier_liste_details(prm_token integer, prm_ent_id integer, prm_sec_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_liste_details(prm_token integer, prm_ent_id integer, prm_sec_id integer) IS 'Retourne la liste détaillée des métiers affectés à un type de personne et assignés à un secteur donné.';


--
-- Name: metier_secteur_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_secteur_liste(prm_token integer, prm_met_id integer) RETURNS SETOF secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
		INNER JOIN meta.metier_secteur USING(sec_id)
		WHERE met_id = prm_met_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION metier_secteur_liste(prm_token integer, prm_met_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_secteur_liste(prm_token integer, prm_met_id integer) IS 'Retourne la liste des secteurs assignés à un métier.';


--
-- Name: metier_secteur_metier_liste(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_secteur_metier_liste(prm_token integer, prm_sec_id integer) RETURNS SETOF metier
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.metier;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT metier.* FROM meta.metier
		INNER JOIN meta.metier_secteur USING(met_id)
		WHERE sec_id = prm_sec_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION metier_secteur_metier_liste(prm_token integer, prm_sec_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_secteur_metier_liste(prm_token integer, prm_sec_id integer) IS 'Retourne la liste des métiers assignés à un secteur donné.';


--
-- Name: metier_secteurs_set(integer, integer, character varying[]); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_secteurs_set(prm_token integer, prm_met_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM meta.metier_secteur WHERE met_id = prm_met_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO meta.metier_secteur (met_id, sec_id) VALUES (prm_met_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION metier_secteurs_set(prm_token integer, prm_met_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_secteurs_set(prm_token integer, prm_met_id integer, prm_secteurs character varying[]) IS 'Assigne des secteurs à un métier.';


--
-- Name: metier_supprime(integer, integer); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_supprime(prm_token integer, prm_met_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM meta.metier_secteur WHERE met_id = prm_met_id;
	DELETE FROM meta.metier_entite WHERE met_id = prm_met_id;
	DELETE FROM meta.metier WHERE met_id = prm_met_id;
END;
$$;


--
-- Name: FUNCTION metier_supprime(prm_token integer, prm_met_id integer); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_supprime(prm_token integer, prm_met_id integer) IS 'Supprime un métier.';


--
-- Name: metier_update(integer, integer, character varying); Type: FUNCTION; Schema: meta; Owner: -
--

CREATE FUNCTION metier_update(prm_token integer, prm_met_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE meta.metier SET met_nom = prm_nom WHERE met_id = prm_met_id;
END;
$$;


--
-- Name: FUNCTION metier_update(prm_token integer, prm_met_id integer, prm_nom character varying); Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON FUNCTION metier_update(prm_token integer, prm_met_id integer, prm_nom character varying) IS 'Modifie les informations d''un métier.';


SET search_path = notes, pg_catalog;

--
-- Name: note_destinataire_derniers_par_utilisateur(integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION note_destinataire_derniers_par_utilisateur(prm_token integer) RETURNS SETOF note_destinataire_derniers_par_utilisateur
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row notes.note_destinataire_derniers_par_utilisateur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN
		select DISTINCT per_id, personne_get_libelle (prm_token, per_id), MAX(not_date_saisie) FROM login.utilisateur
		inner join notes.note_destinataire using(uti_id)
		inner join notes.note using(not_id)
		where uti_id_auteur = uti
		group by utilisateur.per_id
		order by MAX(not_date_saisie) desc
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION note_destinataire_derniers_par_utilisateur(prm_token integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION note_destinataire_derniers_par_utilisateur(prm_token integer) IS 'Retourne la liste des utilisateurs destinataires de notes de l''utilisateur authentifié, les plus récents en premier.
Entrées : 
 - prm_token : Token d''authentification
Retour : 
 - per_id : Identifiant de la personne
 - libelle : Nom et prénom de la personne
';


--
-- Name: note_destinataires_liste(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION note_destinataires_liste(prm_token integer, prm_not_id integer) RETURNS SETOF note_destinataires_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row notes.note_destinataires_liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT 
		       personne_get_libelle (prm_token, per_id), 
		       nde_pour_action, 
		       nde_pour_information, 
		       nde_action_faite, 
		       nde_information_lue, 
		       nde_supprime 
		FROM personne 
		INNER JOIN login.utilisateur USING(per_id) 
		INNER JOIN notes.note_destinataire USING(uti_id) 
		WHERE not_id = prm_not_id
		ORDER BY personne_get_libelle (prm_token, per_id)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION note_destinataires_liste(prm_token integer, prm_not_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION note_destinataires_liste(prm_token integer, prm_not_id integer) IS 'Retourne la liste des destinataires d''une note.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour :
 - libelle : Nom et préom du destinataire
 - nde_pour_action : Indique si la note a été envoyée à ce destinataire pour action
 - nde_pour_information : Indique si la note a été envoyée à ce destinataire pour information
 - nde_action_faite : Indique si le destinataire a marqué l''action comme faite (si envoyée pour action à ce destinataire)
 - nde_information_lue : Indique si le destinataire a marqué la note lue (si envoyée pour information à ce destinataire)';


--
-- Name: note_destinataires_liste_autres(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION note_destinataires_liste_autres(prm_token integer, prm_not_id integer) RETURNS SETOF character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN
		SELECT personne_get_libelle (prm_token, per_id) FROM personne 
		INNER JOIN login.utilisateur USING(per_id) 
		INNER JOIN notes.note_destinataire USING(uti_id) 
		WHERE not_id = prm_not_id AND uti_id <> uti
		ORDER BY personne_get_libelle (prm_token, per_id)
	LOOP
		RETURN NEXT row.personne_get_libelle;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION note_destinataires_liste_autres(prm_token integer, prm_not_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION note_destinataires_liste_autres(prm_token integer, prm_not_id integer) IS 'Retourne la liste des noms et prénoms des destinataires d''une note, autres que l''utilisateur authentifié.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour : 
 - Nom et prénom du destinataire';


--
-- Name: note_usagers_liste(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION note_usagers_liste(prm_token integer, prm_not_id integer) RETURNS SETOF note_usagers_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row notes.note_usagers_liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT per_id, personne_get_libelle (prm_token, per_id) FROM notes.note_usager WHERE not_id = prm_not_id
		ORDER BY personne_get_libelle (prm_token, per_id)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION note_usagers_liste(prm_token integer, prm_not_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION note_usagers_liste(prm_token integer, prm_not_id integer) IS 'Retourne les usagers rattachés à une note.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour : 
 - per_id : Identifiant de l''usager
 - libelle : Nom et prénom de l''usager';


--
-- Name: notes_note_ajoute(integer, timestamp with time zone, character varying, text, integer, integer[], integer[], integer[], integer[], integer[]); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_ajoute(prm_token integer, prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	new_not_id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	INSERT INTO notes.note (not_date_saisie, not_date_evenement, not_objet, not_texte, uti_id_auteur, eta_id_auteur)
		VALUES (CURRENT_TIMESTAMP, prm_date_evenement, prm_objet, prm_texte, uti, prm_eta_id_auteur)
		RETURNING not_id INTO new_not_id;
	IF prm_usagers NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_usagers, 1) LOOP
			INSERT INTO notes.note_usager (not_id, per_id) VALUES (new_not_id, prm_usagers[i]);
		END LOOP;
	END IF;
	IF prm_dests NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_dests, 1) LOOP
			INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_information) VALUES (new_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_dests[i] ORDER BY uti_id LIMIT 1), true);
		END LOOP;
	END IF;
	IF prm_destsaction NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_destsaction, 1) LOOP
			INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_action) VALUES (new_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_destsaction[i]), true);
		END LOOP;
	END IF;
	IF prm_deststheme NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_deststheme, 1) LOOP
			INSERT INTO notes.note_theme (not_id, the_id) VALUES (new_not_id, prm_deststheme[i]);
		END LOOP;
	END IF;
	IF prm_groupes NOTNULL THEN
		FOR i IN 1 .. array_upper (prm_groupes, 1) LOOP
			INSERT INTO notes.note_groupe (not_id, grp_id) VALUES (new_not_id, prm_groupes[i]);
		END LOOP;
	END IF;
	RETURN new_not_id;
END;
$$;


--
-- Name: FUNCTION notes_note_ajoute(prm_token integer, prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_ajoute(prm_token integer, prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]) IS 'Envoie une note.
Entrées : 
 - prm_token : Token d''authentification. L''auteur de la note sera l''utilisateur authentifié
 - prm_date_evenement : Date de l''événement décrit par la note
 - prm_objet : Objet de la note (facultatid)
 - prm_texte : Contenu de la note
 - prm_eta_id_auteur : Identifiant de l''établissement auquel rattacher la note. Doit être un établissement accessible à l''utilisateur authentifié (TODO : à vérifier)
 - prm_usagers : Liste des identifiants des usagers auxquels rattacher la note
 - prm_dests : Liste des identifiants des destinataires pour information
 - prm_destsaction : Liste des identifiants des destinataires pour action
 - prm_deststheme : Liste des identifiants des boîtes thématiques dans lesquelles classer la note
 - prm_groupes : Liste des groupes d''usagers auxquels rattacher la note
Retour : 
L''identifiant de la note.
';


--
-- Name: notes_note_boite_envoi_liste(integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_boite_envoi_liste(prm_token integer) RETURNS SETOF notes_note_boite_envoi_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row notes.notes_note_boite_envoi_liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN
		SELECT not_id, not_date_saisie, not_date_evenement, not_objet, not_texte, eta_id_auteur
			FROM notes.note
			WHERE uti_id_auteur = uti
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION notes_note_boite_envoi_liste(prm_token integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_boite_envoi_liste(prm_token integer) IS 'Retourne la liste des notes envoyées par l''utilisateur authentifié.
Entrées :
 - prm_token : Token d''authentification
Retour :
 - not_id : Identifiant de la note
 - not_date_saisie : Date de saisie de la note 
 - not_date_evenement : Date de l''événement décrit par la note
 - not_objet : Objet de la note
 - not_texte : Contenu de la note
 - eta_id _auteur : Identifiant de l''établissement auquel est rattachée la note';


--
-- Name: notes_note_boite_reception_liste(integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_boite_reception_liste(prm_token integer) RETURNS SETOF notes_note_boite_reception_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row notes.notes_note_boite_reception_liste;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN
		SELECT not_id, not_date_saisie, not_date_evenement, not_objet, not_texte, uti_id_auteur, eta_id_auteur, 
			nde_id, nde_pour_action, nde_pour_information, nde_action_faite, nde_information_lue 
			FROM notes.note
			INNER JOIN notes.note_destinataire USING(not_id)
			WHERE note_destinataire.uti_id = uti AND NOT nde_supprime
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION notes_note_boite_reception_liste(prm_token integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_boite_reception_liste(prm_token integer) IS 'Retourne la liste des notes dont l''utilisateur authentifié est destinataire.
Entrées : 
 - prm_token : Token d''authentification
Retour : 
 - not_id : Identifiant de la note
 - not_date_saisie : Date de saisie de la note
 - not_date_evenement : Date de l''événement décrit par la note
 - not_objet : Objet de la note
 - not_texte : Contenu de la note
 - uti_id_auteur : Identifiant de l''auteur de la note
 - eta_id_auteur : Identifiant de l''établissement auquel est rattachée la note
 - nde_id : Identifiant des informations liées au destinataire de cette note
 - nde_pour_action : Note pour action pour le destinataire authentifié
 - nde_pour_information : Note pour information pour le destinataire authentifié
 - nde_action_faite : L''action a été marquée comme faite par le destinataire authentifié
 - nde_information_lue : La note a été marquée comme lue par le destinataire authentifié
';


--
-- Name: notes_note_boite_reception_nombre_non_lu(integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_boite_reception_nombre_non_lu(prm_token integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	SELECT count(*) INTO ret 
		FROM notes.note
		INNER JOIN notes.note_destinataire USING(not_id)
		WHERE note_destinataire.uti_id = uti AND NOT nde_supprime AND NOT nde_information_lue AND NOT nde_action_faite;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION notes_note_boite_reception_nombre_non_lu(prm_token integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_boite_reception_nombre_non_lu(prm_token integer) IS 'Retourne le nombre de notes dont l''utilisateur authentifié est destinataire et qui n''ont pas encore été marquées comme lues ou faite.
Entrées : 
 - prm_token : Token d''authentification
Retour : 
 - le nombre de notes.
';


--
-- Name: notes_note_destinataire_ajoute_forward_pour_info(integer, integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_destinataire_ajoute_forward_pour_info(prm_token integer, prm_not_id integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_information)
		VALUES (prm_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_per_id), TRUE);
END;
$$;


--
-- Name: FUNCTION notes_note_destinataire_ajoute_forward_pour_info(prm_token integer, prm_not_id integer, prm_per_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_destinataire_ajoute_forward_pour_info(prm_token integer, prm_not_id integer, prm_per_id integer) IS 'Ajoute un destinataire pour information à une note (forward de la note).
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
 - prm_per_id : Identifiant de la personne destinataire pour information';


--
-- Name: notes_note_destinataire_marque_done(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_destinataire_marque_done(prm_token integer, prm_nde_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE notes.note_destinataire SET nde_information_lue = TRUE WHERE nde_pour_information AND nde_id = prm_nde_id;
	UPDATE notes.note_destinataire SET nde_action_faite = TRUE WHERE nde_pour_action AND nde_id = prm_nde_id;
END;
$$;


--
-- Name: FUNCTION notes_note_destinataire_marque_done(prm_token integer, prm_nde_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_destinataire_marque_done(prm_token integer, prm_nde_id integer) IS 'Marque un message comme lu/fait.
TODO : Vérifier que l''utilisateur authentifié est bien le destinataire de prm_nde_id
Entrées :
 - prm_token : Token d''authentification
 - prm_nde_id : Identifiant des informations liées au destinataire de cette note (obtenu avec la fonction notes_note_boite_reception_liste)';


--
-- Name: notes_note_mesnotes(integer, integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer) RETURNS SETOF notes_note_mesnotes
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row notes.notes_note_mesnotes;
	the integer DEFAULT NULL;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	IF prm_nos_id NOTNULL THEN
		SELECT the_id INTO the FROM notes.notes WHERE nos_id = prm_nos_id;
	END IF;
	IF the ISNULL THEN
		FOR row IN
			select DISTINCT note.* FROM notes.note 
				inner join notes.note_usager using(not_id)
				inner join login.utilisateur_usagers_liste (prm_token, prm_grp_id, false) on utilisateur_usagers_liste.per_id = note_usager.per_id
		LOOP
			RETURN NEXT row;
		END LOOP;
	ELSE
		FOR row IN
			select DISTINCT note.* FROM notes.note 
				inner join notes.note_usager using(not_id)
				inner join notes.note_theme USING(not_id)
				inner join login.utilisateur_usagers_liste (prm_token, prm_grp_id, false) on utilisateur_usagers_liste.per_id = note_usager.per_id
				WHERE the_id = the
		LOOP
			RETURN NEXT row;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer) IS 'Retourne la liste des notes intéressant l''utilisateur authentifié. Les notes "intéressantes" sont celles rattachées aux usagers dont l''utilisateur a accès (via les groupes d''usagers/groupes d''utilisateurs).
Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Filtre sur un groupe d''usagers en particulier, ou NULL
 - prm_nos_id : Identifiant de pages de notes (pour appliquer des filtres définis dans cette page)';


--
-- Name: notes_note_supprime(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_supprime(prm_token integer, prm_not_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM notes.note_destinataire WHERE not_id = prm_not_id;
	DELETE FROM notes.note_groupe WHERE not_id = prm_not_id;
	DELETE FROM notes.note_usager WHERE not_id = prm_not_id;
	DELETE FROM notes.note_theme WHERE not_id = prm_not_id;
	DELETE FROM notes.note WHERE not_id = prm_not_id;
END;
$$;


--
-- Name: FUNCTION notes_note_supprime(prm_token integer, prm_not_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_supprime(prm_token integer, prm_not_id integer) IS 'Supprime une note. 
Entrées : 
 - prm_token : Token d''authentification
 - not_id : Identifiant de la note à supprimer';


--
-- Name: note; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE note (
    not_id integer NOT NULL,
    not_date_saisie timestamp with time zone,
    not_date_evenement timestamp with time zone,
    not_objet character varying,
    not_texte text,
    uti_id_auteur integer,
    eta_id_auteur integer
);


--
-- Name: TABLE note; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE note IS 'Notes envoyées entre utilisateurs';


--
-- Name: notes_note_usager_liste(integer, integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_note_usager_liste(prm_token integer, prm_per_id integer, prm_nos_id integer) RETURNS SETOF note
    LANGUAGE plpgsql
    AS $$
DECLARE
	the integer;
	row notes.note;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT the_id INTO the FROM notes.notes WHERE nos_id = prm_nos_id;
	IF the ISNULL THEN
		FOR row IN
			SELECT note.* FROM notes.note 
				INNER JOIN notes.note_usager USING(not_id)
				WHERE per_id = prm_per_id
		LOOP
			RETURN NEXT row;
		END LOOP;
	ELSE
		FOR row IN
			SELECT note.* FROM notes.note 
				INNER JOIN notes.note_usager USING(not_id)
				INNER JOIN notes.note_theme USING(not_id)
				WHERE per_id = prm_per_id AND the_id = the
		LOOP
			RETURN NEXT row;
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION notes_note_usager_liste(prm_token integer, prm_per_id integer, prm_nos_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_note_usager_liste(prm_token integer, prm_per_id integer, prm_nos_id integer) IS 'Retourne les notes rattachées à un usager.
Entrées :
 - prm_token : Token d''authentification
 - prm_per_id : Identifiant de l''usager
TODO : Vérifier que l''utilisateur authentifié a droit d''accès à cet usager
';


--
-- Name: notes; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE notes (
    nos_id integer NOT NULL,
    the_id integer,
    nos_nom character varying
);


--
-- Name: TABLE notes; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE notes IS 'Liste des pages de notes disponibles pour placer dans le menu principal ou usager';


--
-- Name: notes_notes_get(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_notes_get(prm_token integer, prm_nos_id integer) RETURNS notes
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret notes.notes;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM notes.notes WHERE nos_id = prm_nos_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION notes_notes_get(prm_token integer, prm_nos_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_notes_get(prm_token integer, prm_nos_id integer) IS 'Retourne les informations sur la configuration d''une page de notes.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de la page de notes.
';


--
-- Name: notes_notes_liste(integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_notes_liste(prm_token integer) RETURNS SETOF notes
    LANGUAGE plpgsql
    AS $$
DECLARE
	row notes.notes;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	FOR row IN SELECT * FROM notes.notes ORDER BY nos_nom LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION notes_notes_liste(prm_token integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_notes_liste(prm_token integer) IS 'Retourne la liste des informations de configuration de pages de notes, à placer dans le menu principal ou usager.
Remarque : 
Nécessite le droit de configuration de l''interface
';


--
-- Name: notes_notes_supprime(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_notes_supprime(prm_token integer, prm_nos_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM notes.notes WHERE nos_id = prm_nos_id;
END;
$$;


--
-- Name: FUNCTION notes_notes_supprime(prm_token integer, prm_nos_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_notes_supprime(prm_token integer, prm_nos_id integer) IS 'Supprime une configuration de page de notes.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de page de notes
Remarque :
Nécessite le droit de configuration de l''interface';


--
-- Name: notes_notes_update(integer, integer, character varying, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_notes_update(prm_token integer, prm_nos_id integer, prm_nom character varying, prm_the_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	IF prm_nos_id NOTNULL THEN
		UPDATE notes.notes SET nos_nom = prm_nom, the_id = prm_the_id WHERE nos_id = prm_nos_id;
		RETURN prm_nos_id;
	ELSE
		INSERT INTO notes.notes (the_id, nos_nom) VALUES (prm_the_id, prm_nom) RETURNING nos_id INTO ret;
		RETURN ret;
	END IF;
END;
$$;


--
-- Name: FUNCTION notes_notes_update(prm_token integer, prm_nos_id integer, prm_nom character varying, prm_the_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_notes_update(prm_token integer, prm_nos_id integer, prm_nom character varying, prm_the_id integer) IS 'Modifie les informations de configuration d''une page de notes ou crée une nouvelle configuration.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de page à modifier ou NULL pour créer une nouvelle configuration
 - prm_nom : Nouveau nom de page
 - prm_the_id : Identifiant de la boîte thématique permettant de filtrer les notes sur cette page
Remarque :
Nécessite le droit de configuration de l''interface';


--
-- Name: theme; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE theme (
    the_id integer NOT NULL,
    the_nom character varying
);


--
-- Name: TABLE theme; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE theme IS 'Liste des boîtes thématiques';


--
-- Name: notes_theme_get(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_theme_get(prm_token integer, prm_the_id integer) RETURNS theme
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret notes.theme;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM notes.theme WHERE the_id = prm_the_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION notes_theme_get(prm_token integer, prm_the_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_theme_get(prm_token integer, prm_the_id integer) IS 'Retourne les informations sur une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
';


--
-- Name: notes_theme_liste_details(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_theme_liste_details(prm_token integer, prm_por_id integer) RETURNS SETOF notes_theme_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row notes.notes_theme_liste_details ;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT DISTINCT the_id, the_nom, concatenate (por_libelle) FROM notes.theme 
			INNER JOIN notes.theme_portail USING(the_id) 
			INNER JOIN meta.portail USING(por_id) 
		WHERE (prm_por_id ISNULL OR prm_por_id = por_id)
		GROUP BY the_id, the_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION notes_theme_liste_details(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_theme_liste_details(prm_token integer, prm_por_id integer) IS 'Retourne le détail des informations des boîtes thématiques affectées à un portail.
Entrées :
 - prm_token : Token d''authentification
 - prm_por_id : Identifiant du portail
Retour : 
 - the_id : Identifiant de la boîte thématique
 - the_nom : Nom de la boîte thématique
 - portails : Liste des noms de portails auxquels sont affectés cette boîte thématique
';


--
-- Name: notes_theme_portail_liste(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_theme_portail_liste(prm_token integer, prm_the_id integer) RETURNS SETOF meta.portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.portail;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT portail.* FROM meta.portail INNER JOIN notes.theme_portail USING(por_id) WHERE the_id = prm_the_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION notes_theme_portail_liste(prm_token integer, prm_the_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_theme_portail_liste(prm_token integer, prm_the_id integer) IS 'Retourne la liste des portails auxquels est affectée une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
';


--
-- Name: notes_theme_supprime(integer, integer); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_theme_supprime(prm_token integer, prm_the_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM notes.theme_portail WHERE the_id = prm_the_id;
	DELETE FROM notes.theme WHERE the_id = prm_the_id;
END;
$$;


--
-- Name: FUNCTION notes_theme_supprime(prm_token integer, prm_the_id integer); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_theme_supprime(prm_token integer, prm_the_id integer) IS 'Supprime une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
Remarque :
Nécessite le droit de configuration "Réseau"';


--
-- Name: notes_theme_update(integer, integer, character varying, integer[]); Type: FUNCTION; Schema: notes; Owner: -
--

CREATE FUNCTION notes_theme_update(prm_token integer, prm_the_id integer, prm_the_nom character varying, prm_portails integer[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	IF prm_the_id ISNULL THEN
		INSERT INTO notes.theme (the_nom) VALUES (prm_the_nom) RETURNING the_id INTO ret;
	ELSE
		UPDATE notes.theme SET the_nom = prm_the_nom WHERE the_id = prm_the_id;
		ret = prm_the_id;
	END IF;
	DELETE FROM notes.theme_portail WHERE the_id = ret;
	IF prm_portails NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_portails, 1) LOOP
			INSERT INTO notes.theme_portail(the_id, por_id) VALUES (ret, prm_portails[i]);
		END LOOP;
	END IF;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION notes_theme_update(prm_token integer, prm_the_id integer, prm_the_nom character varying, prm_portails integer[]); Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON FUNCTION notes_theme_update(prm_token integer, prm_the_id integer, prm_the_nom character varying, prm_portails integer[]) IS 'Modifie les informations d''une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique à modifier
 - prm_the_nom : Nom de la boîte thématique
 - prm_portails : Tableau d''identifiants de portails auxquels affecter la boîte thématique
Remarque :
Nécessite le droit de configuration "Réseau"';


SET search_path = permission, pg_catalog;

--
-- Name: droit_ajout_entite_portail; Type: TABLE; Schema: permission; Owner: -; Tablespace: 
--

CREATE TABLE droit_ajout_entite_portail (
    daj_id integer NOT NULL,
    ent_code character varying,
    por_id integer,
    daj_droit boolean DEFAULT true NOT NULL
);


--
-- Name: TABLE droit_ajout_entite_portail; Type: COMMENT; Schema: permission; Owner: -
--

COMMENT ON TABLE droit_ajout_entite_portail IS 'Droit pour les utilisateurs d''ajouter des personnes d''une certaine catégorie (usager, personnel, contact, famille) par portail.';


--
-- Name: droit_ajout_entite_portail_liste_par_portail(integer, integer); Type: FUNCTION; Schema: permission; Owner: -
--

CREATE FUNCTION droit_ajout_entite_portail_liste_par_portail(prm_token integer, prm_por_id integer) RETURNS SETOF droit_ajout_entite_portail
    LANGUAGE plpgsql
    AS $$
DECLARE
	row permission.droit_ajout_entite_portail;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN SELECT * FROM permission.droit_ajout_entite_portail WHERE por_id = prm_por_id LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION droit_ajout_entite_portail_liste_par_portail(prm_token integer, prm_por_id integer); Type: COMMENT; Schema: permission; Owner: -
--

COMMENT ON FUNCTION droit_ajout_entite_portail_liste_par_portail(prm_token integer, prm_por_id integer) IS 'Retourne la liste des droits d''ajout de personne pour un portail donné.';


--
-- Name: droit_ajout_entite_portail_set(integer, character varying, integer, boolean); Type: FUNCTION; Schema: permission; Owner: -
--

CREATE FUNCTION droit_ajout_entite_portail_set(prm_token integer, prm_ent_code character varying, prm_por_id integer, prm_droit boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE permission.droit_ajout_entite_portail SET daj_droit = prm_droit WHERE ent_code = prm_ent_code AND por_id = prm_por_id;
	IF NOT FOUND THEN
		INSERT INTO permission.droit_ajout_entite_portail (ent_code, por_id, daj_droit) VALUES (prm_ent_code, prm_por_id, prm_droit);
	END IF;
END;
$$;


--
-- Name: FUNCTION droit_ajout_entite_portail_set(prm_token integer, prm_ent_code character varying, prm_por_id integer, prm_droit boolean); Type: COMMENT; Schema: permission; Owner: -
--

COMMENT ON FUNCTION droit_ajout_entite_portail_set(prm_token integer, prm_ent_code character varying, prm_por_id integer, prm_droit boolean) IS 'Indique le droit d''ajouter une personne d''une certaine catégorie depuis un portail donné.';


SET search_path = procedure, pg_catalog;

--
-- Name: procedure; Type: TABLE; Schema: procedure; Owner: -; Tablespace: 
--

CREATE TABLE procedure (
    pro_id integer NOT NULL,
    pro_titre character varying,
    pro_contenu text
);


--
-- Name: TABLE procedure; Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON TABLE procedure IS 'Contenu de la documentation.';


--
-- Name: procedure_liste(integer, integer, character varying); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_liste(prm_token integer, prm_id integer, prm_table character varying) RETURNS SETOF procedure
    LANGUAGE plpgsql
    AS $$
DECLARE
	row procedure.procedure;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	CASE prm_table
		WHEN 'tsm' THEN
			FOR row IN 
			    SELECT procedure.pro_id, procedure.pro_titre 
			    	   FROM procedure.procedure 
				   INNER JOIN procedure.procedure_affectation USING(pro_id)
			    WHERE tsm_id = prm_id 
			LOOP 
			     RETURN NEXT row; 
			END LOOP;
		WHEN 'sme' THEN
			FOR row IN 
			    SELECT procedure.pro_id, procedure.pro_titre 
			    	   FROM procedure.procedure 
				   INNER JOIN procedure.procedure_affectation USING(pro_id) 
			    WHERE sme_id = prm_id 
			LOOP 
			     RETURN NEXT row; 
			END LOOP;
		WHEN 'asm' THEN
			FOR row IN 
			    SELECT procedure.pro_id, procedure.pro_titre 
			    	   FROM procedure.procedure 
				   INNER JOIN procedure.procedure_affectation USING(pro_id) 
			    WHERE asm_id = prm_id 
			LOOP 
			     RETURN NEXT row; 
			END LOOP;
	END CASE;
END;
$$;


--
-- Name: FUNCTION procedure_liste(prm_token integer, prm_id integer, prm_table character varying); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_liste(prm_token integer, prm_id integer, prm_table character varying) IS 'Retourne la liste des procédures affectées à une page donnée.';


--
-- Name: procedure_procedure_affectation_ajoute(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer, prm_asm_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	INSERT INTO procedure.procedure_affectation (pro_id, tsm_id, sme_id, asm_id) VALUES (prm_pro_id, prm_tsm_id, prm_sme_id, prm_asm_id)
		RETURNING paf_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer, prm_asm_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer, prm_asm_id integer) IS 'Affecte une procédure à une page.';


--
-- Name: procedure_procedure_affectation_detail(integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_affectation_detail(prm_token integer, prm_paf_id integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
	paf procedure.procedure_affectation;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	SELECT * INTO paf FROM procedure.procedure_affectation WHERE paf_id = prm_paf_id;
	IF paf.tsm_id NOTNULL THEN
		ret =  (SELECT por_libelle FROM meta.portail INNER JOIN meta.topmenu USING(por_id) INNER JOIN meta.topsousmenu USING(tom_id) WHERE tsm_id = paf.tsm_id) 
			|| ' > Menu principal > ' 
			|| (SELECT tom_libelle FROM meta.topmenu WHERE tom_id = (SELECT tom_id FROM meta.topsousmenu WHERE tsm_id = paf.tsm_id))
			|| ' > '
			|| (SELECT tsm_libelle FROM meta.topsousmenu WHERE tsm_id = paf.tsm_id);
		RETURN ret;
	END IF;
	IF paf.sme_id NOTNULL THEN
		ret = (SELECT por_libelle FROM meta.portail INNER JOIN meta.menu USING(por_id) INNER JOIN meta.sousmenu USING(men_id) WHERE sme_id = paf.sme_id) 
			|| ' > Menu ' 
			|| (SELECT ent_libelle FROM meta.entite INNER JOIN meta.menu USING(ent_id) INNER JOIN meta.sousmenu USING(men_id) WHERE sme_id = paf.sme_id)
			|| ' > ' 
			|| (SELECT men_libelle FROM meta.menu WHERE men_id = (SELECT men_id FROM meta.sousmenu WHERE sme_id = paf.sme_id))
			|| ' > '
			|| (SELECT sme_libelle FROM meta.sousmenu WHERE sme_id = paf.sme_id);
		RETURN ret;
	END IF;
	IF paf.asm_id NOTNULL THEN
		ret = 'Configuration > ' 
			|| (SELECT asm_libelle FROM meta.adminsousmenu WHERE asm_id = paf.asm_id);
		RETURN ret;
	END IF;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_affectation_detail(prm_token integer, prm_paf_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_affectation_detail(prm_token integer, prm_paf_id integer) IS 'Retourne les informations sur l''affectation d''une procédure à une page.';


--
-- Name: procedure_affectation; Type: TABLE; Schema: procedure; Owner: -; Tablespace: 
--

CREATE TABLE procedure_affectation (
    paf_id integer NOT NULL,
    pro_id integer,
    tsm_id integer,
    sme_id integer,
    asm_id integer
);


--
-- Name: TABLE procedure_affectation; Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON TABLE procedure_affectation IS 'Affichage de la documentation sur une page donnée.';


--
-- Name: procedure_procedure_affectation_liste(integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_affectation_liste(prm_token integer, prm_pro_id integer) RETURNS SETOF procedure_affectation
    LANGUAGE plpgsql
    AS $$
DECLARE
	row procedure.procedure_affectation;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT * FROM procedure.procedure_affectation WHERE pro_id = prm_pro_id ORDER BY paf_id 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_affectation_liste(prm_token integer, prm_pro_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_affectation_liste(prm_token integer, prm_pro_id integer) IS 'Retourne la liste des affectations d''une procédure.';


--
-- Name: procedure_procedure_affectation_supprime(integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_affectation_supprime(prm_token integer, prm_paf_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM procedure.procedure_affectation WHERE paf_id = prm_paf_id;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_affectation_supprime(prm_token integer, prm_paf_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_affectation_supprime(prm_token integer, prm_paf_id integer) IS 'Supprime une affectation d''une procédure à une page.';


--
-- Name: procedure_procedure_details(integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_details(prm_token integer) RETURNS SETOF procedure_procedure_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row procedure.procedure_procedure_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pro_id, pro_titre, 
			(SELECT COUNT(*) FROM procedure.procedure_affectation WHERE procedure_affectation.pro_id = procedure.pro_id)
			FROM procedure.procedure
			ORDER BY pro_titre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_details(prm_token integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_details(prm_token integer) IS 'Retourne la liste détaillée des procédures.';


--
-- Name: procedure_procedure_get(integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_get(prm_token integer, prm_pro_id integer) RETURNS procedure
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret procedure.procedure;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	SELECT * INTO ret FROM procedure.procedure WHERE pro_id = prm_pro_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_get(prm_token integer, prm_pro_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_get(prm_token integer, prm_pro_id integer) IS 'Retourne les informations sur une procédure.';


--
-- Name: procedure_procedure_supprime(integer, integer); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_supprime(prm_token integer, prm_pro_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM procedure.procedure_affectation WHERE pro_id = prm_pro_id;
	DELETE FROM procedure.procedure WHERE pro_id = prm_pro_id;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_supprime(prm_token integer, prm_pro_id integer); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_supprime(prm_token integer, prm_pro_id integer) IS 'Supprime une procédure.';


--
-- Name: procedure_procedure_update(integer, integer, character varying, text); Type: FUNCTION; Schema: procedure; Owner: -
--

CREATE FUNCTION procedure_procedure_update(prm_token integer, prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	IF prm_pro_id NOTNULL THEN
		UPDATE procedure.procedure SET pro_titre = prm_pro_titre, pro_contenu = prm_pro_contenu WHERE pro_id = prm_pro_id;
		RETURN prm_pro_id;
	ELSE
		INSERT INTO procedure.procedure (pro_titre, pro_contenu) VALUES (prm_pro_titre, prm_pro_contenu) RETURNING pro_id INTO ret;
		RETURN ret;
	END IF;
END;
$$;


--
-- Name: FUNCTION procedure_procedure_update(prm_token integer, prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text); Type: COMMENT; Schema: procedure; Owner: -
--

COMMENT ON FUNCTION procedure_procedure_update(prm_token integer, prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text) IS 'Modifie les informations d''une procédure.';


SET search_path = public, pg_catalog;

--
-- Name: adresse; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE adresse (
    adr_id integer NOT NULL,
    adr_adresse character varying,
    adr_cp character varying,
    adr_ville character varying,
    adr_tel character varying,
    adr_fax character varying,
    adr_email character varying,
    adr_web character varying
);


--
-- Name: TABLE adresse; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE adresse IS 'Adresse et moyens de contact d''un établissement/partenaire.';


--
-- Name: COLUMN adresse.adr_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_id IS 'Identifiant de l''adresse';


--
-- Name: COLUMN adresse.adr_adresse; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_adresse IS 'Ligne d''adresse';


--
-- Name: COLUMN adresse.adr_cp; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_cp IS 'Code postal';


--
-- Name: COLUMN adresse.adr_ville; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_ville IS 'Ville';


--
-- Name: COLUMN adresse.adr_tel; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_tel IS 'Téléphone';


--
-- Name: COLUMN adresse.adr_fax; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_fax IS 'Fax';


--
-- Name: COLUMN adresse.adr_email; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_email IS 'Adresse email de contact de l''établissement';


--
-- Name: COLUMN adresse.adr_web; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN adresse.adr_web IS 'Site web de l''établissement';


--
-- Name: adresse_get(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION adresse_get(prm_token integer, prm_adr_id integer) RETURNS adresse
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret adresse;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM adresse WHERE adr_id = prm_adr_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION adresse_get(prm_token integer, prm_adr_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION adresse_get(prm_token integer, prm_adr_id integer) IS 'Retourne les détails de l''adresse d''un établissement/partenaire.

Entrées :
 - prm_token : Token d''authentification
 - prm_adr_id : Identifiant de l''adresse';


--
-- Name: concat2(text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION concat2(text, text) RETURNS text
    LANGUAGE sql
    AS $_$
    SELECT CASE WHEN $1 IS NULL OR $1 = '' THEN $2
                WHEN $2 IS NULL OR $2 = '' THEN $1
                ELSE $1 || ', ' || $2
                END; 
 $_$;


--
-- Name: contact_recherche(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION contact_recherche(prm_token integer, prm_per_id integer) RETURNS SETOF contact_recherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row contact_recherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		select per_id, personne_get_libelle(prm_token, per_id), inf_libelle FROM personne_info_integer 
		inner join personne_info using(pin_id)
		inner join meta.info using(inf_code)
		inner join meta.infos_type USING(int_id)
		where int_code = 'contact' AND pii_valeur = prm_per_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION contact_recherche(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION contact_recherche(prm_token integer, prm_per_id integer) IS 'Retourne la liste des usagers dont une personne (personnel ou contact) est le contact.

Entrées :
 - prm_token : Token d''authentification
 - prm_per_id : Identifiant de la personne (personnel ou contact)
Retour :
 - per_id : Identifiant de l''usager
 - per_libelle : Nom et prénom de l''usager
 - Nom du lien entre l''usager et la personne (personnel ou contact)';


--
-- Name: etablissement_add(integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_add(prm_token integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	adr integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO adresse (adr_adresse, adr_cp, adr_ville, adr_tel, adr_fax, adr_email, adr_web)
		VALUES (prm_adr_adresse, prm_adr_cp, prm_adr_ville, prm_adr_tel, prm_adr_fax, prm_adr_email, prm_adr_web) RETURNING adr_id INTO adr;
	INSERT INTO etablissement (eta_nom, cat_id, adr_id) VALUES (prm_nom, prm_cat_id, adr) RETURNING eta_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION etablissement_add(prm_token integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_add(prm_token integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) IS 'Ajoute un établissement ou partenaire.

Entrées : 
 - prm_token : Token d''authentification
 - prm_nom : Nom de l''établissement/du partenaire
 - prm_cat_id : Identifiant de la catégorie pour un établissement, ou NULL pour un partenaire
 - prm_adr_adresse : Ligne d''adresse
 - prm_adr_cp : Code postal
 - prm_adr_ville : Ville
 - prm_adr_tel : Téléphone
 - prm_adr_fax : Fax
 - prm_adr_email : Email de contact
 - prm_adr_web : Site web
Retour : 
 - Identidiant de l''établissement/partenaire créé.
Remarques :
 - Ne nécessite pas de droit particulier.
';


--
-- Name: etablissement; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE etablissement (
    eta_id integer NOT NULL,
    cat_id integer,
    eta_nom character varying,
    adr_id integer
);


--
-- Name: TABLE etablissement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE etablissement IS 'Etablissement (internes) et partenaires (externes).
cat_id est NULL pour les partenaires, non NULL pour les établissements.';


--
-- Name: COLUMN etablissement.eta_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement.eta_id IS 'Identifiant de l''établissement/partenaire';


--
-- Name: COLUMN etablissement.cat_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement.cat_id IS 'Identifiant de la catégorie de l''établissement, NULL pour un partenaire';


--
-- Name: COLUMN etablissement.eta_nom; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement.eta_nom IS 'Nom de l''établissement/partenaire';


--
-- Name: COLUMN etablissement.adr_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement.adr_id IS 'Identifiant de l''adresse';


--
-- Name: etablissement_cherche(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_cherche(prm_token integer, prm_nom character varying) RETURNS etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret etablissement;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM etablissement WHERE eta_nom = prm_nom LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION etablissement_cherche(prm_token integer, prm_nom character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_cherche(prm_token integer, prm_nom character varying) IS 'Recherche un établissement par son nom.

Entrée : 
 - prm_token : Token d''authentification
 - prm_nom : Nom exact de l''établissement à rechercher';


--
-- Name: etablissement_dans_secteur_editable_liste(integer, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_dans_secteur_editable_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) RETURNS SETOF etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT etablissement.* FROM etablissement 
		INNER JOIN etablissement_secteur USING(eta_id)
		LEFT JOIN etablissement_secteur_edit ON etablissement.eta_id = etablissement_secteur_edit.eta_id AND etablissement_secteur_edit.sec_id = prm_sec_id
		WHERE 
			(etablissement.cat_id ISNULL OR etablissement_secteur_edit.ese_id NOTNULL)
			AND etablissement_secteur.sec_id = prm_sec_id 
			AND prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL) 
			ORDER BY eta_nom 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_dans_secteur_editable_liste(prm_token integer, prm_interne boolean, prm_sec_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_dans_secteur_editable_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) IS 'Retourne la liste des établissements/partenaires d''un secteur donné auxquels les utilisateurs peuvent rajouter des groupes.

Entrées : 
 - prm_token : Token d''authentification
 - prm_interne : TRUE : établissements uniquement, FALSE : partenaires uniquement, NULL : établissements et partenaires
 - prm_sec_id : Identifiant du secteur (non NULL)
Remarques :
 - Tous les partenaires sont éditables, alors qu''il est possible d''indiquer si un établissement est éditable pour un secteur donné avec la table etablissement_secteur_edit.
';


--
-- Name: etablissement_dans_secteur_liste(integer, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_dans_secteur_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) RETURNS SETOF etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT etablissement.* FROM etablissement 
		INNER JOIN etablissement_secteur USING(eta_id)
		WHERE 
			sec_id = prm_sec_id 
			AND (prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL)) 
			ORDER BY eta_nom 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_dans_secteur_liste(prm_token integer, prm_interne boolean, prm_sec_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_dans_secteur_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) IS 'Retourne la liste des établissements/partenaires d''un secteur donné.
 - prm_token : Token d''authentification
 - prm_interne : TRUE : établissements uniquement, FALSE : partenaires uniquement, NULL : établissements et partenaires
 - prm_sec_id : Identifiant du secteur (non NULL)
';


--
-- Name: etablissement_get(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_get(prm_token integer, prm_eta_id integer) RETURNS etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret etablissement;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM etablissement WHERE eta_id = prm_eta_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION etablissement_get(prm_token integer, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_get(prm_token integer, prm_eta_id integer) IS 'Retourne les informations sur un établissement.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement';


--
-- Name: etablissement_liste(integer, boolean, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_liste(prm_token integer, prm_interne boolean, prm_secteur character varying) RETURNS SETOF etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement;
BEGIN
		PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT etablissement.* FROM etablissement 
		INNER JOIN etablissement_secteur USING(eta_id)
		INNER JOIN meta.secteur USING(sec_id)
		WHERE 
			(prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL))
			AND (prm_secteur ISNULL OR prm_secteur = secteur.sec_code)
			ORDER BY eta_nom 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_liste(prm_token integer, prm_interne boolean, prm_secteur character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_liste(prm_token integer, prm_interne boolean, prm_secteur character varying) IS 'Retourne la liste des établissements et/ou partenaires.

Entrées : 
 - prm_token : Token d''authentification
 - prm_interne : TRUE pour les établissements, FALSE pour les partenaires, NULL pour tous
 - prm_secteur : Code d''un secteur ou NULL. Retourne uniquement les établissements couvrant ce secteur';


--
-- Name: etablissement_liste_details(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean) RETURNS SETOF etablissement_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	FOR row IN
		SELECT eta_id, eta_nom, concatenate (roles.sec_nom), concatenate (besoins.sec_nom)
		FROM etablissement
		LEFT JOIN etablissement_secteur USING(eta_id)
		LEFT JOIN meta.secteur roles ON roles.sec_id = etablissement_secteur.sec_id AND roles.sec_est_prise_en_charge = true
		LEFT JOIN meta.secteur besoins ON besoins.sec_id = etablissement_secteur.sec_id AND besoins.sec_est_prise_en_charge = false
		WHERE (prm_sec_id ISNULL OR prm_sec_id = roles.sec_id OR prm_sec_id = besoins.sec_id) 
		AND (prm_interne_seuls ISNULL OR (prm_interne_seuls AND etablissement.cat_id NOTNULL) OR (NOT prm_interne_seuls AND etablissement.cat_id ISNULL))
		GROUP BY eta_id, eta_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean) IS 'Détail des établissements/partenaires couvrant un certain secteur.

Entrées :
 - prm_token : Token d''authentification
 - prm_sec_id : Identifiant du secteur ou NULL pour ne pas filtrer sur les secteurs
 - prm_interne_seuls : TRUE pour retourner les établissements uniquement, FALSE pour retourner établissements et partenaires
Retour :
 - eta_id : Identifiant de l''établissement/partenaire
 - eta_nom : Nom
 - roles : liste des rôles couverts par l''établissement/partenaire
 - besoins : liste des besoins couverts par l''établissement/partenaire
Remarques :
 - Nécessite les droits à la configuration "Établissement" ou "Réseau"';


--
-- Name: etablissement_liste_details(integer, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) RETURNS SETOF etablissement_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT eta_id, eta_nom, 
			(SELECT concatenate (sec_nom) FROM etablissement_secteur_liste(prm_token, eta_id, true)), 
			(SELECT concatenate (sec_nom) FROM etablissement_secteur_liste(prm_token, eta_id, false))
		FROM etablissement
		LEFT JOIN etablissement_secteur etablissement_secteur_roles USING(eta_id)
		LEFT JOIN etablissement_secteur etablissement_secteur_besoins USING(eta_id)
		LEFT JOIN meta.secteur roles ON roles.sec_id = etablissement_secteur_roles.sec_id AND roles.sec_est_prise_en_charge = true
		LEFT JOIN meta.secteur besoins ON besoins.sec_id = etablissement_secteur_besoins.sec_id AND besoins.sec_est_prise_en_charge = false
		WHERE (prm_sec_id_role ISNULL OR prm_sec_id_role = roles.sec_id) 
		AND (prm_sec_id_besoin ISNULL OR prm_sec_id_besoin = besoins.sec_id) 
		AND (prm_interne_seuls ISNULL OR (prm_interne_seuls AND etablissement.cat_id NOTNULL) OR (NOT prm_interne_seuls AND etablissement.cat_id ISNULL))
		GROUP BY eta_id, eta_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) IS 'Détail des établissements/partenaires couvrant un certain rôle et/ou besoin.

Entrées :
 - prm_token : Token d''authentification
 - prm_sec_id_role : Identifiant du rôle ou NULL pour ne pas filtrer sur les rôles
 - prm_sec_id_besoin : Identifiant du besoin ou NULL pour ne pas filtrer sur les besoins
 - prm_interne_seuls : TRUE pour retourner les établissements uniquement, FALSE pour retourner établissements et partenaires
Retour :
 - eta_id : Identifiant de l''établissement/partenaire
 - eta_nom : Nom
 - roles : liste des rôles couverts par l''établissement/partenaire
 - besoins : liste des besoins couverts par l''établissement/partenaire
Remarques :
 - Nécessite les droits à la configuration "Établissement"';


--
-- Name: etablissement_liste_par_secteur(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_liste_par_secteur(prm_token integer, prm_secteur character varying) RETURNS SETOF etablissement
    LANGUAGE plpgsql
    AS $$
DECLARE
	row etablissement;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT etablissement.* FROM etablissement
		INNER JOIN groupe USING(eta_id)
		LEFT JOIN groupe_secteur USING(grp_id)
		LEFT JOIN meta.secteur USING(sec_id)
		WHERE prm_secteur ISNULL OR sec_code = prm_secteur
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_liste_par_secteur(prm_token integer, prm_secteur character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_liste_par_secteur(prm_token integer, prm_secteur character varying) IS 'Retourne la liste des établissements/partenaires en filtrant sur les secteurs couverts par les groupes des établissements/partenaires.

Entrées :
 - prm_token : Token d''authentification
 - prm_secteur : Code secteur ou NULL. Retourne uniquement les établissements dont au moins un groupe couvre le secteur donné';


--
-- Name: etablissement_secteur_edit_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_secteur_edit_get(prm_token integer, prm_eta_id integer, prm_secteur character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret boolean;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	RETURN EXISTS (SELECT 1 FROM etablissement_secteur_edit 
			INNER JOIN meta.secteur USING (sec_id)
			WHERE eta_id = prm_eta_id AND sec_code = prm_secteur);
END;
$$;


--
-- Name: FUNCTION etablissement_secteur_edit_get(prm_token integer, prm_eta_id integer, prm_secteur character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_secteur_edit_get(prm_token integer, prm_eta_id integer, prm_secteur character varying) IS 'Retourne TRUE si l''établissement est éditable (les utilisateurs peuvent y rajouter des groupes) pour le secteur donné, FALSE sinon.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
 - prm_secteur : Code du secteur';


--
-- Name: etablissement_secteur_edit_liste(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_secteur_edit_liste(prm_token integer, prm_eta_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
		INNER JOIN etablissement_secteur_edit USING(sec_id)
		WHERE eta_id = prm_eta_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_secteur_edit_liste(prm_token integer, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_secteur_edit_liste(prm_token integer, prm_eta_id integer) IS 'Retourne la liste des secteurs pour lesquels un établissement est éditable (pour lesquels les utilisateurs peuvent rajouter des groupes).

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
Remarques : 
 - Nécessite les droits à la configuration "Établissement"';


--
-- Name: etablissement_secteur_liste(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_secteur_liste(prm_token integer, prm_eta_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
		INNER JOIN etablissement_secteur USING(sec_id)
		WHERE eta_id = prm_eta_id AND (prm_est_prise_en_charge ISNULL OR sec_est_prise_en_charge = prm_est_prise_en_charge)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION etablissement_secteur_liste(prm_token integer, prm_eta_id integer, prm_est_prise_en_charge boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_secteur_liste(prm_token integer, prm_eta_id integer, prm_est_prise_en_charge boolean) IS 'Retourne la liste des secteurs que couvre un établissement/partenaire.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement/partenaire
 - prm_est_prise_en_charge (booléen) : TRUE pour retourner uniquement les rôles, FALSE pour les besoins, NULL pour tous';


--
-- Name: etablissement_secteurs_edit_set(integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_secteurs_edit_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM etablissement_secteur_edit WHERE eta_id = prm_eta_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO etablissement_secteur_edit (eta_id, sec_id) VALUES (prm_eta_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION etablissement_secteurs_edit_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_secteurs_edit_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) IS 'Indique pour un établissement donné pour quels secteurs il est éditable (il est possible pour les utilisateurs de rajouter des groupes).

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
 - prm_secteurs : Tableau de codes de secteurs
Remarques : 
 - Nécessite les droits à la configuration "Établissement"';


--
-- Name: etablissement_secteurs_set(integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_secteurs_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM etablissement_secteur WHERE eta_id = prm_eta_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO etablissement_secteur (eta_id, sec_id) VALUES (prm_eta_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION etablissement_secteurs_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_secteurs_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) IS 'Indique les secteurs couverts par un établissement/partenaire.

Entrées : 
 - prm_token : Token d''authentificaiton
 - prm_eta_id : Identifiant de l''établissement/partenaire
 - prm_secteurs : Tableau de codes de secteurs
Remarques :
 - Ne nécessite pas de droit de configuration particulier';


--
-- Name: etablissement_supprime(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_supprime(prm_token integer, prm_eta_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	adr integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	SELECT adr_id INTO adr FROM etablissement WHERE eta_id = prm_eta_id;
	DELETE FROM etablissement_secteur WHERE eta_id = prm_eta_id;
	DELETE FROM etablissement_secteur_edit WHERE eta_id = prm_eta_id;
	DELETE FROM etablissement WHERE eta_id = prm_eta_id;
	IF adr NOTNULL THEN
		DELETE FROM adresse WHERE adr_id = adr;
	END IF;
END;
$$;


--
-- Name: FUNCTION etablissement_supprime(prm_token integer, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_supprime(prm_token integer, prm_eta_id integer) IS 'Supprime un établissement/partenaire

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement/partenaire
Remarques :
 - Nécessite les droits à la configuration "Établissement" ou "Réseau"';


--
-- Name: etablissement_update(integer, integer, character varying, integer, character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION etablissement_update(prm_token integer, prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	adr integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, TRUE);
	UPDATE etablissement SET eta_nom = prm_nom, cat_id = prm_cat_id WHERE eta_id = prm_eta_id;
	SELECT adr_id INTO adr FROM etablissement WHERE eta_id = prm_eta_id;
	IF adr ISNULL THEN
		INSERT INTO adresse (adr_adresse, adr_cp, adr_ville, adr_tel, adr_fax, adr_email, adr_web)
			VALUES (prm_adr_adresse, prm_adr_cp, prm_adr_ville, prm_adr_tel, prm_adr_fax, prm_adr_email, prm_adr_web) RETURNING adr_id INTO adr;
		UPDATE etablissement SET adr_id = adr WHERE eta_id = prm_eta_id;
	ELSE
		UPDATE adresse SET 
			adr_adresse = prm_adr_adresse,
			adr_cp = prm_adr_cp,
			adr_ville = prm_adr_ville,
			adr_tel = prm_adr_tel,
			adr_fax = prm_adr_fax,
			adr_email = prm_adr_email,
			adr_web = prm_adr_web
			WHERE adr_id = adr;
	END IF;
END;
$$;


--
-- Name: FUNCTION etablissement_update(prm_token integer, prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION etablissement_update(prm_token integer, prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) IS 'Modifie les informations d''un établissement/partenaire.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement/partenaire à modifier
 - prm_nom : Nouveau nom
 - prm_cat_id : Identifiant de la nouvelle catégorie d''établissement ou NULL pour un partenaire
 - prm_adr_adresse : Ligne d''adresse
 - prm_adr_cp : Code postal
 - prm_adr_ville : Ville
 - prm_adr_tel : Téléphone
 - prm_adr_fax : Fax
 - prm_adr_email : Email de contact
 - prm_adr_web : Site web

Nécessite les droits à la configuration "Établissement" ou "Réseau"';


--
-- Name: famille_recherche(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer) RETURNS SETOF famille_recherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row famille_recherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT per_id, personne_get_libelle (prm_token, per_id), lfa_id, pif_autorite_parentale, pif_droits, pif_periodicite
			FROM personne_info_lien_familial 
			INNER JOIN personne_info USING(pin_id)
			INNER JOIN meta.info USING(inf_code)
			INNER JOIN meta.infos_type USING(int_id)
			WHERE int_code = 'famille' AND per_id_parent = prm_parent_id AND inf_id = prm_inf_id
			ORDER BY personne_get_libelle (prm_token, per_id) 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer) IS 'Recherche les usagers ayant un lien familial avec une personne.

Entrées :
 - prm_token : Token d''authentification
 - prm_parent_id : Identifiant du parent
 - prm_inf_id : Identifiant du champ de type famille sur lequel rechercher le lien familial';


--
-- Name: groupe_add(integer, character varying, integer, date, date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_add(prm_token integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO groupe (grp_nom, eta_id, grp_debut, grp_fin, grp_notes) VALUES (prm_nom, prm_eta_id, prm_debut, prm_fin, prm_notes)
		RETURNING grp_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION groupe_add(prm_token integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_add(prm_token integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) IS 'Ajoute un groupe d''usagers.

Entrées :
 - prm_token : Token d''authentification
 - prm_nom : Nom du grouepe
 - prm_eta_id : Identifiant de l''établissement/partenaire
 - prm_debut : Date de début d''existence du groupe
 - prm_fin : Date de fin d''existence du groupe
 - prm_notes : Notes concernant le groupe
Remarques :
 - Ne nécessite pas de droit particulier.
';


--
-- Name: groupe_aide_a_la_personne_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_aide_a_la_personne_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_aide_a_la_personne_contact = prm_contact,
		grp_aide_a_la_personne_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_aide_a_la_personne_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_aide_a_la_personne_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur aide à la personne.';


--
-- Name: groupe_aide_financiere_directe_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_aide_financiere_directe_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_aide_financiere_directe_contact = prm_contact,
		grp_aide_financiere_directe_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_aide_financiere_directe_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_aide_financiere_directe_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur aide financière directe.';


--
-- Name: groupe_cherche(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_cherche(prm_token integer, prm_eta_nom character varying, prm_grp_nom character varying) RETURNS SETOF groupe_cherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe_cherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT eta_id, grp_id FROM etablissement INNER JOIN groupe USING(eta_id)
	        WHERE eta_nom ilike prm_eta_nom AND grp_nom ilike prm_grp_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION groupe_cherche(prm_token integer, prm_eta_nom character varying, prm_grp_nom character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_cherche(prm_token integer, prm_eta_nom character varying, prm_grp_nom character varying) IS 'Recherche le groupe d''usagers d''un établissement/partenaire à partir de leurs noms.

Entrées : 
 - prm_token : Token d''authentification
 - prm_eta_nom : Nom de l''établissement du groupe
 - prm_grp_nom : Nom du groupe d''usagers recherché
Retour : 
 - eta_id : Identifiant de l''établissement/partenaire
 - grp_id : Identifiant du groupe
Remarques : 
 - La recherche est insensible à la casse.
';


--
-- Name: groupe_culture_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_culture_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_culture_contact = prm_contact,
		grp_culture_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_culture_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_culture_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur culture.';


--
-- Name: groupe_decideur_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_decideur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_decideur_contact = prm_contact,
		grp_decideur_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_decideur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_decideur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur décideur.';


--
-- Name: groupe_divertissement_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_divertissement_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_divertissement_contact = prm_contact,
		grp_divertissement_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_divertissement_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_divertissement_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur divertissement.';


--
-- Name: groupe_education_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_education_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_education_contact = prm_contact,
		grp_education_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_education_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_education_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur éducation.';


--
-- Name: groupe_emploi_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_emploi_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_emploi_contact = prm_contact,
		grp_emploi_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_emploi_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_emploi_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur emploi.';


--
-- Name: groupe_entretien_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_entretien_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_entretien_contact = prm_contact,
		grp_entretien_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_entretien_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_entretien_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur entretien.';


--
-- Name: groupe_equipement_personnel_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_equipement_personnel_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_equipement_personnel_contact = prm_contact,
		grp_equipement_personnel_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_equipement_personnel_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_equipement_personnel_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur équipement personnel.';


--
-- Name: groupe_famille_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_famille_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_famille_contact = prm_contact,
		grp_famille_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_famille_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_famille_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur famille.';


--
-- Name: groupe_filtre(integer, character varying, integer, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_filtre(prm_token integer, prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer) RETURNS SETOF groupe
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT groupe.* FROM groupe
		LEFT JOIN groupe_secteur USING(grp_id)
		LEFT JOIN meta.secteur USING(sec_id)
		LEFT JOIN etablissement USING(eta_id)
		WHERE (prm_secteur ISNULL OR sec_code = prm_secteur)
		AND (prm_sec_id ISNULL OR prm_sec_id = sec_id) 
		AND (prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL)) 
		AND (prm_eta_id ISNULL OR groupe.eta_id = prm_eta_id)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION groupe_filtre(prm_token integer, prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_filtre(prm_token integer, prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer) IS 'Recherche de groupes en appliquant différents filtres.

Entrées :
 - prm_token : token d''authentification
 - prm_secteur : Code d''un secteur, pour rechercher les groupes couvrant un secteur particulier
 - prm_sec_id : Identifiant d''un secteur, pour rechercher les groupes couvrant un secteur particulier
 - prm_interne : NULL = établissements/partenaires, TRUE = établissements seuls, FALSE = partenaires seuls
 - prm_eta_id : Identifiant d''un établissement/partenaire, pour rechercher parmi les groupes de cet établissement/partenaire';


--
-- Name: groupe_financeur_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_financeur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_financeur_contact = prm_contact,
		grp_financeur_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_financeur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_financeur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur financeur.';


--
-- Name: groupe_get(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_get(prm_token integer, prm_grp_id integer) RETURNS groupe
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret groupe;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM groupe WHERE grp_id = prm_grp_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION groupe_get(prm_token integer, prm_grp_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_get(prm_token integer, prm_grp_id integer) IS 'Retourne les informations sur un groupe d''usagers.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
';


--
-- Name: groupe_hebergement_update(integer, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_hebergement_update(prm_token integer, prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_hebergement_adresse = prm_adresse,
		grp_hebergement_cp = prm_cp,
		grp_hebergement_ville = prm_ville,
		grp_hebergement_contact = prm_contact,
		grp_hebergement_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_hebergement_update(prm_token integer, prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_hebergement_update(prm_token integer, prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur hébergement.';


--
-- Name: groupe_info_secteur; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groupe_info_secteur (
    gis_id integer NOT NULL,
    grp_id integer,
    sec_id integer,
    inf_id integer
);


--
-- Name: TABLE groupe_info_secteur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE groupe_info_secteur IS 'Indique sur quel champ de fiche usager est faite l''affectation de l''usager à un groupe pour un secteur donné.';


--
-- Name: COLUMN groupe_info_secteur.gis_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_info_secteur.gis_id IS 'Identifiant de la relation';


--
-- Name: COLUMN groupe_info_secteur.grp_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_info_secteur.grp_id IS 'Identifiant du groupe';


--
-- Name: COLUMN groupe_info_secteur.sec_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_info_secteur.sec_id IS 'Identifiant du secteur';


--
-- Name: COLUMN groupe_info_secteur.inf_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_info_secteur.inf_id IS 'Identifiant du champ';


--
-- Name: groupe_info_secteur_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_info_secteur_get(prm_token integer, prm_grp_id integer, prm_sec_code character varying) RETURNS SETOF groupe_info_secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe_info_secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT groupe_info_secteur.* FROM groupe_info_secteur
		LEFT JOIN meta.secteur USING(sec_id)
			WHERE (prm_grp_id ISNULL OR prm_grp_id = grp_id) AND
			(prm_sec_code ISNULL OR prm_sec_code = sec_code)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION groupe_info_secteur_get(prm_token integer, prm_grp_id integer, prm_sec_code character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_info_secteur_get(prm_token integer, prm_grp_id integer, prm_sec_code character varying) IS 'Retourne les informations indiquant sur quel champ de fiche usager est faite l''affectation d''un usager à un groupe pour un secteur donné.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe ou NULL
 - prm_sec_code : Code du secteur ou NULL
';


--
-- Name: groupe_info_secteur_save(integer, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_info_secteur_save(prm_token integer, prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe_info_secteur SET inf_id = prm_inf_id WHERE grp_id = prm_grp_id AND sec_id = (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code);
	IF NOT FOUND THEN
		INSERT INTO groupe_info_secteur (grp_id, sec_id, inf_id) VALUES (prm_grp_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code), prm_inf_id);
	END IF;
END;
$$;


--
-- Name: FUNCTION groupe_info_secteur_save(prm_token integer, prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_info_secteur_save(prm_token integer, prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer) IS 'Indique le champ de fiche usager sur lequel est faite l''affectation d''un usager à un groupe pour un secteur donné.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_sec_code : Code du secteur
 - prm_inf_id : Identifiant du champ de saisie de fiche usager';


--
-- Name: groupe_info_secteurs_set(integer, integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_info_secteurs_set(prm_token integer, prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN SELECT * FROM meta.secteur LOOP
		PERFORM groupe_info_secteur_save (prm_token, prm_grp_id, row.sec_code, NULL);
	END LOOP;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			PERFORM groupe_info_secteur_save (prm_token, prm_grp_id, prm_secteurs[i], prm_inf_id);
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION groupe_info_secteurs_set(prm_token integer, prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_info_secteurs_set(prm_token integer, prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]) IS 'Indique le champ de fiche usager sur lequel est faite l''affectation d''un usager à un groupe pour une liste de secteurs.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_inf_id : Identifiant du champ de saisie de fiche usager
 - prm_secteurs : Tableau de codes du secteur';


--
-- Name: groupe_justice_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_justice_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_justice_contact = prm_contact,
		grp_justice_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_justice_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_justice_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur justice.';


--
-- Name: groupe_liste_details(integer, integer, integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_liste_details(prm_token integer, prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) RETURNS SETOF groupe_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT grp_id, eta_nom, grp_nom, 
		(SELECT concatenate (sec_nom) FROM groupe_secteur_liste (prm_token, grp_id, true)), 
		(SELECT concatenate (sec_nom) FROM groupe_secteur_liste (prm_token, grp_id, false)), 
		grp_debut, grp_fin
		FROM groupe 
		LEFT JOIN etablissement USING(eta_id)
		LEFT JOIN groupe_secteur groupe_secteur_role USING(grp_id)
		LEFT JOIN groupe_secteur groupe_secteur_besoin USING(grp_id)
		LEFT JOIN meta.secteur roles ON roles.sec_id = groupe_secteur_role.sec_id AND roles.sec_est_prise_en_charge 
		LEFT JOIN meta.secteur besoins ON besoins.sec_id = groupe_secteur_besoin.sec_id AND NOT besoins.sec_est_prise_en_charge 
		WHERE (prm_sec_id_role ISNULL OR prm_sec_id_role = roles.sec_id) AND (prm_sec_id_besoin ISNULL OR prm_sec_id_besoin = besoins.sec_id)  
		AND (NOT prm_interne_seuls OR cat_id NOTNULL)
		AND (prm_eta_id ISNULL OR groupe.eta_id = prm_eta_id)
		GROUP BY grp_id, eta_nom, grp_nom, grp_debut, grp_fin
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION groupe_liste_details(prm_token integer, prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_liste_details(prm_token integer, prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) IS 'Retourne le détail des groupes d''un établissement/partenaire donné couvrant un rôle/besoin donné.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Retourne uniquement les groupes d''un établissement/partenaire, NULL pour retourner les groupes de tous les établissements/partenaires
 - prm_sec_id_role : Retourne uniquement les groupes couvrant le rôlé indiqué, NULL pour ne pas filtrer sur les rôles
 - prm_sec_id_besoin : Retourne uniquement les groupes couvrant le besoin indiqué, NULL pour ne pas filtrer sur les besoins
 - prm_interne_seuls : TRUE pour retourner uniquement les groupes des établissements, NULL pour retourner les groupes des établissements et partenaires
Retour : 
 - grp_id : Identifiant du groupe
 - eta_nom : Nom de l''établissement
 - grp_nom : Nom du groupe
 - roles : Liste des noms de rôles couverts par le groupe
 - besoins : Liste des noms de besoins couverts par le groupe
 - grp_debut : Date de début d''activité du groupe
 - grp_fin : Date de fin d''activité du groupe
';


--
-- Name: groupe_pedagogie_update(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_pedagogie_update(prm_token integer, prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_pedagogie_type = prm_type,
		grp_pedagogie_niveau = prm_niveau,
		grp_pedagogie_contact =prm_contact
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_pedagogie_update(prm_token integer, prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_pedagogie_update(prm_token integer, prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer) IS 'Modifie les informations d''un groupe spécifiques au secteur pédagogie.';


--
-- Name: groupe_prise_en_charge_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_prise_en_charge_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_prise_en_charge_contact = prm_contact,
		grp_prise_en_charge_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_prise_en_charge_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_prise_en_charge_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur prise en charge.';


--
-- Name: groupe_projet_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_projet_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_projet_contact = prm_contact,
		grp_projet_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_projet_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_projet_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur projet.';


--
-- Name: groupe_protection_juridique_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_protection_juridique_contact = prm_contact,
		grp_protection_juridique_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur protection juridique.';


--
-- Name: groupe_restauration_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_restauration_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_restauration_contact = prm_contact,
		grp_restauration_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_restauration_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_restauration_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur restauration.';


--
-- Name: groupe_sante_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_sante_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_sante_contact = prm_contact,
		grp_sante_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_sante_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_sante_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur santé.';


--
-- Name: groupe_secteur_liste(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_secteur_liste(prm_token integer, prm_grp_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
		INNER JOIN groupe_secteur USING(sec_id)
		WHERE grp_id = prm_grp_id
		AND (prm_est_prise_en_charge ISNULL OR sec_est_prise_en_charge = prm_est_prise_en_charge)
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION groupe_secteur_liste(prm_token integer, prm_grp_id integer, prm_est_prise_en_charge boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_secteur_liste(prm_token integer, prm_grp_id integer, prm_est_prise_en_charge boolean) IS 'Retourne la liste des secteurs couverts par un groupe.

Entrées :
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_est_prise_en_charge : NULL pour lister tous les secteurs, TRUE pour les secteurs de prise en charge ou FALSE les autres secteurs
';


--
-- Name: groupe_secteurs_set(integer, integer, character varying[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_secteurs_set(prm_token integer, prm_grp_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM groupe_secteur WHERE grp_id = prm_grp_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO groupe_secteur (grp_id, sec_id) VALUES (prm_grp_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION groupe_secteurs_set(prm_token integer, prm_grp_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_secteurs_set(prm_token integer, prm_grp_id integer, prm_secteurs character varying[]) IS 'Indique les secteurs couverts par un groupe.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_secteurs : Tableau d''identifiants de secteurs';


--
-- Name: groupe_sejour_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_sejour_contact = prm_contact,
		grp_sejour_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur séjour.';


--
-- Name: groupe_social_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_social_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_social_contact = prm_contact,
		grp_social_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_social_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_social_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur social.';


--
-- Name: groupe_sport_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_sport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_sport_contact = prm_contact,
		grp_sport_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_sport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_sport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur sport.';


--
-- Name: groupe_supprime(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_supprime(prm_token integer, prm_grp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM groupe_info_secteur WHERE grp_id = prm_grp_id;
	DELETE FROM groupe_secteur WHERE grp_id = prm_grp_id;
	DELETE FROM groupe WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_supprime(prm_token integer, prm_grp_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_supprime(prm_token integer, prm_grp_id integer) IS 'Supprime un groupe d''usagers.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
';


--
-- Name: groupe_transport_update(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_transport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_transport_contact = prm_contact,
		grp_transport_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;


--
-- Name: FUNCTION groupe_transport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_transport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 'Modifie les informations d''un groupe spécifiques au secteur transport.';


--
-- Name: groupe_update(integer, integer, character varying, integer, date, date, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION groupe_update(prm_token integer, prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET grp_nom = prm_nom, eta_id = prm_eta_id, grp_debut = prm_debut, grp_fin = prm_fin, grp_notes = prm_notes
		WHERE grp_id = prm_grp_id;
	RETURN FOUND;
END;
$$;


--
-- Name: FUNCTION groupe_update(prm_token integer, prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION groupe_update(prm_token integer, prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) IS 'Modifie les informations d''un groupe d''usagers.

Entrées :
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe à mettre à jour
 - prm_nom : Nouveau nom du groupe
 - prm_eta_id : Identifiant de l''établissement/partenaire auquel appartient le groupe
 - prm_debut : Date de début d''existence du groupe
 - prm_fin : Date de fin d''existence du groupe
 -  prm_notes : Notes concernant le groupe
';


--
-- Name: periods_overlap(date, date, date, date); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION periods_overlap(du1 date, au1 date, du2 date, au2 date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret BOOLEAN;
BEGIN
--	RAISE NOTICE '% % % %', du1, au1, du2, au2;
	SELECT (COALESCE (du1, timestamp '-INFINITY'), COALESCE (au1, timestamp 'INFINITY')) 
		OVERLAPS (COALESCE (du2, timestamp '-INFINITY'), COALESCE (au2, timestamp 'INFINITY')) INTO ret;
--	RAISE NOTICE '%', ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION periods_overlap(du1 date, au1 date, du2 date, au2 date); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION periods_overlap(du1 date, au1 date, du2 date, au2 date) IS 'Retourne TRUE si 2 périodes de temps se chevauchent, FALSE sinon.';


--
-- Name: personne_ajoute(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_ajoute(prm_token integer, prm_ent_code character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO personne (ent_code) VALUES (prm_ent_code) 
		RETURNING per_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION personne_ajoute(prm_token integer, prm_ent_code character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_ajoute(prm_token integer, prm_ent_code character varying) IS 'Ajoute une nouvelle personne.';


--
-- Name: personne_cherche(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying) RETURNS SETOF personne_cherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_cherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT per_id, 
		personne_info_varchar_get(prm_token, per_id, 'nom') || ' ' || personne_info_varchar_get(prm_token, per_id, 'prenom')
		FROM personne 
		WHERE (prm_nom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'nom') ilike prm_nom || '%')
		 AND (prm_prenom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'prenom') ilike prm_prenom || '%')
		 ORDER BY personne_info_varchar_get(prm_token, per_id, 'nom') || ' ' || personne_info_varchar_get(prm_token, per_id, 'prenom')
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_cherche(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying) RETURNS SETOF personne_cherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_cherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT per_id, 
		COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)
		FROM personne 
		WHERE (prm_nom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'nom') ilike prm_nom || '%')
		 AND (prm_prenom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'prenom') ilike prm_prenom || '%')
		 AND ent_code = prm_type
		 ORDER BY COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)

	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_cherche(integer, character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_grp_id integer) RETURNS SETOF personne_cherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_cherche;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT per_id, 
		COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)
		FROM personne 
		LEFT JOIN personne_groupe USING(per_id)
		WHERE (prm_nom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'nom') ilike prm_nom || '%')
		 AND (prm_prenom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'prenom') ilike prm_prenom || '%')
		 AND ent_code = prm_type   
		 AND (prm_grp_id ISNULL OR (personne_groupe.grp_id = prm_grp_id AND CURRENT_TIMESTAMP BETWEEN COALESCE(personne_groupe.peg_debut, '-Infinity'::timestamp) AND COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)))
		 ORDER BY COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)

	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_cherche2(integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche2(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_secteur character varying) RETURNS SETOF personne_cherche
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_cherche;
BEGIN
--	RAISE WARNING '%', prm_secteur;
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT per_id, 
		COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)
		FROM personne 
		WHERE (prm_nom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'nom') ilike prm_nom || '%')
		 AND (prm_prenom ISNULL OR personne_info_varchar_get(prm_token, per_id, 'prenom') ilike prm_prenom || '%')
		 AND ent_code = prm_type
		  AND (prm_secteur ISNULL OR 
			personne_info_integer_get (prm_token, per_id, 'personnel_metier') IN (SELECT met_id FROM meta.metier INNER JOIN meta.metier_secteur USING (met_id) INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur) OR 
			personne_info_integer_get (prm_token, per_id, 'contact_metier') IN (SELECT met_id FROM meta.metier INNER JOIN meta.metier_secteur USING (met_id) INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur)
		  )
		 ORDER BY COALESCE (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ', '') || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ||
		(CASE WHEN prm_type = 'usager' THEN ''
		     WHEN prm_type = 'famille' THEN ''
		     WHEN prm_type = 'contact' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'contact_metier'))) || ')', '')
		     WHEN prm_type = 'personnel' THEN COALESCE (' (' || (SELECT met_nom FROM meta.metier WHERE met_id = (SELECT * FROM personne_info_integer_get(prm_token, per_id, 'personnel_metier'))) || ')', '')  
		 END)

	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_cherche_exact(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche_exact(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT per_id FROM personne
		WHERE personne_info_varchar_get(prm_token, per_id, 'nom') ilike prm_nom
		 AND COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') ilike COALESCE (prm_prenom, '')
		 AND ent_code = prm_type 
	LOOP
	    RETURN NEXT row.per_id;
	END LOOP;

END;
$$;


--
-- Name: personne_cherche_exact_tout(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_cherche_exact_tout(prm_token integer, prm_nom_prenom character varying, prm_type character varying) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT per_id FROM personne
		WHERE TRIM (personne_info_varchar_get(prm_token, per_id, 'nom') || ' ' || COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '')) ilike TRIM (prm_nom_prenom)
		 AND ent_code = prm_type 
	LOOP
	    RETURN NEXT row.per_id;
	END LOOP;

END;
$$;


--
-- Name: personne_contact_liste(integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer) RETURNS SETOF personne_contact_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row1 RECORD;
	int_per_id integer;
	row personne_contact_liste%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row1 IN
		SELECT per_id FROM personne 
		WHERE (prm_filtre ISNULL OR ent_code = prm_filtre)
		AND personne_info_integer_get(prm_token, per_id, ent_code || '_metier') 
		  IN (SELECT met_id FROM meta.metier_secteur INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur)
		AND (prm_eta_id ISNULL 
		     OR (((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_affectation') = FALSE 
                          AND (SELECT valeur1 FROM personne_info_integer2_get(prm_token, per_id, ent_code || '_affectation')) = prm_eta_id) 
                         OR ((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_affectation') = TRUE 
                          AND prm_eta_id IN (SELECT valeur1 FROM personne_info_integer2_get_multiple(prm_token, per_id, ent_code || '_affectation')))))
	LOOP
		row.per_id = row1.per_id;
		SELECT personne_info_varchar_get (prm_token, row1.per_id, 'nom') || ' ' || personne_info_varchar_get (prm_token, row1.per_id, 'prenom') INTO row.libelle;
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer) IS 'Retourne la liste des contacts ayant un métier dans un secteur donné affectés à un établissement donné.';


--
-- Name: personne_etablissement_update(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_etablissement_update(prm_token integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	eta RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_etablissement WHERE per_id = prm_per_id;
	FOR eta IN SELECT eta_id FROM etablissement LOOP
		IF EXISTS (SELECT 1 FROM personne_groupe INNER JOIN groupe USING(grp_id) WHERE per_id = prm_per_id AND eta_id = eta.eta_id) THEN
			INSERT INTO personne_etablissement (per_id, eta_id) VALUES (prm_per_id, eta.eta_id);
		END IF;
	END LOOP;
END;
$$;


--
-- Name: personne; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne (
    per_id integer NOT NULL,
    ent_code character varying
);


--
-- Name: TABLE personne; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne IS 'Information de base sur les usagers/personnels/contacts/membres de famille.';


--
-- Name: COLUMN personne.per_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne.per_id IS 'Identifiant de la personne';


--
-- Name: COLUMN personne.ent_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne.ent_code IS 'Code du type de personne';


--
-- Name: personne_get(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_get(prm_token integer, prm_per_id integer) RETURNS personne
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret personne;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM personne WHERE per_id = prm_per_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION personne_get(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_get(prm_token integer, prm_per_id integer) IS 'Retourne les informations sur une personne.';


--
-- Name: personne_get_libelle(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_get_libelle(prm_token integer, prm_per_id integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret VARCHAR;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT COALESCE (personne_info_varchar_get(prm_token, per_id, 'prenom'), '') || ' ' || COALESCE (personne_info_varchar_get (prm_token, per_id, 'nom'), '') INTO ret FROM personne where per_id = prm_per_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION personne_get_libelle(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_get_libelle(prm_token integer, prm_per_id integer) IS 'Retourne le prénom suivi du nom d''une personne.';


--
-- Name: personne_get_libelle_initiale(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_get_libelle_initiale(prm_token integer, prm_per_id integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret VARCHAR;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT COALESCE (SUBSTRING(personne_info_varchar_get(prm_token, per_id, 'prenom') FROM 1 FOR 1) || '.', '') || ' ' || COALESCE (personne_info_varchar_get (prm_token, per_id, 'nom'), '') INTO ret FROM personne where per_id = prm_per_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION personne_get_libelle_initiale(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_get_libelle_initiale(prm_token integer, prm_per_id integer) IS 'Retourne l''initiale du prénom suivi du nom d''une personne.';


--
-- Name: personne_groupe_ajoute(integer, integer, integer, date, date, text, integer, date, date, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_groupe_ajoute(prm_token integer, prm_per_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	tmp integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO personne_groupe (per_id, grp_id, peg_debut, peg_fin, peg_cycle_statut, peg_cycle_date_demande, peg_cycle_date_demande_renouvellement, peg__hebergement_chambre, peg_notes, peg__decideur_financeur) 
	VALUES (prm_per_id, prm_grp_id, prm_debut, prm_fin, prm_cycle_statut, prm_cycle_date_demande, prm_cycle_date_demande_renouvellement, prm__hebergement_chambre, prm_notes, prm__decideur_financeur)
		RETURNING peg_id INTO ret;
	EXECUTE personne_etablissement_update (prm_token, prm_per_id);
	SELECT * INTO tmp FROM meta.meta_statut_usager_calcule ('statut_usager', prm_per_id);
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION personne_groupe_ajoute(prm_token integer, prm_per_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_groupe_ajoute(prm_token integer, prm_per_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) IS 'Affecte un usager à un groupe.';


--
-- Name: personne_groupe_info(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_groupe_info(prm_token integer, prm_peg_id integer) RETURNS groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe_liste%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	select 
		personne_groupe.peg_id, 
		groupe.grp_id, 
		groupe.eta_id,
		etablissement.eta_nom,
		groupe.grp_nom, 
		personne_groupe.peg_debut, 
		personne_groupe.peg_fin,
		personne_groupe.peg_notes,
		personne_groupe.peg_cycle_statut,
		personne_groupe.peg_cycle_date_demande,
		personne_groupe.peg_cycle_date_demande_renouvellement,
		personne_groupe.peg__hebergement_chambre,
		personne_groupe.peg__decideur_financeur
 INTO row
	FROM groupe 
	LEFT JOIN etablissement USING(eta_id)
	INNER JOIN groupe_secteur USING(grp_id)
	INNER JOIN meta.secteur USING(sec_id)
	INNER JOIN personne_groupe USING (grp_id)
	where peg_id = prm_peg_id ;
	RETURN row;
END;
$$;


--
-- Name: FUNCTION personne_groupe_info(prm_token integer, prm_peg_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_groupe_info(prm_token integer, prm_peg_id integer) IS 'Retourne les informations sur l''affectation d''un usager à un groupe.';


--
-- Name: personne_groupe_liste2(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer) RETURNS SETOF groupe_liste
    LANGUAGE plpgsql
    AS $$
DECLARE
	row groupe_liste%ROWTYPE;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT DISTINCT
			personne_groupe.peg_id, 
			groupe.grp_id, 
			groupe.eta_id,
			etablissement.eta_nom,
			groupe.grp_nom, 
			personne_groupe.peg_debut, 
			personne_groupe.peg_fin,
			personne_groupe.peg_notes,
			personne_groupe.peg_cycle_statut,
			personne_groupe.peg_cycle_date_demande,
			personne_groupe.peg_cycle_date_demande_renouvellement,
			personne_groupe.peg__hebergement_chambre,
			personne_groupe.peg__decideur_financeur
		FROM groupe 
		INNER JOIN personne_groupe USING (grp_id)
		INNER JOIN groupe_secteur USING (grp_id)
		INNER JOIN meta.secteur ON secteur.sec_id = groupe_secteur.sec_id
		INNER JOIN meta.info ON info.inf__groupe_type = secteur.sec_code
		INNER JOIN groupe_info_secteur ON groupe_info_secteur.grp_id=groupe.grp_id AND groupe_info_secteur.inf_id=info.inf_id
		LEFT JOIN etablissement USING(eta_id)
		where per_id = prm_per_id AND groupe_info_secteur.inf_id = prm_inf_id
		ORDER BY peg_debut DESC, peg_fin DESC
	LOOP
		return NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer) IS 'Retourne la liste des affectations d''une personne à des groupes, associées à un champ groupe donné.';


--
-- Name: personne_groupe_supprime(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_groupe_supprime(prm_token integer, prm_peg_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	tmp integer;
	per integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT per_id INTO per FROM personne_groupe WHERE peg_id = prm_peg_id;
	DELETE FROM personne_groupe WHERE peg_id = prm_peg_id;
	EXECUTE personne_etablissement_update (prm_token, per);
	SELECT * INTO tmp FROM meta.meta_statut_usager_calcule ('statut_usager', per);
END;
$$;


--
-- Name: FUNCTION personne_groupe_supprime(prm_token integer, prm_peg_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_groupe_supprime(prm_token integer, prm_peg_id integer) IS 'Supprime l''affectation d''un usager à un groupe.';


--
-- Name: personne_groupe_update(integer, integer, integer, date, date, text, integer, date, date, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_groupe_update(prm_token integer, prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	tmp integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE personne_groupe SET 
		grp_id = prm_grp_id,
		peg_debut = prm_debut,
		peg_fin = prm_fin,
		peg_notes = prm_notes,
		peg_cycle_statut = prm_cycle_statut,
		peg_cycle_date_demande = prm_cycle_date_demande,
		peg_cycle_date_demande_renouvellement = prm_cycle_date_demande_renouvellement,
		peg__hebergement_chambre = prm__hebergement_chambre ,
		peg__decideur_financeur = prm__decideur_financeur
		WHERE peg_id = prm_peg_id;
		SELECT * INTO tmp FROM meta.meta_statut_usager_calcule ('statut_usager', (SELECT per_id FROM personne_groupe WHERE peg_id = prm_peg_id));
END;
$$;


--
-- Name: FUNCTION personne_groupe_update(prm_token integer, prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_groupe_update(prm_token integer, prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) IS 'Modifie les informations d''affectation d''un usager à un groupe.';


--
-- Name: personne_info_boolean_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_boolean_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret boolean;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pib_valeur INTO ret 
		FROM personne_info_boolean
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pib_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_boolean_get_histo(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_boolean_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_boolean_histo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_boolean_histo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pib_debut, pib_fin, 
		       CASE WHEN pib_valeur THEN 'oui' else 'non' END,
		       login.utilisateur_prenon_nom(prm_token, uti_id) 
		FROM personne_info_boolean
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pib_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_boolean_set(integer, integer, character varying, boolean, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_boolean_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur boolean, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	historique boolean;
	pib_id_dernier integer;
	the_pin_id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT inf_historique INTO historique FROM meta.info WHERE inf_code = prm_inf_code;
	IF historique THEN
	-- Valeur historisée :
		SELECT pin_id INTO the_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO the_pin_id;
		END IF;
		SELECT pib_id INTO pib_id_dernier FROM personne_info_boolean WHERE pin_id = the_pin_id
			ORDER BY pib_id DESC LIMIT 1;
		-- on met à jour seulement si la valeur n'existe pas encore ou est différente 
		IF prm_valeur IS DISTINCT FROM (SELECT pib_valeur FROM personne_info_boolean WHERE pib_id = pib_id_dernier) THEN
			-- On met la date de fin à la précédente valeur
			UPDATE personne_info_boolean SET pib_fin = CURRENT_TIMESTAMP WHERE pib_id = pib_id_dernier;
			-- puis on crée la nouvelle valeur
			INSERT INTO personne_info_boolean (pin_id, pib_valeur, pib_debut, uti_id) VALUES (the_pin_id, prm_valeur, CURRENT_TIMESTAMP, prm_uti_id);
		END IF;
	ELSE 
		-- Valeur ni historisée ni multiple : on écrase l'ancienne valeur
		UPDATE personne_info_boolean
			SET pib_valeur = prm_valeur, uti_id = prm_uti_id WHERE pib_debut ISNULL AND pib_fin ISNULL AND
			pib_valeur IS DISTINCT FROM prm_valeur AND
			pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
		IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_boolean WHERE 
		       	     	 pib_debut ISNULL AND pib_fin ISNULL AND
				 pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN 
			-- ou on la crée si elle n'existe pas
			SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
			IF NOT FOUND THEN
				INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
			END IF;
			INSERT INTO personne_info_boolean (pin_id, pib_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
		END IF;
	END IF;
END;
$$;


--
-- Name: personne_info_contact_get_histo(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_contact_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_contact_histo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_contact_histo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pii_debut, pii_fin, 
		       personne_info_varchar_get (prm_token, pii_valeur, 'nom') || ' ' || personne_info_varchar_get (prm_token, pii_valeur, 'prenom'),
		       login.utilisateur_prenon_nom(prm_token, uti_id) 
		FROM personne_info_integer 
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pii_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_date_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_date_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS date
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret date;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pid_valeur INTO ret 
		FROM personne_info_date
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pid_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_date_get_histo(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_date_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_date_histo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_date_histo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pid_debut, pid_fin, pid_valeur,
		       login.utilisateur_prenon_nom(prm_token, uti_id) 
		FROM personne_info_date 
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pid_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_date_get_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_date_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF date
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT pid_valeur
			FROM personne_info_date
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY pid_id 
	LOOP
		RETURN NEXT row.pid_valeur;
	END LOOP;
END;
$$;


--
-- Name: personne_info_date_prepare_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_date_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_date WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;


--
-- Name: personne_info_date_set(integer, integer, character varying, date, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_date_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur date, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	historique boolean;
	multiple boolean;
	pid_id_dernier integer;
	the_pin_id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT inf_historique INTO historique FROM meta.info WHERE inf_code = prm_inf_code;
	SELECT inf_multiple INTO multiple FROM meta.info WHERE inf_code = prm_inf_code;
	IF historique THEN
	-- Valeur historisée :
		SELECT pin_id INTO the_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO the_pin_id;
		END IF;
		SELECT pid_id INTO pid_id_dernier FROM personne_info_date WHERE pin_id = the_pin_id
			ORDER BY pid_id DESC LIMIT 1;
		-- on met à jour seulement si la valeur n'existe pas encore ou est différente 
		IF prm_valeur IS DISTINCT FROM (SELECT pid_valeur FROM personne_info_date WHERE pid_id = pid_id_dernier) THEN
			-- On met la date de fin à la précédente valeur
			UPDATE personne_info_date SET pid_fin = CURRENT_TIMESTAMP WHERE pid_id = pid_id_dernier;
			-- puis on crée la nouvelle valeur
			INSERT INTO personne_info_date (pin_id, pid_valeur, pid_debut, uti_id) VALUES (the_pin_id, prm_valeur, CURRENT_TIMESTAMP, prm_uti_id);
		END IF;
	ELSIF multiple THEN
		SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
		END IF;
		INSERT INTO personne_info_date (pin_id, pid_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
	ELSE 
		-- Valeur ni historisée ni multiple : on écrase l'ancienne valeur
		UPDATE personne_info_date
			SET pid_valeur = prm_valeur, uti_id = prm_uti_id WHERE pid_debut ISNULL AND pid_fin ISNULL AND
			pid_valeur IS DISTINCT FROM prm_valeur AND
			pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
		IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_date WHERE pid_debut ISNULL AND pid_fin ISNULL AND
		       	     	 pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN
			-- ou on la crée si elle n'existe pas
			SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
			IF NOT FOUND THEN
				INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
			END IF;
			INSERT INTO personne_info_date (pin_id, pid_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
		END IF;
	END IF;
END;
$$;


--
-- Name: personne_info_integer2_delete(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_delete(prm_token integer, prm_pij_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer2 WHERE pij_id = prm_pij_id;
END;
$$;


--
-- Name: personne_info_integer2_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS integer2
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer2;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pij_valeur1, pij_valeur2, pij_id INTO ret 
		FROM personne_info_integer2
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pij_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_integer2_get_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF integer2
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT pij_valeur1, pij_valeur2, pij_id
			FROM personne_info_integer2
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY pij_id 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_integer2_get_par_id(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_get_par_id(prm_token integer, prm_pij_id integer) RETURNS integer2
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer2;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pij_valeur1, pij_valeur2, pij_id INTO ret 
		FROM personne_info_integer2
		WHERE pij_id = prm_pij_id; 
	RETURN ret;
END;
$$;


--
-- Name: personne_info_integer2_prepare_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer2 WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;


--
-- Name: personne_info_integer2_set(integer, integer, character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer2_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur1 integer, prm_valeur2 integer, prm_uti_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	multiple boolean;
	pii_id_dernier integer;
	the_pin_id integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT inf_multiple INTO multiple FROM meta.info WHERE inf_code = prm_inf_code;
	IF multiple THEN
		SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
		END IF;
		INSERT INTO personne_info_integer2 (pin_id, pij_valeur1, pij_valeur2, uti_id) VALUES (new_pin_id, prm_valeur1, prm_valeur2, prm_uti_id)
			RETURNING pij_id INTO ret;
		RETURN ret;
	ELSE 
		-- Valeur ni historisée ni multiple : on écrase l'ancienne valeur
		UPDATE personne_info_integer2
			SET pij_valeur1 = prm_valeur1, pij_valeur2 = prm_valeur2, uti_id = prm_uti_id WHERE pij_debut ISNULL AND pij_fin ISNULL AND
			(pij_valeur1 IS DISTINCT FROM prm_valeur1 OR pij_valeur2 IS DISTINCT FROM prm_valeur2) AND
			pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
		IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_integer2 WHERE pij_debut ISNULL AND pij_fin ISNULL AND
		       	     pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN
			-- ou on la crée si elle n'existe pas
			SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
			IF NOT FOUND THEN
				INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
			END IF;
			INSERT INTO personne_info_integer2 (pin_id, pij_valeur1, pij_valeur2, uti_id) VALUES (new_pin_id, prm_valeur1, prm_valeur2, prm_uti_id)
				RETURNING pij_id INTO ret;
			RETURN ret;
		ELSE
			RETURN 0;
		END IF;
	END IF;
END;
$$;


--
-- Name: personne_info_integer_delete(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_delete(prm_token integer, prm_pii_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer WHERE pii_id = prm_pii_id;
END;
$$;


--
-- Name: personne_info_integer_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pii_valeur INTO ret 
		FROM personne_info_integer
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pii_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_integer_get_histo(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_integer_histo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_integer_histo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pii_debut, pii_fin, sen_libelle,
		       login.utilisateur_prenon_nom(prm_token, uti_id) 
		FROM personne_info_integer 
		INNER JOIN personne_info USING (pin_id)
		INNER JOIN meta.selection_entree ON pii_valeur = sen_id
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY pii_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_integer_get_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT pii_valeur
			FROM personne_info_integer
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY pii_id 
	LOOP
		RETURN NEXT row.pii_valeur;
	END LOOP;
END;
$$;


--
-- Name: personne_info_integer_get_multiple_details(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_get_multiple_details(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_integer_get_multiple_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_integer_get_multiple_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT pii_id, pii_valeur
			FROM personne_info_integer
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY pii_id 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_integer_prepare_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;


--
-- Name: personne_info_integer_set(integer, integer, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_integer_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur integer, prm_uti_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	historique boolean;
	multiple boolean;
	pii_id_dernier integer;
	the_pin_id integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	ret = 0;
--	RAISE NOTICE '% % %', prm_per_id, prm_inf_code, prm_valeur;
	SELECT inf_historique INTO historique FROM meta.info WHERE inf_code = prm_inf_code;
	SELECT inf_multiple INTO multiple FROM meta.info WHERE inf_code = prm_inf_code;
	IF historique THEN
	-- Valeur historisée :
		SELECT pin_id INTO the_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO the_pin_id;
		END IF;
		SELECT pii_id INTO pii_id_dernier FROM personne_info_integer WHERE pin_id = the_pin_id
			ORDER BY pii_id DESC LIMIT 1;
		-- on met à jour seulement si la valeur n'existe pas encore ou est différente 
		IF prm_valeur IS DISTINCT FROM (SELECT pii_valeur FROM personne_info_integer WHERE pii_id = pii_id_dernier) THEN
			-- On met la date de fin à la précédente valeur
			UPDATE personne_info_integer SET pii_fin = CURRENT_TIMESTAMP WHERE pii_id = pii_id_dernier;
			-- puis on crée la nouvelle valeur
			INSERT INTO personne_info_integer (pin_id, pii_valeur, pii_debut, uti_id) VALUES (the_pin_id, prm_valeur, CURRENT_TIMESTAMP, prm_uti_id)
				RETURNING pii_id INTO ret;
		END IF;
	ELSIF multiple THEN
		SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
		END IF;
		INSERT INTO personne_info_integer (pin_id, pii_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id)
			RETURNING pii_id INTO ret;
	ELSE 
		-- Valeur ni historisée ni multiple : on écrase l'ancienne valeur
		UPDATE personne_info_integer
			SET pii_valeur = prm_valeur, uti_id = prm_uti_id WHERE pii_debut ISNULL AND pii_fin ISNULL AND
			pii_valeur IS DISTINCT FROM prm_valeur AND
			pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
		IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_integer WHERE pii_debut ISNULL AND pii_fin ISNULL AND
		       	     pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN
			-- ou on la crée si elle n'existe pas
			SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
			IF NOT FOUND THEN
				INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
			END IF;
			INSERT INTO personne_info_integer (pin_id, pii_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id)
				RETURNING pii_id INTO ret;
		END IF;
	END IF;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_lien_familial_delete(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_lien_familial_delete(prm_token integer, prm_pif_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_lien_familial WHERE pif_id = prm_pif_id;
END;
$$;


--
-- Name: personne_info_lien_familial; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_lien_familial (
    pif_id integer NOT NULL,
    pin_id integer,
    per_id_parent integer,
    lfa_id integer,
    pif_droits character varying,
    pif_periodicite character varying,
    pif_autorite_parentale integer
);


--
-- Name: TABLE personne_info_lien_familial; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_lien_familial IS 'Valeur d''un champ de type "Lien familial" pour une personne.';


--
-- Name: COLUMN personne_info_lien_familial.pif_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.pif_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_lien_familial.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_lien_familial.per_id_parent; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.per_id_parent IS 'Identifiant de la personne parente';


--
-- Name: COLUMN personne_info_lien_familial.lfa_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.lfa_id IS 'Type de lien familial';


--
-- Name: COLUMN personne_info_lien_familial.pif_droits; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.pif_droits IS 'Droits du parent sur l''usager :
rencontre : Rencontre médiatisée
visite : Visite
sortie : Sortie et visite
hebergement : Hébergement';


--
-- Name: COLUMN personne_info_lien_familial.pif_periodicite; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.pif_periodicite IS 'Périodicité du droit (texte libre)';


--
-- Name: COLUMN personne_info_lien_familial.pif_autorite_parentale; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_lien_familial.pif_autorite_parentale IS 'Autorité du parent sur l''usager :
1 : Autorité parentale
2 : Tutelle
3 : Aucune autorité';


--
-- Name: personne_info_lien_familial_get_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_lien_familial_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_lien_familial
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT personne_info_lien_familial.*
			FROM personne_info_lien_familial
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY pif_id 
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_lien_familial_get_par_id(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_lien_familial_get_par_id(prm_token integer, prm_pif_id integer) RETURNS personne_info_lien_familial
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret personne_info_lien_familial;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT personne_info_lien_familial.* INTO ret 
		FROM personne_info_lien_familial
		WHERE pif_id = prm_pif_id; 
	RETURN ret;
END;
$$;


--
-- Name: personne_info_lien_familial_set(integer, integer, character varying, integer, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_lien_familial_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_per_id_parent integer, prm_lfa_id integer, prm_autorite_parentale integer, prm_droits character varying, prm_periodicite character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	-- On considère que c'est multiple
	SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
	IF NOT FOUND THEN
		INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
	END IF;
	INSERT INTO personne_info_lien_familial (pin_id, per_id_parent, lfa_id, pif_autorite_parentale, pif_droits, pif_periodicite) 
			VALUES (new_pin_id, prm_per_id_parent, prm_lfa_id, prm_autorite_parentale, prm_droits, prm_periodicite)
		RETURNING pif_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_text_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_text_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret text;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT pit_valeur INTO ret 
		FROM personne_info_text
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_text_set(integer, integer, character varying, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_text_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur text, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE personne_info_text
		SET pit_valeur = prm_valeur, uti_id = prm_uti_id WHERE pit_debut ISNULL AND pit_fin ISNULL AND
		pit_valeur IS DISTINCT FROM prm_valeur AND 
		pin_id = (SELECT pin_id FROM personne_info 
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
	IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_text WHERE pit_debut ISNULL AND pit_fin ISNULL AND
	              	 pin_id = (SELECT pin_id FROM personne_info 
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN
		INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
		INSERT INTO personne_info_text (pin_id, pit_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
	END IF;
END;
$$;


--
-- Name: personne_info_varchar_get(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_varchar_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT piv_valeur INTO ret 
		FROM personne_info_varchar
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY piv_id DESC LIMIT 1;
	RETURN ret;
END;
$$;


--
-- Name: personne_info_varchar_get_histo(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_varchar_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_varchar_histo
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_varchar_histo;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT piv_debut, piv_fin, piv_valeur,
		       login.utilisateur_prenon_nom(prm_token, uti_id) 
		FROM personne_info_varchar 
		INNER JOIN personne_info USING (pin_id)
		WHERE per_id = prm_per_id AND inf_code = prm_inf_code
		ORDER BY piv_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: personne_info_varchar_get_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_varchar_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN 
		SELECT piv_valeur
			FROM personne_info_varchar
			INNER JOIN personne_info USING (pin_id)
			WHERE per_id = prm_per_id AND inf_code = prm_inf_code
			ORDER BY piv_id 
	LOOP
		RETURN NEXT row.piv_valeur;
	END LOOP;
END;
$$;


--
-- Name: personne_info_varchar_prepare_multiple(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_varchar_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_varchar WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;


--
-- Name: personne_info_varchar_set(integer, integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_info_varchar_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur character varying, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	new_pin_id integer;
	historique boolean;
	multiple boolean;
	piv_id_dernier integer;
	the_pin_id integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT inf_historique INTO historique FROM meta.info WHERE inf_code = prm_inf_code;
	SELECT inf_multiple INTO multiple FROM meta.info WHERE inf_code = prm_inf_code;
	IF historique THEN
	-- Valeur historisée :
		SELECT pin_id INTO the_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO the_pin_id;
		END IF;
		SELECT piv_id INTO piv_id_dernier FROM personne_info_varchar WHERE pin_id = the_pin_id
			ORDER BY piv_id DESC LIMIT 1;
		-- on met à jour seulement si la valeur n'existe pas encore ou est différente 
		IF prm_valeur IS DISTINCT FROM (SELECT piv_valeur FROM personne_info_varchar WHERE piv_id = piv_id_dernier) THEN
			-- On met la date de fin à la précédente valeur
			UPDATE personne_info_varchar SET piv_fin = CURRENT_TIMESTAMP WHERE piv_id = piv_id_dernier;
			-- puis on crée la nouvelle valeur
			INSERT INTO personne_info_varchar (pin_id, piv_valeur, piv_debut, uti_id) VALUES (the_pin_id, prm_valeur, CURRENT_TIMESTAMP, prm_uti_id);
		END IF;
	ELSIF multiple THEN
		SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
		IF NOT FOUND THEN
			INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
		END IF;
		INSERT INTO personne_info_varchar (pin_id, piv_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
	ELSE 
		-- Valeur ni historisée ni multiple : on écrase l'ancienne valeur
		UPDATE personne_info_varchar
			SET piv_valeur = prm_valeur, uti_id = prm_uti_id WHERE piv_debut ISNULL AND piv_fin ISNULL AND
			piv_valeur IS DISTINCT FROM prm_valeur AND
			pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
		IF NOT FOUND AND NOT EXISTS (SELECT 1 FROM personne_info_varchar WHERE piv_debut ISNULL AND piv_fin ISNULL AND
		       	     	 pin_id = (SELECT pin_id FROM personne_info 
				WHERE per_id = prm_per_id AND inf_code = prm_inf_code)) THEN
			-- ou on la crée si elle n'existe pas
			SELECT pin_id INTO new_pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code;
			IF NOT FOUND THEN
				INSERT INTO personne_info (per_id, inf_code) VALUES (prm_per_id, prm_inf_code) RETURNING pin_id INTO new_pin_id;
			END IF;
			INSERT INTO personne_info_varchar (pin_id, piv_valeur, uti_id) VALUES (new_pin_id, prm_valeur, prm_uti_id);
		END IF;
	END IF;
END;
$$;


--
-- Name: personne_liste(integer, character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_liste(prm_token integer, prm_ent_code character varying) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT per_id FROM personne WHERE ent_code = prm_ent_code ORDER BY per_id
	LOOP
		RETURN NEXT row.per_id;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION personne_liste(prm_token integer, prm_ent_code character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_liste(prm_token integer, prm_ent_code character varying) IS 'Retourne la liste des personne d''un type donné.';


--
-- Name: personne_supprime(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION personne_supprime(prm_token integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row RECORD;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT pin_id FROM personne_info WHERE per_id = prm_per_id
	LOOP
		DELETE FROM personne_info_boolean WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_date WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_integer WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_integer2 WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_lien_familial WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_text WHERE pin_id = row.pin_id;
		DELETE FROM personne_info_varchar WHERE pin_id = row.pin_id;
		DELETE FROM personne_info WHERE pin_id = row.pin_id;
	END LOOP;
	DELETE FROM personne_info_lien_familial WHERE per_id_parent = prm_per_id;
	DELETE FROM personne_etablissement WHERE per_id = prm_per_id;
	DELETE FROM personne_groupe WHERE per_id = prm_per_id;
	DELETE FROM notes.note_usager WHERE per_id = prm_per_id;
	DELETE FROM events.event_personne WHERE per_id = prm_per_id;
	DELETE FROM personne WHERE per_id = prm_per_id;
END;
$$;


--
-- Name: FUNCTION personne_supprime(prm_token integer, prm_per_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION personne_supprime(prm_token integer, prm_per_id integer) IS 'Supprime une personne.';


--
-- Name: pgprocedures_add_call(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgprocedures_add_call(prm_method character varying, prm_nargs integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE pgprocedures_stats SET cal_ncalls = cal_ncalls + 1 WHERE cal_function_name = prm_method AND cal_nargs = prm_nargs;
	IF NOT FOUND THEN
		INSERT INTO pgprocedures_stats (cal_function_name, cal_nargs, cal_ncalls) VALUES (prm_method, prm_nargs, 1);
	END IF;
END;
$$;


--
-- Name: pgprocedures_search_arguments(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgprocedures_search_arguments(prm_function character varying) RETURNS SETOF pgprocedures_search_arguments
    LANGUAGE plpgsql
    AS $$                                                                                                                                
DECLARE                                                                                                                           
 row pgprocedures_search_arguments%ROWTYPE;                                                                                       
BEGIN                                                                                                                             
 FOR row IN                                                                                                                       
   SELECT proargnames, proargtypes                                                                                                
    FROM pg_proc                                                                                                                  
     WHERE proname = prm_function                                                                                                 
     ORDER BY pronargs DESC                                                                                                       
 LOOP                                                                                                                             
   RETURN NEXT row;                                                                                                               
 END LOOP;                                                                                                                        
END;                                                                                                                              
$$;


--
-- Name: pgprocedures_search_function(character varying, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pgprocedures_search_function(prm_method character varying, prm_nargs integer) RETURNS pgprocedures_search_function
    LANGUAGE plpgsql
    AS $$                                                                                                                            
DECLARE                                                                                                                           
      ret pgprocedures_search_function%ROWTYPE;                                                                                   
BEGIN            
	--PERFORM pgprocedures_add_call (prm_method, prm_nargs);
      SELECT                                                                                                                      
          pg_namespace_proc.nspname AS proc_nspname,                                                                              
          proargtypes,                                                                                                            
          prorettype,                                                                                                             
          pg_type_ret.typtype AS ret_typtype,                                                                                     
          pg_type_ret.typname AS ret_typname,                                                                                     
          pg_namespace_ret.nspname AS ret_nspname,                                                                                
          proretset                                                                                                               
      INTO ret                                                                                                                    
      FROM pg_proc                                                                                                                
          INNER JOIN pg_type pg_type_ret ON pg_type_ret.oid = pg_proc.prorettype                                                  
          INNER JOIN pg_namespace pg_namespace_ret ON pg_namespace_ret.oid = pg_type_ret.typnamespace                             
          INNER JOIN pg_namespace pg_namespace_proc ON pg_namespace_proc.oid = pg_proc.pronamespace                               
      WHERE proname = prm_method AND pronargs = prm_nargs;                                                                        
      RETURN ret;                                                                                                                 
END;                                                                                                                              
$$;


--
-- Name: pour_code(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION pour_code(str character varying) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE

BEGIN
	RETURN LOWER (TRANSLATE (str,' ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ°«»#,()''+/.&"', 
                                     '_aaaaaaaaaaaaooooooooooooeeeeeeeecciiiiiiiiuuuuuuuuynn___d_________'));
END;
$$;


--
-- Name: FUNCTION pour_code(str character varying); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION pour_code(str character varying) IS 'Retourne une chaîne sans caractères non-ascii.';


--
-- Name: prise_en_charge_select(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION prise_en_charge_select(prm_token integer, prm_eta_id integer) RETURNS SETOF prise_en_charge_select
    LANGUAGE plpgsql
    AS $$
DECLARE
	uti integer;
	row prise_en_charge_select;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT uti_id INTO uti FROM login.token WHERE tok_token = prm_token;
	FOR row IN SELECT groupe.grp_id, groupe.grp_nom FROM groupe 
		INNER JOIN login.grouputil_groupe USING(grp_id) 
		INNER JOIN login.utilisateur_grouputil USING(gut_id) WHERE uti_id = uti AND groupe.eta_id = prm_eta_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION prise_en_charge_select(prm_token integer, prm_eta_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION prise_en_charge_select(prm_token integer, prm_eta_id integer) IS 'Retourne la liste des groupes de prise en charge auxquels un utilisateur a accès depuis le portail d''un établissement.';


--
-- Name: secteur_infos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE secteur_infos (
    sei_id integer NOT NULL,
    sec_id integer,
    sec_editable boolean
);


--
-- Name: secteur_infos_get(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION secteur_infos_get(prm_token integer, prm_sec_id integer) RETURNS secteur_infos
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret secteur_infos;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	SELECT * INTO ret FROM secteur_infos WHERE sec_id = prm_sec_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION secteur_infos_get(prm_token integer, prm_sec_id integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION secteur_infos_get(prm_token integer, prm_sec_id integer) IS 'Retourne les informations supplémentaires sur un secteur.';


--
-- Name: secteur_infos_update(integer, integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION secteur_infos_update(prm_token integer, prm_sec_id integer, prm_editable boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE secteur_infos SET sec_editable = prm_editable WHERE sec_id = prm_sec_id;
	IF NOT FOUND THEN
		INSERT INTO secteur_infos (sec_id, sec_editable) VALUES (prm_sec_id, prm_editable);
	END IF;
END;
$$;


--
-- Name: FUNCTION secteur_infos_update(prm_token integer, prm_sec_id integer, prm_editable boolean); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION secteur_infos_update(prm_token integer, prm_sec_id integer, prm_editable boolean) IS 'Modifie les informations supplémentaires sur un secteur.';


--
-- Name: test1(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION test1() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	raise notice 'coucou';
END;
$$;


--
-- Name: tmp_transforme_lien_familial(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION tmp_transforme_lien_familial() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
	row personne_info_integer2;
BEGIN
	FOR row IN select personne_info_integer2.* FROM personne_info_integer2 inner join personne_info using(pin_id) where inf_code = 'famille' LOOP
--		INSERT INTO personne_info_lien_familial (pin_id, per_id_parent, lfa_id) VALUES (row.pin_id, row.pij_valeur1, row.pij_valeur2);
		delete from personne_info_integer2 WHERE pij_id = row.pij_id;
	END LOOP;
END;
$$;


SET search_path = ressource, pg_catalog;

--
-- Name: ressource_add(integer, character varying); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_add(prm_token integer, prm_res_nom character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	INSERT INTO ressource.ressource (res_nom) VALUES (prm_res_nom) RETURNING res_id INTO ret;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION ressource_add(prm_token integer, prm_res_nom character varying); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_add(prm_token integer, prm_res_nom character varying) IS 'Ajoute une ressource.';


--
-- Name: ressource_get(integer, integer); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_get(prm_token integer, prm_res_id integer) RETURNS ressource
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret ressource.ressource;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	SELECT * INTO ret FROM ressource.ressource WHERE res_id = prm_res_id;
	RETURN ret;
END;
$$;


--
-- Name: FUNCTION ressource_get(prm_token integer, prm_res_id integer); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_get(prm_token integer, prm_res_id integer) IS 'Retourne les informations d''une ressource.';


--
-- Name: ressource_list(integer, integer[]); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_list(prm_token integer, prm_sec_id integer[]) RETURNS SETOF ressource
    LANGUAGE plpgsql
    AS $$
DECLARE
	row ressource.ressource;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT DISTINCT ressource.* FROM ressource.ressource 
		INNER JOIN ressource.ressource_secteur USING(res_id)
		WHERE sec_id = ANY(prm_sec_id)
		ORDER BY res_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION ressource_list(prm_token integer, prm_sec_id integer[]); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_list(prm_token integer, prm_sec_id integer[]) IS 'Retourne la liste des ressources.';


--
-- Name: ressource_liste_details(integer, integer); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_liste_details(prm_token integer, prm_sec_id integer) RETURNS SETOF ressource_liste_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row ressource.ressource_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT res_id, res_nom, concatenate (besoins.sec_nom)
		FROM ressource.ressource
		LEFT JOIN ressource.ressource_secteur USING(res_id)
		LEFT JOIN meta.secteur besoins ON besoins.sec_id = ressource_secteur.sec_id 
		WHERE (prm_sec_id ISNULL OR prm_sec_id = besoins.sec_id) 
		GROUP BY res_id, res_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION ressource_liste_details(prm_token integer, prm_sec_id integer); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_liste_details(prm_token integer, prm_sec_id integer) IS 'Liste en détail les ressources.';


--
-- Name: ressource_save(integer, integer, character varying); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_save(prm_token integer, prm_res_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE ressource.ressource SET res_nom = prm_nom WHERE res_id = prm_res_id;
END;
$$;


--
-- Name: FUNCTION ressource_save(prm_token integer, prm_res_id integer, prm_nom character varying); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_save(prm_token integer, prm_res_id integer, prm_nom character varying) IS 'Enregistre les informations d''une ressource.';


--
-- Name: ressource_secteur_liste(integer, integer); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_secteur_liste(prm_token integer, prm_res_id integer) RETURNS SETOF meta.secteur
    LANGUAGE plpgsql
    AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur
		INNER JOIN ressource.ressource_secteur USING(sec_id)
		WHERE res_id = prm_res_id
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;


--
-- Name: FUNCTION ressource_secteur_liste(prm_token integer, prm_res_id integer); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_secteur_liste(prm_token integer, prm_res_id integer) IS 'Retourne la liste des secteurs auxquels est affectée une ressource.';


--
-- Name: ressource_secteur_set(integer, integer, character varying[]); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_secteur_set(prm_token integer, prm_res_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM ressource.ressource_secteur WHERE res_id = prm_res_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO ressource.ressource_secteur(res_id, sec_id) VALUES (prm_res_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;


--
-- Name: FUNCTION ressource_secteur_set(prm_token integer, prm_res_id integer, prm_secteurs character varying[]); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_secteur_set(prm_token integer, prm_res_id integer, prm_secteurs character varying[]) IS 'Indique à quels secteurs à est affecté une ressource.';


--
-- Name: ressource_supprime(integer, integer); Type: FUNCTION; Schema: ressource; Owner: -
--

CREATE FUNCTION ressource_supprime(prm_token integer, prm_res_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM ressource.ressource_secteur WHERE res_id = prm_res_id;
	DELETE FROM ressource.ressource WHERE res_id = prm_res_id;
END;
$$;


--
-- Name: FUNCTION ressource_supprime(prm_token integer, prm_res_id integer); Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON FUNCTION ressource_supprime(prm_token integer, prm_res_id integer) IS 'Supprime une ressource.';


SET search_path = public, pg_catalog;

--
-- Name: concatenate(text); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE concatenate(text) (
    SFUNC = concat2,
    STYPE = text,
    INITCOND = ''
);


SET search_path = document, pg_catalog;

--
-- Name: document_doc_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_doc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_doc_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_doc_id_seq OWNED BY document.doc_id;


--
-- Name: document_secteur; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document_secteur (
    dse_id integer NOT NULL,
    doc_id integer,
    sec_id integer
);


--
-- Name: TABLE document_secteur; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document_secteur IS 'Rattachement d''un document à des secteurs';


--
-- Name: document_secteur_dse_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_secteur_dse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_secteur_dse_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_secteur_dse_id_seq OWNED BY document_secteur.dse_id;


--
-- Name: document_type_dty_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_type_dty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_type_dty_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_type_dty_id_seq OWNED BY document_type.dty_id;


--
-- Name: document_type_etablissement; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document_type_etablissement (
    dte_id integer NOT NULL,
    dty_id integer,
    eta_id integer
);


--
-- Name: TABLE document_type_etablissement; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document_type_etablissement IS 'Utilisation d''un type de document par un établissement';


--
-- Name: document_type_etablissement_dte_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_type_etablissement_dte_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_type_etablissement_dte_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_type_etablissement_dte_id_seq OWNED BY document_type_etablissement.dte_id;


--
-- Name: document_type_secteur; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE document_type_secteur (
    dts_id integer NOT NULL,
    dty_id integer,
    sec_id integer
);


--
-- Name: TABLE document_type_secteur; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE document_type_secteur IS 'Affectation d''un type de document à des secteurs';


--
-- Name: document_type_secteur_dts_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_type_secteur_dts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_type_secteur_dts_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_type_secteur_dts_id_seq OWNED BY document_type_secteur.dts_id;


--
-- Name: document_usager_dus_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE document_usager_dus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_usager_dus_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE document_usager_dus_id_seq OWNED BY document_usager.dus_id;


--
-- Name: documents_dos_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE documents_dos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_dos_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE documents_dos_id_seq OWNED BY documents.dos_id;


--
-- Name: documents_secteur; Type: TABLE; Schema: document; Owner: -; Tablespace: 
--

CREATE TABLE documents_secteur (
    dss_id integer NOT NULL,
    dos_id integer,
    sec_id integer
);


--
-- Name: TABLE documents_secteur; Type: COMMENT; Schema: document; Owner: -
--

COMMENT ON TABLE documents_secteur IS 'Spécialisation des pages de documents à certains secteurs';


--
-- Name: documents_secteur_dss_id_seq; Type: SEQUENCE; Schema: document; Owner: -
--

CREATE SEQUENCE documents_secteur_dss_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_secteur_dss_id_seq; Type: SEQUENCE OWNED BY; Schema: document; Owner: -
--

ALTER SEQUENCE documents_secteur_dss_id_seq OWNED BY documents_secteur.dss_id;


SET search_path = events, pg_catalog;

--
-- Name: agressources_agr_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE agressources_agr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agressources_agr_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE agressources_agr_id_seq OWNED BY agressources.agr_id;


--
-- Name: agressources_secteur; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE agressources_secteur (
    ase_id integer NOT NULL,
    agr_id integer,
    sec_id integer
);


--
-- Name: TABLE agressources_secteur; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE agressources_secteur IS 'Spécialisation des pages d''agenda par secteur';


--
-- Name: agressources_secteur_ase_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE agressources_secteur_ase_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agressources_secteur_ase_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE agressources_secteur_ase_id_seq OWNED BY agressources_secteur.ase_id;


--
-- Name: categorie_events; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE categorie_events (
    cev_id integer NOT NULL,
    eca_id integer,
    evs_id integer
);


--
-- Name: TABLE categorie_events; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE categorie_events IS 'Spécialisation des pages d''événements à certaines catégories d''événements';


--
-- Name: categorie_events_cev_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE categorie_events_cev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorie_events_cev_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE categorie_events_cev_id_seq OWNED BY categorie_events.cev_id;


--
-- Name: event_eve_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_eve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_eve_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_eve_id_seq OWNED BY event.eve_id;


--
-- Name: event_memo; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_memo (
    eme_id integer NOT NULL,
    eve_id integer,
    eme_timestamp timestamp with time zone,
    eme_type character varying,
    eme_texte text
);


--
-- Name: TABLE event_memo; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_memo IS 'Textes accompagnant les événements (objet, compte-rendu)';


--
-- Name: COLUMN event_memo.eme_type; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON COLUMN event_memo.eme_type IS 'Type de mémo : bilan ou description';


--
-- Name: event_memo_eme_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_memo_eme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_memo_eme_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_memo_eme_id_seq OWNED BY event_memo.eme_id;


--
-- Name: event_personne_epe_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_personne_epe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_personne_epe_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_personne_epe_id_seq OWNED BY event_personne.epe_id;


--
-- Name: event_ressource; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_ressource (
    ere_id integer NOT NULL,
    eve_id integer,
    res_id integer
);


--
-- Name: TABLE event_ressource; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_ressource IS 'Affectation de ressources aux événements';


--
-- Name: event_ressource_ere_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_ressource_ere_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_ressource_ere_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_ressource_ere_id_seq OWNED BY event_ressource.ere_id;


--
-- Name: event_type_etablissement; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_type_etablissement (
    ete_id integer NOT NULL,
    ety_id integer,
    eta_id integer
);


--
-- Name: TABLE event_type_etablissement; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_type_etablissement IS 'Utilisation d''un type d''événement par un établissement';


--
-- Name: event_type_etablissement_ete_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_type_etablissement_ete_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_type_etablissement_ete_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_type_etablissement_ete_id_seq OWNED BY event_type_etablissement.ete_id;


--
-- Name: event_type_ety_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_type_ety_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_type_ety_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_type_ety_id_seq OWNED BY event_type.ety_id;


--
-- Name: event_type_secteur; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE event_type_secteur (
    ets_id integer NOT NULL,
    ety_id integer,
    sec_id integer
);


--
-- Name: TABLE event_type_secteur; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE event_type_secteur IS 'Affectation d''un type d''événement à des secteurs';


--
-- Name: event_type_secteur_ets_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE event_type_secteur_ets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: event_type_secteur_ets_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE event_type_secteur_ets_id_seq OWNED BY event_type_secteur.ets_id;


--
-- Name: events_categorie_eca_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE events_categorie_eca_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_categorie_eca_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE events_categorie_eca_id_seq OWNED BY events_categorie.eca_id;


--
-- Name: events_evs_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE events_evs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_evs_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE events_evs_id_seq OWNED BY events.evs_id;


--
-- Name: secteur_event; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE secteur_event (
    set_id integer NOT NULL,
    sec_id integer,
    eve_id integer
);


--
-- Name: TABLE secteur_event; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE secteur_event IS 'Affectation des événements à des secteurs';


--
-- Name: secteur_event_set_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE secteur_event_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_event_set_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE secteur_event_set_id_seq OWNED BY secteur_event.set_id;


--
-- Name: secteur_events; Type: TABLE; Schema: events; Owner: -; Tablespace: 
--

CREATE TABLE secteur_events (
    sev_id integer NOT NULL,
    sec_id integer,
    evs_id integer
);


--
-- Name: TABLE secteur_events; Type: COMMENT; Schema: events; Owner: -
--

COMMENT ON TABLE secteur_events IS 'Spécialisation des pages d''événements à certains secteurs';


--
-- Name: secteur_events_sev_id_seq; Type: SEQUENCE; Schema: events; Owner: -
--

CREATE SEQUENCE secteur_events_sev_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_events_sev_id_seq; Type: SEQUENCE OWNED BY; Schema: events; Owner: -
--

ALTER SEQUENCE secteur_events_sev_id_seq OWNED BY secteur_events.sev_id;


SET search_path = liste, pg_catalog;

--
-- Name: champ_cha_id_seq; Type: SEQUENCE; Schema: liste; Owner: -
--

CREATE SEQUENCE champ_cha_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: champ_cha_id_seq; Type: SEQUENCE OWNED BY; Schema: liste; Owner: -
--

ALTER SEQUENCE champ_cha_id_seq OWNED BY champ.cha_id;


--
-- Name: defaut_def_id_seq; Type: SEQUENCE; Schema: liste; Owner: -
--

CREATE SEQUENCE defaut_def_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: defaut_def_id_seq; Type: SEQUENCE OWNED BY; Schema: liste; Owner: -
--

ALTER SEQUENCE defaut_def_id_seq OWNED BY defaut.def_id;


--
-- Name: liste_lis_id_seq; Type: SEQUENCE; Schema: liste; Owner: -
--

CREATE SEQUENCE liste_lis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: liste_lis_id_seq; Type: SEQUENCE OWNED BY; Schema: liste; Owner: -
--

ALTER SEQUENCE liste_lis_id_seq OWNED BY liste.lis_id;


--
-- Name: supp; Type: TABLE; Schema: liste; Owner: -; Tablespace: 
--

CREATE TABLE supp (
    sup_id integer NOT NULL,
    cha_id integer,
    inf_id integer,
    sup_ordre integer
);


--
-- Name: TABLE supp; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON TABLE supp IS 'Champs supplémentaires à afficher pour un champ lien ou famille';


--
-- Name: COLUMN supp.sup_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN supp.sup_id IS 'Identifiant';


--
-- Name: COLUMN supp.cha_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN supp.cha_id IS 'Champ dans une liste pour lequel afficher le détail';


--
-- Name: COLUMN supp.inf_id; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN supp.inf_id IS 'Champ à afficher en détail';


--
-- Name: COLUMN supp.sup_ordre; Type: COMMENT; Schema: liste; Owner: -
--

COMMENT ON COLUMN supp.sup_ordre IS 'Ordre d''affichage';


--
-- Name: supp_sup_id_seq; Type: SEQUENCE; Schema: liste; Owner: -
--

CREATE SEQUENCE supp_sup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: supp_sup_id_seq; Type: SEQUENCE OWNED BY; Schema: liste; Owner: -
--

ALTER SEQUENCE supp_sup_id_seq OWNED BY supp.sup_id;


SET search_path = localise, pg_catalog;

--
-- Name: localisation_secteur; Type: TABLE; Schema: localise; Owner: -; Tablespace: 
--

CREATE TABLE localisation_secteur (
    loc_id integer NOT NULL,
    ter_id integer,
    loc_valeur character varying,
    sec_id integer
);


--
-- Name: TABLE localisation_secteur; Type: COMMENT; Schema: localise; Owner: -
--

COMMENT ON TABLE localisation_secteur IS 'Localisation d''un terme pour un secteur particulier.';


--
-- Name: localisation_loc_id_seq; Type: SEQUENCE; Schema: localise; Owner: -
--

CREATE SEQUENCE localisation_loc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: localisation_loc_id_seq; Type: SEQUENCE OWNED BY; Schema: localise; Owner: -
--

ALTER SEQUENCE localisation_loc_id_seq OWNED BY localisation_secteur.loc_id;


--
-- Name: terme_ter_id_seq; Type: SEQUENCE; Schema: localise; Owner: -
--

CREATE SEQUENCE terme_ter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: terme_ter_id_seq; Type: SEQUENCE OWNED BY; Schema: localise; Owner: -
--

ALTER SEQUENCE terme_ter_id_seq OWNED BY terme.ter_id;


SET search_path = lock, pg_catalog;

--
-- Name: personne_loc_id_seq; Type: SEQUENCE; Schema: lock; Owner: -
--

CREATE SEQUENCE personne_loc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_loc_id_seq; Type: SEQUENCE OWNED BY; Schema: lock; Owner: -
--

ALTER SEQUENCE personne_loc_id_seq OWNED BY fiche.loc_id;


SET search_path = login, pg_catalog;

--
-- Name: grouputil_groupe_ggr_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE grouputil_groupe_ggr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grouputil_groupe_ggr_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE grouputil_groupe_ggr_id_seq OWNED BY grouputil_groupe.ggr_id;


--
-- Name: grouputil_gut_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE grouputil_gut_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grouputil_gut_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE grouputil_gut_id_seq OWNED BY grouputil.gut_id;


--
-- Name: grouputil_portail_gpo_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE grouputil_portail_gpo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grouputil_portail_gpo_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE grouputil_portail_gpo_id_seq OWNED BY grouputil_portail.gpo_id;


--
-- Name: token; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE token (
    tok_id integer NOT NULL,
    uti_id integer,
    tok_token integer,
    tok_date_creation timestamp with time zone
);


--
-- Name: TABLE token; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE token IS 'Token d''authentification (interne)';


--
-- Name: COLUMN token.tok_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN token.tok_id IS 'Identifiant ';


--
-- Name: COLUMN token.uti_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN token.uti_id IS 'Utilisateur ayant reçu ce token';


--
-- Name: COLUMN token.tok_token; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN token.tok_token IS 'Valeur du token';


--
-- Name: COLUMN token.tok_date_creation; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN token.tok_date_creation IS 'Date de création (à la connexion de l''utilisateur)';


--
-- Name: token_tok_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE token_tok_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: token_tok_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE token_tok_id_seq OWNED BY token.tok_id;


--
-- Name: utilisateur_grouputil; Type: TABLE; Schema: login; Owner: -; Tablespace: 
--

CREATE TABLE utilisateur_grouputil (
    ugr_id integer NOT NULL,
    uti_id integer,
    gut_id integer
);


--
-- Name: TABLE utilisateur_grouputil; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON TABLE utilisateur_grouputil IS 'Affectation des utilisateurs aux groupes d''utilisateurs.';


--
-- Name: COLUMN utilisateur_grouputil.ugr_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur_grouputil.ugr_id IS 'Identifiant de la relation';


--
-- Name: COLUMN utilisateur_grouputil.uti_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur_grouputil.uti_id IS 'Identifiant de l''utilisateur';


--
-- Name: COLUMN utilisateur_grouputil.gut_id; Type: COMMENT; Schema: login; Owner: -
--

COMMENT ON COLUMN utilisateur_grouputil.gut_id IS 'Identifiant du groupe d''utilisateurs';


--
-- Name: utilisateur_grouputil_ugr_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE utilisateur_grouputil_ugr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: utilisateur_grouputil_ugr_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE utilisateur_grouputil_ugr_id_seq OWNED BY utilisateur_grouputil.ugr_id;


--
-- Name: utilisateur_uti_id_seq; Type: SEQUENCE; Schema: login; Owner: -
--

CREATE SEQUENCE utilisateur_uti_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: utilisateur_uti_id_seq; Type: SEQUENCE OWNED BY; Schema: login; Owner: -
--

ALTER SEQUENCE utilisateur_uti_id_seq OWNED BY utilisateur.uti_id;


SET search_path = meta, pg_catalog;

--
-- Name: adminsousmenu_asm_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE adminsousmenu_asm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adminsousmenu_asm_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE adminsousmenu_asm_id_seq OWNED BY adminsousmenu.asm_id;


--
-- Name: categorie_cat_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE categorie_cat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorie_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE categorie_cat_id_seq OWNED BY categorie.cat_id;


--
-- Name: dirinfo_din_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE dirinfo_din_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dirinfo_din_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE dirinfo_din_id_seq OWNED BY dirinfo.din_id;


--
-- Name: entite_ent_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE entite_ent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entite_ent_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE entite_ent_id_seq OWNED BY entite.ent_id;


--
-- Name: groupe_infos_gin_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE groupe_infos_gin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groupe_infos_gin_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE groupe_infos_gin_id_seq OWNED BY groupe_infos.gin_id;


--
-- Name: info_aide; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE info_aide (
    ina_id integer NOT NULL,
    inf_id integer,
    ina_aide text
);


--
-- Name: TABLE info_aide; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE info_aide IS 'Texte d''aide d''un champ';


--
-- Name: info_aide_ina_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE info_aide_ina_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_aide_ina_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE info_aide_ina_id_seq OWNED BY info_aide.ina_id;


--
-- Name: info_groupe_ing_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE info_groupe_ing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_groupe_ing_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE info_groupe_ing_id_seq OWNED BY info_groupe.ing_id;


--
-- Name: info_inf_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE info_inf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: info_inf_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE info_inf_id_seq OWNED BY info.inf_id;


--
-- Name: infos_type_int_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE infos_type_int_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: infos_type_int_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE infos_type_int_id_seq OWNED BY infos_type.int_id;


--
-- Name: lien_familial_lfa_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE lien_familial_lfa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lien_familial_lfa_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE lien_familial_lfa_id_seq OWNED BY lien_familial.lfa_id;


--
-- Name: menu_men_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE menu_men_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: menu_men_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE menu_men_id_seq OWNED BY menu.men_id;


--
-- Name: metier_entite; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE metier_entite (
    mee_id integer NOT NULL,
    met_id integer,
    ent_id integer
);


--
-- Name: TABLE metier_entite; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE metier_entite IS 'Affectation d''un métier à un type de personne';


--
-- Name: metier_entite_mee_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE metier_entite_mee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metier_entite_mee_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE metier_entite_mee_id_seq OWNED BY metier_entite.mee_id;


--
-- Name: metier_met_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE metier_met_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metier_met_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE metier_met_id_seq OWNED BY metier.met_id;


--
-- Name: metier_secteur; Type: TABLE; Schema: meta; Owner: -; Tablespace: 
--

CREATE TABLE metier_secteur (
    mes_id integer NOT NULL,
    met_id integer,
    sec_id integer
);


--
-- Name: TABLE metier_secteur; Type: COMMENT; Schema: meta; Owner: -
--

COMMENT ON TABLE metier_secteur IS 'Asignation d''un métier à un secteur';


--
-- Name: metier_secteur_mes_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE metier_secteur_mes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metier_secteur_mes_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE metier_secteur_mes_id_seq OWNED BY metier_secteur.mes_id;


--
-- Name: portail_por_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE portail_por_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portail_por_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE portail_por_id_seq OWNED BY portail.por_id;


--
-- Name: rootsousmenu_rsm_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE rootsousmenu_rsm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rootsousmenu_rsm_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE rootsousmenu_rsm_id_seq OWNED BY rootsousmenu.rsm_id;


--
-- Name: secteur_sec_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE secteur_sec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_sec_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE secteur_sec_id_seq OWNED BY secteur.sec_id;


--
-- Name: secteur_type_set_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE secteur_type_set_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_type_set_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE secteur_type_set_id_seq OWNED BY secteur_type.set_id;


--
-- Name: selection_entree_sen_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE selection_entree_sen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selection_entree_sen_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE selection_entree_sen_id_seq OWNED BY selection_entree.sen_id;


--
-- Name: selection_sel_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE selection_sel_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: selection_sel_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE selection_sel_id_seq OWNED BY selection.sel_id;


--
-- Name: sousmenu_sme_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE sousmenu_sme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sousmenu_sme_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE sousmenu_sme_id_seq OWNED BY sousmenu.sme_id;


--
-- Name: topmenu_tom_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE topmenu_tom_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topmenu_tom_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE topmenu_tom_id_seq OWNED BY topmenu.tom_id;


--
-- Name: topsousmenu_tsm_id_seq; Type: SEQUENCE; Schema: meta; Owner: -
--

CREATE SEQUENCE topsousmenu_tsm_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topsousmenu_tsm_id_seq; Type: SEQUENCE OWNED BY; Schema: meta; Owner: -
--

ALTER SEQUENCE topsousmenu_tsm_id_seq OWNED BY topsousmenu.tsm_id;


SET search_path = notes, pg_catalog;

--
-- Name: note_destinataire; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE note_destinataire (
    nde_id integer NOT NULL,
    not_id integer,
    uti_id integer,
    nde_pour_action boolean DEFAULT false NOT NULL,
    nde_pour_information boolean DEFAULT false NOT NULL,
    nde_action_faite boolean DEFAULT false NOT NULL,
    nde_information_lue boolean DEFAULT false NOT NULL,
    nde_supprime boolean DEFAULT false
);


--
-- Name: TABLE note_destinataire; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE note_destinataire IS 'Destinataires d''une note';


--
-- Name: note_destinataire_nde_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE note_destinataire_nde_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_destinataire_nde_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE note_destinataire_nde_id_seq OWNED BY note_destinataire.nde_id;


--
-- Name: note_groupe; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE note_groupe (
    ngr_id integer NOT NULL,
    not_id integer,
    grp_id integer
);


--
-- Name: TABLE note_groupe; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE note_groupe IS 'Rattachement d''une note à un groupe d''usagers';


--
-- Name: note_groupe_ngr_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE note_groupe_ngr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_groupe_ngr_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE note_groupe_ngr_id_seq OWNED BY note_groupe.ngr_id;


--
-- Name: note_not_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE note_not_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_not_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE note_not_id_seq OWNED BY note.not_id;


--
-- Name: note_theme; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE note_theme (
    nth_id integer NOT NULL,
    not_id integer,
    the_id integer
);


--
-- Name: TABLE note_theme; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE note_theme IS 'Classification des notes dans des boîtes thématiques';


--
-- Name: note_theme_nth_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE note_theme_nth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_theme_nth_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE note_theme_nth_id_seq OWNED BY note_theme.nth_id;


--
-- Name: note_usager; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE note_usager (
    nus_id integer NOT NULL,
    not_id integer,
    per_id integer
);


--
-- Name: TABLE note_usager; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE note_usager IS 'Rattachement d''une note à un usager';


--
-- Name: note_usager_nus_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE note_usager_nus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: note_usager_nus_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE note_usager_nus_id_seq OWNED BY note_usager.nus_id;


--
-- Name: notes_nos_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE notes_nos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_nos_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE notes_nos_id_seq OWNED BY notes.nos_id;


--
-- Name: theme_portail; Type: TABLE; Schema: notes; Owner: -; Tablespace: 
--

CREATE TABLE theme_portail (
    tpo_id integer NOT NULL,
    the_id integer,
    por_id integer
);


--
-- Name: TABLE theme_portail; Type: COMMENT; Schema: notes; Owner: -
--

COMMENT ON TABLE theme_portail IS 'Affectation des boîtes thématiques aux portails';


--
-- Name: theme_portail_tpo_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE theme_portail_tpo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: theme_portail_tpo_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE theme_portail_tpo_id_seq OWNED BY theme_portail.tpo_id;


--
-- Name: theme_the_id_seq; Type: SEQUENCE; Schema: notes; Owner: -
--

CREATE SEQUENCE theme_the_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: theme_the_id_seq; Type: SEQUENCE OWNED BY; Schema: notes; Owner: -
--

ALTER SEQUENCE theme_the_id_seq OWNED BY theme.the_id;


SET search_path = permission, pg_catalog;

--
-- Name: droit_ajout_entite_portail_daj_id_seq; Type: SEQUENCE; Schema: permission; Owner: -
--

CREATE SEQUENCE droit_ajout_entite_portail_daj_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: droit_ajout_entite_portail_daj_id_seq; Type: SEQUENCE OWNED BY; Schema: permission; Owner: -
--

ALTER SEQUENCE droit_ajout_entite_portail_daj_id_seq OWNED BY droit_ajout_entite_portail.daj_id;


SET search_path = procedure, pg_catalog;

--
-- Name: procedure_affectation_paf_id_seq; Type: SEQUENCE; Schema: procedure; Owner: -
--

CREATE SEQUENCE procedure_affectation_paf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: procedure_affectation_paf_id_seq; Type: SEQUENCE OWNED BY; Schema: procedure; Owner: -
--

ALTER SEQUENCE procedure_affectation_paf_id_seq OWNED BY procedure_affectation.paf_id;


--
-- Name: procedure_pro_id_seq; Type: SEQUENCE; Schema: procedure; Owner: -
--

CREATE SEQUENCE procedure_pro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: procedure_pro_id_seq; Type: SEQUENCE OWNED BY; Schema: procedure; Owner: -
--

ALTER SEQUENCE procedure_pro_id_seq OWNED BY procedure.pro_id;


SET search_path = public, pg_catalog;

--
-- Name: adresse_adr_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE adresse_adr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: adresse_adr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE adresse_adr_id_seq OWNED BY adresse.adr_id;


--
-- Name: etablissement_eta_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etablissement_eta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissement_eta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etablissement_eta_id_seq OWNED BY etablissement.eta_id;


--
-- Name: etablissement_secteur; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE etablissement_secteur (
    ets_id integer NOT NULL,
    eta_id integer,
    sec_id integer
);


--
-- Name: TABLE etablissement_secteur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE etablissement_secteur IS 'Liste des secteurs couverts par les établissements/partenaires.';


--
-- Name: COLUMN etablissement_secteur.ets_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur.ets_id IS 'Identifiant de la relation';


--
-- Name: COLUMN etablissement_secteur.eta_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur.eta_id IS 'Identifiant de l''établissement/partenaire';


--
-- Name: COLUMN etablissement_secteur.sec_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur.sec_id IS 'Identifiant du secteur';


--
-- Name: etablissement_secteur_edit; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE etablissement_secteur_edit (
    ese_id integer NOT NULL,
    eta_id integer,
    sec_id integer
);


--
-- Name: TABLE etablissement_secteur_edit; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE etablissement_secteur_edit IS 'Liste des secteurs pour lesquels les utilisateurs ont le droit de rajouter des groupes à un établissement/partenaire.';


--
-- Name: COLUMN etablissement_secteur_edit.ese_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur_edit.ese_id IS 'Identifiant de la relation';


--
-- Name: COLUMN etablissement_secteur_edit.eta_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur_edit.eta_id IS 'Identifiant de l''établissement';


--
-- Name: COLUMN etablissement_secteur_edit.sec_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN etablissement_secteur_edit.sec_id IS 'Identifiant du secteur';


--
-- Name: etablissement_secteur_edit_ese_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etablissement_secteur_edit_ese_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissement_secteur_edit_ese_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etablissement_secteur_edit_ese_id_seq OWNED BY etablissement_secteur_edit.ese_id;


--
-- Name: etablissement_secteur_ets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE etablissement_secteur_ets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: etablissement_secteur_ets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE etablissement_secteur_ets_id_seq OWNED BY etablissement_secteur.ets_id;


--
-- Name: groupe_grp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groupe_grp_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groupe_grp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groupe_grp_id_seq OWNED BY groupe.grp_id;


--
-- Name: groupe_info_secteur_gis_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groupe_info_secteur_gis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groupe_info_secteur_gis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groupe_info_secteur_gis_id_seq OWNED BY groupe_info_secteur.gis_id;


--
-- Name: groupe_secteur; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groupe_secteur (
    grs_id integer NOT NULL,
    grp_id integer,
    sec_id integer
);


--
-- Name: TABLE groupe_secteur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE groupe_secteur IS 'Liste des secteurs couverts par un groupe d''usagers.';


--
-- Name: COLUMN groupe_secteur.grs_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_secteur.grs_id IS 'Identifiant de la relation';


--
-- Name: COLUMN groupe_secteur.grp_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_secteur.grp_id IS 'Identifiant du groupe';


--
-- Name: COLUMN groupe_secteur.sec_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN groupe_secteur.sec_id IS 'Identifiant du secteur';


--
-- Name: groupe_secteur_grs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groupe_secteur_grs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groupe_secteur_grs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groupe_secteur_grs_id_seq OWNED BY groupe_secteur.grs_id;


--
-- Name: personne_etablissement; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_etablissement (
    per_id integer NOT NULL,
    eta_id integer NOT NULL
);


--
-- Name: TABLE personne_etablissement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_etablissement IS 'Appartenance d''un usager à un établissement.
Cette table est mise à jour par la fonction personne_etablissement_update()';


--
-- Name: COLUMN personne_etablissement.per_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_etablissement.per_id IS 'Identifiant de l''usager';


--
-- Name: COLUMN personne_etablissement.eta_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_etablissement.eta_id IS 'Identifiant de l''établissement';


--
-- Name: personne_groupe; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_groupe (
    peg_id integer NOT NULL,
    per_id integer,
    grp_id integer,
    peg_debut date,
    peg_fin date,
    peg_cycle_statut integer,
    peg_cycle_date_demande date,
    peg_cycle_date_demande_renouvellement date,
    peg__hebergement_chambre character varying,
    peg_notes text,
    _inf_id integer,
    peg__decideur_financeur integer
);


--
-- Name: TABLE personne_groupe; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_groupe IS 'Affectation d''un usager à un groupe d''usagers.';


--
-- Name: COLUMN personne_groupe.peg_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_id IS 'Identifiant de la relation';


--
-- Name: COLUMN personne_groupe.per_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.per_id IS 'Identifiant de l''usager';


--
-- Name: COLUMN personne_groupe.grp_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.grp_id IS 'Identifiant du groupe';


--
-- Name: COLUMN personne_groupe.peg_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_debut IS 'Date de début d''affectation de l''usager au groupe';


--
-- Name: COLUMN personne_groupe.peg_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_fin IS 'Date de fin d''affectation';


--
-- Name: COLUMN personne_groupe.peg_cycle_statut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_cycle_statut IS 'Statut du cyle :
 1: Demandé
 2: Accepté
 3: Terminé
-1: Refusé';


--
-- Name: COLUMN personne_groupe.peg_cycle_date_demande; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_cycle_date_demande IS 'Date de demande d''affectation';


--
-- Name: COLUMN personne_groupe.peg_cycle_date_demande_renouvellement; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_cycle_date_demande_renouvellement IS 'Date de demande de renouvellement de l''affectation';


--
-- Name: COLUMN personne_groupe.peg_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe.peg_notes IS 'Notes sur l''affectation';


--
-- Name: COLUMN personne_groupe._inf_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_groupe._inf_id IS '(non utilisé)';


--
-- Name: personne_groupe_peg_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_groupe_peg_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_groupe_peg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_groupe_peg_id_seq OWNED BY personne_groupe.peg_id;


--
-- Name: personne_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info (
    pin_id integer NOT NULL,
    per_id integer,
    inf_code character varying
);


--
-- Name: TABLE personne_info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info IS 'Valeur d''un champ pour une personne.';


--
-- Name: COLUMN personne_info.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info.pin_id IS 'Identifiant de la relation';


--
-- Name: COLUMN personne_info.per_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info.per_id IS 'Identifiant de la personne';


--
-- Name: COLUMN personne_info.inf_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info.inf_code IS 'Code du champ';


--
-- Name: personne_info_boolean; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_boolean (
    pib_id integer NOT NULL,
    pin_id integer,
    pib_valeur boolean,
    pib_debut timestamp with time zone,
    pib_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_boolean; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_boolean IS 'Valeur d''un champ de type "case à cocher" pour une personne.';


--
-- Name: COLUMN personne_info_boolean.pib_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.pib_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_boolean.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_boolean.pib_valeur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.pib_valeur IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_boolean.pib_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.pib_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_boolean.pib_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.pib_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_boolean.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_boolean.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_boolean_pib_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_boolean_pib_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_boolean_pib_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_boolean_pib_id_seq OWNED BY personne_info_boolean.pib_id;


--
-- Name: personne_info_date; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_date (
    pid_id integer NOT NULL,
    pin_id integer,
    pid_valeur date,
    pid_debut timestamp with time zone,
    pid_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_date IS 'Valeur d''un champ de type "Champ date" pour une personne.';


--
-- Name: COLUMN personne_info_date.pid_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.pid_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_date.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_date.pid_valeur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.pid_valeur IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_date.pid_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.pid_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_date.pid_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.pid_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_date.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_date.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_date_pid_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_date_pid_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_date_pid_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_date_pid_id_seq OWNED BY personne_info_date.pid_id;


--
-- Name: personne_info_integer; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_integer (
    pii_id integer NOT NULL,
    pin_id integer,
    pii_valeur integer,
    pii_debut timestamp with time zone,
    pii_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_integer; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_integer IS 'Valeur d''un champ de type "Boîtier de sélection", "Lien", "Métier", "Affectation à organisme" ou "Statut usager" pour une personne.';


--
-- Name: COLUMN personne_info_integer.pii_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.pii_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_integer.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_integer.pii_valeur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.pii_valeur IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_integer.pii_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.pii_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_integer.pii_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.pii_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_integer.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_integer2; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_integer2 (
    pij_id integer NOT NULL,
    pin_id integer,
    pij_valeur1 integer,
    pij_valeur2 integer,
    pij_debut timestamp with time zone,
    pij_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_integer2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_integer2 IS 'Valeur d''un champ de type "Affectation de personnel" pour une personne.';


--
-- Name: COLUMN personne_info_integer2.pij_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pij_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_integer2.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_integer2.pij_valeur1; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pij_valeur1 IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_integer2.pij_valeur2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pij_valeur2 IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_integer2.pij_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pij_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_integer2.pij_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.pij_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_integer2.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_integer2.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_integer2_pij_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_integer2_pij_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_integer2_pij_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_integer2_pij_id_seq OWNED BY personne_info_integer2.pij_id;


--
-- Name: personne_info_integer_pii_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_integer_pii_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_integer_pii_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_integer_pii_id_seq OWNED BY personne_info_integer.pii_id;


--
-- Name: personne_info_lien_familial_pif_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_lien_familial_pif_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_lien_familial_pif_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_lien_familial_pif_id_seq OWNED BY personne_info_lien_familial.pif_id;


--
-- Name: personne_info_pin_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_pin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_pin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_pin_id_seq OWNED BY personne_info.pin_id;


--
-- Name: personne_info_text; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_text (
    pit_id integer NOT NULL,
    pin_id integer,
    pit_valeur text,
    pit_debut timestamp with time zone,
    pit_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_text; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_text IS 'Valeur d''un champ de type "Texte multi-ligne" pour une personne.';


--
-- Name: COLUMN personne_info_text.pit_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.pit_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_text.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_text.pit_valeur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.pit_valeur IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_text.pit_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.pit_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_text.pit_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.pit_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_text.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_text.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_text_pit_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_text_pit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_text_pit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_text_pit_id_seq OWNED BY personne_info_text.pit_id;


--
-- Name: personne_info_varchar; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personne_info_varchar (
    piv_id integer NOT NULL,
    pin_id integer,
    piv_valeur character varying,
    piv_debut timestamp with time zone,
    piv_fin timestamp with time zone,
    uti_id integer
);


--
-- Name: TABLE personne_info_varchar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE personne_info_varchar IS 'Valeur d''un champ de type "Champ Texte" pour une personne.';


--
-- Name: COLUMN personne_info_varchar.piv_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.piv_id IS 'Identifiant unique';


--
-- Name: COLUMN personne_info_varchar.pin_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.pin_id IS 'Lien vers personne_info';


--
-- Name: COLUMN personne_info_varchar.piv_valeur; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.piv_valeur IS 'Valeur du champ';


--
-- Name: COLUMN personne_info_varchar.piv_debut; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.piv_debut IS 'Date de début pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_varchar.piv_fin; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.piv_fin IS 'Date de fin pour cette valeur (si champ historisé)';


--
-- Name: COLUMN personne_info_varchar.uti_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN personne_info_varchar.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';


--
-- Name: personne_info_varchar_piv_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_info_varchar_piv_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_info_varchar_piv_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_info_varchar_piv_id_seq OWNED BY personne_info_varchar.piv_id;


--
-- Name: personne_per_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personne_per_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personne_per_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personne_per_id_seq OWNED BY personne.per_id;


--
-- Name: pgprocedures_stats; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pgprocedures_stats (
    cal_function_name character varying,
    cal_nargs integer,
    cal_ncalls integer
);


--
-- Name: secteur_infos_sei_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE secteur_infos_sei_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secteur_infos_sei_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE secteur_infos_sei_id_seq OWNED BY secteur_infos.sei_id;


SET search_path = ressource, pg_catalog;

--
-- Name: ressource_res_id_seq; Type: SEQUENCE; Schema: ressource; Owner: -
--

CREATE SEQUENCE ressource_res_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ressource_res_id_seq; Type: SEQUENCE OWNED BY; Schema: ressource; Owner: -
--

ALTER SEQUENCE ressource_res_id_seq OWNED BY ressource.res_id;


--
-- Name: ressource_secteur; Type: TABLE; Schema: ressource; Owner: -; Tablespace: 
--

CREATE TABLE ressource_secteur (
    rse_id integer NOT NULL,
    res_id integer,
    sec_id integer
);


--
-- Name: TABLE ressource_secteur; Type: COMMENT; Schema: ressource; Owner: -
--

COMMENT ON TABLE ressource_secteur IS 'Affectation des ressources à des secteurs.';


--
-- Name: ressource_secteur_rse_id_seq; Type: SEQUENCE; Schema: ressource; Owner: -
--

CREATE SEQUENCE ressource_secteur_rse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ressource_secteur_rse_id_seq; Type: SEQUENCE OWNED BY; Schema: ressource; Owner: -
--

ALTER SEQUENCE ressource_secteur_rse_id_seq OWNED BY ressource_secteur.rse_id;


SET search_path = document, pg_catalog;

--
-- Name: doc_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document ALTER COLUMN doc_id SET DEFAULT nextval('document_doc_id_seq'::regclass);


--
-- Name: dse_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_secteur ALTER COLUMN dse_id SET DEFAULT nextval('document_secteur_dse_id_seq'::regclass);


--
-- Name: dty_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type ALTER COLUMN dty_id SET DEFAULT nextval('document_type_dty_id_seq'::regclass);


--
-- Name: dte_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_etablissement ALTER COLUMN dte_id SET DEFAULT nextval('document_type_etablissement_dte_id_seq'::regclass);


--
-- Name: dts_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_secteur ALTER COLUMN dts_id SET DEFAULT nextval('document_type_secteur_dts_id_seq'::regclass);


--
-- Name: dus_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_usager ALTER COLUMN dus_id SET DEFAULT nextval('document_usager_dus_id_seq'::regclass);


--
-- Name: dos_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN dos_id SET DEFAULT nextval('documents_dos_id_seq'::regclass);


--
-- Name: dss_id; Type: DEFAULT; Schema: document; Owner: -
--

ALTER TABLE ONLY documents_secteur ALTER COLUMN dss_id SET DEFAULT nextval('documents_secteur_dss_id_seq'::regclass);


SET search_path = events, pg_catalog;

--
-- Name: agr_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY agressources ALTER COLUMN agr_id SET DEFAULT nextval('agressources_agr_id_seq'::regclass);


--
-- Name: ase_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY agressources_secteur ALTER COLUMN ase_id SET DEFAULT nextval('agressources_secteur_ase_id_seq'::regclass);


--
-- Name: cev_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY categorie_events ALTER COLUMN cev_id SET DEFAULT nextval('categorie_events_cev_id_seq'::regclass);


--
-- Name: eve_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event ALTER COLUMN eve_id SET DEFAULT nextval('event_eve_id_seq'::regclass);


--
-- Name: eme_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_memo ALTER COLUMN eme_id SET DEFAULT nextval('event_memo_eme_id_seq'::regclass);


--
-- Name: epe_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_personne ALTER COLUMN epe_id SET DEFAULT nextval('event_personne_epe_id_seq'::regclass);


--
-- Name: ere_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_ressource ALTER COLUMN ere_id SET DEFAULT nextval('event_ressource_ere_id_seq'::regclass);


--
-- Name: ety_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type ALTER COLUMN ety_id SET DEFAULT nextval('event_type_ety_id_seq'::regclass);


--
-- Name: ete_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_etablissement ALTER COLUMN ete_id SET DEFAULT nextval('event_type_etablissement_ete_id_seq'::regclass);


--
-- Name: ets_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_secteur ALTER COLUMN ets_id SET DEFAULT nextval('event_type_secteur_ets_id_seq'::regclass);


--
-- Name: evs_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY events ALTER COLUMN evs_id SET DEFAULT nextval('events_evs_id_seq'::regclass);


--
-- Name: eca_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY events_categorie ALTER COLUMN eca_id SET DEFAULT nextval('events_categorie_eca_id_seq'::regclass);


--
-- Name: set_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_event ALTER COLUMN set_id SET DEFAULT nextval('secteur_event_set_id_seq'::regclass);


--
-- Name: sev_id; Type: DEFAULT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_events ALTER COLUMN sev_id SET DEFAULT nextval('secteur_events_sev_id_seq'::regclass);


SET search_path = liste, pg_catalog;

--
-- Name: cha_id; Type: DEFAULT; Schema: liste; Owner: -
--

ALTER TABLE ONLY champ ALTER COLUMN cha_id SET DEFAULT nextval('champ_cha_id_seq'::regclass);


--
-- Name: def_id; Type: DEFAULT; Schema: liste; Owner: -
--

ALTER TABLE ONLY defaut ALTER COLUMN def_id SET DEFAULT nextval('defaut_def_id_seq'::regclass);


--
-- Name: lis_id; Type: DEFAULT; Schema: liste; Owner: -
--

ALTER TABLE ONLY liste ALTER COLUMN lis_id SET DEFAULT nextval('liste_lis_id_seq'::regclass);


--
-- Name: sup_id; Type: DEFAULT; Schema: liste; Owner: -
--

ALTER TABLE ONLY supp ALTER COLUMN sup_id SET DEFAULT nextval('supp_sup_id_seq'::regclass);


SET search_path = localise, pg_catalog;

--
-- Name: loc_id; Type: DEFAULT; Schema: localise; Owner: -
--

ALTER TABLE ONLY localisation_secteur ALTER COLUMN loc_id SET DEFAULT nextval('localisation_loc_id_seq'::regclass);


--
-- Name: ter_id; Type: DEFAULT; Schema: localise; Owner: -
--

ALTER TABLE ONLY terme ALTER COLUMN ter_id SET DEFAULT nextval('terme_ter_id_seq'::regclass);


SET search_path = lock, pg_catalog;

--
-- Name: loc_id; Type: DEFAULT; Schema: lock; Owner: -
--

ALTER TABLE ONLY fiche ALTER COLUMN loc_id SET DEFAULT nextval('personne_loc_id_seq'::regclass);


SET search_path = login, pg_catalog;

--
-- Name: gut_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil ALTER COLUMN gut_id SET DEFAULT nextval('grouputil_gut_id_seq'::regclass);


--
-- Name: ggr_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_groupe ALTER COLUMN ggr_id SET DEFAULT nextval('grouputil_groupe_ggr_id_seq'::regclass);


--
-- Name: gpo_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_portail ALTER COLUMN gpo_id SET DEFAULT nextval('grouputil_portail_gpo_id_seq'::regclass);


--
-- Name: tok_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY token ALTER COLUMN tok_id SET DEFAULT nextval('token_tok_id_seq'::regclass);


--
-- Name: uti_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY utilisateur ALTER COLUMN uti_id SET DEFAULT nextval('utilisateur_uti_id_seq'::regclass);


--
-- Name: ugr_id; Type: DEFAULT; Schema: login; Owner: -
--

ALTER TABLE ONLY utilisateur_grouputil ALTER COLUMN ugr_id SET DEFAULT nextval('utilisateur_grouputil_ugr_id_seq'::regclass);


SET search_path = meta, pg_catalog;

--
-- Name: asm_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY adminsousmenu ALTER COLUMN asm_id SET DEFAULT nextval('adminsousmenu_asm_id_seq'::regclass);


--
-- Name: cat_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY categorie ALTER COLUMN cat_id SET DEFAULT nextval('categorie_cat_id_seq'::regclass);


--
-- Name: din_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY dirinfo ALTER COLUMN din_id SET DEFAULT nextval('dirinfo_din_id_seq'::regclass);


--
-- Name: ent_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY entite ALTER COLUMN ent_id SET DEFAULT nextval('entite_ent_id_seq'::regclass);


--
-- Name: gin_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY groupe_infos ALTER COLUMN gin_id SET DEFAULT nextval('groupe_infos_gin_id_seq'::regclass);


--
-- Name: inf_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info ALTER COLUMN inf_id SET DEFAULT nextval('info_inf_id_seq'::regclass);


--
-- Name: ina_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info_aide ALTER COLUMN ina_id SET DEFAULT nextval('info_aide_ina_id_seq'::regclass);


--
-- Name: ing_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info_groupe ALTER COLUMN ing_id SET DEFAULT nextval('info_groupe_ing_id_seq'::regclass);


--
-- Name: int_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY infos_type ALTER COLUMN int_id SET DEFAULT nextval('infos_type_int_id_seq'::regclass);


--
-- Name: lfa_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY lien_familial ALTER COLUMN lfa_id SET DEFAULT nextval('lien_familial_lfa_id_seq'::regclass);


--
-- Name: men_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY menu ALTER COLUMN men_id SET DEFAULT nextval('menu_men_id_seq'::regclass);


--
-- Name: met_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier ALTER COLUMN met_id SET DEFAULT nextval('metier_met_id_seq'::regclass);


--
-- Name: mee_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_entite ALTER COLUMN mee_id SET DEFAULT nextval('metier_entite_mee_id_seq'::regclass);


--
-- Name: mes_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_secteur ALTER COLUMN mes_id SET DEFAULT nextval('metier_secteur_mes_id_seq'::regclass);


--
-- Name: por_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY portail ALTER COLUMN por_id SET DEFAULT nextval('portail_por_id_seq'::regclass);


--
-- Name: rsm_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY rootsousmenu ALTER COLUMN rsm_id SET DEFAULT nextval('rootsousmenu_rsm_id_seq'::regclass);


--
-- Name: sec_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY secteur ALTER COLUMN sec_id SET DEFAULT nextval('secteur_sec_id_seq'::regclass);


--
-- Name: set_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY secteur_type ALTER COLUMN set_id SET DEFAULT nextval('secteur_type_set_id_seq'::regclass);


--
-- Name: sel_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY selection ALTER COLUMN sel_id SET DEFAULT nextval('selection_sel_id_seq'::regclass);


--
-- Name: sen_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY selection_entree ALTER COLUMN sen_id SET DEFAULT nextval('selection_entree_sen_id_seq'::regclass);


--
-- Name: sme_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY sousmenu ALTER COLUMN sme_id SET DEFAULT nextval('sousmenu_sme_id_seq'::regclass);


--
-- Name: tom_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY topmenu ALTER COLUMN tom_id SET DEFAULT nextval('topmenu_tom_id_seq'::regclass);


--
-- Name: tsm_id; Type: DEFAULT; Schema: meta; Owner: -
--

ALTER TABLE ONLY topsousmenu ALTER COLUMN tsm_id SET DEFAULT nextval('topsousmenu_tsm_id_seq'::regclass);


SET search_path = notes, pg_catalog;

--
-- Name: not_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note ALTER COLUMN not_id SET DEFAULT nextval('note_not_id_seq'::regclass);


--
-- Name: nde_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_destinataire ALTER COLUMN nde_id SET DEFAULT nextval('note_destinataire_nde_id_seq'::regclass);


--
-- Name: ngr_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_groupe ALTER COLUMN ngr_id SET DEFAULT nextval('note_groupe_ngr_id_seq'::regclass);


--
-- Name: nth_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_theme ALTER COLUMN nth_id SET DEFAULT nextval('note_theme_nth_id_seq'::regclass);


--
-- Name: nus_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_usager ALTER COLUMN nus_id SET DEFAULT nextval('note_usager_nus_id_seq'::regclass);


--
-- Name: nos_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY notes ALTER COLUMN nos_id SET DEFAULT nextval('notes_nos_id_seq'::regclass);


--
-- Name: the_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY theme ALTER COLUMN the_id SET DEFAULT nextval('theme_the_id_seq'::regclass);


--
-- Name: tpo_id; Type: DEFAULT; Schema: notes; Owner: -
--

ALTER TABLE ONLY theme_portail ALTER COLUMN tpo_id SET DEFAULT nextval('theme_portail_tpo_id_seq'::regclass);


SET search_path = permission, pg_catalog;

--
-- Name: daj_id; Type: DEFAULT; Schema: permission; Owner: -
--

ALTER TABLE ONLY droit_ajout_entite_portail ALTER COLUMN daj_id SET DEFAULT nextval('droit_ajout_entite_portail_daj_id_seq'::regclass);


SET search_path = procedure, pg_catalog;

--
-- Name: pro_id; Type: DEFAULT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure ALTER COLUMN pro_id SET DEFAULT nextval('procedure_pro_id_seq'::regclass);


--
-- Name: paf_id; Type: DEFAULT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure_affectation ALTER COLUMN paf_id SET DEFAULT nextval('procedure_affectation_paf_id_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: adr_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY adresse ALTER COLUMN adr_id SET DEFAULT nextval('adresse_adr_id_seq'::regclass);


--
-- Name: eta_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement ALTER COLUMN eta_id SET DEFAULT nextval('etablissement_eta_id_seq'::regclass);


--
-- Name: ets_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur ALTER COLUMN ets_id SET DEFAULT nextval('etablissement_secteur_ets_id_seq'::regclass);


--
-- Name: ese_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur_edit ALTER COLUMN ese_id SET DEFAULT nextval('etablissement_secteur_edit_ese_id_seq'::regclass);


--
-- Name: grp_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe ALTER COLUMN grp_id SET DEFAULT nextval('groupe_grp_id_seq'::regclass);


--
-- Name: gis_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_info_secteur ALTER COLUMN gis_id SET DEFAULT nextval('groupe_info_secteur_gis_id_seq'::regclass);


--
-- Name: grs_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_secteur ALTER COLUMN grs_id SET DEFAULT nextval('groupe_secteur_grs_id_seq'::regclass);


--
-- Name: per_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne ALTER COLUMN per_id SET DEFAULT nextval('personne_per_id_seq'::regclass);


--
-- Name: peg_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_groupe ALTER COLUMN peg_id SET DEFAULT nextval('personne_groupe_peg_id_seq'::regclass);


--
-- Name: pin_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info ALTER COLUMN pin_id SET DEFAULT nextval('personne_info_pin_id_seq'::regclass);


--
-- Name: pib_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_boolean ALTER COLUMN pib_id SET DEFAULT nextval('personne_info_boolean_pib_id_seq'::regclass);


--
-- Name: pid_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_date ALTER COLUMN pid_id SET DEFAULT nextval('personne_info_date_pid_id_seq'::regclass);


--
-- Name: pii_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer ALTER COLUMN pii_id SET DEFAULT nextval('personne_info_integer_pii_id_seq'::regclass);


--
-- Name: pij_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer2 ALTER COLUMN pij_id SET DEFAULT nextval('personne_info_integer2_pij_id_seq'::regclass);


--
-- Name: pif_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_lien_familial ALTER COLUMN pif_id SET DEFAULT nextval('personne_info_lien_familial_pif_id_seq'::regclass);


--
-- Name: pit_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_text ALTER COLUMN pit_id SET DEFAULT nextval('personne_info_text_pit_id_seq'::regclass);


--
-- Name: piv_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_varchar ALTER COLUMN piv_id SET DEFAULT nextval('personne_info_varchar_piv_id_seq'::regclass);


--
-- Name: sei_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY secteur_infos ALTER COLUMN sei_id SET DEFAULT nextval('secteur_infos_sei_id_seq'::regclass);


SET search_path = ressource, pg_catalog;

--
-- Name: res_id; Type: DEFAULT; Schema: ressource; Owner: -
--

ALTER TABLE ONLY ressource ALTER COLUMN res_id SET DEFAULT nextval('ressource_res_id_seq'::regclass);


--
-- Name: rse_id; Type: DEFAULT; Schema: ressource; Owner: -
--

ALTER TABLE ONLY ressource_secteur ALTER COLUMN rse_id SET DEFAULT nextval('ressource_secteur_rse_id_seq'::regclass);


SET search_path = document, pg_catalog;

--
-- Name: document_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pkey PRIMARY KEY (doc_id);


--
-- Name: document_secteur_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_secteur
    ADD CONSTRAINT document_secteur_pkey PRIMARY KEY (dse_id);


--
-- Name: document_type_etablissement_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_type_etablissement
    ADD CONSTRAINT document_type_etablissement_pkey PRIMARY KEY (dte_id);


--
-- Name: document_type_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_type
    ADD CONSTRAINT document_type_pkey PRIMARY KEY (dty_id);


--
-- Name: document_type_secteur_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_type_secteur
    ADD CONSTRAINT document_type_secteur_pkey PRIMARY KEY (dts_id);


--
-- Name: document_usager_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY document_usager
    ADD CONSTRAINT document_usager_pkey PRIMARY KEY (dus_id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (dos_id);


--
-- Name: documents_secteur_pkey; Type: CONSTRAINT; Schema: document; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents_secteur
    ADD CONSTRAINT documents_secteur_pkey PRIMARY KEY (dss_id);


SET search_path = events, pg_catalog;

--
-- Name: categorie_events_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categorie_events
    ADD CONSTRAINT categorie_events_pkey PRIMARY KEY (cev_id);


--
-- Name: event_memo_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_memo
    ADD CONSTRAINT event_memo_pkey PRIMARY KEY (eme_id);


--
-- Name: event_personne_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_personne
    ADD CONSTRAINT event_personne_pkey PRIMARY KEY (epe_id);


--
-- Name: event_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (eve_id);


--
-- Name: event_ressource_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_ressource
    ADD CONSTRAINT event_ressource_pkey PRIMARY KEY (ere_id);


--
-- Name: event_type_etablissement_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_type_etablissement
    ADD CONSTRAINT event_type_etablissement_pkey PRIMARY KEY (ete_id);


--
-- Name: event_type_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pkey PRIMARY KEY (ety_id);


--
-- Name: event_type_secteur_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY event_type_secteur
    ADD CONSTRAINT event_type_secteur_pkey PRIMARY KEY (ets_id);


--
-- Name: events_categorie_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events_categorie
    ADD CONSTRAINT events_categorie_pkey PRIMARY KEY (eca_id);


--
-- Name: events_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_pkey PRIMARY KEY (evs_id);


--
-- Name: secteur_event_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur_event
    ADD CONSTRAINT secteur_event_pkey PRIMARY KEY (set_id);


--
-- Name: secteur_events_pkey; Type: CONSTRAINT; Schema: events; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur_events
    ADD CONSTRAINT secteur_events_pkey PRIMARY KEY (sev_id);


SET search_path = liste, pg_catalog;

--
-- Name: champ_pkey; Type: CONSTRAINT; Schema: liste; Owner: -; Tablespace: 
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT champ_pkey PRIMARY KEY (cha_id);


--
-- Name: defaut_pkey; Type: CONSTRAINT; Schema: liste; Owner: -; Tablespace: 
--

ALTER TABLE ONLY defaut
    ADD CONSTRAINT defaut_pkey PRIMARY KEY (def_id);


--
-- Name: liste_pkey; Type: CONSTRAINT; Schema: liste; Owner: -; Tablespace: 
--

ALTER TABLE ONLY liste
    ADD CONSTRAINT liste_pkey PRIMARY KEY (lis_id);


--
-- Name: supp_pkey; Type: CONSTRAINT; Schema: liste; Owner: -; Tablespace: 
--

ALTER TABLE ONLY supp
    ADD CONSTRAINT supp_pkey PRIMARY KEY (sup_id);


SET search_path = localise, pg_catalog;

--
-- Name: localisation_pkey; Type: CONSTRAINT; Schema: localise; Owner: -; Tablespace: 
--

ALTER TABLE ONLY localisation_secteur
    ADD CONSTRAINT localisation_pkey PRIMARY KEY (loc_id);


--
-- Name: terme_pkey; Type: CONSTRAINT; Schema: localise; Owner: -; Tablespace: 
--

ALTER TABLE ONLY terme
    ADD CONSTRAINT terme_pkey PRIMARY KEY (ter_id);


SET search_path = lock, pg_catalog;

--
-- Name: personne_pkey; Type: CONSTRAINT; Schema: lock; Owner: -; Tablespace: 
--

ALTER TABLE ONLY fiche
    ADD CONSTRAINT personne_pkey PRIMARY KEY (loc_id);


SET search_path = login, pg_catalog;

--
-- Name: grouputil_groupe_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grouputil_groupe
    ADD CONSTRAINT grouputil_groupe_pkey PRIMARY KEY (ggr_id);


--
-- Name: grouputil_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grouputil
    ADD CONSTRAINT grouputil_pkey PRIMARY KEY (gut_id);


--
-- Name: grouputil_portail_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY grouputil_portail
    ADD CONSTRAINT grouputil_portail_pkey PRIMARY KEY (gpo_id);


--
-- Name: token_tok_id_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_tok_id_pkey PRIMARY KEY (tok_id);


--
-- Name: token_tok_token_unique; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_tok_token_unique UNIQUE (tok_token);


--
-- Name: utilisateur_grouputil_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY utilisateur_grouputil
    ADD CONSTRAINT utilisateur_grouputil_pkey PRIMARY KEY (ugr_id);


--
-- Name: utilisateur_pkey; Type: CONSTRAINT; Schema: login; Owner: -; Tablespace: 
--

ALTER TABLE ONLY utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (uti_id);


SET search_path = meta, pg_catalog;

--
-- Name: adminsousmenu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY adminsousmenu
    ADD CONSTRAINT adminsousmenu_pkey PRIMARY KEY (asm_id);


--
-- Name: categorie_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (cat_id);


--
-- Name: dirinfo_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY dirinfo
    ADD CONSTRAINT dirinfo_pkey PRIMARY KEY (din_id);


--
-- Name: entite_ent_code_unique; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entite
    ADD CONSTRAINT entite_ent_code_unique UNIQUE (ent_code);


--
-- Name: entite_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entite
    ADD CONSTRAINT entite_pkey PRIMARY KEY (ent_id);


--
-- Name: groupe_infos_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupe_infos
    ADD CONSTRAINT groupe_infos_pkey PRIMARY KEY (gin_id);


--
-- Name: info_aide_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY info_aide
    ADD CONSTRAINT info_aide_pkey PRIMARY KEY (ina_id);


--
-- Name: info_groupe_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY info_groupe
    ADD CONSTRAINT info_groupe_pkey PRIMARY KEY (ing_id);


--
-- Name: info_inf_code_unique; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_inf_code_unique UNIQUE (inf_code);


--
-- Name: info_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_pkey PRIMARY KEY (inf_id);


--
-- Name: infos_type_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY infos_type
    ADD CONSTRAINT infos_type_pkey PRIMARY KEY (int_id);


--
-- Name: lien_familial_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY lien_familial
    ADD CONSTRAINT lien_familial_pkey PRIMARY KEY (lfa_id);


--
-- Name: menu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (men_id);


--
-- Name: metier_entite_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metier_entite
    ADD CONSTRAINT metier_entite_pkey PRIMARY KEY (mee_id);


--
-- Name: metier_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metier
    ADD CONSTRAINT metier_pkey PRIMARY KEY (met_id);


--
-- Name: metier_secteur_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metier_secteur
    ADD CONSTRAINT metier_secteur_pkey PRIMARY KEY (mes_id);


--
-- Name: portail_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY portail
    ADD CONSTRAINT portail_pkey PRIMARY KEY (por_id);


--
-- Name: rootsousmenu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rootsousmenu
    ADD CONSTRAINT rootsousmenu_pkey PRIMARY KEY (rsm_id);


--
-- Name: secteur_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur
    ADD CONSTRAINT secteur_pkey PRIMARY KEY (sec_id);


--
-- Name: secteur_sec_code_key; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur
    ADD CONSTRAINT secteur_sec_code_key UNIQUE (sec_code);


--
-- Name: secteur_type_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur_type
    ADD CONSTRAINT secteur_type_pkey PRIMARY KEY (set_id);


--
-- Name: selection_entree_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection_entree
    ADD CONSTRAINT selection_entree_pkey PRIMARY KEY (sen_id);


--
-- Name: selection_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection
    ADD CONSTRAINT selection_pkey PRIMARY KEY (sel_id);


--
-- Name: selection_sel_code_unique; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY selection
    ADD CONSTRAINT selection_sel_code_unique UNIQUE (sel_code);


--
-- Name: sousmenu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sousmenu
    ADD CONSTRAINT sousmenu_pkey PRIMARY KEY (sme_id);


--
-- Name: topmenu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topmenu
    ADD CONSTRAINT topmenu_pkey PRIMARY KEY (tom_id);


--
-- Name: topsousmenu_pkey; Type: CONSTRAINT; Schema: meta; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topsousmenu
    ADD CONSTRAINT topsousmenu_pkey PRIMARY KEY (tsm_id);


SET search_path = notes, pg_catalog;

--
-- Name: note_destinataire_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_destinataire
    ADD CONSTRAINT note_destinataire_pkey PRIMARY KEY (nde_id);


--
-- Name: note_groupe_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_groupe
    ADD CONSTRAINT note_groupe_pkey PRIMARY KEY (ngr_id);


--
-- Name: note_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_pkey PRIMARY KEY (not_id);


--
-- Name: note_theme_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_theme
    ADD CONSTRAINT note_theme_pkey PRIMARY KEY (nth_id);


--
-- Name: note_usager_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY note_usager
    ADD CONSTRAINT note_usager_pkey PRIMARY KEY (nus_id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (nos_id);


--
-- Name: theme_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY theme
    ADD CONSTRAINT theme_pkey PRIMARY KEY (the_id);


--
-- Name: theme_portail_pkey; Type: CONSTRAINT; Schema: notes; Owner: -; Tablespace: 
--

ALTER TABLE ONLY theme_portail
    ADD CONSTRAINT theme_portail_pkey PRIMARY KEY (tpo_id);


SET search_path = permission, pg_catalog;

--
-- Name: droit_ajout_entite_portail_pkey; Type: CONSTRAINT; Schema: permission; Owner: -; Tablespace: 
--

ALTER TABLE ONLY droit_ajout_entite_portail
    ADD CONSTRAINT droit_ajout_entite_portail_pkey PRIMARY KEY (daj_id);


SET search_path = procedure, pg_catalog;

--
-- Name: procedure_affectation_pkey; Type: CONSTRAINT; Schema: procedure; Owner: -; Tablespace: 
--

ALTER TABLE ONLY procedure_affectation
    ADD CONSTRAINT procedure_affectation_pkey PRIMARY KEY (paf_id);


--
-- Name: procedure_pkey; Type: CONSTRAINT; Schema: procedure; Owner: -; Tablespace: 
--

ALTER TABLE ONLY procedure
    ADD CONSTRAINT procedure_pkey PRIMARY KEY (pro_id);


SET search_path = public, pg_catalog;

--
-- Name: adresse_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY adresse
    ADD CONSTRAINT adresse_pkey PRIMARY KEY (adr_id);


--
-- Name: etablissement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY etablissement
    ADD CONSTRAINT etablissement_pkey PRIMARY KEY (eta_id);


--
-- Name: etablissement_secteur_edit_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY etablissement_secteur_edit
    ADD CONSTRAINT etablissement_secteur_edit_pkey PRIMARY KEY (ese_id);


--
-- Name: etablissement_secteur_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY etablissement_secteur
    ADD CONSTRAINT etablissement_secteur_pkey PRIMARY KEY (ets_id);


--
-- Name: groupe_info_secteur_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupe_info_secteur
    ADD CONSTRAINT groupe_info_secteur_pkey PRIMARY KEY (gis_id);


--
-- Name: groupe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupe
    ADD CONSTRAINT groupe_pkey PRIMARY KEY (grp_id);


--
-- Name: groupe_secteur_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groupe_secteur
    ADD CONSTRAINT groupe_secteur_pkey PRIMARY KEY (grs_id);


--
-- Name: personne_etablissement_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_etablissement
    ADD CONSTRAINT personne_etablissement_pkey PRIMARY KEY (per_id, eta_id);


--
-- Name: personne_groupe_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_groupe
    ADD CONSTRAINT personne_groupe_pkey PRIMARY KEY (peg_id);


--
-- Name: personne_info_boolean_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_boolean
    ADD CONSTRAINT personne_info_boolean_pkey PRIMARY KEY (pib_id);


--
-- Name: personne_info_date_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_date
    ADD CONSTRAINT personne_info_date_pkey PRIMARY KEY (pid_id);


--
-- Name: personne_info_integer2_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_integer2
    ADD CONSTRAINT personne_info_integer2_pkey PRIMARY KEY (pij_id);


--
-- Name: personne_info_integer_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_integer
    ADD CONSTRAINT personne_info_integer_pkey PRIMARY KEY (pii_id);


--
-- Name: personne_info_lien_familial_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_lien_familial
    ADD CONSTRAINT personne_info_lien_familial_pkey PRIMARY KEY (pif_id);


--
-- Name: personne_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info
    ADD CONSTRAINT personne_info_pkey PRIMARY KEY (pin_id);


--
-- Name: personne_info_text_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_text
    ADD CONSTRAINT personne_info_text_pkey PRIMARY KEY (pit_id);


--
-- Name: personne_info_varchar_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne_info_varchar
    ADD CONSTRAINT personne_info_varchar_pkey PRIMARY KEY (piv_id);


--
-- Name: personne_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personne
    ADD CONSTRAINT personne_pkey PRIMARY KEY (per_id);


--
-- Name: secteur_infos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY secteur_infos
    ADD CONSTRAINT secteur_infos_pkey PRIMARY KEY (sei_id);


SET search_path = ressource, pg_catalog;

--
-- Name: ressource_pkey; Type: CONSTRAINT; Schema: ressource; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ressource
    ADD CONSTRAINT ressource_pkey PRIMARY KEY (res_id);


--
-- Name: ressource_secteur_pkey; Type: CONSTRAINT; Schema: ressource; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ressource_secteur
    ADD CONSTRAINT ressource_secteur_pkey PRIMARY KEY (rse_id);


SET search_path = document, pg_catalog;

--
-- Name: fki_docuent_dty_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_docuent_dty_id_fkey ON document USING btree (dty_id);


--
-- Name: fki_document_per_id_responsable_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_per_id_responsable_fkey ON document USING btree (per_id_responsable);


--
-- Name: fki_document_secteur_doc_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_secteur_doc_id_fkey ON document_secteur USING btree (doc_id);


--
-- Name: fki_document_secteur_sec_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_secteur_sec_id_fkey ON document_secteur USING btree (sec_id);


--
-- Name: fki_document_type_etablissement_dty_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_type_etablissement_dty_id_fkey ON document_type_etablissement USING btree (dty_id);


--
-- Name: fki_document_type_etablissement_eta_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_type_etablissement_eta_id_fkey ON document_type_etablissement USING btree (eta_id);


--
-- Name: fki_document_type_secteur_dty_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_type_secteur_dty_id_fkey ON document_type_secteur USING btree (dty_id);


--
-- Name: fki_document_type_secteur_sec_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_type_secteur_sec_id_fkey ON document_type_secteur USING btree (sec_id);


--
-- Name: fki_document_usager_doc_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_usager_doc_id_fkey ON document_usager USING btree (doc_id);


--
-- Name: fki_document_usager_per_id_usager_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_usager_per_id_usager_fkey ON document_usager USING btree (per_id_usager);


--
-- Name: fki_document_uti_id_creation_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_document_uti_id_creation_fkey ON document USING btree (uti_id_creation);


--
-- Name: fki_documents_dty_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_documents_dty_id_fkey ON documents USING btree (dty_id);


--
-- Name: fki_documents_secteur_dos_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_documents_secteur_dos_id_fkey ON documents_secteur USING btree (dos_id);


--
-- Name: fki_documents_secteur_sec_id_fkey; Type: INDEX; Schema: document; Owner: -; Tablespace: 
--

CREATE INDEX fki_documents_secteur_sec_id_fkey ON documents_secteur USING btree (sec_id);


SET search_path = events, pg_catalog;

--
-- Name: event_memo_eme_type_idx; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX event_memo_eme_type_idx ON event_memo USING btree (eme_type);


--
-- Name: fki_event_ety_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_ety_id_fkey ON event USING btree (ety_id);


--
-- Name: fki_event_memo_eve_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_memo_eve_id_fkey ON event_memo USING btree (eve_id);


--
-- Name: fki_event_personne_eve_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_personne_eve_id_fkey ON event_personne USING btree (eve_id);


--
-- Name: fki_event_personne_per_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_personne_per_id_fkey ON event_personne USING btree (per_id);


--
-- Name: fki_event_ressource_eve_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_ressource_eve_id_fkey ON event_ressource USING btree (eve_id);


--
-- Name: fki_event_ressource_res_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_ressource_res_id_fkey ON event_ressource USING btree (res_id);


--
-- Name: fki_event_type_eca_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_type_eca_id_fkey ON event_type USING btree (eca_id);


--
-- Name: fki_event_type_etablissement_eta_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_type_etablissement_eta_id_fkey ON event_type_etablissement USING btree (eta_id);


--
-- Name: fki_event_type_etablissement_ety_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_type_etablissement_ety_id_fkey ON event_type_etablissement USING btree (ety_id);


--
-- Name: fki_event_type_secteur_ety_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_type_secteur_ety_id_fkey ON event_type_secteur USING btree (ety_id);


--
-- Name: fki_event_type_secteur_sec_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_type_secteur_sec_id_fkey ON event_type_secteur USING btree (sec_id);


--
-- Name: fki_event_uti_id_creation_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_event_uti_id_creation_fkey ON event USING btree (uti_id_creation);


--
-- Name: fki_events_ety_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_events_ety_id_fkey ON events USING btree (ety_id);


--
-- Name: fki_secteur_events_evs_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_secteur_events_evs_id_fkey ON secteur_events USING btree (evs_id);


--
-- Name: fki_secteur_events_sec_id_fkey; Type: INDEX; Schema: events; Owner: -; Tablespace: 
--

CREATE INDEX fki_secteur_events_sec_id_fkey ON secteur_events USING btree (sec_id);


SET search_path = liste, pg_catalog;

--
-- Name: fki_champ_inf_id_fkey; Type: INDEX; Schema: liste; Owner: -; Tablespace: 
--

CREATE INDEX fki_champ_inf_id_fkey ON champ USING btree (inf_id);


--
-- Name: fki_champ_lis_id_fkey; Type: INDEX; Schema: liste; Owner: -; Tablespace: 
--

CREATE INDEX fki_champ_lis_id_fkey ON champ USING btree (lis_id);


--
-- Name: fki_defaut_cha_id_fkey; Type: INDEX; Schema: liste; Owner: -; Tablespace: 
--

CREATE INDEX fki_defaut_cha_id_fkey ON defaut USING btree (cha_id);


--
-- Name: fki_liste_ent_id_fkey; Type: INDEX; Schema: liste; Owner: -; Tablespace: 
--

CREATE INDEX fki_liste_ent_id_fkey ON liste USING btree (ent_id);


SET search_path = localise, pg_catalog;

--
-- Name: fki_localisation_sec_id_fkey; Type: INDEX; Schema: localise; Owner: -; Tablespace: 
--

CREATE INDEX fki_localisation_sec_id_fkey ON localisation_secteur USING btree (sec_id);


--
-- Name: fki_localisation_ter_id_fkey; Type: INDEX; Schema: localise; Owner: -; Tablespace: 
--

CREATE INDEX fki_localisation_ter_id_fkey ON localisation_secteur USING btree (ter_id);


SET search_path = lock, pg_catalog;

--
-- Name: fki_fiche_per_id_fkey; Type: INDEX; Schema: lock; Owner: -; Tablespace: 
--

CREATE INDEX fki_fiche_per_id_fkey ON fiche USING btree (per_id);


--
-- Name: fki_fiche_uti_id_fkey; Type: INDEX; Schema: lock; Owner: -; Tablespace: 
--

CREATE INDEX fki_fiche_uti_id_fkey ON fiche USING btree (uti_id);


SET search_path = login, pg_catalog;

--
-- Name: fki_grouputil_groupe_grp_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_grouputil_groupe_grp_id_fkey ON grouputil_groupe USING btree (grp_id);


--
-- Name: fki_grouputil_groupe_gut_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_grouputil_groupe_gut_id_fkey ON grouputil_groupe USING btree (gut_id);


--
-- Name: fki_grouputil_portail_gut_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_grouputil_portail_gut_id_fkey ON grouputil_portail USING btree (gut_id);


--
-- Name: fki_grouputil_portail_por_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_grouputil_portail_por_id_fkey ON grouputil_portail USING btree (por_id);


--
-- Name: fki_token_uti_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_token_uti_id_fkey ON utilisateur USING btree (uti_id);


--
-- Name: fki_utilisateur_grouputil_gut_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_utilisateur_grouputil_gut_id_fkey ON utilisateur_grouputil USING btree (gut_id);


--
-- Name: fki_utilisateur_grouputil_uti_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_utilisateur_grouputil_uti_id_fkey ON utilisateur_grouputil USING btree (uti_id);


--
-- Name: fki_utilisateur_per_id_fkey; Type: INDEX; Schema: login; Owner: -; Tablespace: 
--

CREATE INDEX fki_utilisateur_per_id_fkey ON utilisateur USING btree (per_id);


SET search_path = meta, pg_catalog;

--
-- Name: fki_dirinfo_din_id_parent_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_dirinfo_din_id_parent_fkey ON dirinfo USING btree (din_id_parent);


--
-- Name: fki_info_aide_inf_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_aide_inf_id_fkey ON info_aide USING btree (inf_id);


--
-- Name: fki_info_din_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_din_id_fkey ON info USING btree (din_id);


--
-- Name: fki_info_groupe_gin_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_groupe_gin_id_fkey ON info_groupe USING btree (gin_id);


--
-- Name: fki_info_groupe_inf_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_groupe_inf_id_fkey ON info_groupe USING btree (inf_id);


--
-- Name: fki_info_inf__date_echeance_secteur_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_inf__date_echeance_secteur_fkey ON info USING btree (inf__date_echeance_secteur);


--
-- Name: fki_info_inf__etablissement_secteur_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_inf__etablissement_secteur_fkey ON info USING btree (inf__etablissement_secteur);


--
-- Name: fki_info_inf__selection_code_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_info_inf__selection_code_fkey ON info USING btree (inf__selection_code);


--
-- Name: fki_menu_ent_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_menu_ent_id_fkey ON menu USING btree (ent_id);


--
-- Name: fki_menu_por_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_menu_por_id_fkey ON menu USING btree (por_id);


--
-- Name: fki_metier_entite_ent_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_metier_entite_ent_id_fkey ON metier_entite USING btree (ent_id);


--
-- Name: fki_metier_entite_met_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_metier_entite_met_id_fkey ON metier_entite USING btree (met_id);


--
-- Name: fki_metier_secteur_met_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_metier_secteur_met_id_fkey ON metier_secteur USING btree (met_id);


--
-- Name: fki_metier_secteur_sec_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_metier_secteur_sec_id_fkey ON metier_secteur USING btree (sec_id);


--
-- Name: fki_portail_cat_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_portail_cat_id_fkey ON portail USING btree (cat_id);


--
-- Name: fki_secteur_type_sec_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_secteur_type_sec_id_fkey ON secteur_type USING btree (sec_id);


--
-- Name: fki_topmenu_por_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_topmenu_por_id_fkey ON topmenu USING btree (por_id);


--
-- Name: fki_topsousmenu_tom_id_fkey; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX fki_topsousmenu_tom_id_fkey ON topsousmenu USING btree (tom_id);


--
-- Name: info_inf_code_idx; Type: INDEX; Schema: meta; Owner: -; Tablespace: 
--

CREATE INDEX info_inf_code_idx ON info USING btree (inf_code);


SET search_path = notes, pg_catalog;

--
-- Name: fki_note_destinataire_not_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_destinataire_not_id_fkey ON note_destinataire USING btree (not_id);


--
-- Name: fki_note_destinataire_uti_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_destinataire_uti_id_fkey ON note_destinataire USING btree (uti_id);


--
-- Name: fki_note_eta_id_auteur_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_eta_id_auteur_fkey ON note USING btree (eta_id_auteur);


--
-- Name: fki_note_groupe_grp_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_groupe_grp_id_fkey ON note_groupe USING btree (grp_id);


--
-- Name: fki_note_groupe_not_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_groupe_not_id_fkey ON note_groupe USING btree (not_id);


--
-- Name: fki_note_theme_not_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_theme_not_id_fkey ON note_theme USING btree (not_id);


--
-- Name: fki_note_theme_the_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_theme_the_id_fkey ON note_theme USING btree (the_id);


--
-- Name: fki_note_usager_not_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_usager_not_id_fkey ON note_usager USING btree (not_id);


--
-- Name: fki_note_usager_per_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_usager_per_id_fkey ON note_usager USING btree (per_id);


--
-- Name: fki_note_uti_id_auteur_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_note_uti_id_auteur_fkey ON note USING btree (uti_id_auteur);


--
-- Name: fki_notes_the_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_notes_the_id_fkey ON notes USING btree (the_id);


--
-- Name: fki_theme_portail_por_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_theme_portail_por_id_fkey ON theme_portail USING btree (por_id);


--
-- Name: fki_theme_portail_the_id_fkey; Type: INDEX; Schema: notes; Owner: -; Tablespace: 
--

CREATE INDEX fki_theme_portail_the_id_fkey ON theme_portail USING btree (the_id);


SET search_path = permission, pg_catalog;

--
-- Name: fki_droit_ajout_entite_portail_ent_code_fkey; Type: INDEX; Schema: permission; Owner: -; Tablespace: 
--

CREATE INDEX fki_droit_ajout_entite_portail_ent_code_fkey ON droit_ajout_entite_portail USING btree (ent_code);


--
-- Name: fki_droit_ajout_entite_portail_por_id_fkey; Type: INDEX; Schema: permission; Owner: -; Tablespace: 
--

CREATE INDEX fki_droit_ajout_entite_portail_por_id_fkey ON droit_ajout_entite_portail USING btree (por_id);


SET search_path = procedure, pg_catalog;

--
-- Name: fki_procedure_affectation_asm_id_fkey; Type: INDEX; Schema: procedure; Owner: -; Tablespace: 
--

CREATE INDEX fki_procedure_affectation_asm_id_fkey ON procedure_affectation USING btree (asm_id);


--
-- Name: fki_procedure_affectation_pro_id_fkey; Type: INDEX; Schema: procedure; Owner: -; Tablespace: 
--

CREATE INDEX fki_procedure_affectation_pro_id_fkey ON procedure_affectation USING btree (pro_id);


--
-- Name: fki_procedure_affectation_sme_id_fkey; Type: INDEX; Schema: procedure; Owner: -; Tablespace: 
--

CREATE INDEX fki_procedure_affectation_sme_id_fkey ON procedure_affectation USING btree (sme_id);


--
-- Name: fki_procedure_affectation_tsm_id_fkey; Type: INDEX; Schema: procedure; Owner: -; Tablespace: 
--

CREATE INDEX fki_procedure_affectation_tsm_id_fkey ON procedure_affectation USING btree (tsm_id);


SET search_path = public, pg_catalog;

--
-- Name: fki_etablissement_adr_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_adr_id_fkey ON etablissement USING btree (adr_id);


--
-- Name: fki_etablissement_cat_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_cat_id_fkey ON etablissement USING btree (cat_id);


--
-- Name: fki_etablissement_secteur_edit_eta_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_secteur_edit_eta_id_fkey ON etablissement_secteur_edit USING btree (eta_id);


--
-- Name: fki_etablissement_secteur_edit_sec_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_secteur_edit_sec_id_fkey ON etablissement_secteur_edit USING btree (sec_id);


--
-- Name: fki_etablissement_secteur_eta_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_secteur_eta_id_fkey ON etablissement_secteur USING btree (eta_id);


--
-- Name: fki_etablissement_secteur_sec_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_etablissement_secteur_sec_id_fkey ON etablissement_secteur USING btree (sec_id);


--
-- Name: fki_groupe_eta_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_eta_id_fkey ON groupe USING btree (eta_id);


--
-- Name: fki_groupe_info_escteur_inf_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_info_escteur_inf_id_fkey ON groupe_info_secteur USING btree (inf_id);


--
-- Name: fki_groupe_info_secteur_grp_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_info_secteur_grp_id_fkey ON groupe_info_secteur USING btree (grp_id);


--
-- Name: fki_groupe_info_secteur_sec_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_info_secteur_sec_id_fkey ON groupe_info_secteur USING btree (sec_id);


--
-- Name: fki_groupe_secteur_grp_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_secteur_grp_id_fkey ON groupe_secteur USING btree (grp_id);


--
-- Name: fki_groupe_secteur_sec_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_groupe_secteur_sec_id_fkey ON groupe_secteur USING btree (sec_id);


--
-- Name: fki_personne_etablissement_eta_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_etablissement_eta_id_fkey ON personne_etablissement USING btree (eta_id);


--
-- Name: fki_personne_etablissement_per_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_etablissement_per_id_fkey ON personne_etablissement USING btree (per_id);


--
-- Name: fki_personne_groupe_grp_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_groupe_grp_id_fkey ON personne_groupe USING btree (grp_id);


--
-- Name: fki_personne_groupe_inf_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_groupe_inf_id_fkey ON personne_groupe USING btree (_inf_id);


--
-- Name: fki_personne_groupe_per_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_groupe_per_id_fkey ON personne_groupe USING btree (per_id);


--
-- Name: fki_personne_info_boolean_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_boolean_uti_id_fkey ON personne_info_boolean USING btree (uti_id);


--
-- Name: fki_personne_info_date_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_date_uti_id_fkey ON personne_info_date USING btree (uti_id);


--
-- Name: fki_personne_info_inf_code_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_inf_code_fkey ON personne_info USING btree (inf_code);


--
-- Name: fki_personne_info_integer2_pij_valeur1_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_integer2_pij_valeur1_fkey ON personne_info_integer2 USING btree (pij_valeur1);


--
-- Name: fki_personne_info_integer2_pij_valeur2_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_integer2_pij_valeur2_fkey ON personne_info_integer2 USING btree (pij_valeur2);


--
-- Name: fki_personne_info_integer2_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_integer2_uti_id_fkey ON personne_info_integer2 USING btree (uti_id);


--
-- Name: fki_personne_info_integer_pii_valeur_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_integer_pii_valeur_fkey ON personne_info_integer USING btree (pii_valeur);


--
-- Name: fki_personne_info_integer_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_integer_uti_id_fkey ON personne_info_integer USING btree (uti_id);


--
-- Name: fki_personne_info_lien_familial_lfa_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_lien_familial_lfa_id_fkey ON personne_info_lien_familial USING btree (lfa_id);


--
-- Name: fki_personne_info_lien_familial_per_id_parent_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_lien_familial_per_id_parent_fkey ON personne_info_lien_familial USING btree (per_id_parent);


--
-- Name: fki_personne_info_lien_familial_pin_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_lien_familial_pin_id_fkey ON personne_info_lien_familial USING btree (pin_id);


--
-- Name: fki_personne_info_text_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_text_uti_id_fkey ON personne_info_text USING btree (uti_id);


--
-- Name: fki_personne_info_varchar_uti_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_personne_info_varchar_uti_id_fkey ON personne_info_varchar USING btree (uti_id);


--
-- Name: fki_secteur_infos_sec_id_fkey; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX fki_secteur_infos_sec_id_fkey ON secteur_infos USING btree (sec_id);


--
-- Name: personne_ent_code_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_ent_code_idx ON personne USING btree (ent_code);


--
-- Name: personne_info_boolean_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_boolean_pin_id_idx ON personne_info_boolean USING btree (pin_id);


--
-- Name: personne_info_date_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_date_pin_id_idx ON personne_info_date USING btree (pin_id);


--
-- Name: personne_info_integer2_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_integer2_pin_id_idx ON personne_info_integer2 USING btree (pin_id);


--
-- Name: personne_info_integer_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_integer_pin_id_idx ON personne_info_integer USING btree (pin_id);


--
-- Name: personne_info_per_id_inf_code_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_per_id_inf_code_idx ON personne_info USING btree (per_id, inf_code);


--
-- Name: personne_info_text_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_text_pin_id_idx ON personne_info_text USING btree (pin_id);


--
-- Name: personne_info_varchar_pin_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX personne_info_varchar_pin_id_idx ON personne_info_varchar USING btree (pin_id);


SET search_path = ressource, pg_catalog;

--
-- Name: fki_ressource_secteur_res_id_fkey; Type: INDEX; Schema: ressource; Owner: -; Tablespace: 
--

CREATE INDEX fki_ressource_secteur_res_id_fkey ON ressource_secteur USING btree (res_id);


--
-- Name: fki_ressource_secteur_sec_id_fkey; Type: INDEX; Schema: ressource; Owner: -; Tablespace: 
--

CREATE INDEX fki_ressource_secteur_sec_id_fkey ON ressource_secteur USING btree (sec_id);


SET search_path = document, pg_catalog;

--
-- Name: docuent_dty_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document
    ADD CONSTRAINT docuent_dty_id_fkey FOREIGN KEY (dty_id) REFERENCES document_type(dty_id);


--
-- Name: document_per_id_responsable_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_per_id_responsable_fkey FOREIGN KEY (per_id_responsable) REFERENCES public.personne(per_id);


--
-- Name: document_secteur_doc_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_secteur
    ADD CONSTRAINT document_secteur_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES document(doc_id);


--
-- Name: document_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_secteur
    ADD CONSTRAINT document_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: document_type_etablissement_dty_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_etablissement
    ADD CONSTRAINT document_type_etablissement_dty_id_fkey FOREIGN KEY (dty_id) REFERENCES document_type(dty_id);


--
-- Name: document_type_etablissement_eta_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_etablissement
    ADD CONSTRAINT document_type_etablissement_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES public.etablissement(eta_id);


--
-- Name: document_type_secteur_dty_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_secteur
    ADD CONSTRAINT document_type_secteur_dty_id_fkey FOREIGN KEY (dty_id) REFERENCES document_type(dty_id);


--
-- Name: document_type_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_type_secteur
    ADD CONSTRAINT document_type_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: document_usager_doc_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_usager
    ADD CONSTRAINT document_usager_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES document(doc_id);


--
-- Name: document_usager_per_id_usager_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document_usager
    ADD CONSTRAINT document_usager_per_id_usager_fkey FOREIGN KEY (per_id_usager) REFERENCES public.personne(per_id);


--
-- Name: document_uti_id_creation_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_uti_id_creation_fkey FOREIGN KEY (uti_id_creation) REFERENCES login.utilisateur(uti_id);


--
-- Name: documents_dty_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_dty_id_fkey FOREIGN KEY (dty_id) REFERENCES document_type(dty_id);


--
-- Name: documents_secteur_dos_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY documents_secteur
    ADD CONSTRAINT documents_secteur_dos_id_fkey FOREIGN KEY (dos_id) REFERENCES documents(dos_id);


--
-- Name: documents_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: document; Owner: -
--

ALTER TABLE ONLY documents_secteur
    ADD CONSTRAINT documents_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


SET search_path = events, pg_catalog;

--
-- Name: categorie_events_eca_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY categorie_events
    ADD CONSTRAINT categorie_events_eca_id_fkey FOREIGN KEY (eca_id) REFERENCES events_categorie(eca_id);


--
-- Name: categorie_events_evs_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY categorie_events
    ADD CONSTRAINT categorie_events_evs_id_fkey FOREIGN KEY (evs_id) REFERENCES events(evs_id);


--
-- Name: event_ety_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_ety_id_fkey FOREIGN KEY (ety_id) REFERENCES event_type(ety_id);


--
-- Name: event_memo_eve_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_memo
    ADD CONSTRAINT event_memo_eve_id_fkey FOREIGN KEY (eve_id) REFERENCES event(eve_id);


--
-- Name: event_personne_eve_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_personne
    ADD CONSTRAINT event_personne_eve_id_fkey FOREIGN KEY (eve_id) REFERENCES event(eve_id);


--
-- Name: event_personne_per_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_personne
    ADD CONSTRAINT event_personne_per_id_fkey FOREIGN KEY (per_id) REFERENCES public.personne(per_id);


--
-- Name: event_ressource_eve_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_ressource
    ADD CONSTRAINT event_ressource_eve_id_fkey FOREIGN KEY (eve_id) REFERENCES event(eve_id);


--
-- Name: event_ressource_res_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_ressource
    ADD CONSTRAINT event_ressource_res_id_fkey FOREIGN KEY (res_id) REFERENCES ressource.ressource(res_id);


--
-- Name: event_type_eca_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_eca_id_fkey FOREIGN KEY (eca_id) REFERENCES events_categorie(eca_id);


--
-- Name: event_type_etablissement_eta_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_etablissement
    ADD CONSTRAINT event_type_etablissement_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES public.etablissement(eta_id);


--
-- Name: event_type_etablissement_ety_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_etablissement
    ADD CONSTRAINT event_type_etablissement_ety_id_fkey FOREIGN KEY (ety_id) REFERENCES event_type(ety_id);


--
-- Name: event_type_secteur_ety_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_secteur
    ADD CONSTRAINT event_type_secteur_ety_id_fkey FOREIGN KEY (ety_id) REFERENCES event_type(ety_id);


--
-- Name: event_type_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event_type_secteur
    ADD CONSTRAINT event_type_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: event_uti_id_creation_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY event
    ADD CONSTRAINT event_uti_id_creation_fkey FOREIGN KEY (uti_id_creation) REFERENCES login.utilisateur(uti_id);


--
-- Name: events_ety_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY events
    ADD CONSTRAINT events_ety_id_fkey FOREIGN KEY (ety_id) REFERENCES event_type(ety_id);


--
-- Name: secteur_event_eve_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_event
    ADD CONSTRAINT secteur_event_eve_id_fkey FOREIGN KEY (eve_id) REFERENCES event(eve_id);


--
-- Name: secteur_events_evs_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_events
    ADD CONSTRAINT secteur_events_evs_id_fkey FOREIGN KEY (evs_id) REFERENCES events(evs_id);


--
-- Name: secteur_events_sec_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_events
    ADD CONSTRAINT secteur_events_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: secteur_events_sec_id_fkey; Type: FK CONSTRAINT; Schema: events; Owner: -
--

ALTER TABLE ONLY secteur_event
    ADD CONSTRAINT secteur_events_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


SET search_path = liste, pg_catalog;

--
-- Name: champ_inf_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT champ_inf_id_fkey FOREIGN KEY (inf_id) REFERENCES meta.info(inf_id);


--
-- Name: champ_lis_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY champ
    ADD CONSTRAINT champ_lis_id_fkey FOREIGN KEY (lis_id) REFERENCES liste(lis_id);


--
-- Name: defaut_cha_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY defaut
    ADD CONSTRAINT defaut_cha_id_fkey FOREIGN KEY (cha_id) REFERENCES champ(cha_id);


--
-- Name: liste_ent_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY liste
    ADD CONSTRAINT liste_ent_id_fkey FOREIGN KEY (ent_id) REFERENCES meta.entite(ent_id);


--
-- Name: supp_cha_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY supp
    ADD CONSTRAINT supp_cha_id_fkey FOREIGN KEY (cha_id) REFERENCES champ(cha_id);


--
-- Name: supp_inf_id_fkey; Type: FK CONSTRAINT; Schema: liste; Owner: -
--

ALTER TABLE ONLY supp
    ADD CONSTRAINT supp_inf_id_fkey FOREIGN KEY (inf_id) REFERENCES meta.info(inf_id);


SET search_path = localise, pg_catalog;

--
-- Name: localisation_sec_id_fkey; Type: FK CONSTRAINT; Schema: localise; Owner: -
--

ALTER TABLE ONLY localisation_secteur
    ADD CONSTRAINT localisation_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id) DEFERRABLE;


--
-- Name: localisation_ter_id_fkey; Type: FK CONSTRAINT; Schema: localise; Owner: -
--

ALTER TABLE ONLY localisation_secteur
    ADD CONSTRAINT localisation_ter_id_fkey FOREIGN KEY (ter_id) REFERENCES terme(ter_id);


SET search_path = lock, pg_catalog;

--
-- Name: fiche_per_id_fkey; Type: FK CONSTRAINT; Schema: lock; Owner: -
--

ALTER TABLE ONLY fiche
    ADD CONSTRAINT fiche_per_id_fkey FOREIGN KEY (per_id) REFERENCES public.personne(per_id);


--
-- Name: fiche_uti_id_fkey; Type: FK CONSTRAINT; Schema: lock; Owner: -
--

ALTER TABLE ONLY fiche
    ADD CONSTRAINT fiche_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


SET search_path = login, pg_catalog;

--
-- Name: grouputil_groupe_grp_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_groupe
    ADD CONSTRAINT grouputil_groupe_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES public.groupe(grp_id);


--
-- Name: grouputil_groupe_gut_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_groupe
    ADD CONSTRAINT grouputil_groupe_gut_id_fkey FOREIGN KEY (gut_id) REFERENCES grouputil(gut_id);


--
-- Name: grouputil_portail_gut_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_portail
    ADD CONSTRAINT grouputil_portail_gut_id_fkey FOREIGN KEY (gut_id) REFERENCES grouputil(gut_id);


--
-- Name: grouputil_portail_por_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY grouputil_portail
    ADD CONSTRAINT grouputil_portail_por_id_fkey FOREIGN KEY (por_id) REFERENCES meta.portail(por_id);


--
-- Name: token_uti_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES utilisateur(uti_id);


--
-- Name: utilisateur_grouputil_gut_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY utilisateur_grouputil
    ADD CONSTRAINT utilisateur_grouputil_gut_id_fkey FOREIGN KEY (gut_id) REFERENCES grouputil(gut_id);


--
-- Name: utilisateur_grouputil_uti_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY utilisateur_grouputil
    ADD CONSTRAINT utilisateur_grouputil_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES utilisateur(uti_id);


--
-- Name: utilisateur_per_id_fkey; Type: FK CONSTRAINT; Schema: login; Owner: -
--

ALTER TABLE ONLY utilisateur
    ADD CONSTRAINT utilisateur_per_id_fkey FOREIGN KEY (per_id) REFERENCES public.personne(per_id);


SET search_path = meta, pg_catalog;

--
-- Name: dirinfo_din_id_parent_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY dirinfo
    ADD CONSTRAINT dirinfo_din_id_parent_fkey FOREIGN KEY (din_id_parent) REFERENCES dirinfo(din_id);


--
-- Name: groupe_infos_sme_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY groupe_infos
    ADD CONSTRAINT groupe_infos_sme_id_fkey FOREIGN KEY (sme_id) REFERENCES sousmenu(sme_id);


--
-- Name: info_aide_inf_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info_aide
    ADD CONSTRAINT info_aide_inf_id_fkey FOREIGN KEY (inf_id) REFERENCES info(inf_id);


--
-- Name: info_din_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_din_id_fkey FOREIGN KEY (din_id) REFERENCES dirinfo(din_id);


--
-- Name: info_groupe_gin_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info_groupe
    ADD CONSTRAINT info_groupe_gin_id_fkey FOREIGN KEY (gin_id) REFERENCES groupe_infos(gin_id);


--
-- Name: info_groupe_inf_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info_groupe
    ADD CONSTRAINT info_groupe_inf_id_fkey FOREIGN KEY (inf_id) REFERENCES info(inf_id);


--
-- Name: info_inf__date_echeance_secteur_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_inf__date_echeance_secteur_fkey FOREIGN KEY (inf__date_echeance_secteur) REFERENCES secteur(sec_code);


--
-- Name: info_inf__etablissement_secteur_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_inf__etablissement_secteur_fkey FOREIGN KEY (inf__etablissement_secteur) REFERENCES secteur(sec_code);


--
-- Name: info_inf__selection_code_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_inf__selection_code_fkey FOREIGN KEY (inf__selection_code) REFERENCES selection(sel_id) DEFERRABLE;


--
-- Name: info_int_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY info
    ADD CONSTRAINT info_int_id_fkey FOREIGN KEY (int_id) REFERENCES infos_type(int_id);


--
-- Name: menu_ent_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_ent_id_fkey FOREIGN KEY (ent_id) REFERENCES entite(ent_id);


--
-- Name: menu_por_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_por_id_fkey FOREIGN KEY (por_id) REFERENCES portail(por_id);


--
-- Name: metier_entite_ent_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_entite
    ADD CONSTRAINT metier_entite_ent_id_fkey FOREIGN KEY (ent_id) REFERENCES entite(ent_id);


--
-- Name: metier_entite_met_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_entite
    ADD CONSTRAINT metier_entite_met_id_fkey FOREIGN KEY (met_id) REFERENCES metier(met_id);


--
-- Name: metier_secteur_met_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_secteur
    ADD CONSTRAINT metier_secteur_met_id_fkey FOREIGN KEY (met_id) REFERENCES metier(met_id);


--
-- Name: metier_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY metier_secteur
    ADD CONSTRAINT metier_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES secteur(sec_id);


--
-- Name: portail_cat_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY portail
    ADD CONSTRAINT portail_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES categorie(cat_id);


--
-- Name: secteur_type_sec_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY secteur_type
    ADD CONSTRAINT secteur_type_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES secteur(sec_id);


--
-- Name: selection_entree_sel_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY selection_entree
    ADD CONSTRAINT selection_entree_sel_id_fkey FOREIGN KEY (sel_id) REFERENCES selection(sel_id);


--
-- Name: sousmenu_men_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY sousmenu
    ADD CONSTRAINT sousmenu_men_id_fkey FOREIGN KEY (men_id) REFERENCES menu(men_id);


--
-- Name: topmenu_por_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY topmenu
    ADD CONSTRAINT topmenu_por_id_fkey FOREIGN KEY (por_id) REFERENCES portail(por_id);


--
-- Name: topsousmenu_tom_id_fkey; Type: FK CONSTRAINT; Schema: meta; Owner: -
--

ALTER TABLE ONLY topsousmenu
    ADD CONSTRAINT topsousmenu_tom_id_fkey FOREIGN KEY (tom_id) REFERENCES topmenu(tom_id);


SET search_path = notes, pg_catalog;

--
-- Name: note_destinataire_not_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_destinataire
    ADD CONSTRAINT note_destinataire_not_id_fkey FOREIGN KEY (not_id) REFERENCES note(not_id);


--
-- Name: note_destinataire_uti_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_destinataire
    ADD CONSTRAINT note_destinataire_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: note_eta_id_auteur_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_eta_id_auteur_fkey FOREIGN KEY (eta_id_auteur) REFERENCES public.etablissement(eta_id);


--
-- Name: note_groupe_grp_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_groupe
    ADD CONSTRAINT note_groupe_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES public.groupe(grp_id);


--
-- Name: note_groupe_not_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_groupe
    ADD CONSTRAINT note_groupe_not_id_fkey FOREIGN KEY (not_id) REFERENCES note(not_id);


--
-- Name: note_theme_not_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_theme
    ADD CONSTRAINT note_theme_not_id_fkey FOREIGN KEY (not_id) REFERENCES note(not_id);


--
-- Name: note_theme_the_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_theme
    ADD CONSTRAINT note_theme_the_id_fkey FOREIGN KEY (the_id) REFERENCES theme(the_id);


--
-- Name: note_usager_not_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_usager
    ADD CONSTRAINT note_usager_not_id_fkey FOREIGN KEY (not_id) REFERENCES note(not_id);


--
-- Name: note_usager_per_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note_usager
    ADD CONSTRAINT note_usager_per_id_fkey FOREIGN KEY (per_id) REFERENCES public.personne(per_id);


--
-- Name: note_uti_id_auteur_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_uti_id_auteur_fkey FOREIGN KEY (uti_id_auteur) REFERENCES login.utilisateur(uti_id);


--
-- Name: notes_the_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_the_id_fkey FOREIGN KEY (the_id) REFERENCES theme(the_id);


--
-- Name: theme_portail_por_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY theme_portail
    ADD CONSTRAINT theme_portail_por_id_fkey FOREIGN KEY (por_id) REFERENCES meta.portail(por_id);


--
-- Name: theme_portail_the_id_fkey; Type: FK CONSTRAINT; Schema: notes; Owner: -
--

ALTER TABLE ONLY theme_portail
    ADD CONSTRAINT theme_portail_the_id_fkey FOREIGN KEY (the_id) REFERENCES theme(the_id);


SET search_path = permission, pg_catalog;

--
-- Name: droit_ajout_entite_portail_ent_code_fkey; Type: FK CONSTRAINT; Schema: permission; Owner: -
--

ALTER TABLE ONLY droit_ajout_entite_portail
    ADD CONSTRAINT droit_ajout_entite_portail_ent_code_fkey FOREIGN KEY (ent_code) REFERENCES meta.entite(ent_code);


--
-- Name: droit_ajout_entite_portail_por_id_fkey; Type: FK CONSTRAINT; Schema: permission; Owner: -
--

ALTER TABLE ONLY droit_ajout_entite_portail
    ADD CONSTRAINT droit_ajout_entite_portail_por_id_fkey FOREIGN KEY (por_id) REFERENCES meta.portail(por_id);


SET search_path = procedure, pg_catalog;

--
-- Name: procedure_affectation_asm_id_fkey; Type: FK CONSTRAINT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure_affectation
    ADD CONSTRAINT procedure_affectation_asm_id_fkey FOREIGN KEY (asm_id) REFERENCES meta.adminsousmenu(asm_id);


--
-- Name: procedure_affectation_pro_id_fkey; Type: FK CONSTRAINT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure_affectation
    ADD CONSTRAINT procedure_affectation_pro_id_fkey FOREIGN KEY (pro_id) REFERENCES procedure(pro_id);


--
-- Name: procedure_affectation_sme_id_fkey; Type: FK CONSTRAINT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure_affectation
    ADD CONSTRAINT procedure_affectation_sme_id_fkey FOREIGN KEY (sme_id) REFERENCES meta.sousmenu(sme_id);


--
-- Name: procedure_affectation_tsm_id_fkey; Type: FK CONSTRAINT; Schema: procedure; Owner: -
--

ALTER TABLE ONLY procedure_affectation
    ADD CONSTRAINT procedure_affectation_tsm_id_fkey FOREIGN KEY (tsm_id) REFERENCES meta.topsousmenu(tsm_id);


SET search_path = public, pg_catalog;

--
-- Name: etablissement_adr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement
    ADD CONSTRAINT etablissement_adr_id_fkey FOREIGN KEY (adr_id) REFERENCES adresse(adr_id);


--
-- Name: etablissement_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement
    ADD CONSTRAINT etablissement_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES meta.categorie(cat_id) DEFERRABLE;


--
-- Name: etablissement_secteur_eta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur
    ADD CONSTRAINT etablissement_secteur_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES etablissement(eta_id);


--
-- Name: etablissement_secteur_eta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur_edit
    ADD CONSTRAINT etablissement_secteur_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES etablissement(eta_id);


--
-- Name: etablissement_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur
    ADD CONSTRAINT etablissement_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: etablissement_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY etablissement_secteur_edit
    ADD CONSTRAINT etablissement_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: groupe_eta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe
    ADD CONSTRAINT groupe_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES etablissement(eta_id);


--
-- Name: groupe_info_escteur_inf_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_info_secteur
    ADD CONSTRAINT groupe_info_escteur_inf_id_fkey FOREIGN KEY (inf_id) REFERENCES meta.info(inf_id);


--
-- Name: groupe_info_secteur_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_info_secteur
    ADD CONSTRAINT groupe_info_secteur_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES groupe(grp_id);


--
-- Name: groupe_info_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_info_secteur
    ADD CONSTRAINT groupe_info_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: groupe_secteur_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_secteur
    ADD CONSTRAINT groupe_secteur_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES groupe(grp_id);


--
-- Name: groupe_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY groupe_secteur
    ADD CONSTRAINT groupe_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: personne_ent_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne
    ADD CONSTRAINT personne_ent_code_fkey FOREIGN KEY (ent_code) REFERENCES meta.entite(ent_code);


--
-- Name: personne_etablissement_eta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_etablissement
    ADD CONSTRAINT personne_etablissement_eta_id_fkey FOREIGN KEY (eta_id) REFERENCES etablissement(eta_id);


--
-- Name: personne_etablissement_per_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_etablissement
    ADD CONSTRAINT personne_etablissement_per_id_fkey FOREIGN KEY (per_id) REFERENCES personne(per_id);


--
-- Name: personne_groupe_grp_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_groupe
    ADD CONSTRAINT personne_groupe_grp_id_fkey FOREIGN KEY (grp_id) REFERENCES groupe(grp_id);


--
-- Name: personne_groupe_inf_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_groupe
    ADD CONSTRAINT personne_groupe_inf_id_fkey FOREIGN KEY (_inf_id) REFERENCES meta.info(inf_id);


--
-- Name: personne_groupe_per_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_groupe
    ADD CONSTRAINT personne_groupe_per_id_fkey FOREIGN KEY (per_id) REFERENCES personne(per_id);


--
-- Name: personne_info_boolean_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_boolean
    ADD CONSTRAINT personne_info_boolean_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_boolean_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_boolean
    ADD CONSTRAINT personne_info_boolean_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_date_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_date
    ADD CONSTRAINT personne_info_date_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_inf_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info
    ADD CONSTRAINT personne_info_inf_code_fkey FOREIGN KEY (inf_code) REFERENCES meta.info(inf_code);


--
-- Name: personne_info_integer2_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer2
    ADD CONSTRAINT personne_info_integer2_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_integer2_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer2
    ADD CONSTRAINT personne_info_integer2_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_integer_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer
    ADD CONSTRAINT personne_info_integer_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_integer_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_integer
    ADD CONSTRAINT personne_info_integer_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_lien_familial_lfa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_lien_familial
    ADD CONSTRAINT personne_info_lien_familial_lfa_id_fkey FOREIGN KEY (lfa_id) REFERENCES meta.lien_familial(lfa_id);


--
-- Name: personne_info_lien_familial_per_id_parent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_lien_familial
    ADD CONSTRAINT personne_info_lien_familial_per_id_parent_fkey FOREIGN KEY (per_id_parent) REFERENCES personne(per_id);


--
-- Name: personne_info_lien_familial_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_lien_familial
    ADD CONSTRAINT personne_info_lien_familial_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_per_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info
    ADD CONSTRAINT personne_info_per_id_fkey FOREIGN KEY (per_id) REFERENCES personne(per_id);


--
-- Name: personne_info_text_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_text
    ADD CONSTRAINT personne_info_text_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_text_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_text
    ADD CONSTRAINT personne_info_text_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_varchar_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_varchar
    ADD CONSTRAINT personne_info_varchar_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: personne_info_varchar_uti_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_varchar
    ADD CONSTRAINT personne_info_varchar_uti_id_fkey FOREIGN KEY (uti_id) REFERENCES login.utilisateur(uti_id);


--
-- Name: personne_info_vdate_pin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY personne_info_date
    ADD CONSTRAINT personne_info_vdate_pin_id_fkey FOREIGN KEY (pin_id) REFERENCES personne_info(pin_id);


--
-- Name: secteur_infos_sec_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY secteur_infos
    ADD CONSTRAINT secteur_infos_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


SET search_path = ressource, pg_catalog;

--
-- Name: ressource_secteur_res_id_fkey; Type: FK CONSTRAINT; Schema: ressource; Owner: -
--

ALTER TABLE ONLY ressource_secteur
    ADD CONSTRAINT ressource_secteur_res_id_fkey FOREIGN KEY (res_id) REFERENCES ressource(res_id);


--
-- Name: ressource_secteur_sec_id_fkey; Type: FK CONSTRAINT; Schema: ressource; Owner: -
--

ALTER TABLE ONLY ressource_secteur
    ADD CONSTRAINT ressource_secteur_sec_id_fkey FOREIGN KEY (sec_id) REFERENCES meta.secteur(sec_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

--REVOKE ALL ON SCHEMA public FROM PUBLIC;
--REVOKE ALL ON SCHEMA public FROM accueil;
--GRANT ALL ON SCHEMA public TO accueil;
--GRANT ALL ON SCHEMA public TO postgres;
--GRANT ALL ON SCHEMA public TO PUBLIC;


SET search_path = public, pg_catalog;

--
-- Name: pgprocedures_stats; Type: ACL; Schema: public; Owner: -
--

--REVOKE ALL ON TABLE pgprocedures_stats FROM PUBLIC;
--REVOKE ALL ON TABLE pgprocedures_stats FROM accueil;
--GRANT ALL ON TABLE pgprocedures_stats TO accueil;


--
-- PostgreSQL database dump complete
--

