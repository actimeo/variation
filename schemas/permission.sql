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

SET search_path = permission, pg_catalog;

COMMENT ON SCHEMA permission IS 'Enregistrement des diverses permissions.';

COMMENT ON TABLE droit_ajout_entite_portail IS 'Droit pour les utilisateurs d''ajouter des personnes d''une certaine catégorie (usager, personnel, contact, famille) par portail.';

DROP FUNCTION IF EXISTS droit_ajout_entite_portail_liste_par_portail(prm_por_id integer);
CREATE OR REPLACE FUNCTION droit_ajout_entite_portail_liste_par_portail(prm_token integer, prm_por_id integer) RETURNS SETOF droit_ajout_entite_portail
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
COMMENT ON FUNCTION droit_ajout_entite_portail_liste_par_portail(prm_token integer, prm_por_id integer) IS 
'Retourne la liste des droits d''ajout de personne pour un portail donné.';

DROP FUNCTION IF EXISTS droit_ajout_entite_portail_set(prm_ent_code character varying, prm_por_id integer, prm_droit boolean);
CREATE OR REPLACE FUNCTION droit_ajout_entite_portail_set(prm_token integer, prm_ent_code character varying, prm_por_id integer, prm_droit boolean) RETURNS void
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
COMMENT ON FUNCTION droit_ajout_entite_portail_set(prm_token integer, prm_ent_code character varying, prm_por_id integer, prm_droit boolean) IS 
'Indique le droit d''ajouter une personne d''une certaine catégorie depuis un portail donné.';
