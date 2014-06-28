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

SET search_path = lock, pg_catalog;

COMMENT ON schema lock IS 'Système de verrouillage de fiches.';

COMMENT ON TABLE fiche IS 'Fiche verrouillée.';
COMMENT ON COLUMN fiche.loc_id IS 'Identifiant';
COMMENT ON COLUMN fiche.uti_id IS 'Utilisateur ayant verrouillé la fiche';
COMMENT ON COLUMN fiche.per_id IS 'Identifiant de la personne affichée par la fiche';
COMMENT ON COLUMN fiche.loc_date IS 'Date de dernière consultation de la fiche par l''utilisateur';
COMMENT ON COLUMN fiche.sme_id IS 'Dernier menu visité dans la fiche';

DROP FUNCTION IF EXISTS fiche_lock(prm_uti_id integer, prm_per_id integer, prm_force boolean);
CREATE OR REPLACE FUNCTION fiche_lock(prm_token integer, prm_per_id integer, prm_force boolean) RETURNS integer
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
COMMENT ON FUNCTION fiche_lock(prm_token integer, prm_per_id integer, prm_force boolean) IS
'Verouille une fiche.';

DROP FUNCTION IF EXISTS fiche_unlock(prm_loc_id integer);
-- CREATE OR REPLACE FUNCTION fiche_unlock(prm_loc_id integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	DELETE FROM lock.fiche WHERE loc_id = prm_loc_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS fiche_unlock(prm_uti_id integer, prm_per_id integer);
CREATE OR REPLACE FUNCTION fiche_unlock(prm_token integer, prm_per_id integer) RETURNS void
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
COMMENT ON FUNCTION fiche_unlock(prm_token integer, prm_per_id integer) IS
'Déverouille une fiche.';

DROP FUNCTION IF EXISTS fiche_touch(prm_uti_id integer, prm_per_id integer);
CREATE OR REPLACE FUNCTION fiche_touch(prm_token integer, prm_per_id integer) RETURNS void
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
COMMENT ON FUNCTION fiche_touch(prm_token integer, prm_per_id integer) IS
'Rafraîchit la date de dernière consultation d''une fiche.';

DROP FUNCTION IF EXISTS fiche_unlock_tout(prm_uti_id integer);
CREATE OR REPLACE FUNCTION fiche_unlock_tout(prm_token integer) RETURNS void
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
COMMENT ON FUNCTION fiche_unlock_tout(prm_token integer) IS
'Déverouille toutes les fichers verrouillées par l''utilisateur authentifié.';

DROP FUNCTION IF EXISTS lock_fiche_liste(prm_uti_id integer);
CREATE OR REPLACE FUNCTION lock_fiche_liste(prm_token integer) RETURNS SETOF fiche
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
COMMENT ON FUNCTION lock_fiche_liste(prm_token integer) IS
'Retourne la liste des fiches verrouillées par l''utilisateur authentifié.';

DROP FUNCTION IF EXISTS lock_fiche_set_sme(prm_per_id integer, prm_uti_id integer, prm_sme_id integer);
CREATE OR REPLACE FUNCTION lock_fiche_set_sme(prm_per_id integer, prm_token integer, prm_sme_id integer) RETURNS void
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
COMMENT ON FUNCTION lock_fiche_set_sme(prm_per_id integer, prm_token integer, prm_sme_id integer) IS
'Modifie le dernier menu visité.';
