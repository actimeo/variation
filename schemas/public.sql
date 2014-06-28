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

SET search_path = public, pg_catalog;

--COMMENT ON SCHEMA public IS 'Données des établissements, groupes et personnes.';

COMMENT ON TABLE adresse IS 'Adresse et moyens de contact d''un établissement/partenaire.';
COMMENT ON COLUMN adresse.adr_id IS 'Identifiant de l''adresse';
COMMENT ON COLUMN adresse.adr_adresse IS 'Ligne d''adresse';
COMMENT ON COLUMN adresse.adr_cp IS 'Code postal';
COMMENT ON COLUMN adresse.adr_ville IS 'Ville';
COMMENT ON COLUMN adresse.adr_tel IS 'Téléphone';
COMMENT ON COLUMN adresse.adr_fax IS 'Fax';
COMMENT ON COLUMN adresse.adr_email IS 'Adresse email de contact de l''établissement';
COMMENT ON COLUMN adresse.adr_web IS 'Site web de l''établissement';

COMMENT ON TABLE etablissement IS 'Etablissement (internes) et partenaires (externes).
cat_id est NULL pour les partenaires, non NULL pour les établissements.';
COMMENT ON COLUMN etablissement.eta_id IS 'Identifiant de l''établissement/partenaire';
COMMENT ON COLUMN etablissement.cat_id IS 'Identifiant de la catégorie de l''établissement, NULL pour un partenaire';
COMMENT ON COLUMN etablissement.eta_nom IS 'Nom de l''établissement/partenaire';
COMMENT ON COLUMN etablissement.adr_id IS 'Identifiant de l''adresse';

COMMENT ON TABLE etablissement_secteur IS 'Liste des secteurs couverts par les établissements/partenaires.';
COMMENT ON COLUMN etablissement_secteur.ets_id IS 'Identifiant de la relation';
COMMENT ON COLUMN etablissement_secteur.eta_id IS 'Identifiant de l''établissement/partenaire';
COMMENT ON COLUMN etablissement_secteur.sec_id IS 'Identifiant du secteur';

COMMENT ON TABLE etablissement_secteur_edit IS 'Liste des secteurs pour lesquels les utilisateurs ont le droit de rajouter des groupes à un établissement/partenaire.';
COMMENT ON COLUMN etablissement_secteur_edit.ese_id IS 'Identifiant de la relation';
COMMENT ON COLUMN etablissement_secteur_edit.eta_id IS 'Identifiant de l''établissement';
COMMENT ON COLUMN etablissement_secteur_edit.sec_id IS 'Identifiant du secteur';

COMMENT ON TABLE groupe IS 'Groupe d''usagers';
COMMENT ON COLUMN groupe.grp_id IS 'Identifiant du groupe';
COMMENT ON COLUMN groupe.grp_nom IS 'Nom du groupe';
COMMENT ON COLUMN groupe.grp_complet IS 'Indique s''il est possible d''affecter des usagers à ce groupe (non utilisé)';
COMMENT ON COLUMN groupe.eta_id IS 'Identifiant de l''établissement/partenaire auquel appartient ce groupe';
COMMENT ON COLUMN groupe.grp_debut IS 'Date de début d''activité du groupe';
COMMENT ON COLUMN groupe.grp_fin IS 'Date de fin d''activité du groupe';
COMMENT ON COLUMN groupe.grp_notes IS 'Notes sur le groupe';

COMMENT ON TABLE groupe_info_secteur IS 'Indique sur quel champ de fiche usager est faite l''affectation de l''usager à un groupe pour un secteur donné.';
COMMENT ON COLUMN groupe_info_secteur.gis_id IS 'Identifiant de la relation';
COMMENT ON COLUMN groupe_info_secteur.grp_id IS 'Identifiant du groupe';
COMMENT ON COLUMN groupe_info_secteur.sec_id IS 'Identifiant du secteur';
COMMENT ON COLUMN groupe_info_secteur.inf_id IS 'Identifiant du champ';

COMMENT ON TABLE groupe_secteur IS 'Liste des secteurs couverts par un groupe d''usagers.';
COMMENT ON COLUMN groupe_secteur.grs_id IS 'Identifiant de la relation';
COMMENT ON COLUMN groupe_secteur.grp_id IS 'Identifiant du groupe';
COMMENT ON COLUMN groupe_secteur.sec_id IS 'Identifiant du secteur';

COMMENT ON TABLE personne IS 'Information de base sur les usagers/personnels/contacts/membres de famille.';
COMMENT ON COLUMN personne.per_id IS 'Identifiant de la personne';
COMMENT ON COLUMN personne.ent_code IS 'Code du type de personne';

COMMENT ON TABLE personne_etablissement IS 'Appartenance d''un usager à un établissement.
Cette table est mise à jour par la fonction personne_etablissement_update()';
COMMENT ON COLUMN personne_etablissement.per_id IS 'Identifiant de l''usager';
COMMENT ON COLUMN personne_etablissement.eta_id IS 'Identifiant de l''établissement';

COMMENT ON TABLE personne_groupe IS 'Affectation d''un usager à un groupe d''usagers.';
COMMENT ON COLUMN personne_groupe.peg_id IS 'Identifiant de la relation';
COMMENT ON COLUMN personne_groupe.per_id IS 'Identifiant de l''usager';
COMMENT ON COLUMN personne_groupe.grp_id IS 'Identifiant du groupe';
COMMENT ON COLUMN personne_groupe.peg_debut IS 'Date de début d''affectation de l''usager au groupe';
COMMENT ON COLUMN personne_groupe.peg_fin IS 'Date de fin d''affectation';
COMMENT ON COLUMN personne_groupe.peg_cycle_statut IS 'Statut du cyle :
 1: Demandé
 2: Accepté
 3: Terminé
-1: Refusé';
COMMENT ON COLUMN personne_groupe.peg_cycle_date_demande IS 'Date de demande d''affectation';
COMMENT ON COLUMN personne_groupe.peg_cycle_date_demande_renouvellement IS 'Date de demande de renouvellement de l''affectation';
COMMENT ON COLUMN personne_groupe.peg__hebergement_chambre IS '';
COMMENT ON COLUMN personne_groupe.peg_notes IS 'Notes sur l''affectation';
COMMENT ON COLUMN personne_groupe._inf_id IS '(non utilisé)';
COMMENT ON COLUMN personne_groupe.peg__decideur_financeur IS '';

COMMENT ON TABLE personne_info IS 'Valeur d''un champ pour une personne.';
COMMENT ON COLUMN personne_info.pin_id IS 'Identifiant de la relation';
COMMENT ON COLUMN personne_info.per_id IS 'Identifiant de la personne';
COMMENT ON COLUMN personne_info.inf_code IS 'Code du champ';

COMMENT ON TABLE personne_info_boolean IS 'Valeur d''un champ de type "case à cocher" pour une personne.';
COMMENT ON COLUMN personne_info_boolean.pib_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_boolean.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_boolean.pib_valeur IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_boolean.pib_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_boolean.pib_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_boolean.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

COMMENT ON TABLE personne_info_date IS 'Valeur d''un champ de type "Champ date" pour une personne.';
COMMENT ON COLUMN personne_info_date.pid_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_date.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_date.pid_valeur IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_date.pid_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_date.pid_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_date.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

COMMENT ON TABLE personne_info_integer IS 'Valeur d''un champ de type "Boîtier de sélection", "Lien", "Métier", "Affectation à organisme" ou "Statut usager" pour une personne.';
COMMENT ON COLUMN personne_info_integer.pii_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_integer.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_integer.pii_valeur IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_integer.pii_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_integer.pii_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_integer.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

COMMENT ON TABLE personne_info_integer2 IS 'Valeur d''un champ de type "Affectation de personnel" pour une personne.';
COMMENT ON COLUMN personne_info_integer2.pij_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_integer2.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_integer2.pij_valeur1 IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_integer2.pij_valeur2 IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_integer2.pij_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_integer2.pij_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_integer2.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

COMMENT ON TABLE personne_info_lien_familial IS 'Valeur d''un champ de type "Lien familial" pour une personne.';
COMMENT ON COLUMN personne_info_lien_familial.pif_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_lien_familial.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_lien_familial.per_id_parent IS 'Identifiant de la personne parente';
COMMENT ON COLUMN personne_info_lien_familial.lfa_id IS 'Type de lien familial';
COMMENT ON COLUMN personne_info_lien_familial.pif_droits IS 'Droits du parent sur l''usager :
rencontre : Rencontre médiatisée
visite : Visite
sortie : Sortie et visite
hebergement : Hébergement';
COMMENT ON COLUMN personne_info_lien_familial.pif_periodicite IS 'Périodicité du droit (texte libre)';
COMMENT ON COLUMN personne_info_lien_familial.pif_autorite_parentale IS 'Autorité du parent sur l''usager :
1 : Autorité parentale
2 : Tutelle
3 : Aucune autorité';

COMMENT ON TABLE personne_info_text IS 'Valeur d''un champ de type "Texte multi-ligne" pour une personne.';
COMMENT ON COLUMN personne_info_text.pit_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_text.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_text.pit_valeur IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_text.pit_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_text.pit_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_text.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

COMMENT ON TABLE personne_info_varchar IS 'Valeur d''un champ de type "Champ Texte" pour une personne.';
COMMENT ON COLUMN personne_info_varchar.piv_id IS 'Identifiant unique';
COMMENT ON COLUMN personne_info_varchar.pin_id IS 'Lien vers personne_info';
COMMENT ON COLUMN personne_info_varchar.piv_valeur IS 'Valeur du champ';
COMMENT ON COLUMN personne_info_varchar.piv_debut IS 'Date de début pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_varchar.piv_fin IS 'Date de fin pour cette valeur (si champ historisé)';
COMMENT ON COLUMN personne_info_varchar.uti_id IS 'Identifiant de l''utilisateur ayant saisi cette valeur';

DROP FUNCTION IF EXISTS contact_recherche(prm_per_id integer);
DROP FUNCTION IF EXISTS contact_recherche(prm_token integer, prm_per_id integer);
DROP TYPE contact_recherche;
CREATE TYPE contact_recherche AS (
	per_id integer,
	per_libelle character varying,
	inf_libelle character varying
);

CREATE OR REPLACE FUNCTION contact_recherche(prm_token integer, prm_per_id integer) RETURNS SETOF contact_recherche
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

COMMENT ON FUNCTION contact_recherche(prm_token integer, prm_per_id integer) IS
'Retourne la liste des usagers dont une personne (personnel ou contact) est le contact.

Entrées :
 - prm_token : Token d''authentification
 - prm_per_id : Identifiant de la personne (personnel ou contact)
Retour :
 - per_id : Identifiant de l''usager
 - per_libelle : Nom et prénom de l''usager
 - Nom du lien entre l''usager et la personne (personnel ou contact)';

DROP FUNCTION IF EXISTS etablissement_liste_details(prm_sec_id integer, prm_interne_seuls boolean);
DROP FUNCTION IF EXISTS etablissement_liste_details(prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean);
DROP FUNCTION IF EXISTS etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean);
DROP FUNCTION IF EXISTS etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean);
DROP TYPE etablissement_liste_details;
CREATE TYPE etablissement_liste_details AS (
	eta_id integer,
	eta_nom character varying,
	roles character varying,
	besoins character varying
);

CREATE OR REPLACE FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean) RETURNS SETOF etablissement_liste_details
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
COMMENT ON FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id integer, prm_interne_seuls boolean) IS
'Détail des établissements/partenaires couvrant un certain secteur.

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

CREATE OR REPLACE FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) RETURNS SETOF etablissement_liste_details
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
COMMENT ON FUNCTION etablissement_liste_details(prm_token integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) IS
'Détail des établissements/partenaires couvrant un certain rôle et/ou besoin.

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

DROP FUNCTION IF EXISTS famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer);
DROP FUNCTION IF EXISTS famille_recherche(prm_parent_id integer, prm_inf_id integer);
DROP FUNCTION IF EXISTS famille_recherche(prm_parent_id integer);
DROP TYPE famille_recherche;
CREATE TYPE famille_recherche AS (
	per_id integer,
	per_libelle character varying,
	lfa_id integer,
	pif_autorite_parentale boolean,
	pif_droits character varying,
	pif_periodicite character varying
);

--CREATE OR REPLACE FUNCTION famille_recherche(prm_parent_id integer) RETURNS SETOF famille_recherche
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row famille_recherche;
--BEGIN
--	FOR row IN
--		SELECT per_id, personne_get_libelle (per_id), lfa_id, pif_autorite_parentale, pif_droits, pif_periodicite
--			FROM personne_info_lien_familial 
--			INNER JOIN personne_info USING(pin_id)
--			INNER JOIN meta.info USING(inf_code)
--			INNER JOIN meta.infos_type USING(int_id)
--			WHERE int_code = 'famille' AND per_id_parent = prm_parent_id
--			ORDER BY personne_get_libelle (per_id) 
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

CREATE OR REPLACE FUNCTION famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer) RETURNS SETOF famille_recherche
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
COMMENT ON FUNCTION famille_recherche(prm_token integer, prm_parent_id integer, prm_inf_id integer) IS
'Recherche les usagers ayant un lien familial avec une personne.

Entrées :
 - prm_token : Token d''authentification
 - prm_parent_id : Identifiant du parent
 - prm_inf_id : Identifiant du champ de type famille sur lequel rechercher le lien familial';

DROP FUNCTION IF EXISTS personne_groupe_info(prm_peg_id integer);
DROP FUNCTION IF EXISTS personne_groupe_info(prm_token integer, prm_peg_id integer);
DROP FUNCTION IF EXISTS personne_groupe_liste(prm_per_id integer, prm_secteur character varying);
DROP FUNCTION IF EXISTS personne_groupe_liste2(prm_per_id integer, prm_inf_id integer);
DROP FUNCTION IF EXISTS personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer);
DROP TYPE groupe_liste;
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

CREATE OR REPLACE FUNCTION personne_groupe_info(prm_token integer, prm_peg_id integer) RETURNS groupe_liste
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
COMMENT ON FUNCTION personne_groupe_info(prm_token integer, prm_peg_id integer) IS
'Retourne les informations sur l''affectation d''un usager à un groupe.';

-- CREATE OR REPLACE FUNCTION personne_groupe_liste(prm_per_id integer, prm_secteur character varying) RETURNS SETOF groupe_liste
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row groupe_liste%ROWTYPE;
-- BEGIN
-- 	FOR row IN
-- 		select 
-- 			personne_groupe.peg_id, 
-- 			groupe.grp_id, 
-- 			groupe.eta_id,
-- 			etablissement.eta_nom,
-- 			groupe.grp_nom, 
-- 			personne_groupe.peg_debut, 
-- 			personne_groupe.peg_fin,
-- 			personne_groupe.peg_notes,
-- 			personne_groupe.peg_cycle_statut,
-- 			personne_groupe.peg_cycle_date_demande,
-- 			personne_groupe.peg_cycle_date_demande_renouvellement,
-- 			personne_groupe.peg__hebergement_chambre,
-- 			personne_groupe.peg__decideur_financeur
 
-- 		FROM groupe 
-- 		LEFT JOIN etablissement USING(eta_id)
-- 		INNER JOIN groupe_secteur USING(grp_id)
-- 		INNER JOIN meta.secteur USING(sec_id)
-- 		INNER JOIN personne_groupe USING (grp_id)
-- 		where per_id = prm_per_id AND sec_code = prm_secteur
-- 		ORDER BY peg_debut DESC, peg_fin DESC
-- 	LOOP
-- 		return NEXT row;
-- 	END LOOP;
-- END;
-- $$;

CREATE OR REPLACE FUNCTION personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer) RETURNS SETOF groupe_liste
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
COMMENT ON FUNCTION personne_groupe_liste2(prm_token integer, prm_per_id integer, prm_inf_id integer) IS
'Retourne la liste des affectations d''une personne à des groupes, associées à un champ groupe donné.';

DROP FUNCTION IF EXISTS groupe_liste_details(prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean);
DROP FUNCTION IF EXISTS groupe_liste_details(prm_token integer, prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean);DROP TYPE groupe_liste_details;
CREATE TYPE groupe_liste_details AS (
	grp_id integer,
	eta_nom character varying,
	grp_nom character varying,
	roles character varying,
	besoins character varying,
	grp_debut date,
	grp_fin date
);

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
COMMENT ON FUNCTION groupe_liste_details(prm_token integer, prm_eta_id integer, prm_sec_id_role integer, prm_sec_id_besoin integer, prm_interne_seuls boolean) IS
'Retourne le détail des groupes d''un établissement/partenaire donné couvrant un rôle/besoin donné.

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

DROP FUNCTION IF EXISTS personne_info_integer2_get(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer2_get_multiple(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer2_get_par_id(prm_pij_id integer);
DROP FUNCTION IF EXISTS personne_info_integer2_get(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer2_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer2_get_par_id(prm_token integer, prm_pij_id integer);
DROP TYPE integer2;
CREATE TYPE integer2 AS (
	valeur1 integer,
	valeur2 integer,
	pij_id integer
);

CREATE OR REPLACE FUNCTION personne_info_integer2_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS integer2
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

CREATE OR REPLACE FUNCTION personne_info_integer2_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF integer2
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

CREATE OR REPLACE FUNCTION personne_info_integer2_get_par_id(prm_token integer, prm_pij_id integer) RETURNS integer2
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

DROP FUNCTION IF EXISTS personne_cherche(prm_nom character varying, prm_prenom character varying);
DROP FUNCTION IF EXISTS personne_cherche(prm_nom character varying, prm_prenom character varying, prm_type character varying); 
DROP FUNCTION IF EXISTS personne_cherche2(prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_secteur character varying);
DROP FUNCTION IF EXISTS personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying);
DROP FUNCTION IF EXISTS personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying); 
DROP FUNCTION IF EXISTS personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_grp_id integer);
DROP FUNCTION IF EXISTS personne_cherche2(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_secteur character varying);
DROP TYPE personne_cherche;
CREATE TYPE personne_cherche AS (
	per_id integer,
	nom_prenom character varying
);

-- TODO
CREATE OR REPLACE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying) RETURNS SETOF personne_cherche
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

-- TODO
CREATE OR REPLACE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying) RETURNS SETOF personne_cherche
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

CREATE OR REPLACE FUNCTION personne_cherche(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_grp_id integer) RETURNS SETOF personne_cherche
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


CREATE OR REPLACE FUNCTION personne_cherche2(prm_token integer, prm_nom character varying, prm_prenom character varying, prm_type character varying, prm_secteur character varying) RETURNS SETOF personne_cherche
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

DROP FUNCTION IF EXISTS personne_cherche_exact (prm_nom varchar, prm_prenom varchar, prm_type varchar);
CREATE OR REPLACE FUNCTION personne_cherche_exact (prm_token integer, prm_nom varchar, prm_prenom varchar, prm_type varchar)
  RETURNS SETOF integer
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

DROP FUNCTION IF EXISTS personne_cherche_exact_tout (prm_nom_prenom varchar, prm_type varchar);
CREATE OR REPLACE FUNCTION personne_cherche_exact_tout (prm_token integer, prm_nom_prenom varchar, prm_type varchar)
  RETURNS SETOF integer
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


DROP FUNCTION IF EXISTS personne_contact_liste(prm_secteur character varying, prm_eta_id integer);
DROP FUNCTION IF EXISTS personne_contact_liste(prm_filtre character varying, prm_secteur character varying, prm_eta_id integer);
DROP FUNCTION IF EXISTS personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer);
DROP FUNCTION IF EXISTS personne_contact_liste_test(prm_filtre character varying, prm_secteur character varying, prm_eta_id integer);
DROP TYPE personne_contact_liste;
CREATE TYPE personne_contact_liste AS (
	per_id integer,
	libelle character varying
);

-- CREATE OR REPLACE FUNCTION personne_contact_liste(prm_secteur character varying, prm_eta_id integer) RETURNS SETOF personne_contact_liste
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row1 RECORD;
-- 	int_per_id integer;
-- 	row personne_contact_liste%ROWTYPE;
-- BEGIN
-- 	RAISE NOTICE '% %', prm_secteur, prm_eta_id;
-- 	FOR row1 IN
-- 		SELECT per_id FROM personne 
-- 		WHERE personne_info_integer_get(per_id, 'contact_metier') IN (SELECT met_id FROM meta.metier_secteur INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur)
-- 		AND (((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_etablissement') = FALSE AND personne_info_integer_get(per_id, ent_code || '_etablissement') = prm_eta_id) OR
-- 			((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_etablissement') = TRUE AND prm_eta_id IN (SELECT * FROM personne_info_integer_get_multiple(per_id, ent_code || '_etablissement'))))
-- 	LOOP
-- 		row.per_id = row1.per_id;
-- 		SELECT personne_info_varchar_get (row1.per_id, 'nom') || ' ' || personne_info_varchar_get (row1.per_id, 'prenom') INTO row.libelle;
-- 		RETURN NEXT row;
-- 	END LOOP;
-- 	FOR row1 IN
-- 		SELECT per_id FROM personne 
-- 		WHERE personne_info_integer_get(per_id, 'personnel_metier') IN (SELECT met_id FROM meta.metier_secteur INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur)
-- 		AND prm_eta_id IN (SELECT valeur1 FROM personne_info_integer2_get_multiple(per_id, 'personnel_affectation'))
-- 	LOOP
-- 		row.per_id = row1.per_id;
-- 		SELECT personne_info_varchar_get (row1.per_id, 'nom') || ' ' || personne_info_varchar_get (row1.per_id, 'prenom') INTO row.libelle;
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

CREATE OR REPLACE FUNCTION personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer) RETURNS SETOF personne_contact_liste
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
COMMENT ON FUNCTION personne_contact_liste(prm_token integer, prm_filtre character varying, prm_secteur character varying, prm_eta_id integer) IS
'Retourne la liste des contacts ayant un métier dans un secteur donné affectés à un établissement donné.';

-- CREATE OR REPLACE FUNCTION personne_contact_liste_test(prm_filtre character varying, prm_secteur character varying, prm_eta_id integer) RETURNS SETOF personne_contact_liste
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row1 RECORD;
-- 	int_per_id integer;
-- 	row personne_contact_liste%ROWTYPE;
-- BEGIN
-- 	FOR row1 IN
-- 		SELECT per_id FROM personne 
-- 		WHERE (prm_filtre ISNULL OR ent_code = prm_filtre)
-- 		AND personne_info_integer_get(per_id, ent_code || '_metier') IN (SELECT met_id FROM meta.metier_secteur INNER JOIN meta.secteur USING(sec_id) WHERE sec_code = prm_secteur)
-- 		AND (prm_eta_id ISNULL OR (((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_affectation') = FALSE AND (SELECT valeur1 FROM personne_info_integer2_get(per_id, ent_code || '_affectation')) = prm_eta_id) OR
-- 			((SELECT inf_multiple FROM meta.info WHERE inf_code = ent_code || '_affectation') = TRUE AND prm_eta_id IN (SELECT valeur1 FROM personne_info_integer2_get_multiple(per_id, ent_code || '_affectation')))))
-- 	LOOP
-- 		row.per_id = row1.per_id;
-- 		SELECT personne_info_varchar_get (row1.per_id, 'nom') || ' ' || personne_info_varchar_get (row1.per_id, 'prenom') INTO row.libelle;
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS personne_info_boolean_get_histo(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_boolean_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_boolean_histo;
CREATE TYPE personne_info_boolean_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur varchar
);

CREATE OR REPLACE FUNCTION personne_info_boolean_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_boolean_histo
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

DROP FUNCTION IF EXISTS personne_info_contact_get_histo(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_contact_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_contact_histo;
CREATE TYPE personne_info_contact_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur varchar
);

CREATE OR REPLACE FUNCTION personne_info_contact_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_contact_histo
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

DROP FUNCTION IF EXISTS personne_info_date_get_histo(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_date_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_date_histo;
CREATE TYPE personne_info_date_histo AS (
	debut date,
	fin date,
	valeur date,
	utilisateur varchar
);

CREATE OR REPLACE FUNCTION personne_info_date_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_date_histo
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

DROP FUNCTION IF EXISTS personne_info_integer_get_multiple_details(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer_get_multiple_details(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_integer_get_multiple_details;
CREATE TYPE personne_info_integer_get_multiple_details AS (
	pii_id integer,
	pii_valeur integer
);

CREATE OR REPLACE FUNCTION personne_info_integer_get_multiple_details(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_integer_get_multiple_details
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

DROP FUNCTION IF EXISTS personne_info_integer_get_histo(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_integer_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_integer_histo;
CREATE TYPE personne_info_integer_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur varchar
);

CREATE OR REPLACE FUNCTION personne_info_integer_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_integer_histo
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

DROP FUNCTION IF EXISTS personne_info_varchar_get_histo(prm_per_id integer, prm_inf_code character varying);
DROP FUNCTION IF EXISTS personne_info_varchar_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying);
DROP TYPE personne_info_varchar_histo;
CREATE TYPE personne_info_varchar_histo AS (
	debut date,
	fin date,
	valeur character varying,
	utilisateur varchar
);

CREATE OR REPLACE FUNCTION personne_info_varchar_get_histo(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_varchar_histo
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

DROP FUNCTION pgprocedures_search_arguments(prm_function character varying);
DROP TYPE pgprocedures_search_arguments;
CREATE TYPE pgprocedures_search_arguments AS (
	argnames character varying[],
	argtypes oidvector
);

CREATE OR REPLACE FUNCTION pgprocedures_search_arguments(prm_function character varying) RETURNS SETOF pgprocedures_search_arguments
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

DROP FUNCTION pgprocedures_search_function(prm_method character varying, prm_nargs integer);
DROP TYPE pgprocedures_search_function;
CREATE TYPE pgprocedures_search_function AS (
	proc_nspname name,
	proargtypes oidvector,
	prorettype oid,
	ret_typtype character(1),
	ret_typname name,
	ret_nspname name,
	proretset boolean
);

CREATE OR REPLACE FUNCTION pgprocedures_search_function(prm_method character varying, prm_nargs integer) RETURNS pgprocedures_search_function
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

DROP FUNCTION IF EXISTS prise_en_charge_select(prm_uti_id integer, prm_eta_id integer);
DROP FUNCTION IF EXISTS prise_en_charge_select(prm_token integer, prm_eta_id integer);
DROP TYPE prise_en_charge_select;
CREATE TYPE prise_en_charge_select AS (
	id integer,
	nom character varying
);

CREATE OR REPLACE FUNCTION prise_en_charge_select(prm_token integer, prm_eta_id integer) RETURNS SETOF prise_en_charge_select
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
COMMENT ON FUNCTION prise_en_charge_select(prm_token integer, prm_eta_id integer) IS
'Retourne la liste des groupes de prise en charge auxquels un utilisateur a accès depuis le portail d''un établissement.';

DROP FUNCTION IF EXISTS adresse_get(prm_adr_id integer);
CREATE OR REPLACE FUNCTION adresse_get(prm_token integer, prm_adr_id integer) RETURNS adresse
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
COMMENT ON FUNCTION adresse_get(prm_token integer, prm_adr_id integer) IS
'Retourne les détails de l''adresse d''un établissement/partenaire.

Entrées :
 - prm_token : Token d''authentification
 - prm_adr_id : Identifiant de l''adresse';

CREATE OR REPLACE FUNCTION concat2(text, text) RETURNS text
    LANGUAGE sql
    AS $_$
    SELECT CASE WHEN $1 IS NULL OR $1 = '' THEN $2
                WHEN $2 IS NULL OR $2 = '' THEN $1
                ELSE $1 || ', ' || $2
                END; 
 $_$;

DROP FUNCTION IF EXISTS etablissement_add(prm_nom character varying);
--CREATE OR REPLACE FUNCTION etablissement_add(prm_nom character varying) RETURNS integer
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret integer;
--BEGIN
--	INSERT INTO etablissement (eta_nom) VALUES (prm_nom) RETURNING eta_id INTO ret;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_add(prm_nom character varying, prm_cat_id integer);
--CREATE OR REPLACE FUNCTION etablissement_add(prm_nom character varying, prm_cat_id integer) RETURNS integer
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret integer;
--BEGIN
--	INSERT INTO etablissement (eta_nom, cat_id) VALUES (prm_nom, prm_cat_id) RETURNING eta_id INTO ret;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_add(prm_nom character varying, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying);
--CREATE OR REPLACE FUNCTION etablissement_add(prm_nom character varying, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS integer
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	ret integer;
--	adr integer;
--BEGIN
--	INSERT INTO adresse (adr_adresse, adr_cp, adr_ville, adr_tel, adr_fax, adr_email, adr_web)
--		VALUES (prm_adr_adresse, prm_adr_cp, prm_adr_ville, prm_adr_tel, prm_adr_fax, prm_adr_email, prm_adr_web) RETURNING adr_id INTO adr;
--
--	INSERT INTO etablissement (eta_nom, adr_id) VALUES (prm_nom, adr) RETURNING eta_id INTO ret;
--	RETURN ret;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_add(prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying);
CREATE OR REPLACE FUNCTION etablissement_add(prm_token integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS integer
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
COMMENT ON FUNCTION etablissement_add(prm_token integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) IS 
'Ajoute un établissement ou partenaire.

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

DROP FUNCTION IF EXISTS etablissement_dans_secteur_editable_liste(prm_interne boolean, prm_sec_id integer);
CREATE OR REPLACE FUNCTION etablissement_dans_secteur_editable_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) RETURNS SETOF etablissement
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
COMMENT ON FUNCTION etablissement_dans_secteur_editable_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) IS 
'Retourne la liste des établissements/partenaires d''un secteur donné auxquels les utilisateurs peuvent rajouter des groupes.

Entrées : 
 - prm_token : Token d''authentification
 - prm_interne : TRUE : établissements uniquement, FALSE : partenaires uniquement, NULL : établissements et partenaires
 - prm_sec_id : Identifiant du secteur (non NULL)
Remarques :
 - Tous les partenaires sont éditables, alors qu''il est possible d''indiquer si un établissement est éditable pour un secteur donné avec la table etablissement_secteur_edit.
';

DROP FUNCTION IF EXISTS etablissement_dans_secteur_liste(prm_interne boolean, prm_sec_id integer);
CREATE OR REPLACE FUNCTION etablissement_dans_secteur_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) RETURNS SETOF etablissement
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
COMMENT ON FUNCTION etablissement_dans_secteur_liste(prm_token integer, prm_interne boolean, prm_sec_id integer) IS
'Retourne la liste des établissements/partenaires d''un secteur donné.
 - prm_token : Token d''authentification
 - prm_interne : TRUE : établissements uniquement, FALSE : partenaires uniquement, NULL : établissements et partenaires
 - prm_sec_id : Identifiant du secteur (non NULL)
';

DROP FUNCTION IF EXISTS etablissement_get(prm_eta_id integer);
CREATE OR REPLACE FUNCTION etablissement_get(prm_token integer, prm_eta_id integer) RETURNS etablissement
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
COMMENT ON FUNCTION etablissement_get(prm_token integer, prm_eta_id integer) IS
'Retourne les informations sur un établissement.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement';

DROP FUNCTION IF EXISTS etablissement_cherche(prm_nom varchar);
CREATE OR REPLACE FUNCTION etablissement_cherche(prm_token integer, prm_nom varchar) RETURNS etablissement
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
COMMENT ON FUNCTION etablissement_cherche(prm_token integer, prm_nom varchar) IS
'Recherche un établissement par son nom.

Entrée : 
 - prm_token : Token d''authentification
 - prm_nom : Nom exact de l''établissement à rechercher';

DROP FUNCTION IF EXISTS etablissement_liste(prm_interne boolean);
--CREATE OR REPLACE FUNCTION etablissement_liste(prm_interne boolean) RETURNS SETOF etablissement
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row etablissement;
--BEGIN
--	FOR row IN
--		SELECT * FROM etablissement WHERE 
--			prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL) 
--			ORDER BY eta_nom 
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_liste(prm_interne boolean, prm_secteur character varying);
CREATE OR REPLACE FUNCTION etablissement_liste(prm_token integer, prm_interne boolean, prm_secteur character varying) RETURNS SETOF etablissement
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
COMMENT ON FUNCTION etablissement_liste(prm_token integer, prm_interne boolean, prm_secteur character varying) IS 
'Retourne la liste des établissements et/ou partenaires.

Entrées : 
 - prm_token : Token d''authentification
 - prm_interne : TRUE pour les établissements, FALSE pour les partenaires, NULL pour tous
 - prm_secteur : Code d''un secteur ou NULL. Retourne uniquement les établissements couvrant ce secteur';

DROP FUNCTION IF EXISTS etablissement_liste_par_secteur(prm_secteur character varying);
CREATE OR REPLACE FUNCTION etablissement_liste_par_secteur(prm_token integer, prm_secteur character varying) RETURNS SETOF etablissement
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
COMMENT ON FUNCTION etablissement_liste_par_secteur(prm_token integer, prm_secteur character varying) IS
'Retourne la liste des établissements/partenaires en filtrant sur les secteurs couverts par les groupes des établissements/partenaires.

Entrées :
 - prm_token : Token d''authentification
 - prm_secteur : Code secteur ou NULL. Retourne uniquement les établissements dont au moins un groupe couvre le secteur donné';

DROP FUNCTION IF EXISTS etablissement_liste_par_secteur_direct(prm_secteur character varying);
--CREATE OR REPLACE FUNCTION etablissement_liste_par_secteur_direct(prm_secteur character varying) RETURNS SETOF etablissement
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row etablissement;
--BEGIN
--	FOR row IN
--		SELECT DISTINCT etablissement.* FROM etablissement
--		INNER JOIN etablissement_secteur USING(eta_id)
--		LEFT JOIN meta.secteur USING(sec_id)
--		WHERE prm_secteur ISNULL OR sec_code = prm_secteur
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_secteur_edit_get(prm_eta_id integer, prm_secteur character varying);
CREATE OR REPLACE FUNCTION etablissement_secteur_edit_get(prm_token integer, prm_eta_id integer, prm_secteur character varying) RETURNS boolean
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
COMMENT ON FUNCTION etablissement_secteur_edit_get(prm_token integer, prm_eta_id integer, prm_secteur character varying) IS
'Retourne TRUE si l''établissement est éditable (les utilisateurs peuvent y rajouter des groupes) pour le secteur donné, FALSE sinon.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
 - prm_secteur : Code du secteur';

DROP FUNCTION IF EXISTS etablissement_secteur_edit_liste(prm_eta_id integer);
CREATE OR REPLACE FUNCTION etablissement_secteur_edit_liste(prm_token integer, prm_eta_id integer) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION etablissement_secteur_edit_liste(prm_token integer, prm_eta_id integer) IS
'Retourne la liste des secteurs pour lesquels un établissement est éditable (pour lesquels les utilisateurs peuvent rajouter des groupes).

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
Remarques : 
 - Nécessite les droits à la configuration "Établissement"';

DROP FUNCTION IF EXISTS etablissement_secteur_liste(prm_eta_id integer);
--CREATE OR REPLACE FUNCTION etablissement_secteur_liste(prm_eta_id integer) RETURNS SETOF meta.secteur
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row meta.secteur;
--BEGIN
--	FOR row IN
--		SELECT secteur.* FROM meta.secteur
--		INNER JOIN etablissement_secteur USING(sec_id)
--		WHERE eta_id = prm_eta_id
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_secteur_liste(prm_eta_id integer, prm_est_prise_en_charge boolean);
CREATE OR REPLACE FUNCTION etablissement_secteur_liste(prm_token integer, prm_eta_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION etablissement_secteur_liste(prm_token integer, prm_eta_id integer, prm_est_prise_en_charge boolean) IS
'Retourne la liste des secteurs que couvre un établissement/partenaire.

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement/partenaire
 - prm_est_prise_en_charge (booléen) : TRUE pour retourner uniquement les rôles, FALSE pour les besoins, NULL pour tous';

DROP FUNCTION IF EXISTS etablissement_secteurs_edit_set(prm_eta_id integer, prm_secteurs character varying[]);
CREATE OR REPLACE FUNCTION etablissement_secteurs_edit_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) RETURNS void
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
COMMENT ON FUNCTION etablissement_secteurs_edit_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) IS 
'Indique pour un établissement donné pour quels secteurs il est éditable (il est possible pour les utilisateurs de rajouter des groupes).

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement
 - prm_secteurs : Tableau de codes de secteurs
Remarques : 
 - Nécessite les droits à la configuration "Établissement"';

DROP FUNCTION IF EXISTS etablissement_secteurs_set(prm_eta_id integer, prm_secteurs character varying[]);
CREATE OR REPLACE FUNCTION etablissement_secteurs_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) RETURNS void
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
COMMENT ON FUNCTION etablissement_secteurs_set(prm_token integer, prm_eta_id integer, prm_secteurs character varying[]) IS
'Indique les secteurs couverts par un établissement/partenaire.

Entrées : 
 - prm_token : Token d''authentificaiton
 - prm_eta_id : Identifiant de l''établissement/partenaire
 - prm_secteurs : Tableau de codes de secteurs
Remarques :
 - Ne nécessite pas de droit de configuration particulier';

DROP FUNCTION IF EXISTS etablissement_supprime(prm_eta_id integer);
CREATE OR REPLACE FUNCTION etablissement_supprime(prm_token integer, prm_eta_id integer) RETURNS void
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
COMMENT ON FUNCTION etablissement_supprime(prm_token integer, prm_eta_id integer) IS
'Supprime un établissement/partenaire

Entrées :
 - prm_token : Token d''authentification
 - prm_eta_id : Identifiant de l''établissement/partenaire
Remarques :
 - Nécessite les droits à la configuration "Établissement" ou "Réseau"';

DROP FUNCTION IF EXISTS etablissement_update(prm_eta_id integer, prm_nom character varying);
--CREATE OR REPLACE FUNCTION etablissement_update(prm_eta_id integer, prm_nom character varying) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--BEGIN
--	UPDATE etablissement SET eta_nom = prm_nom WHERE eta_id = prm_eta_id;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_update(prm_eta_id integer, prm_nom character varying, prm_cat_id integer);
--CREATE OR REPLACE FUNCTION etablissement_update(prm_eta_id integer, prm_nom character varying, prm_cat_id integer) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--BEGIN
--	UPDATE etablissement SET eta_nom = prm_nom, cat_id = prm_cat_id WHERE eta_id = prm_eta_id;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_update(prm_eta_id integer, prm_nom character varying, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying);
--CREATE OR REPLACE FUNCTION etablissement_update(prm_eta_id integer, prm_nom character varying, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS void
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	adr integer;
--BEGIN
--	UPDATE etablissement SET eta_nom = prm_nom WHERE eta_id = prm_eta_id;
--	SELECT adr_id INTO adr FROM etablissement WHERE eta_id = prm_eta_id;
--	IF adr ISNULL THEN
--		INSERT INTO adresse (adr_adresse, adr_cp, adr_ville, adr_tel, adr_fax, adr_email, adr_web)
--			VALUES (prm_adr_adresse, prm_adr_cp, prm_adr_ville, prm_adr_tel, prm_adr_fax, prm_adr_email, prm_adr_web) RETURNING adr_id INTO adr;
--		UPDATE etablissement SET adr_id = adr WHERE eta_id = prm_eta_id;
--	ELSE
--		UPDATE adresse SET 
--			adr_adresse = prm_adr_adresse,
--			adr_cp = prm_adr_cp,
--			adr_ville = prm_adr_ville,
--			adr_tel = prm_adr_tel,
--			adr_fax = prm_adr_fax,
--			adr_email = prm_adr_email,
--			adr_web = prm_adr_web
--			WHERE adr_id = adr;
--	END IF;
--END;
--$$;

DROP FUNCTION IF EXISTS etablissement_update(prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying);
CREATE OR REPLACE FUNCTION etablissement_update(prm_token integer, prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) RETURNS void
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
COMMENT ON FUNCTION etablissement_update(prm_token integer, prm_eta_id integer, prm_nom character varying, prm_cat_id integer, prm_adr_adresse character varying, prm_adr_cp character varying, prm_adr_ville character varying, prm_adr_tel character varying, prm_adr_fax character varying, prm_adr_email character varying, prm_adr_web character varying) IS
'Modifie les informations d''un établissement/partenaire.

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

DROP FUNCTION IF EXISTS groupe_add(prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying);
CREATE OR REPLACE FUNCTION groupe_add(prm_token integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) RETURNS integer
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
COMMENT ON FUNCTION groupe_add(prm_token integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) IS
'Ajoute un groupe d''usagers.

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

DROP FUNCTION IF EXISTS groupe_aide_a_la_personne_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_aide_a_la_personne_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_aide_a_la_personne_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur aide à la personne.';

DROP FUNCTION IF EXISTS groupe_aide_financiere_directe_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_aide_financiere_directe_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_aide_financiere_directe_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur aide financière directe.';

DROP FUNCTION IF EXISTS groupe_culture_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_culture_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_culture_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur culture.';

DROP FUNCTION IF EXISTS groupe_decideur_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_decideur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_decideur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 
'Modifie les informations d''un groupe spécifiques au secteur décideur.';

DROP FUNCTION IF EXISTS groupe_divertissement_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_divertissement_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_divertissement_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur divertissement.';

DROP FUNCTION IF EXISTS groupe_education_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_education_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_education_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur éducation.';

DROP FUNCTION IF EXISTS groupe_emploi_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_emploi_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_emploi_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur emploi.';

DROP FUNCTION IF EXISTS groupe_entretien_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_entretien_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_entretien_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur entretien.';

DROP FUNCTION IF EXISTS groupe_equipement_personnel_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_equipement_personnel_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_equipement_personnel_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS 
'Modifie les informations d''un groupe spécifiques au secteur équipement personnel.';

DROP FUNCTION IF EXISTS groupe_etablissement_liste(prm_eta_id integer);
--CREATE OR REPLACE FUNCTION groupe_etablissement_liste(prm_eta_id integer) RETURNS SETOF groupe
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row groupe;
--BEGIN
--	FOR row IN
--		SELECT * FROM groupe 
--		WHERE eta_id = prm_eta_id
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS groupe_famille_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_famille_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_famille_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur famille.';

DROP FUNCTION IF EXISTS groupe_financeur_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_financeur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_financeur_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur financeur.';

DROP FUNCTION IF EXISTS groupe_cherche (prm_eta_nom varchar, prm_grp_nom varchar);
DROP FUNCTION IF EXISTS groupe_cherche (prm_token integer, prm_eta_nom varchar, prm_grp_nom varchar);
DROP TYPE IF EXISTS groupe_cherche;
CREATE TYPE groupe_cherche AS (
       eta_id integer,
       grp_id integer
);

CREATE OR REPLACE FUNCTION groupe_cherche (prm_token integer, prm_eta_nom varchar, prm_grp_nom varchar)
    RETURNS SETOF groupe_cherche
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
COMMENT ON FUNCTION groupe_cherche (prm_token integer, prm_eta_nom varchar, prm_grp_nom varchar) IS
'Recherche le groupe d''usagers d''un établissement/partenaire à partir de leurs noms.

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

DROP FUNCTION IF EXISTS groupe_get(prm_grp_id integer);
CREATE OR REPLACE FUNCTION groupe_get(prm_token integer, prm_grp_id integer) RETURNS groupe
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
COMMENT ON FUNCTION groupe_get(prm_token integer, prm_grp_id integer) IS
'Retourne les informations sur un groupe d''usagers.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
';

DROP FUNCTION IF EXISTS groupe_hebergement_update(prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_hebergement_update(prm_token integer, prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_hebergement_update(prm_token integer, prm_grp_id integer, prm_adresse character varying, prm_cp character varying, prm_ville character varying, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur hébergement.';

DROP FUNCTION IF EXISTS groupe_info_secteur_get(prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer);
CREATE OR REPLACE FUNCTION groupe_info_secteur_get(prm_token integer, prm_grp_id integer, prm_sec_code character varying) RETURNS SETOF groupe_info_secteur
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
COMMENT ON FUNCTION groupe_info_secteur_get(prm_token integer, prm_grp_id integer, prm_sec_code character varying) IS
'Retourne les informations indiquant sur quel champ de fiche usager est faite l''affectation d''un usager à un groupe pour un secteur donné.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe ou NULL
 - prm_sec_code : Code du secteur ou NULL
';

DROP FUNCTION IF EXISTS groupe_info_secteur_save(prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer);
CREATE OR REPLACE FUNCTION groupe_info_secteur_save(prm_token integer, prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer) RETURNS void
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
COMMENT ON FUNCTION groupe_info_secteur_save(prm_token integer, prm_grp_id integer, prm_sec_code character varying, prm_inf_id integer) IS
'Indique le champ de fiche usager sur lequel est faite l''affectation d''un usager à un groupe pour un secteur donné.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_sec_code : Code du secteur
 - prm_inf_id : Identifiant du champ de saisie de fiche usager';

CREATE OR REPLACE FUNCTION groupe_type_secteur_update (prm_token integer, prm_grp_id integer, prm_sec_code varchar, prm_type integer) RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
	sql varchar;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);	
	sql = 'UPDATE public.groupe SET grp_' || prm_sec_code || '_type = ' || prm_type || ' WHERE grp_id = ' || prm_grp_id;
	EXECUTE sql;
END;
$$;
COMMENT ON FUNCTION groupe_type_secteur_update (prm_token integer, prm_grp_id integer, prm_sec_code varchar, prm_type integer) IS
'Modifie le type d''un groupe pour un secteur particulier';

DROP FUNCTION IF EXISTS groupe_info_secteurs_set(prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]);
CREATE OR REPLACE FUNCTION groupe_info_secteurs_set(prm_token integer, prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]) RETURNS void
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
COMMENT ON FUNCTION groupe_info_secteurs_set(prm_token integer, prm_grp_id integer, prm_inf_id integer, prm_secteurs character varying[]) IS
'Indique le champ de fiche usager sur lequel est faite l''affectation d''un usager à un groupe pour une liste de secteurs.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_inf_id : Identifiant du champ de saisie de fiche usager
 - prm_secteurs : Tableau de codes du secteur';

DROP FUNCTION IF EXISTS groupe_justice_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_justice_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_justice_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur justice.';

DROP FUNCTION IF EXISTS groupe_liste(prm_secteur character varying);
--CREATE OR REPLACE FUNCTION groupe_liste(prm_secteur character varying) RETURNS SETOF groupe
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row groupe;
--BEGIN
--	FOR row IN
--		SELECT DISTINCT groupe.* FROM groupe
--		LEFT JOIN groupe_secteur USING(grp_id)
--		LEFT JOIN meta.secteur USING(sec_id)
--		WHERE prm_secteur ISNULL OR sec_code = prm_secteur
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS groupe_liste(prm_secteur character varying, prm_sec_id integer);
--CREATE OR REPLACE FUNCTION groupe_liste(prm_secteur character varying, prm_sec_id integer) RETURNS SETOF groupe
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row groupe;
--BEGIN
--	FOR row IN
--		SELECT DISTINCT groupe.* FROM groupe
--		LEFT JOIN groupe_secteur USING(grp_id)
--		LEFT JOIN meta.secteur USING(sec_id)
--		WHERE (prm_secteur ISNULL OR sec_code = prm_secteur)
--		AND (prm_sec_id ISNULL OR prm_sec_id = sec_id) 
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS groupe_liste(prm_secteur character varying, prm_sec_id integer, prm_interne boolean);
--CREATE OR REPLACE FUNCTION groupe_liste(prm_secteur character varying, prm_sec_id integer, prm_interne boolean) RETURNS SETOF groupe
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row groupe;
--BEGIN
--	FOR row IN
--		SELECT DISTINCT groupe.* FROM groupe
--		LEFT JOIN groupe_secteur USING(grp_id)
--		LEFT JOIN meta.secteur USING(sec_id)
--		LEFT JOIN etablissement USING(eta_id)
--		WHERE (prm_secteur ISNULL OR sec_code = prm_secteur)
--		AND (prm_sec_id ISNULL OR prm_sec_id = sec_id) 
--		AND (prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL)) 
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS groupe_liste(prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer);
-- CREATE OR REPLACE FUNCTION groupe_liste(prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer) RETURNS SETOF groupe
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row groupe;
-- BEGIN
-- 	FOR row IN
-- 		SELECT DISTINCT groupe.* FROM groupe
-- 		LEFT JOIN groupe_secteur USING(grp_id)
-- 		LEFT JOIN meta.secteur USING(sec_id)
-- 		LEFT JOIN etablissement USING(eta_id)
-- 		WHERE (prm_secteur ISNULL OR sec_code = prm_secteur)
-- 		AND (prm_sec_id ISNULL OR prm_sec_id = sec_id) 
-- 		AND (prm_interne ISNULL OR (prm_interne AND cat_id NOTNULL) OR (NOT prm_interne AND cat_id ISNULL)) 
-- 		AND (prm_eta_id ISNULL OR groupe.eta_id = prm_eta_id)
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS groupe_filtre(prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer, prm_soustype integer);
CREATE OR REPLACE FUNCTION groupe_filtre(prm_token integer, prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer) RETURNS SETOF groupe
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
COMMENT ON FUNCTION groupe_filtre(prm_token integer, prm_secteur character varying, prm_sec_id integer, prm_interne boolean, prm_eta_id integer) IS
'Recherche de groupes en appliquant différents filtres.

Entrées :
 - prm_token : token d''authentification
 - prm_secteur : Code d''un secteur, pour rechercher les groupes couvrant un secteur particulier
 - prm_sec_id : Identifiant d''un secteur, pour rechercher les groupes couvrant un secteur particulier
 - prm_interne : NULL = établissements/partenaires, TRUE = établissements seuls, FALSE = partenaires seuls
 - prm_eta_id : Identifiant d''un établissement/partenaire, pour rechercher parmi les groupes de cet établissement/partenaire';

DROP FUNCTION IF EXISTS groupe_pedagogie_update(prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer);
CREATE OR REPLACE FUNCTION groupe_pedagogie_update(prm_token integer, prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer) RETURNS void
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
COMMENT ON FUNCTION groupe_pedagogie_update(prm_token integer, prm_grp_id integer, prm_type integer, prm_niveau integer, prm_contact integer) IS
'Modifie les informations d''un groupe spécifiques au secteur pédagogie.';

DROP FUNCTION IF EXISTS groupe_prise_en_charge_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_prise_en_charge_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_prise_en_charge_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur prise en charge.';

DROP FUNCTION IF EXISTS groupe_projet_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_projet_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_projet_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur projet.';

DROP FUNCTION IF EXISTS groupe_protection_juridique_update(prm_grp_id integer, prm_contact integer);
-- CREATE OR REPLACE FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	PERFORM login._token_assert (prm_token, FALSE, FALSE);
-- 	UPDATE groupe SET 
-- 		grp_protection_juridique_contact = prm_contact
-- 		WHERE grp_id = prm_grp_id;
-- END;
-- $$;
-- COMMENT ON FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer) IS
-- 'Modifie les informations d''un groupe spécifiques au secteur protection juridique.';

DROP FUNCTION IF EXISTS groupe_protection_juridique_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_protection_juridique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur protection juridique.';

DROP FUNCTION IF EXISTS groupe_restauration_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_restauration_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_restauration_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur restauration.';

DROP FUNCTION IF EXISTS groupe_sante_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_sante_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_sante_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur santé.';

DROP FUNCTION IF EXISTS groupe_secteur_liste(prm_grp_id integer);
--CREATE OR REPLACE FUNCTION groupe_secteur_liste(prm_grp_id integer) RETURNS SETOF meta.secteur
--    LANGUAGE plpgsql
--    AS $$
--DECLARE
--	row meta.secteur;
--BEGIN
--	FOR row IN
--		SELECT secteur.* FROM meta.secteur
--		INNER JOIN groupe_secteur USING(sec_id)
--		WHERE grp_id = prm_grp_id
--	LOOP
--		RETURN NEXT row;
--	END LOOP;
--END;
--$$;

DROP FUNCTION IF EXISTS groupe_secteur_liste(prm_grp_id integer, prm_est_prise_en_charge boolean);
CREATE OR REPLACE FUNCTION groupe_secteur_liste(prm_token integer, prm_grp_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION groupe_secteur_liste(prm_token integer, prm_grp_id integer, prm_est_prise_en_charge boolean) IS 
'Retourne la liste des secteurs couverts par un groupe.

Entrées :
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_est_prise_en_charge : NULL pour lister tous les secteurs, TRUE pour les secteurs de prise en charge ou FALSE les autres secteurs
';

DROP FUNCTION IF EXISTS groupe_secteurs_set(prm_grp_id integer, prm_secteurs character varying[]);
CREATE OR REPLACE FUNCTION groupe_secteurs_set(prm_token integer, prm_grp_id integer, prm_secteurs character varying[]) RETURNS void
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
COMMENT ON FUNCTION groupe_secteurs_set(prm_token integer, prm_grp_id integer, prm_secteurs character varying[]) IS
'Indique les secteurs couverts par un groupe.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
 - prm_secteurs : Tableau d''identifiants de secteurs';

DROP FUNCTION IF EXISTS groupe_sejour_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur séjour.';

DROP FUNCTION IF EXISTS groupe_social_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_social_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_social_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur social.';

DROP FUNCTION IF EXISTS groupe_sport_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_sport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_sport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur sport.';

DROP FUNCTION IF EXISTS groupe_supprime(prm_grp_id integer);
CREATE OR REPLACE FUNCTION groupe_supprime(prm_token integer, prm_grp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM groupe_info_secteur WHERE grp_id = prm_grp_id;
	DELETE FROM groupe_secteur WHERE grp_id = prm_grp_id;
	DELETE FROM groupe WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_supprime(prm_token integer, prm_grp_id integer) IS 
'Supprime un groupe d''usagers.

Entrées : 
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe
';

DROP FUNCTION IF EXISTS groupe_transport_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_transport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
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
COMMENT ON FUNCTION groupe_transport_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur transport.';

DROP FUNCTION IF EXISTS groupe_soins_infirmiers_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_soins_infirmiers_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_soins_infirmiers_contact = prm_contact,
		grp_soins_infirmiers_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_soins_infirmiers_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur soins_infirmiers.';

DROP FUNCTION IF EXISTS groupe_dietetique_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_dietetique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_dietetique_contact = prm_contact,
		grp_dietetique_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_dietetique_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur dietetique.';

DROP FUNCTION IF EXISTS groupe_ergotherapie_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_ergotherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_ergotherapie_contact = prm_contact,
		grp_ergotherapie_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_ergotherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur ergotherapie.';

DROP FUNCTION IF EXISTS groupe_physiotherapie_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_physiotherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_physiotherapie_contact = prm_contact,
		grp_physiotherapie_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_physiotherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur physiotherapie.';

DROP FUNCTION IF EXISTS groupe_kinesitherapie_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_kinesitherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_kinesitherapie_contact = prm_contact,
		grp_kinesitherapie_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_kinesitherapie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur kinesitherapie.';

DROP FUNCTION IF EXISTS groupe_orthophonie_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_orthophonie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_orthophonie_contact = prm_contact,
		grp_orthophonie_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_orthophonie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur orthophonie.';

DROP FUNCTION IF EXISTS groupe_psychomotricite_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_psychomotricite_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_psychomotricite_contact = prm_contact,
		grp_psychomotricite_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_psychomotricite_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur psychomotricite.';

DROP FUNCTION IF EXISTS groupe_psychologie_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_psychologie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_psychologie_contact = prm_contact,
		grp_psychologie_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_psychologie_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur psychologie.';

DROP FUNCTION IF EXISTS groupe_droits_de_sejour_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_droits_de_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_droits_de_sejour_contact = prm_contact,
		grp_droits_de_sejour_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_droits_de_sejour_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur droits_de_sejour.';

DROP FUNCTION IF EXISTS groupe_aide_formalites_update(prm_grp_id integer, prm_contact integer, prm_type integer);
CREATE OR REPLACE FUNCTION groupe_aide_formalites_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET 
		grp_aide_formalites_contact = prm_contact,
		grp_aide_formalites_type = prm_type
		WHERE grp_id = prm_grp_id;
END;
$$;
COMMENT ON FUNCTION groupe_aide_formalites_update(prm_token integer, prm_grp_id integer, prm_contact integer, prm_type integer) IS
'Modifie les informations d''un groupe spécifiques au secteur aide_formalites.';

DROP FUNCTION IF EXISTS groupe_update(prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying);
CREATE OR REPLACE FUNCTION groupe_update(prm_token integer, prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	UPDATE groupe SET grp_nom = prm_nom, eta_id = prm_eta_id, grp_debut = prm_debut, grp_fin = prm_fin, grp_notes = prm_notes
		WHERE grp_id = prm_grp_id;
	RETURN FOUND;
END;
$$;
COMMENT ON FUNCTION groupe_update(prm_token integer, prm_grp_id integer, prm_nom character varying, prm_eta_id integer, prm_debut date, prm_fin date, prm_notes character varying) IS
'Modifie les informations d''un groupe d''usagers.

Entrées :
 - prm_token : Token d''authentification
 - prm_grp_id : Identifiant du groupe à mettre à jour
 - prm_nom : Nouveau nom du groupe
 - prm_eta_id : Identifiant de l''établissement/partenaire auquel appartient le groupe
 - prm_debut : Date de début d''existence du groupe
 - prm_fin : Date de fin d''existence du groupe
 -  prm_notes : Notes concernant le groupe
';

CREATE OR REPLACE FUNCTION periods_overlap(du1 date, au1 date, du2 date, au2 date) RETURNS boolean
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
COMMENT ON FUNCTION periods_overlap(du1 date, au1 date, du2 date, au2 date) IS
'Retourne TRUE si 2 périodes de temps se chevauchent, FALSE sinon.';

DROP FUNCTION IF EXISTS personne_ajoute(prm_ent_code character varying);
CREATE OR REPLACE FUNCTION personne_ajoute(prm_token integer, prm_ent_code character varying) RETURNS integer
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
COMMENT ON FUNCTION personne_ajoute(prm_token integer, prm_ent_code character varying) IS
'Ajoute une nouvelle personne.';

DROP FUNCTION IF EXISTS personne_etablissement_update();
DROP FUNCTION IF EXISTS personne_etablissement_update(prm_token integer);
-- CREATE OR REPLACE FUNCTION personne_etablissement_update(prm_token integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	eta RECORD;
-- 	per RECORD;
-- BEGIN
-- 	PERFORM login._token_assert (prm_token, FALSE, FALSE);
-- 	DELETE FROM personne_etablissement;
-- 	FOR eta IN SELECT eta_id FROM etablissement LOOP
-- 		FOR per IN SELECT per_id FROM personne WHERE ent_code = 'usager' LOOP
-- 			IF EXISTS (SELECT 1 FROM personne_groupe INNER JOIN groupe USING(grp_id) WHERE per_id = per.per_id AND eta_id = eta.eta_id) THEN
-- 				INSERT INTO personne_etablissement (per_id, eta_id) VALUES (per.per_id, eta.eta_id);
-- 			END IF;
-- 		END LOOP;
-- 	END LOOP;
-- END;
-- $$;
CREATE OR REPLACE FUNCTION personne_etablissement_update(prm_token integer, prm_per_id integer) RETURNS void
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

DROP FUNCTION IF EXISTS personne_get(prm_per_id integer);
CREATE OR REPLACE FUNCTION personne_get(prm_token integer, prm_per_id integer) RETURNS personne
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
COMMENT ON FUNCTION personne_get(prm_token integer, prm_per_id integer) IS
'Retourne les informations sur une personne.';

DROP FUNCTION IF EXISTS personne_get_libelle(prm_per_id integer);
CREATE OR REPLACE FUNCTION personne_get_libelle(prm_token integer , prm_per_id integer) RETURNS character varying
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
COMMENT ON FUNCTION personne_get_libelle(prm_token integer, prm_per_id integer) IS
'Retourne le prénom suivi du nom d''une personne.';

CREATE OR REPLACE FUNCTION personne_get_libelle_initiale(prm_token integer , prm_per_id integer) RETURNS character varying
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
COMMENT ON FUNCTION personne_get_libelle_initiale(prm_token integer, prm_per_id integer) IS
'Retourne l''initiale du prénom suivi du nom d''une personne.';

DROP FUNCTION IF EXISTS personne_groupe_ajoute(prm_per_id integer, prm_inf_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer);
CREATE OR REPLACE FUNCTION personne_groupe_ajoute(prm_token integer, prm_per_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) RETURNS integer
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
COMMENT ON FUNCTION personne_groupe_ajoute(prm_token integer, prm_per_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) IS
'Affecte un usager à un groupe.';

DROP FUNCTION IF EXISTS personne_groupe_supprime(prm_peg_id integer);
CREATE OR REPLACE FUNCTION personne_groupe_supprime(prm_token integer, prm_peg_id integer) RETURNS void
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
COMMENT ON FUNCTION personne_groupe_supprime(prm_token integer, prm_peg_id integer) IS
'Supprime l''affectation d''un usager à un groupe.';

DROP FUNCTION IF EXISTS personne_groupe_update(prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying);
-- CREATE OR REPLACE FUNCTION personne_groupe_update(prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	-- Non utilisé
-- 	RAISE NOTICE 'ERREUR non utilisé';
-- 	UPDATE personne_groupe SET 
-- 		grp_id = prm_grp_id,
-- 		peg_debut = prm_debut,
-- 		peg_fin = prm_fin,
-- 		peg_notes = prm_notes,
-- 		peg_cycle_statut = prm_cycle_statut,
-- 		peg_cycle_date_demande = prm_cycle_date_demande,
-- 		peg_cycle_date_demande_renouvellement = prm_cycle_date_demande_renouvellement,
-- 		peg__hebergement_chambre = prm__hebergement_chambre 
-- 		WHERE peg_id = prm_peg_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS personne_groupe_update(prm_peg_id integer, prm_inf_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer);
CREATE OR REPLACE FUNCTION personne_groupe_update(prm_token integer, prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) RETURNS void
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
COMMENT ON FUNCTION personne_groupe_update(prm_token integer, prm_peg_id integer, prm_grp_id integer, prm_debut date, prm_fin date, prm_notes text, prm_cycle_statut integer, prm_cycle_date_demande date, prm_cycle_date_demande_renouvellement date, prm__hebergement_chambre character varying, prm__decideur_financeur integer) IS
'Modifie les informations d''affectation d''un usager à un groupe.';

DROP FUNCTION IF EXISTS personne_info_boolean_get(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_boolean_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS boolean
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

DROP FUNCTION IF EXISTS personne_info_boolean_set(prm_per_id integer, prm_inf_code character varying, prm_valeur boolean);
DROP FUNCTION IF EXISTS personne_info_boolean_set(prm_per_id integer, prm_inf_code character varying, prm_valeur boolean, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_boolean_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur boolean, prm_uti_id integer) RETURNS void
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

DROP FUNCTION IF EXISTS personne_info_date_get(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_date_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS date
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

DROP FUNCTION IF EXISTS personne_info_date_get_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_date_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF date
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

DROP FUNCTION IF EXISTS personne_info_date_prepare_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_date_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_date WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;

DROP FUNCTION IF EXISTS personne_info_date_set(prm_per_id integer, prm_inf_code character varying, prm_valeur date);
DROP FUNCTION IF EXISTS personne_info_date_set(prm_per_id integer, prm_inf_code character varying, prm_valeur date, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_date_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur date, prm_uti_id integer) RETURNS void
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

DROP FUNCTION IF EXISTS personne_info_integer2_delete(prm_pij_id integer);
CREATE OR REPLACE FUNCTION personne_info_integer2_delete(prm_token integer, prm_pij_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer2 WHERE pij_id = prm_pij_id;
END;
$$;

DROP FUNCTION IF EXISTS personne_info_integer2_prepare_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_integer2_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer2 WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;

DROP FUNCTION IF EXISTS personne_info_integer2_set(prm_per_id integer, prm_inf_code character varying, prm_valeur1 integer, prm_valeur2 integer);
DROP FUNCTION IF EXISTS personne_info_integer2_set(prm_per_id integer, prm_inf_code character varying, prm_valeur1 integer, prm_valeur2 integer, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_integer2_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur1 integer, prm_valeur2 integer, prm_uti_id integer) RETURNS integer
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

DROP FUNCTION IF EXISTS personne_info_integer_delete(prm_pii_id integer);
CREATE OR REPLACE FUNCTION personne_info_integer_delete(prm_token integer, prm_pii_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer WHERE pii_id = prm_pii_id;
END;
$$;

DROP FUNCTION IF EXISTS personne_info_integer_get(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_integer_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS integer
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

DROP FUNCTION IF EXISTS personne_info_integer_get_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_integer_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF integer
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

DROP FUNCTION IF EXISTS personne_info_integer_prepare_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_integer_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_integer WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;

DROP FUNCTION IF EXISTS personne_info_integer_set(prm_per_id integer, prm_inf_code character varying, prm_valeur integer);
DROP FUNCTION IF EXISTS personne_info_integer_set(prm_per_id integer, prm_inf_code character varying, prm_valeur integer, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_integer_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur integer, prm_uti_id integer) RETURNS integer
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

DROP FUNCTION IF EXISTS personne_info_lien_familial_delete(prm_pif_id integer);
CREATE OR REPLACE FUNCTION personne_info_lien_familial_delete(prm_token integer, prm_pif_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_lien_familial WHERE pif_id = prm_pif_id;
END;
$$;

DROP FUNCTION IF EXISTS personne_info_lien_familial_get_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_lien_familial_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF personne_info_lien_familial
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

DROP FUNCTION IF EXISTS personne_info_lien_familial_get_par_id(prm_pif_id integer);
CREATE OR REPLACE FUNCTION personne_info_lien_familial_get_par_id(prm_token integer, prm_pif_id integer) RETURNS personne_info_lien_familial
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

DROP FUNCTION IF EXISTS personne_info_lien_familial_set(prm_per_id integer, prm_inf_code character varying, prm_per_id_parent integer, prm_lfa_id integer, prm_autorite_parentale integer, prm_droits character varying, prm_periodicite character varying);
CREATE OR REPLACE FUNCTION personne_info_lien_familial_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_per_id_parent integer, prm_lfa_id integer, prm_autorite_parentale integer, prm_droits character varying, prm_periodicite character varying) RETURNS integer
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

DROP FUNCTION IF EXISTS personne_info_text_get(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_text_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS text
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

DROP FUNCTION IF EXISTS personne_info_text_set(prm_per_id integer, prm_inf_code character varying, prm_valeur text);
DROP FUNCTION IF EXISTS personne_info_text_set(prm_per_id integer, prm_inf_code character varying, prm_valeur text, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_text_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur text, prm_uti_id integer) RETURNS void
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

DROP FUNCTION IF EXISTS personne_info_varchar_get(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_varchar_get(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS character varying
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

DROP FUNCTION IF EXISTS personne_info_varchar_get_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_varchar_get_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS SETOF character varying
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

DROP FUNCTION IF EXISTS personne_info_varchar_prepare_multiple(prm_per_id integer, prm_inf_code character varying);
CREATE OR REPLACE FUNCTION personne_info_varchar_prepare_multiple(prm_token integer, prm_per_id integer, prm_inf_code character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	DELETE FROM personne_info_varchar WHERE pin_id = (SELECT pin_id FROM personne_info WHERE per_id = prm_per_id AND inf_code = prm_inf_code);
END;
$$;

DROP FUNCTION IF EXISTS personne_info_varchar_set(prm_per_id integer, prm_inf_code character varying, prm_valeur character varying);
DROP FUNCTION IF EXISTS personne_info_varchar_set(prm_per_id integer, prm_inf_code character varying, prm_valeur character varying, prm_uti_id integer);
CREATE OR REPLACE FUNCTION personne_info_varchar_set(prm_token integer, prm_per_id integer, prm_inf_code character varying, prm_valeur character varying, prm_uti_id integer) RETURNS void
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

DROP FUNCTION IF EXISTS personne_liste(prm_ent_code character varying);
CREATE OR REPLACE FUNCTION personne_liste(prm_token integer, prm_ent_code character varying) RETURNS SETOF integer
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
COMMENT ON FUNCTION personne_liste(prm_token integer, prm_ent_code character varying) IS
'Retourne la liste des personne d''un type donné.';

DROP FUNCTION IF EXISTS personne_supprime(prm_per_id integer);
CREATE OR REPLACE FUNCTION personne_supprime(prm_token integer, prm_per_id integer) RETURNS void
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
COMMENT ON FUNCTION personne_supprime(prm_token integer, prm_per_id integer) IS
'Supprime une personne.';

CREATE OR REPLACE FUNCTION pgprocedures_add_call(prm_method character varying, prm_nargs integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE pgprocedures_stats SET cal_ncalls = cal_ncalls + 1 WHERE cal_function_name = prm_method AND cal_nargs = prm_nargs;
	IF NOT FOUND THEN
		INSERT INTO pgprocedures_stats (cal_function_name, cal_nargs, cal_ncalls) VALUES (prm_method, prm_nargs, 1);
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION pour_code(str character varying) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE

BEGIN
	RETURN LOWER (TRANSLATE (str,' ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëÇçÌÍÎÏìíîïÙÚÛÜùúûüÿÑñ°«»#,()''+/.&"', 
                                     '_aaaaaaaaaaaaooooooooooooeeeeeeeecciiiiiiiiuuuuuuuuynn___d_________'));
END;
$$;
COMMENT ON FUNCTION pour_code(str character varying) IS
'Retourne une chaîne sans caractères non-ascii.';

DROP FUNCTION IF EXISTS secteur_infos_get(prm_sec_id integer);
CREATE OR REPLACE FUNCTION secteur_infos_get(prm_token integer, prm_sec_id integer) RETURNS secteur_infos
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
COMMENT ON FUNCTION secteur_infos_get(prm_token integer, prm_sec_id integer) IS
'Retourne les informations supplémentaires sur un secteur.';

DROP FUNCTION IF EXISTS secteur_infos_update(prm_sec_id integer, prm_editable boolean);
CREATE OR REPLACE FUNCTION secteur_infos_update(prm_token integer, prm_sec_id integer, prm_editable boolean) RETURNS void
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
COMMENT ON FUNCTION secteur_infos_update(prm_token integer, prm_sec_id integer, prm_editable boolean) IS
'Modifie les informations supplémentaires sur un secteur.';

DROP FUNCTION IF EXISTS test1();
-- CREATE OR REPLACE FUNCTION test1() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	raise notice 'coucou';
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_transforme_lien_familial();
-- CREATE OR REPLACE FUNCTION tmp_transforme_lien_familial() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row personne_info_integer2;
-- BEGIN
-- 	FOR row IN select personne_info_integer2.* FROM personne_info_integer2 inner join personne_info using(pin_id) where inf_code = 'famille' LOOP
-- --		INSERT INTO personne_info_lien_familial (pin_id, per_id_parent, lfa_id) VALUES (row.pin_id, row.pij_valeur1, row.pij_valeur2);
-- 		delete from personne_info_integer2 WHERE pij_id = row.pij_id;
-- 	END LOOP;
-- END;
-- $$;

DROP AGGREGATE concatenate(text);
CREATE AGGREGATE concatenate(text) (
    SFUNC = concat2,
    STYPE = text,
    INITCOND = ''
);
