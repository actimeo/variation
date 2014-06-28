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

SET search_path = localise, pg_catalog;

COMMENT ON schema localise IS 'Système de localisation. A ce point, il est possible de localiser un terme pour un secteur particulier.';

COMMENT ON TABLE terme IS 'Terme à localiser.';

COMMENT ON TABLE localisation_secteur IS 'Localisation d''un terme pour un secteur particulier.';

DROP FUNCTION IF EXISTS localise_par_code_secteur(prm_ter_code character varying, prm_sec_code character varying);
CREATE OR REPLACE FUNCTION localise_par_code_secteur(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) RETURNS character varying
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
COMMENT ON FUNCTION localise_par_code_secteur(prm_token integer, prm_ter_code character varying, prm_sec_code character varying) IS
'Retourne un terme localisé pour un secteur donné.';

CREATE OR REPLACE FUNCTION localise_par_code_secteur_set (prm_token integer, prm_ter_code character varying, prm_sec_code character varying, prm_valeur varchar) RETURNS VOID
LANGUAGE plpgsql
AS
$$
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
COMMENT ON FUNCTION localise_par_code_secteur_set (prm_token integer, prm_ter_code character varying, prm_sec_code character varying, prm_valeur varchar) IS
'Modifie la localisation d''un terme pour un secteur particulier.
Entrées :
 - prm_token : Token d''authentification
 - prm_ter_code : Code du terme
 - prm_sec_code : Code du secteur ou NULL pour modifier la valeur par défaut
 - prm_valeur : Valeur de la localisation
';

CREATE OR REPLACE  FUNCTION localise_par_code_secteur_supprime (prm_token integer, prm_ter_code character varying, prm_sec_code character varying) RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN
	DELETE FROM localise.localisation_secteur 
	WHERE 
	      sec_id = (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_sec_code) AND
	      ter_id = (SELECT ter_id FROM localise.terme WHERE ter_code = prm_ter_code);
END;
$$;
COMMENT ON  FUNCTION localise_par_code_secteur_supprime (prm_token integer, prm_ter_code character varying, prm_sec_code character varying) IS
'Suppime la localisation d''un terme pour un secteur donné.';


DROP FUNCTION IF EXISTS localise_terme_supprime (prm_ter_id integer);
CREATE OR REPLACE FUNCTION localise_terme_supprime (prm_token integer, prm_ter_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM localise.localisation_secteur WHERE ter_id = prm_ter_id;
	DELETE FROM localise.terme WHERE ter_id = prm_ter_id;
END;
$$;
COMMENT ON FUNCTION localise_terme_supprime (prm_token integer, prm_ter_id integer) IS
'Supprime un terme à localiser.';

DROP FUNCTION IF EXISTS localise_terme_liste_details (prm_token integer);
DROP TYPE IF EXISTS localise_terme_liste_details;
CREATE TYPE localise_terme_liste_details AS (
       ter_id integer,
       ter_code varchar,
       ter_commentaire varchar,
       defaut varchar
);

CREATE OR REPLACE FUNCTION localise_terme_liste_details (prm_token integer) RETURNS SETOF localise.localise_terme_liste_details
LANGUAGE plpgsql
 AS
$$
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
COMMENT ON  FUNCTION localise_terme_liste_details (prm_token integer) IS
'Retourne le détail des termes à localiser.';

CREATE OR REPLACE FUNCTION localise_terme_get (prm_token integer, prm_id integer) RETURNS localise.terme 
LANGUAGE plpgsql
AS
$$
DECLARE
	ret localise.terme;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	SELECT * INTO ret FROM localise.terme WHERE ter_id = prm_id;
	RETURN ret;
END;
$$;
COMMENT ON  FUNCTION localise_terme_get (prm_token integer, prm_id integer) IS
'Retourne les détails d''un terme à localiser.';

CREATE OR REPLACE FUNCTION localise_terme_set (prm_token integer, prm_id integer, prm_commentaire varchar) RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE localise.terme SET ter_commentaire = prm_commentaire WHERE ter_id = prm_id;
END;
$$;
COMMENT ON FUNCTION localise_terme_set (prm_token integer, prm_id integer, prm_commentaire varchar) IS
'Modifie les détails d''un terme à localiser.';
