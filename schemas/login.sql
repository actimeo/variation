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

SET search_path = login, pg_catalog;

COMMENT ON SCHEMA login
  IS 'Procédures d''authentification de l''utilisateur. Gestion des utilisateurs et groupes d''utilisateurs.
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

COMMENT ON TABLE grouputil IS 'Liste des groupes d''utilisateurs.';
COMMENT ON COLUMN grouputil.gut_id IS 'Identifiant du groupe d''utilisateurs';
COMMENT ON COLUMN grouputil.gut_nom IS 'Nom du groupe';

COMMENT ON TABLE grouputil_groupe IS 'Groupes d''usagers auxquels un groupe d''utilisateurs a accès';
COMMENT ON COLUMN grouputil_groupe.ggr_id IS 'Identifiant de la relation';
COMMENT ON COLUMN grouputil_groupe.gut_id IS 'Identifiant du groupe d''utilisateurs';
COMMENT ON COLUMN grouputil_groupe.grp_id IS 'Identifiant du groupe d''usagers';

COMMENT ON TABLE grouputil_portail IS 'Portails auxquels un groupe d''utilisateurs a accès';
COMMENT ON COLUMN grouputil_portail.gpo_id IS 'Identifiant de la relation';
COMMENT ON COLUMN grouputil_portail.gut_id IS 'Identifiant du groupe d''utilisateurs';
COMMENT ON COLUMN grouputil_portail.por_id IS 'Identifiant du portail';

COMMENT ON TABLE token IS 'Token d''authentification (interne)';
COMMENT ON COLUMN token.tok_id IS 'Identifiant ';
COMMENT ON COLUMN token.uti_id IS 'Utilisateur ayant reçu ce token';
COMMENT ON COLUMN token.tok_token IS 'Valeur du token';
COMMENT ON COLUMN token.tok_date_creation IS 'Date de création (à la connexion de l''utilisateur)';

COMMENT ON TABLE utilisateur IS 'Utilisateurs de l''application';
COMMENT ON COLUMN utilisateur.uti_id IS 'Identifiant de l''utilisateur';
COMMENT ON COLUMN utilisateur.uti_login IS 'Login de connexion';
COMMENT ON COLUMN utilisateur.uti_salt IS 'Mot de passe crypté';
COMMENT ON COLUMN utilisateur.uti_root IS 'Droit de configuration "Réseau"';
COMMENT ON COLUMN utilisateur.uti_config IS 'Droit de configuration "Etablissement"';
COMMENT ON COLUMN utilisateur.per_id IS 'Identifiant du personnel associé à l''utilisateur';
COMMENT ON COLUMN utilisateur.uti_pwd IS 'Mot de passe temporaire en clair';
COMMENT ON COLUMN utilisateur.uti_digest IS 'Mot de passe crypté pour connexion par webdav';

COMMENT ON TABLE utilisateur_grouputil IS 'Affectation des utilisateurs aux groupes d''utilisateurs.';
COMMENT ON COLUMN utilisateur_grouputil.ugr_id IS 'Identifiant de la relation';
COMMENT ON COLUMN utilisateur_grouputil.uti_id IS 'Identifiant de l''utilisateur';
COMMENT ON COLUMN utilisateur_grouputil.gut_id IS 'Identifiant du groupe d''utilisateurs';

CREATE OR REPLACE FUNCTION login._token_create (prm_uti_id integer) RETURNS varchar
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
COMMENT ON FUNCTION login._token_create (prm_uti_id integer) IS 
'[INTERNE] Crée un token d''authentification pour un utilisateur donné.
Retourne la valeur du token, à utiliser dans tout appel de fonction sécurisée';


CREATE OR REPLACE FUNCTION login._token_assert (prm_token integer, prm_config boolean, prm_root boolean) RETURNS VOID
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
COMMENT ON FUNCTION login._token_assert (prm_token integer, prm_config boolean, prm_root boolean) IS 
'[INTERNE] Vérifie la validité d''un token et ses droits de configuratiuon "Établissement" et "Réseau".

Entrée :
 - prm_token  : Token à vérifier
 - prm_config : Vérifie le droit de configuration "Etablissement"
 - prm_root   : Vérifie le droit de configuration "Réseau"
Lève une exception "insufficient_privilege" si le token est invalide ou si une demande de vérification config ou root échoue.';

CREATE OR REPLACE FUNCTION login._token_assert_interface (prm_token integer) RETURNS VOID
  LANGUAGE plpgsql
  AS $$
DECLARE
	uti integer;
	util login.utilisateur;
BEGIN
	-- TODO : Vérifier les droits de config de l'interface
END;
$$;
COMMENT ON FUNCTION login._token_assert_interface (prm_token integer) IS
'[INTERNE] Vérifie les droits de configuration de l''inteface pour un token';

DROP FUNCTION utilisateur_login2(prm_login character varying, prm_mdp character varying);
DROP TYPE utilisateur_login2;
CREATE TYPE utilisateur_login2 AS (
	uti_id integer,
	tok_token integer,
	uti_root boolean,
	uti_config boolean,
	eta_id integer,
	por_id integer,
	uti_pwd_provisoire boolean
);

CREATE OR REPLACE FUNCTION utilisateur_login_digest (prm_login varchar, prm_hash varchar, prm_response varchar) RETURNS integer 
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

CREATE OR REPLACE FUNCTION utilisateur_login2(prm_login character varying, prm_mdp character varying) RETURNS SETOF utilisateur_login2
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
	IF prm_login = 'kavarna' OR prm_login = 'variation' THEN
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

COMMENT ON FUNCTION login.utilisateur_login2(character varying, character varying) IS 
'Authentifie un utilisateur à partir d''un login et mot de passe.
Retourne un ensemble de :
 - uti_id : l''identifiant de l''utilisateur 
 - tok_token : token d''authentification à utiliser dans tout appel de fonction sécurisée
 - uti_root : l''utilisateur a accès à la configuration du réseau
 - uti_config : l''utilisateur a accès à la configuration de l''établissement
 - eta_id / por_id : paire établissement/portail auxquels l''utilisateur a droit
 - uti_pwd_provisoire (booléen) : indique si le mot de passe est provisoire (stocké en clair en base et visible dans la configuration de l''utilisateur)

Les données autres que eta_id et por_id sont répétées à l''identique sur toutes les lignes de la réponse. 
';

DROP FUNCTION IF EXISTS utilisateur_liste_details(prm_roots boolean);
DROP TYPE IF EXISTS utilisateur_liste_details;
--CREATE TYPE utilisateur_liste_details AS (
--	uti_id integer,
--	uti_login character varying,
--	uti_root character varying
--);

--CREATE OR REPLACE FUNCTION utilisateur_liste_details(prm_roots boolean) RETURNS SETOF utilisateur_liste_details
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row login.utilisateur_liste_details;
--BEGIN
--	FOR row IN
--		SELECT uti_id, uti_login, CASE WHEN uti_root THEN 'X' ELSE '' END FROM login.utilisateur
--		WHERE prm_roots OR (uti_root ISNULL OR NOT uti_root)
--a	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_liste_details_configuration();
DROP FUNCTION IF EXISTS utilisateur_liste_details_configuration(prm_token integer);
DROP TYPE utilisateur_liste_details_configuration;
CREATE TYPE utilisateur_liste_details_configuration AS (
	uti_id integer,
	uti_login character varying,
	uti_prenom character varying,
	uti_nom character varying
);

CREATE OR REPLACE FUNCTION utilisateur_liste_details_configuration(prm_token integer) RETURNS SETOF utilisateur_liste_details_configuration
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
COMMENT ON FUNCTION utilisateur_liste_details_configuration(prm_token integer) IS
'Liste le détail des utilisateurs.

Entrée :
 - prm_token : Token d''authentification
Remarques :
Nécessite les droits à la configuration "Etablissement"
';

CREATE OR REPLACE FUNCTION utilisateur_portail_liste(prm_login character varying) RETURNS SETOF integer
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
COMMENT ON FUNCTION utilisateur_portail_liste(prm_login character varying) IS 
'TODO : Utilisé par webdav';

DROP FUNCTION IF EXISTS utilisateur_usagers_liste(prm_uti_id integer, prm_grp_id integer, prm_presents boolean);
DROP FUNCTION IF EXISTS utilisateur_usagers_liste(prm_token integer, prm_grp_id integer, prm_presents boolean);
DROP TYPE utilisateur_usagers_liste;
CREATE TYPE utilisateur_usagers_liste AS (
	per_id integer,
	libelle character varying
);

CREATE OR REPLACE FUNCTION utilisateur_usagers_liste(prm_token integer, prm_grp_id integer, prm_presents boolean) RETURNS SETOF utilisateur_usagers_liste
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
COMMENT ON FUNCTION utilisateur_usagers_liste(prm_uti_id integer, prm_grp_id integer, prm_presents boolean) IS
'Retourne la liste des usagers en relation avec l''utilisateur authentifié par le token.

Entrée :
 - prm_token : token d''authentification
 - prm_grp_id : Identifiant du groupe auquel doivent appartenir les usagers, ou NULL pour rechercher parmi tous les groupes
 - prm_presents : TRUS pour retourner les usagers présents uniquement, FALSE sinon
';

DROP FUNCTION IF EXISTS login_grouputil_add(prm_nom character varying);
CREATE OR REPLACE FUNCTION login_grouputil_add(prm_token integer, prm_nom character varying) RETURNS integer
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
COMMENT ON FUNCTION login_grouputil_add(prm_token integer, prm_nom character varying) IS 
'Ajoute un nouveau groupe d''utilisateurs.

Entrée : 
 - prm_token : token d''authentification
 - prm_nom   : Nom du groupe
Retour : 
 - Id du groupe d''utilisateurs créé
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_get(prm_gut_id integer);
CREATE OR REPLACE FUNCTION login_grouputil_get(prm_token integer, prm_gut_id integer) RETURNS grouputil
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
COMMENT ON FUNCTION login_grouputil_get(prm_token integer, prm_gut_id integer) IS
'Retourne les informations sur un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour : 
 - gut_id  : Id du groupe
 - gut_nom : Nom du groupe d''utilisateurs
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_groupe_liste(prm_gut_id integer);
CREATE OR REPLACE FUNCTION login_grouputil_groupe_liste(prm_token integer, prm_gut_id integer) RETURNS SETOF grouputil_groupe
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
COMMENT ON FUNCTION login_grouputil_groupe_liste(prm_token integer, prm_gut_id integer) IS 
'Retourne la liste des groupes d''usagers accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour (multiple) : 
 - gut_id : Id du groupe d''utilisateurs
 - grp_id : Id du groupe d''usagers
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_groupe_set(prm_gut_id integer, prm_groupes integer[]);
CREATE OR REPLACE FUNCTION login_grouputil_groupe_set(prm_token integer, prm_gut_id integer, prm_groupes integer[]) RETURNS void
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
COMMENT ON FUNCTION login_grouputil_groupe_set(prm_token integer, prm_gut_id integer, prm_groupes integer[]) IS 
'Définit la liste des groupes d''usagers accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token     : token d''authentification
 - prm_gut_id    : Id du groupe d''utilisateurs
 - prm_groupes[] : tableau d''identifiants de groupes d''usagers
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_liste();
CREATE OR REPLACE FUNCTION login_grouputil_liste(prm_token integer) RETURNS SETOF grouputil
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
COMMENT ON FUNCTION login_grouputil_liste(prm_token integer) IS
'Retourne la liste des groupe d''utilisateurs.

Entrée :
 - prm_token : token d''authentification
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_portail_liste(prm_gut_id integer);
CREATE OR REPLACE FUNCTION login_grouputil_portail_liste(prm_token integer, prm_gut_id integer) RETURNS SETOF grouputil_portail
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
COMMENT ON FUNCTION login_grouputil_portail_liste(prm_token integer, prm_gut_id integer) IS
'Retourne la liste des portails accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token  : token d''authentification
 - prm_gut_id : Id du groupe d''utilisateurs
Retour (multiple) : 
 - gut_id : Id du groupe d''utilisateurs
 - por_id : Id du portail
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_portail_set(prm_gut_id integer, prm_portails integer[]);
CREATE OR REPLACE FUNCTION login_grouputil_portail_set(prm_token integer, prm_gut_id integer, prm_portails integer[]) RETURNS void
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
COMMENT ON FUNCTION login_grouputil_portail_set(prm_token integer, prm_gut_id integer, prm_portails integer[]) IS 
'Définit la liste des portails accessibles par un groupe d''utilisateurs.

Entrée : 
 - prm_token      : token d''authentification
 - prm_gut_id     : Id du groupe d''utilisateurs
 - prm_portails[] : tableau d''identifiants de portails
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_grouputil_supprime(prm_gut_id integer);
CREATE OR REPLACE FUNCTION login_grouputil_supprime(prm_token integer, prm_gut_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.grouputil_groupe WHERE gut_id = prm_gut_id;
	DELETE FROM login.grouputil_portail WHERE gut_id = prm_gut_id;
	DELETE FROM login.grouputil WHERE gut_id = prm_gut_id;
END;
$$;
COMMENT ON FUNCTION login_grouputil_supprime(prm_token integer, prm_gut_id integer) IS 
'Supprime un groupe d''utilisateurs.
 - prm_token  : token d''authentification
 - prm_gut_id : Identifiant du groupe d''utilisateurs
Nécessite les droits à la configuration "Etablissement"';


DROP FUNCTION IF EXISTS login_grouputil_update(prm_id integer, prm_nom character varying);
CREATE OR REPLACE FUNCTION login_grouputil_update(prm_token integer, prm_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE login.grouputil SET gut_nom = prm_nom WHERE gut_id = prm_id;
END;
$$;
COMMENT ON FUNCTION login_grouputil_update(prm_token integer, prm_id integer, prm_nom character varying) IS
'Met à jour les informations d''un groupe d''utilisateurs.

Entrée :
 - prm_token : token d''authentification
 - prm_id    : Identifiant du groupe d''utilisateurs
 - prm_nom   : nom du groupe à mettre à jour
Nécessite les droits à la configuration "Etablissement"';

DROP FUNCTION IF EXISTS login_utilisateur_acces_personne(prm_uti_id integer, prm_per_id integer);
CREATE OR REPLACE FUNCTION login_utilisateur_acces_personne(prm_token integer, prm_per_id integer) RETURNS boolean
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
COMMENT ON FUNCTION login_utilisateur_acces_personne(prm_token integer, prm_per_id integer) IS
'Vérifie que le token donne accès à un usager donné.
L''accès est validé si l''usager fait partie d''un groupe d''usagers auquel le groupe d''utilisateurs de l''utilisateur (identifié par le token) a accès.

Entrée :
 - prm_token : token d''authentification
 - prm_per_id : Identifiant de l''usager';

DROP FUNCTION IF EXISTS utilisateur_add(prm_login character varying, prm_per_id integer);
--CREATE OR REPLACE FUNCTION utilisateur_add(prm_login character varying, prm_per_id integer) RETURNS integer
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret integer;
--	mdp varchar;
--BEGIN
--	mdp = LPAD((random()*1000000)::varchar, 6, '0');
--	INSERT INTO login.utilisateur (uti_login, per_id, uti_salt, uti_pwd) VALUES (prm_login, prm_per_id, crypt (mdp, gen_salt('des')), mdp) RETURNING uti_id INTO ret;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_add(prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean);
CREATE OR REPLACE FUNCTION utilisateur_add(prm_token integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
	mdp varchar;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);	
	mdp = LPAD((100000+random()*900000)::varchar, 6, '0');
	INSERT INTO login.utilisateur (uti_login, per_id, uti_salt, uti_pwd, uti_config, uti_root) VALUES (prm_login, prm_per_id, crypt (mdp, gen_salt('des')), mdp, prm_uti_config, prm_uti_root) RETURNING uti_id INTO ret;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION utilisateur_add(prm_token integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) IS 
'Ajoute un utilisateur.

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

DROP FUNCTION IF EXISTS utilisateur_etablissement_liste(prm_uti_id integer);
--CREATE OR REPLACE FUNCTION utilisateur_etablissement_liste(prm_uti_id integer) RETURNS SETOF public.etablissement
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row public.etablissement;
--BEGIN
--	FOR row IN
--		SELECT etablissement.* FROM login.utilisateur_etablissement
--		INNER JOIN etablissement USING(eta_id) 
--		WHERE uti_id = prm_uti_id
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_etablissement_set(prm_uti_id integer, prm_etabs integer[]);
--CREATE OR REPLACE FUNCTION utilisateur_etablissement_set(prm_uti_id integer, prm_etabs integer[]) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--BEGIN
--	DELETE FROM login.utilisateur_etablissement WHERE uti_id = prm_uti_id;
--	IF prm_etabs NOTNULL THEN
--		FOR i IN 1 .. array_upper(prm_etabs, 1) LOOP
--			INSERT INTO login.utilisateur_etablissement(uti_id, eta_id) VALUES (prm_uti_id, prm_etabs[i]);
--		END LOOP;
--	END IF;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_get(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_get(prm_token integer, prm_uti_id integer) RETURNS utilisateur
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
COMMENT ON FUNCTION utilisateur_get(prm_token integer, prm_uti_id integer) IS 
'Retourne les informations d''un utilisateur.
 - uti_id     : Id de l''utilisateur
 - uti_login  : login de l''utilisateur, NULL si pas droit de config Établissement
 - uti_salt   : toujours NULL
 - uti_root   : Vrai si l''utilisateur a droit de config "Réseau", NULL si pas droit de config Établissement
 - uti_config : Vrai si l''utilisateur a droit de config "Établissement", NULL si pas droit de config Établissement
 - per_id     : Id du personnel relié à l''utilisateur
 - uti_pwd    : Mot de passe (si temporaire), NULL si pas droit de config Établissement
 - uti_digest : toujours NULL';

CREATE OR REPLACE FUNCTION utilisateur_get_par_login(prm_uti_login varchar) RETURNS utilisateur
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret login.utilisateur;
BEGIN
	SELECT utilisateur.* INTO ret FROM login.utilisateur WHERE uti_login = prm_uti_login;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION utilisateur_get_par_login(prm_uti_login varchar) IS
'TODO : utilisé par imports temporaires';

CREATE OR REPLACE FUNCTION utilisateur_get_digest_hash(prm_uti_login varchar) RETURNS varchar
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret varchar;
BEGIN
	SELECT utilisateur.uti_digest INTO ret FROM login.utilisateur WHERE uti_login = prm_uti_login;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION utilisateur_get_digest_hash(prm_uti_login varchar) IS 
'TODO: utilisé par webdav';

DROP FUNCTION IF EXISTS utilisateur_groupe_liste(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_groupe_liste(prm_token integer) RETURNS SETOF public.groupe
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
COMMENT ON FUNCTION utilisateur_groupe_liste(prm_token integer) IS
'Retourne la liste des groupes d''usagers accessibles par l''utilisateur authentifié.

Entrées :
 - prm_token : Token d''authentification';

DROP FUNCTION IF EXISTS utilisateur_grouputil_liste(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_grouputil_liste(prm_token integer, prm_uti_id integer) RETURNS SETOF grouputil
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
COMMENT ON FUNCTION utilisateur_grouputil_liste(prm_token integer, prm_uti_id integer) IS 
'Liste des groupes d''utilisateurs auxquels est affecté un utilisateur.

Entrée : 
 - prm_token : Token d''authentification
 - prm_uti_id : Id de l''utilisateur concerné
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';

DROP FUNCTION IF EXISTS utilisateur_grouputil_set(prm_uti_id integer, prm_grouputils integer[]);
CREATE OR REPLACE FUNCTION utilisateur_grouputil_set(prm_token integer, prm_uti_id integer, prm_grouputils integer[]) RETURNS void
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
COMMENT ON FUNCTION utilisateur_grouputil_set(prm_token integer, prm_uti_id integer, prm_grouputils integer[]) IS 
'Modifie les groupes d''utilisateurs auxquels est affecté un utilisateur.

Entrée :
 - prm_token : Token d''authentification
 - prm_uti_id : Id de l''Utilisateur à modifier
 - prm_grouputils : Tableau d''identifiants de groupes d''utilisateurs
Remarques :
Nécessite les droits à la configuration "Etablissement"
';

DROP FUNCTION IF EXISTS utilisateur_login(prm_login character varying, prm_mdp character varying, prm_eta_id integer);
DROP TYPE IF EXISTS utilisateur_login;
--CREATE TYPE utilisateur_login AS (
--	uti_id integer,
--	uti_root boolean,
--	uti_config boolean
--);

--CREATE OR REPLACE FUNCTION utilisateur_login(prm_login character varying, prm_mdp character varying, prm_eta_id integer) RETURNS login.utilisateur_login
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret login.utilisateur_login;
--BEGIN
--	SELECT uti_id, uti_root, uti_config INTO ret FROM login.utilisateur 
--	INNER JOIN login.utilisateur_etablissement USING(uti_id)
--	WHERE uti_login = prm_login AND crypt(prm_mdp, SUBSTRING(uti_salt FROM 1 FOR 2)) = uti_salt
--	AND eta_id = prm_eta_id;
--	IF NOT FOUND THEN
--		ret.uti_id = 0;
--	END IF;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_mdp_change(prm_uti_id integer, prm_mdp character varying);
CREATE OR REPLACE FUNCTION utilisateur_mdp_change(prm_token integer, prm_mdp character varying) RETURNS void
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
COMMENT ON FUNCTION utilisateur_mdp_change(prm_token integer, prm_mdp character varying) IS
'Modifie le mot de passe de l''utilisateur identifié.

Entrée :
 - prm_token : Token d''authentification
 - prm_mdp   : Nouveau mot de passe
Remarques :
Seul l''utilisateur connecté peut modifier son mot de passe.
Il est possible pour un utilisateur ayant les droits de configuration "Etablissement" de générer un mot de passe temporaire avec utilisateur_mdp_genere pour tout autre utilisateur, mais seul l''utilisateur lui-même peut saisir un nouveau mot de passe.';

DROP FUNCTION IF EXISTS utilisateur_mdp_genere(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_mdp_genere(prm_token integer, prm_uti_id integer) RETURNS void
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

COMMENT ON FUNCTION utilisateur_mdp_genere(prm_token integer, prm_uti_id integer) IS 
'Génére un nouveau mot de passe aléatoire pour un utilisateur.

Entrée : 
 - prm_token  : Token d''authentification
 - prm_uti_id : Id de l''utilisateur pour qui générer un nouveau mot de passe
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';

DROP FUNCTION IF EXISTS utilisateur_nom(prm_uti_id integer);
--CREATE OR REPLACE FUNCTION utilisateur_nom(prm_uti_id integer) RETURNS character varying
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret varchar;
--BEGIN
--	SELECT uti_login INTO ret FROM login.utilisateur WHERE uti_id = prm_uti_id;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_prenon_nom(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_prenon_nom(prm_token integer, prm_uti_id integer) RETURNS character varying
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
COMMENT ON FUNCTION utilisateur_prenon_nom(prm_token integer, prm_uti_id integer) IS
'Retourne le nom et prénom d''un utilisateur';

DROP FUNCTION IF EXISTS utilisateur_supprime(prm_uti_id integer);
CREATE OR REPLACE FUNCTION utilisateur_supprime(prm_token integer, prm_uti_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM login.utilisateur_grouputil WHERE uti_id = prm_uti_id;
	DELETE FROM login.utilisateur WHERE uti_id = prm_uti_id;
END;
$$;
COMMENT ON FUNCTION utilisateur_supprime(prm_token integer, prm_uti_id integer) IS
'Supprime un utilisateur.

Entrée : 
 - prm_token  : Token d''authentification
 - prm_uti_id : Id de l''utilisateur à supprimer
Remarques : 
Nécessite les droits à la configuration "Etablissement"
';

DROP FUNCTION IF EXISTS utilisateur_update(prm_uti_id integer, prm_login character varying, prm_per_id integer);
--CREATE OR REPLACE FUNCTION utilisateur_update(prm_uti_id integer, prm_login character varying, prm_per_id integer) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--BEGIN
--	UPDATE login.utilisateur SET uti_login = prm_login, per_id = prm_per_id WHERE uti_id = prm_uti_id;
--END;
--$$;

DROP FUNCTION IF EXISTS utilisateur_update(prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean);
CREATE OR REPLACE FUNCTION utilisateur_update(prm_token integer, prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE login.utilisateur SET uti_login = prm_login, per_id = prm_per_id, uti_config = prm_uti_config, uti_root = prm_uti_root WHERE uti_id = prm_uti_id;
END;
$$;
COMMENT ON FUNCTION utilisateur_update(prm_token integer, prm_uti_id integer, prm_login character varying, prm_per_id integer, prm_uti_config boolean, prm_uti_root boolean) IS
'Met à jour les informations d''un utilisateur.

Entrée : 
 - prm_token      : Token d''authentification
 - prm_uti_id     : Id de l''utilisateur à mettre à jour
 - prm_login      : Nouveau login
 - prm_per_id     : Nouveau lien vers personnel
 - prm_uti_config : Nouveau droit de configuration "Établissement"
 - prm_uti_root   : Nouveau droit de configuration "Réseau"
';
