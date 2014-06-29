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

SET search_path = notes, pg_catalog;

COMMENT ON SCHEMA notes IS 'Données des notes écrites par les utilisateurs.
Les utilisateurs peuvent écrire des notes. Ces notes, peuvent, indépendemment :
 - être rattachées à un ou plusieurs usagers
 - être rattachées à un ou plusieurs groupes d''usagers
 - être explicitement à destination d''autres utilisateurs, pour information ou pour action
 - être classifiées dans des boîtes thématiques.
L''utilisateur qui a écrit une note peut à tout moment savoir si les utilisateurs destinataires de cette note pour information respectivement action ont marqué cette note comme lue resp. faite.
';
COMMENT ON TABLE notes IS 'Liste des pages de notes disponibles pour placer dans le menu principal ou usager';
COMMENT ON TABLE theme IS 'Liste des boîtes thématiques';
COMMENT ON TABLE theme_portail IS 'Affectation des boîtes thématiques aux portails';
COMMENT ON TABLE note IS 'Notes envoyées entre utilisateurs';
COMMENT ON TABLE note_destinataire IS 'Destinataires d''une note';
COMMENT ON TABLE note_groupe IS 'Rattachement d''une note à un groupe d''usagers';
COMMENT ON TABLE note_theme IS 'Classification des notes dans des boîtes thématiques';
COMMENT ON TABLE note_usager IS 'Rattachement d''une note à un usager';

DROP FUNCTION IF EXISTS note_destinataire_derniers_par_utilisateur(prm_uti_id integer);
DROP FUNCTION IF EXISTS note_destinataire_derniers_par_utilisateur(prm_token integer);
DROP TYPE note_destinataire_derniers_par_utilisateur;
CREATE TYPE note_destinataire_derniers_par_utilisateur AS (
	per_id integer,
	libelle character varying
);
CREATE OR REPLACE FUNCTION note_destinataire_derniers_par_utilisateur(prm_token integer) RETURNS SETOF note_destinataire_derniers_par_utilisateur
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
COMMENT ON FUNCTION note_destinataire_derniers_par_utilisateur(prm_token integer) IS
'Retourne la liste des utilisateurs destinataires de notes de l''utilisateur authentifié, les plus récents en premier.
Entrées : 
 - prm_token : Token d''authentification
Retour : 
 - per_id : Identifiant de la personne
 - libelle : Nom et prénom de la personne
';

DROP FUNCTION IF EXISTS note_destinataires_liste(prm_not_id integer);
DROP FUNCTION IF EXISTS note_destinataires_liste(prm_token integer, prm_not_id integer);
DROP TYPE note_destinataires_liste;
CREATE TYPE note_destinataires_liste AS (
	libelle character varying,
	nde_pour_action boolean,
	nde_pour_information boolean,
	nde_action_faite boolean,
	nde_information_lue boolean,
	nde_supprime boolean
);
CREATE OR REPLACE FUNCTION note_destinataires_liste(prm_token integer, prm_not_id integer) RETURNS SETOF note_destinataires_liste
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
COMMENT ON FUNCTION note_destinataires_liste(prm_token integer, prm_not_id integer) IS
'Retourne la liste des destinataires d''une note.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour :
 - libelle : Nom et préom du destinataire
 - nde_pour_action : Indique si la note a été envoyée à ce destinataire pour action
 - nde_pour_information : Indique si la note a été envoyée à ce destinataire pour information
 - nde_action_faite : Indique si le destinataire a marqué l''action comme faite (si envoyée pour action à ce destinataire)
 - nde_information_lue : Indique si le destinataire a marqué la note lue (si envoyée pour information à ce destinataire)';

DROP FUNCTION IF EXISTS note_usagers_liste(prm_not_id integer);
DROP FUNCTION IF EXISTS note_usagers_liste(prm_token integer, prm_not_id integer);
DROP TYPE note_usagers_liste;
CREATE TYPE note_usagers_liste AS (
	per_id integer,
	libelle character varying
);

CREATE OR REPLACE FUNCTION note_usagers_liste(prm_token integer, prm_not_id integer) RETURNS SETOF note_usagers_liste
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
COMMENT ON FUNCTION note_usagers_liste(prm_token integer, prm_not_id integer) IS
'Retourne les usagers rattachés à une note.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour : 
 - per_id : Identifiant de l''usager
 - libelle : Nom et prénom de l''usager';

DROP FUNCTION IF EXISTS notes_note_boite_envoi_liste(prm_uti_id integer);
DROP FUNCTION IF EXISTS notes_note_boite_envoi_liste(prm_token integer);
DROP TYPE notes_note_boite_envoi_liste;
CREATE TYPE notes_note_boite_envoi_liste AS (
	not_id integer,
	not_date_saisie timestamp with time zone,
	not_date_evenement timestamp with time zone,
	not_objet character varying,
	not_texte text,
	eta_id_auteur integer
);

CREATE OR REPLACE FUNCTION notes_note_boite_envoi_liste(prm_token integer) RETURNS SETOF notes_note_boite_envoi_liste
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
COMMENT ON FUNCTION notes_note_boite_envoi_liste(prm_token integer) IS
'Retourne la liste des notes envoyées par l''utilisateur authentifié.
Entrées :
 - prm_token : Token d''authentification
Retour :
 - not_id : Identifiant de la note
 - not_date_saisie : Date de saisie de la note 
 - not_date_evenement : Date de l''événement décrit par la note
 - not_objet : Objet de la note
 - not_texte : Contenu de la note
 - eta_id _auteur : Identifiant de l''établissement auquel est rattachée la note';

DROP FUNCTION IF EXISTS notes_note_boite_reception_liste(prm_uti_id integer);
DROP FUNCTION IF EXISTS notes_note_boite_reception_liste(prm_token integer);
DROP TYPE notes_note_boite_reception_liste;
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

CREATE OR REPLACE FUNCTION notes_note_boite_reception_liste(prm_token integer) RETURNS SETOF notes_note_boite_reception_liste
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
COMMENT ON FUNCTION notes_note_boite_reception_liste(prm_token integer) IS
'Retourne la liste des notes dont l''utilisateur authentifié est destinataire.
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

DROP FUNCTION IF EXISTS notes_note_mesnotes(prm_uti_id integer, prm_grp_id integer);
DROP FUNCTION IF EXISTS notes_note_mesnotes(prm_uti_id integer, prm_grp_id integer, prm_nos_id integer);
DROP FUNCTION IF EXISTS notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer);
DROP TYPE notes_note_mesnotes;
CREATE TYPE notes_note_mesnotes AS (
	not_id integer,
	not_date_saisie timestamp with time zone,
	not_date_evenement timestamp with time zone,
	not_objet character varying,
	not_texte text,
	uti_id_auteur integer,
	eta_id_auteur integer
);

--CREATE OR REPLACE FUNCTION notes_note_mesnotes(prm_uti_id integer, prm_grp_id integer) RETURNS SETOF notes_note_mesnotes
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row notes.notes_note_mesnotes;
--BEGIN
--	FOR row IN
--		select DISTINCT note.* FROM notes.note 
--			inner join notes.note_usager using(not_id)
--			inner join login.utilisateur_usagers_liste (prm_uti_id, prm_grp_id, false) on utilisateur_usagers_liste.per_id = note_usager.per_id
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

CREATE OR REPLACE FUNCTION notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer) RETURNS SETOF notes_note_mesnotes
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
COMMENT ON FUNCTION notes_note_mesnotes(prm_token integer, prm_grp_id integer, prm_nos_id integer) IS
'Retourne la liste des notes intéressant l''utilisateur authentifié. Les notes "intéressantes" sont celles rattachées aux usagers dont l''utilisateur a accès (via les groupes d''usagers/groupes d''utilisateurs).
Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Filtre sur un groupe d''usagers en particulier, ou NULL
 - prm_nos_id : Identifiant de pages de notes (pour appliquer des filtres définis dans cette page)';

DROP FUNCTION IF EXISTS notes_theme_liste_details(prm_por_id integer);
DROP FUNCTION IF EXISTS notes_theme_liste_details(prm_token integer, prm_por_id integer);
DROP TYPE notes_theme_liste_details;
CREATE TYPE notes_theme_liste_details AS (
	the_id integer,
	the_nom character varying,
	portails character varying
);

CREATE OR REPLACE FUNCTION notes_theme_liste_details(prm_token integer, prm_por_id integer) RETURNS SETOF notes_theme_liste_details
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
COMMENT ON FUNCTION notes_theme_liste_details(prm_token integer, prm_por_id integer) IS
'Retourne le détail des informations des boîtes thématiques affectées à un portail.
Entrées :
 - prm_token : Token d''authentification
 - prm_por_id : Identifiant du portail
Retour : 
 - the_id : Identifiant de la boîte thématique
 - the_nom : Nom de la boîte thématique
 - portails : Liste des noms de portails auxquels sont affectés cette boîte thématique
';

DROP FUNCTION IF EXISTS note_destinataires_liste_autres(prm_not_id integer, prm_uti_id integer);
CREATE OR REPLACE FUNCTION note_destinataires_liste_autres(prm_token integer, prm_not_id integer) RETURNS SETOF character varying
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
COMMENT ON FUNCTION note_destinataires_liste_autres(prm_token integer, prm_not_id integer) IS
'Retourne la liste des noms et prénoms des destinataires d''une note, autres que l''utilisateur authentifié.
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
Retour : 
 - Nom et prénom du destinataire';

DROP FUNCTION IF EXISTS note_supprime(prm_not_id integer);
--CREATE OR REPLACE FUNCTION note_supprime(prm_not_id integer) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--BEGIN
--	DELETE FROM notes.note_destinataire WHERE not_id = prm_not_id;
--	DELETE FROM notes.note_groupe WHERE not_id = prm_not_id;
--	DELETE FROM notes.note_theme WHERE not_id = prm_not_id;
--	DELETE FROM notes.note_usager WHERE not_id = prm_not_id;
--	DELETE FROM notes.note WHERE not_id = prm_not_id;
--END;
--$$;

DROP FUNCTION IF EXISTS notes_note_ajoute(prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_uti_id_auteur integer, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_groupes integer[]);
--CREATE OR REPLACE FUNCTION notes_note_ajoute(prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_uti_id_auteur integer, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_groupes integer[]) RETURNS integer
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	new_not_id integer;
--BEGIN
--	-- non utilisé
--	INSERT INTO notes.note (not_date_saisie, not_date_evenement, not_objet, not_texte, uti_id_auteur, eta_id_auteur)
--		VALUES (CURRENT_TIMESTAMP, prm_date_evenement, prm_objet, prm_texte, prm_uti_id_auteur, prm_eta_id_auteur)
--		RETURNING not_id INTO new_not_id;
--	IF prm_usagers NOTNULL THEN
--		FOR i IN 1 .. array_upper (prm_usagers, 1) LOOP
--			INSERT INTO notes.note_usager (not_id, per_id) VALUES (new_not_id, prm_usagers[i]);
--		END LOOP;
--	END IF;
--	IF prm_dests NOTNULL THEN
--		FOR i IN 1 .. array_upper (prm_dests, 1) LOOP
--			INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_information) VALUES (new_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_dests[i]), true);
--		END LOOP;
--	END IF;
--	IF prm_destsaction NOTNULL THEN
--		FOR i IN 1 .. array_upper (prm_destsaction, 1) LOOP
--			INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_action) VALUES (new_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_destsaction[i]), true);
--		END LOOP;
--	END IF;
--	IF prm_groupes NOTNULL THEN
--		FOR i IN 1 .. array_upper (prm_groupes, 1) LOOP
--			INSERT INTO notes.note_groupe (not_id, grp_id) VALUES (new_not_id, prm_groupes[i]);
--		END LOOP;
--	END IF;
--	RETURN new_not_id;
--END;
--$$;

DROP FUNCTION IF EXISTS notes_note_ajoute(prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_uti_id_auteur integer, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]);
CREATE OR REPLACE FUNCTION notes_note_ajoute(prm_token integer, prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]) RETURNS integer
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
COMMENT ON FUNCTION notes_note_ajoute(prm_token integer, prm_date_evenement timestamp with time zone, prm_objet character varying, prm_texte text, prm_eta_id_auteur integer, prm_usagers integer[], prm_dests integer[], prm_destsaction integer[], prm_deststheme integer[], prm_groupes integer[]) IS
'Envoie une note.
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

DROP FUNCTION IF EXISTS notes_note_boite_reception_nombre_non_lu(prm_uti_id integer);
CREATE OR REPLACE FUNCTION notes_note_boite_reception_nombre_non_lu(prm_token integer) RETURNS integer
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
COMMENT on FUNCTION notes_note_boite_reception_nombre_non_lu(prm_token integer) IS
'Retourne le nombre de notes dont l''utilisateur authentifié est destinataire et qui n''ont pas encore été marquées comme lues ou faite.
Entrées : 
 - prm_token : Token d''authentification
Retour : 
 - le nombre de notes.
';

DROP FUNCTION IF EXISTS notes_note_destinataire_ajoute_forward_pour_info(prm_not_id integer, prm_per_id integer);
CREATE OR REPLACE FUNCTION notes_note_destinataire_ajoute_forward_pour_info(prm_token integer, prm_not_id integer, prm_per_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	INSERT INTO notes.note_destinataire (not_id, uti_id, nde_pour_information)
		VALUES (prm_not_id, (SELECT uti_id FROM login.utilisateur WHERE per_id = prm_per_id), TRUE);
END;
$$;
COMMENT ON FUNCTION notes_note_destinataire_ajoute_forward_pour_info(prm_token integer, prm_not_id integer, prm_per_id integer) IS
'Ajoute un destinataire pour information à une note (forward de la note).
Entrées :
 - prm_token : Token d''authentification
 - prm_not_id : Identifiant de la note
 - prm_per_id : Identifiant de la personne destinataire pour information';

DROP FUNCTION IF EXISTS notes_note_destinataire_marque_done(prm_nde_id integer);
CREATE OR REPLACE FUNCTION notes_note_destinataire_marque_done(prm_token integer, prm_nde_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE notes.note_destinataire SET nde_information_lue = TRUE WHERE nde_pour_information AND nde_id = prm_nde_id;
	UPDATE notes.note_destinataire SET nde_action_faite = TRUE WHERE nde_pour_action AND nde_id = prm_nde_id;
END;
$$;
COMMENT ON FUNCTION notes_note_destinataire_marque_done(prm_token integer, prm_nde_id integer) IS
'Marque un message comme lu/fait.
TODO : Vérifier que l''utilisateur authentifié est bien le destinataire de prm_nde_id
Entrées :
 - prm_token : Token d''authentification
 - prm_nde_id : Identifiant des informations liées au destinataire de cette note (obtenu avec la fonction notes_note_boite_reception_liste)';

DROP FUNCTION IF EXISTS notes_note_supprime(prm_not_id integer);
CREATE OR REPLACE FUNCTION notes_note_supprime(prm_token integer, prm_not_id integer) RETURNS void
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
COMMENT ON FUNCTION notes_note_supprime(prm_token integer, prm_not_id integer) IS
'Supprime une note. 
Entrées : 
 - prm_token : Token d''authentification
 - not_id : Identifiant de la note à supprimer';

DROP FUNCTION IF EXISTS notes_note_usager_liste(prm_per_id integer);
DROP FUNCTION IF EXISTS notes_note_usager_liste(prm_token integer, prm_per_id integer);
CREATE OR REPLACE FUNCTION notes_note_usager_liste(prm_token integer, prm_per_id integer, prm_nos_id integer) RETURNS SETOF note
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
COMMENT ON FUNCTION notes_note_usager_liste(prm_token integer, prm_per_id integer, prm_nos_id integer) IS
'Retourne les notes rattachées à un usager.
Entrées :
 - prm_token : Token d''authentification
 - prm_per_id : Identifiant de l''usager
TODO : Vérifier que l''utilisateur authentifié a droit d''accès à cet usager
';

DROP FUNCTION IF EXISTS notes_notes_get(prm_nos_id integer);
CREATE OR REPLACE FUNCTION notes_notes_get(prm_token integer, prm_nos_id integer) RETURNS notes
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
COMMENT ON FUNCTION notes_notes_get(prm_token integer, prm_nos_id integer) IS
'Retourne les informations sur la configuration d''une page de notes.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de la page de notes.
';

DROP FUNCTION IF EXISTS notes_notes_liste();
CREATE OR REPLACE FUNCTION notes_notes_liste(prm_token integer) RETURNS SETOF notes
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
COMMENT ON FUNCTION notes_notes_liste(prm_token integer) IS
'Retourne la liste des informations de configuration de pages de notes, à placer dans le menu principal ou usager.
Remarque : 
Nécessite le droit de configuration de l''interface
';

DROP FUNCTION IF EXISTS notes_notes_supprime(prm_nos_id integer);
CREATE OR REPLACE FUNCTION notes_notes_supprime(prm_token integer, prm_nos_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	DELETE FROM notes.notes WHERE nos_id = prm_nos_id;
END;
$$;
COMMENT ON FUNCTION notes_notes_supprime(prm_token integer, prm_nos_id integer) IS 
'Supprime une configuration de page de notes.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de page de notes
Remarque :
Nécessite le droit de configuration de l''interface';

DROP FUNCTION IF EXISTS notes_notes_update(prm_nos_id integer, prm_nom character varying, prm_the_id integer);
DROP FUNCTION IF EXISTS notes_notes_update(prm_token integer, prm_nos_id integer, prm_nom character varying, prm_the_id integer);
CREATE OR REPLACE FUNCTION notes_notes_update(prm_token integer, prm_nos_id integer, prm_code varchar, prm_nom character varying, prm_the_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	PERFORM login._token_assert_interface (prm_token);
	IF prm_nos_id NOTNULL THEN
		UPDATE notes.notes SET nos_code = prm_code, nos_nom = prm_nom, the_id = prm_the_id WHERE nos_id = prm_nos_id;
		RETURN prm_nos_id;
	ELSE
		INSERT INTO notes.notes (the_id, nos_code, nos_nom) VALUES (prm_the_id, prm_code, prm_nom) RETURNING nos_id INTO ret;
		RETURN ret;
	END IF;
END;
$$;
COMMENT ON FUNCTION notes_notes_update(prm_token integer, prm_nos_id integer, prm_code varchar, prm_nom character varying, prm_the_id integer) IS
'Modifie les informations de configuration d''une page de notes ou crée une nouvelle configuration.
Entrées :
 - prm_token : Token d''authentification
 - prm_nos_id : Identifiant de la configuration de page à modifier ou NULL pour créer une nouvelle configuration
 - prm_code : Code pour la page
 - prm_nom : Nouveau nom de page
 - prm_the_id : Identifiant de la boîte thématique permettant de filtrer les notes sur cette page
Remarque :
Nécessite le droit de configuration de l''interface';

DROP FUNCTION IF EXISTS notes_theme_get(prm_the_id integer);
CREATE OR REPLACE FUNCTION notes_theme_get(prm_token integer, prm_the_id integer) RETURNS theme
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
COMMENT ON FUNCTION notes_theme_get(prm_token integer, prm_the_id integer) IS
'Retourne les informations sur une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
';

DROP FUNCTION IF EXISTS notes_theme_portail_liste(prm_the_id integer);
CREATE OR REPLACE FUNCTION notes_theme_portail_liste(prm_token integer, prm_the_id integer) RETURNS SETOF meta.portail
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
COMMENT ON FUNCTION notes_theme_portail_liste(prm_token integer, prm_the_id integer) IS
'Retourne la liste des portails auxquels est affectée une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
';

DROP FUNCTION IF EXISTS notes_theme_supprime(prm_the_id integer);
CREATE OR REPLACE FUNCTION notes_theme_supprime(prm_token integer, prm_the_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM notes.theme_portail WHERE the_id = prm_the_id;
	DELETE FROM notes.theme WHERE the_id = prm_the_id;
END;
$$;
COMMENT ON FUNCTION notes_theme_supprime(prm_token integer, prm_the_id integer) IS
'Supprime une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique
Remarque :
Nécessite le droit de configuration "Réseau"';

DROP FUNCTION IF EXISTS notes_theme_update(prm_the_id integer, prm_the_nom character varying, prm_portails integer[]);
CREATE OR REPLACE FUNCTION notes_theme_update(prm_token integer, prm_the_id integer, prm_the_nom character varying, prm_portails integer[]) RETURNS integer
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
COMMENT ON FUNCTION notes_theme_update(prm_token integer, prm_the_id integer, prm_the_nom character varying, prm_portails integer[]) IS
'Modifie les informations d''une boîte thématique.
Entrées :
 - prm_token : Token d''authentification
 - prm_the_id : Identifiant de la boîte thématique à modifier
 - prm_the_nom : Nom de la boîte thématique
 - prm_portails : Tableau d''identifiants de portails auxquels affecter la boîte thématique
Remarque :
Nécessite le droit de configuration "Réseau"';

