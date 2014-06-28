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

SET search_path = procedure, pg_catalog;

COMMENT ON SCHEMA procedure IS 'Documentations à afficher sur diverses pages.';
COMMENT ON TABLE procedure IS 'Contenu de la documentation.';
COMMENT ON TABLE procedure_affectation IS 'Affichage de la documentation sur une page donnée.';

DROP FUNCTION IF EXISTS procedure_procedure_details();
DROP FUNCTION IF EXISTS procedure_procedure_details(prm_token integer);
DROP TYPE procedure_procedure_details;
CREATE TYPE procedure_procedure_details AS (
	pro_id integer,
	pro_titre character varying,
	n_affectations integer
);

CREATE OR REPLACE FUNCTION procedure_procedure_details(prm_token integer) RETURNS SETOF procedure_procedure_details
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
COMMENT ON FUNCTION procedure_procedure_details(prm_token integer) IS
'Retourne la liste détaillée des procédures.';

DROP FUNCTION IF EXISTS procedure_liste(prm_id integer, prm_table character varying);
CREATE OR REPLACE FUNCTION procedure_liste(prm_token integer, prm_id integer, prm_table character varying) RETURNS SETOF procedure
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
	END CASE;
END;
$$;
COMMENT ON FUNCTION procedure_liste(prm_token integer, prm_id integer, prm_table character varying) IS
'Retourne la liste des procédures affectées à une page donnée.';

DROP FUNCTION IF EXISTS procedure_procedure_affectation_ajoute(prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer, prm_asm_id integer);
DROP FUNCTION IF EXISTS procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer, prm_asm_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	INSERT INTO procedure.procedure_affectation (pro_id, tsm_id, sme_id) VALUES (prm_pro_id, prm_tsm_id, prm_sme_id)
		RETURNING paf_id INTO ret;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION procedure_procedure_affectation_ajoute(prm_token integer, prm_pro_id integer, prm_tsm_id integer, prm_sme_id integer) IS
'Affecte une procédure à une page.';

DROP FUNCTION IF EXISTS procedure_procedure_affectation_detail(prm_paf_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_affectation_detail(prm_token integer, prm_paf_id integer) RETURNS character varying
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
END;
$$;
COMMENT ON FUNCTION procedure_procedure_affectation_detail(prm_token integer, prm_paf_id integer) IS
'Retourne les informations sur l''affectation d''une procédure à une page.';

DROP FUNCTION IF EXISTS procedure_procedure_affectation_liste(prm_pro_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_affectation_liste(prm_token integer, prm_pro_id integer) RETURNS SETOF procedure_affectation
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
COMMENT ON FUNCTION procedure_procedure_affectation_liste(prm_token integer, prm_pro_id integer) IS
'Retourne la liste des affectations d''une procédure.';

DROP FUNCTION IF EXISTS procedure_procedure_affectation_supprime(prm_paf_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_affectation_supprime(prm_token integer, prm_paf_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM procedure.procedure_affectation WHERE paf_id = prm_paf_id;
END;
$$;
COMMENT ON FUNCTION procedure_procedure_affectation_supprime(prm_token integer, prm_paf_id integer) IS
'Supprime une affectation d''une procédure à une page.';

DROP FUNCTION IF EXISTS procedure_procedure_get(prm_pro_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_get(prm_token integer, prm_pro_id integer) RETURNS procedure
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
COMMENT ON FUNCTION procedure_procedure_get(prm_token integer, prm_pro_id integer) IS
'Retourne les informations sur une procédure.';

DROP FUNCTION IF EXISTS procedure_procedure_supprime(prm_pro_id integer);
CREATE OR REPLACE FUNCTION procedure_procedure_supprime(prm_token integer, prm_pro_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	DELETE FROM procedure.procedure_affectation WHERE pro_id = prm_pro_id;
	DELETE FROM procedure.procedure WHERE pro_id = prm_pro_id;
END;
$$;
COMMENT ON FUNCTION procedure_procedure_supprime(prm_token integer, prm_pro_id integer) IS
'Supprime une procédure.';

DROP FUNCTION IF EXISTS procedure_procedure_update(prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text);
CREATE OR REPLACE FUNCTION procedure_procedure_update(prm_token integer, prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text) RETURNS integer
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
COMMENT ON FUNCTION procedure_procedure_update(prm_token integer, prm_pro_id integer, prm_pro_titre character varying, prm_pro_contenu text) IS
'Modifie les informations d''une procédure.';
