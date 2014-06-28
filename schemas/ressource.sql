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

SET search_path = ressource, pg_catalog;

COMMENT ON SCHEMA ressource IS 'Ressources à affecter à des événements.';
COMMENT ON TABLE ressource IS 'Les ressources.';
COMMENT ON TABLE ressource_secteur IS 'Affectation des ressources à des secteurs.';

DROP FUNCTION IF EXISTS ressource_liste_details(prm_sec_id integer);
DROP FUNCTION IF EXISTS ressource_liste_details(prm_token integer, prm_sec_id integer);
DROP TYPE ressource_liste_details;
CREATE TYPE ressource_liste_details AS (
	res_id integer,
	res_nom character varying,
	secteurs character varying
);

CREATE OR REPLACE FUNCTION ressource_liste_details(prm_token integer, prm_sec_id integer) RETURNS SETOF ressource_liste_details
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
COMMENT ON FUNCTION ressource_liste_details(prm_token integer, prm_sec_id integer) IS
'Liste en détail les ressources.';

DROP FUNCTION IF EXISTS ressource_add(prm_res_nom character varying);
CREATE OR REPLACE FUNCTION ressource_add(prm_token integer, prm_res_nom character varying) RETURNS integer
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
COMMENT ON FUNCTION ressource_add(prm_token integer, prm_res_nom character varying) IS
'Ajoute une ressource.';

DROP FUNCTION IF EXISTS ressource_get(prm_res_id integer);
CREATE OR REPLACE FUNCTION ressource_get(prm_token integer, prm_res_id integer) RETURNS ressource
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
COMMENT ON FUNCTION ressource_get(prm_token integer, prm_res_id integer) IS
'Retourne les informations d''une ressource.';

DROP FUNCTION IF EXISTS ressource_list(prm_sec_id integer[]);
CREATE OR REPLACE FUNCTION ressource_list(prm_token integer, prm_sec_id integer[]) RETURNS SETOF ressource
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
COMMENT ON FUNCTION ressource_list(prm_token integer, prm_sec_id integer[]) IS
'Retourne la liste des ressources.';

DROP FUNCTION IF EXISTS ressource_save(prm_res_id integer, prm_nom character varying);
CREATE OR REPLACE FUNCTION ressource_save(prm_token integer, prm_res_id integer, prm_nom character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	UPDATE ressource.ressource SET res_nom = prm_nom WHERE res_id = prm_res_id;
END;
$$;
COMMENT ON FUNCTION ressource_save(prm_token integer, prm_res_id integer, prm_nom character varying) IS
'Enregistre les informations d''une ressource.';

DROP FUNCTION IF EXISTS ressource_secteur_liste(prm_res_id integer);
CREATE OR REPLACE FUNCTION ressource_secteur_liste(prm_token integer, prm_res_id integer) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION ressource_secteur_liste(prm_token integer, prm_res_id integer) IS
'Retourne la liste des secteurs auxquels est affectée une ressource.';

DROP FUNCTION IF EXISTS ressource_secteur_set(prm_res_id integer, prm_secteurs character varying[]);
CREATE OR REPLACE FUNCTION ressource_secteur_set(prm_token integer, prm_res_id integer, prm_secteurs character varying[]) RETURNS void
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
COMMENT ON FUNCTION ressource_secteur_set(prm_token integer, prm_res_id integer, prm_secteurs character varying[]) IS
'Indique à quels secteurs à est affecté une ressource.';

DROP FUNCTION IF EXISTS ressource_supprime(prm_res_id integer);
CREATE OR REPLACE FUNCTION ressource_supprime(prm_token integer, prm_res_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM ressource.ressource_secteur WHERE res_id = prm_res_id;
	DELETE FROM ressource.ressource WHERE res_id = prm_res_id;
END;
$$;
COMMENT ON FUNCTION ressource_supprime(prm_token integer, prm_res_id integer) IS
'Supprime une ressource.';
