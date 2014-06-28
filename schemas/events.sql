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

SET search_path = events, pg_catalog;

COMMENT ON SCHEMA events IS 
'Données des événements rattachés aux usagers.
Il est possible de définir des pages événements, spécialisables par secteur et par catégories d''événements.
Il est possible de créer des événements et de les rattacher à des personnes (usager, personnel, contact, famille) et des secteurs. On peut lui spécifier un type d''événement (d''où découle une catégorie), et y affecter des ressources (voir schéma ressource).
Il est possible de définir des types d''événements (classifiés en catégories) et de les affecter à des secteurs. Chacun de ces types d''événements pourra être utilisé ou non par chacun des établissements du réseau.
Il est possible de définir des pages Agenda ressource, résumant l''utilisation des ressources affectées aux événements.
';

COMMENT ON TABLE agressources IS 'Configuration des pages d''agenda de ressources';

COMMENT ON TABLE agressources_secteur IS 'Spécialisation des pages d''agenda par secteur';

COMMENT ON TABLE categorie_events IS 'Spécialisation des pages d''événements à certaines catégories d''événements';

COMMENT ON TABLE event IS 'Les événements.
Un événement est caractérisé par un type d''événement (les types étant eux-mêmes classifiés en catégories) et une période de temps. La période est expérimée soit par un intervalle entre 2 heures précises, soit par journées entières, soit par une heure précise pour un événement ponctuel.
Certains champs sont spécifiques aux secteurs associés à l''événement.
';

COMMENT ON COLUMN event.eve_intitule IS 'Intitulé de l''événement';
COMMENT ON COLUMN event.eve__depenses_montant IS 'Si le secteur depenses est associé à l''événement, ce champs indique le montant de la dépense associée à l''événement';
COMMENT ON COLUMN event.eca_id IS 'Identifiant de la catégorie d''événement (découle directement du type donné par ety_id)';
COMMENT ON COLUMN event.ety_id IS 'Identifiant du type d''événement';
COMMENT ON COLUMN event.eve_debut IS 'Date de début de l''événement. 
Si l''événement est de type journée, l''heure doit être 00:00';
COMMENT ON COLUMN event.eve_fin IS 'Date de fin de l''événement. 
Si l''événement est de type journée, l''heure doit être 00:00 et l''événement termine à la fin de la journée indiquée.
Si l''événement est de type ponctuel, cette valeur doit être égale à celle de eve_debut.';
COMMENT ON COLUMN event.eve_journee IS 'Indique s''il s''agit d''un événement sur une ou des journées entières.';
COMMENT ON COLUMN event.eve_ponctuel IS 'Indique s''il s''agit d''un événement à une heure précise, sans durée particulière.';

COMMENT ON TABLE event_memo IS 'Textes accompagnant les événements (objet, compte-rendu)';
COMMENT ON COLUMN event_memo.eme_type IS 'Type de mémo : bilan ou description';

COMMENT ON TABLE event_personne IS 'Rattachement de personnes (usager, personnel, contact, famille) aux événements';

COMMENT ON TABLE event_ressource IS 'Affectation de ressources aux événements';

COMMENT ON TABLE event_type IS 'Types d''événements (sous-niveau de catégories d''événements)';

COMMENT ON TABLE event_type_etablissement IS 'Utilisation d''un type d''événement par un établissement';

COMMENT ON TABLE event_type_secteur IS 'Affectation d''un type d''événement à des secteurs';

COMMENT ON TABLE events IS 'Configuration des pages d''événements disponibles pour placer dans le menu principal ou usager';

COMMENT ON TABLE events_categorie IS 'Catégories d''évenements';

COMMENT ON TABLE secteur_event IS 'Affectation des événements à des secteurs';

COMMENT ON TABLE secteur_events IS 'Spécialisation des pages d''événements à certains secteurs';

DROP FUNCTION IF EXISTS events_document_liste_validite(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_document_liste_obtention(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_document_liste_realisation(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP TYPE events_document_liste;
CREATE TYPE events_document_liste AS (
	doc_id integer,
	doc_titre character varying,
	doc_description character varying,
	d integer,
	doc_icone character varying,
	usagers varchar
);

CREATE OR REPLACE FUNCTION events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
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
COMMENT ON FUNCTION events_document_liste_obtention(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événement la liste des documents dont la date d''obtention est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';

CREATE OR REPLACE FUNCTION events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
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
COMMENT ON FUNCTION events_document_liste_realisation(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événement la liste des documents dont la date de réalisation est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';

CREATE OR REPLACE FUNCTION events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_document_liste
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
COMMENT ON FUNCTION events_document_liste_validite(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événement la liste des documents dont la date de validité est comprise dans une période donnée.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les documents du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux documents rattachés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux documents rattachés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux documents rattachés à un de ces usagers au moins';

DROP FUNCTION IF EXISTS events_echeance_liste(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP TYPE events_echeance_liste;
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

CREATE OR REPLACE FUNCTION events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_echeance_liste
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
COMMENT ON FUNCTION events_echeance_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événement la liste des échéances arrivées à terme lors d''une période donnée.
Une échéance est définie par un champ usager de format date marquée comme échéance.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les champs échéance du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux échéances de cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux échéances des usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux échéances d''un de ces usagers au moins';

DROP FUNCTION IF EXISTS events_event_liste(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP TYPE events_event_liste;
CREATE TYPE events_event_liste AS (
	eve_id integer,
	eca_id integer,
	eve_intitule character varying,
	eve_journee boolean,
	eve_ponctuel boolean,
	eve_debut integer,
	eve_fin integer,
	sec_icone character varying,
	eve__depenses_montant numeric
);

CREATE OR REPLACE FUNCTION events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_event_liste
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
			eve_journee,
			eve_ponctuel,
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
COMMENT ON FUNCTION events_event_liste(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne la liste des événements d''une période donnée.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les événements du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux événements liés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux événements liés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux événements liés à un de ces usagers au moins';

DROP FUNCTION IF EXISTS events_event_type_list(prm_eca_id integer, prm_eta_id integer);
DROP FUNCTION IF EXISTS events_event_type_list(prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer);
DROP FUNCTION IF EXISTS events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer);
DROP FUNCTION IF EXISTS events_event_type_list_all(prm_eta_id integer);
DROP FUNCTION IF EXISTS events_event_type_list_all(prm_sec_ids integer[], prm_eta_id integer);
DROP FUNCTION IF EXISTS events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer);

DROP TYPE events_event_type_list_all;
CREATE TYPE events_event_type_list_all AS (
	eca_nom character varying,
	ety_id integer,
	eca_id integer,
	ety_intitule character varying,
	ety_intitule_individuel boolean
);

-- CREATE OR REPLACE FUNCTION events_event_type_list(prm_eca_id integer, prm_eta_id integer) RETURNS SETOF events_event_type_list_all
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row events.events_event_type_list_all;
-- 	req varchar;
-- BEGIN
-- 	IF prm_eca_id ISNULL THEN
-- 		RETURN;
-- 	END IF;
-- 	req = 'SELECT DISTINCT eca_nom, event_type.* FROM events.event_type INNER JOIN events.events_categorie USING(eca_id) LEFT JOIN events.event_type_etablissement USING (ety_id) ';

-- 	req = req || 'where eca_id = ' || prm_eca_id;
-- 	IF prm_eta_id NOTNULL THEN
-- 		req = req || ' AND eta_id = ' || prm_eta_id;
-- 	END IF;
-- 	req = req || ' ORDER BY event_type.ety_intitule';
-- 	FOR row IN
-- 		EXECUTE req
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

CREATE OR REPLACE FUNCTION events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer) RETURNS SETOF events_event_type_list_all
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
COMMENT ON FUNCTION events_event_type_list(prm_token integer, prm_eca_id integer, prm_sec_ids integer[], prm_eta_id integer) IS
'Retourne les types d''événements filtrés par établissement, catégorie et secteurs.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eca_id : Catégorie d''événements, seuls les types de cette catégorie seront retournés (non NULL)
 - prm_sec_ids : Secteurs, seuls les types utilisés dans tous ces secteurs seront retournés
 - prm_eta_id : Identifiant d''établissement, seuls les types utilisés par cet établissement seront retournés, ou NULL';

-- CREATE OR REPLACE FUNCTION events_event_type_list_all(prm_eta_id integer) RETURNS SETOF events_event_type_list_all
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row events.events_event_type_list_all;
-- 	req varchar;
-- BEGIN
-- 	req = 'SELECT DISTINCT eca_nom, event_type.ety_id, event_type.eca_id, event_type.ety_intitule COLLATE "C", event_type.ety_intitule_individuel FROM events.event_type INNER JOIN events.events_categorie USING(eca_id) LEFT JOIN events.event_type_etablissement USING (ety_id) ';

-- 	IF prm_eta_id NOTNULL THEN
-- 		req = req || ' WHERE eta_id = ' || prm_eta_id;
-- 	END IF;
-- 	req = req || ' ORDER BY event_type.eca_id, event_type.ety_intitule COLLATE "C"';
-- 	FOR row IN
-- 		EXECUTE req
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

CREATE OR REPLACE FUNCTION events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) RETURNS SETOF events_event_type_list_all
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
COMMENT ON FUNCTION events_event_type_list_all(prm_token integer, prm_sec_ids integer[], prm_eta_id integer) IS
'Retourne les types d''événements filtrés par établissement et secteurs, toutes catégories confondues.
Entrées : 
 - prm_token : Token d''authentification
 - prm_sec_ids : Secteurs, seuls les types utilisés dans tous ces secteurs seront retournés
 - prm_eta_id : Identifiant d''établissement, seuls les types utilisés par cet établissement seront retournés, ou NULL';

DROP FUNCTION IF EXISTS events_event_type_list_par_evs(prm_evs_id integer);
DROP FUNCTION IF EXISTS events_event_type_list_par_evs(prm_token integer, prm_evs_id integer);
DROP TYPE events_event_type_list_par_evs;
CREATE TYPE events_event_type_list_par_evs AS (
	id integer,
	nom character varying
);

CREATE OR REPLACE FUNCTION events_event_type_list_par_evs(prm_token integer, prm_evs_id integer) RETURNS SETOF events_event_type_list_par_evs
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
COMMENT ON FUNCTION events_event_type_list_par_evs(prm_token integer, prm_evs_id integer) IS
'Retourne la liste d''événements filtrés par catégories et secteurs de la configuration d''une page d''événements.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identifiant de la configuration de page d''événements';

DROP FUNCTION IF EXISTS events_groupe_liste_fin(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_groupe_liste_debut(prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP FUNCTION IF EXISTS events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP TYPE events_groupe_liste;
CREATE TYPE events_groupe_liste AS (
	per_id integer,
	nom character varying,
	prenom character varying,
	valeur integer,
	grp_nom character varying,
	sec_icone character varying
);

CREATE OR REPLACE FUNCTION events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_groupe_liste
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
COMMENT ON  FUNCTION events_groupe_liste_debut(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événements les entrées d''usagers dans des groupes.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les groupes du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche à un de ces usagers au moins';

CREATE OR REPLACE FUNCTION events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) RETURNS SETOF events_groupe_liste
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
COMMENT ON FUNCTION events_groupe_liste_fin(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS
'Retourne sous forme d''événement les sorties de groupes d''usagers.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les groupes du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche à un de ces usagers au moins';

DROP FUNCTION IF EXISTS events_groupe_liste(prm_evs_id integer);
DROP FUNCTION IF EXISTS events_groupe_liste(prm_token integer, prm_evs_id integer);
DROP TYPE events_groupe_liste2;
CREATE TYPE events_groupe_liste2 AS (
	grp_id integer,
	grp_nom character varying,
	eta_id integer,
	eta_nom character varying
);

CREATE OR REPLACE FUNCTION events_groupe_liste(prm_token integer, prm_evs_id integer) RETURNS SETOF events_groupe_liste2
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
COMMENT ON FUNCTION events_groupe_liste(prm_token integer, prm_evs_id integer) IS
'Retourne la liste des groupes affectés à un des secteurs de la page d''événement.';

DROP FUNCTION IF EXISTS events_categorie_events_liste(prm_evs_id integer);
CREATE OR REPLACE FUNCTION events_categorie_events_liste(prm_token integer, prm_evs_id integer) RETURNS SETOF events_categorie
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
COMMENT ON FUNCTION events_categorie_events_liste(prm_token integer, prm_evs_id integer) IS
'Retourne la liste des catégories d''événements sur lesquelles une page d''événements est spécialisée.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identifiant de la configuration de page d''événement';

DROP FUNCTION IF EXISTS events_event_get(prm_eve_id integer);
CREATE OR REPLACE FUNCTION events_event_get(prm_token integer, prm_eve_id integer) RETURNS event
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
COMMENT ON FUNCTION events_event_get(prm_token integer, prm_eve_id integer) IS
'Retourne les informations sur un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';

DROP FUNCTION IF EXISTS events_event_memo_get(prm_eve_id integer, prm_type character varying);
CREATE OR REPLACE FUNCTION events_event_memo_get(prm_token integer, prm_eve_id integer, prm_type character varying) RETURNS text
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
COMMENT ON FUNCTION events_event_memo_get(prm_token integer, prm_eve_id integer, prm_type character varying) IS
'Retourne un texte (objet, compte-rendu) d''un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_type : Type du mémo : description (Objet) ou bilan (Compte-rendu)';

DROP FUNCTION IF EXISTS events_event_personne_ajoute(prm_eve_id integer, prm_per_id integer);
-- CREATE OR REPLACE FUNCTION events_event_personne_ajoute(prm_eve_id integer, prm_per_id integer) RETURNS integer
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	ret integer;
-- BEGIN
-- 	INSERT INTO events.event_personne (eve_id, per_id) VALUES (prm_eve_id, prm_per_id) RETURNING epe_id INTO ret;
-- 	RETURN ret;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_personne_list(prm_eve_id integer);
CREATE OR REPLACE FUNCTION events_event_personne_list(prm_token integer, prm_eve_id integer) RETURNS SETOF event_personne
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
COMMENT ON FUNCTION events_event_personne_list(prm_token integer, prm_eve_id integer) IS
'Retourne la liste des personnes rattachées à un événement.';

DROP FUNCTION IF EXISTS events_event_personne_supprime(prm_eve_id integer);
-- CREATE OR REPLACE FUNCTION events_event_personne_supprime(prm_eve_id integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	DELETE FROM events.event_personne WHERE eve_id = prm_eve_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_personnes_save(prm_eve_id integer, prm_per_ids integer[]);
CREATE OR REPLACE FUNCTION events_event_personnes_save(prm_token integer, prm_eve_id integer, prm_per_ids integer[]) RETURNS void
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
COMMENT ON FUNCTION events_event_personnes_save(prm_token integer, prm_eve_id integer, prm_per_ids integer[]) IS
'Modifie les personnes rattachées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_per_ids : Tableau d''identifiants de personnes à rattacher';

DROP FUNCTION IF EXISTS events_event_ressource_ajoute(prm_eve_id integer, prm_res_id integer);
-- CREATE OR REPLACE FUNCTION events_event_ressource_ajoute(prm_eve_id integer, prm_res_id integer) RETURNS integer
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	ret integer;
-- BEGIN
-- 	INSERT INTO events.event_ressource (eve_id, res_id) VALUES (prm_eve_id, prm_res_id) RETURNING ere_id INTO ret;
-- 	RETURN ret;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_ressource_list(prm_eve_id integer);
CREATE OR REPLACE FUNCTION events_event_ressource_list(prm_token integer, prm_eve_id integer) RETURNS SETOF ressource.ressource
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
COMMENT ON FUNCTION events_event_ressource_list(prm_token integer, prm_eve_id integer) IS
'Retourne la liste des ressources affectées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';

DROP FUNCTION IF EXISTS events_event_ressource_supprime(prm_eve_id integer);
-- CREATE OR REPLACE FUNCTION events_event_ressource_supprime(prm_eve_id integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	DELETE FROM events.event_ressource WHERE eve_id = prm_eve_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_ressources_save(prm_eve_id integer, prm_res_ids integer[]);
CREATE OR REPLACE FUNCTION events_event_ressources_save(prm_token integer, prm_eve_id integer, prm_res_ids integer[]) RETURNS void
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
COMMENT ON FUNCTION events_event_ressources_save(prm_token integer, prm_eve_id integer, prm_res_ids integer[]) IS 
'Modifie les ressources rattachées à un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_res_ids : Tableau d''identifiants de ressources à rattacher';

DROP FUNCTION IF EXISTS events_event_save(prm_eve_id integer, prm_uti_id integer, prm_intitule character varying, prm_eca_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text);
-- CREATE OR REPLACE FUNCTION events_event_save(prm_eve_id integer, prm_uti_id integer, prm_intitule character varying, prm_eca_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text) RETURNS integer
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	new_eve_id integer;
-- BEGIN
-- 	IF prm_eve_id NOTNULL THEN
-- 		UPDATE events.event SET 
-- 			eve_intitule = prm_intitule,
-- 			eca_id = prm_eca_id,
-- 			eve_debut = prm_debut,
-- 			eve_fin = prm_fin,
-- 			eve__depenses_montant = prm__depenses_montant
-- 			WHERE eve_id = prm_eve_id;
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
-- 		RETURN prm_eve_id;
-- 	ELSE
-- 		INSERT INTO events.event (eve_intitule, eca_id, eve_debut, eve_fin, eve__depenses_montant, uti_id_creation, eve_date_creation) VALUES (prm_intitule, prm_eca_id, prm_debut, prm_fin, prm__depenses_montant, prm_uti_id, CURRENT_TIMESTAMP) RETURNING eve_id INTO new_eve_id;
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
-- 		RETURN new_eve_id;
-- 	END IF;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_save_all(prm_eve_id integer, prm_uti_id integer, prm_intitule character varying, prm_eca_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]);
-- CREATE OR REPLACE FUNCTION events_event_save_all(prm_eve_id integer, prm_uti_id integer, prm_intitule character varying, prm_eca_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]) RETURNS integer
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	new_eve_id integer;
-- BEGIN
-- 	-- non utilisé
-- 	IF prm_eve_id NOTNULL THEN
-- 		UPDATE events.event SET 
-- 			eve_intitule = prm_intitule,
-- 			eca_id = prm_eca_id,
-- 			eve_debut = prm_debut,
-- 			eve_fin = prm_fin,
-- 			eve__depenses_montant = prm__depenses_montant
-- 			WHERE eve_id = prm_eve_id;
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
-- 		new_eve_id = prm_eve_id;
-- 	ELSE
-- 		INSERT INTO events.event (eve_intitule, eca_id, eve_debut, eve_fin, eve__depenses_montant, uti_id_creation, eve_date_creation) VALUES (prm_intitule, prm_eca_id, prm_debut, prm_fin, prm__depenses_montant, prm_uti_id, CURRENT_TIMESTAMP) RETURNING eve_id INTO new_eve_id;
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
-- 		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
-- 	END IF;
-- 	-- participants, ressources, secteurs
-- 	RAISE NOTICE '%', prm_per_ids;
-- 	IF prm_per_ids <> '{0}' THEN
-- 		PERFORM events.events_event_personnes_save (new_eve_id, prm_per_ids);		
-- 	ELSE
-- 		PERFORM events.events_event_personnes_save (new_eve_id, NULL);			
-- 	END IF;
-- 	IF prm_res_ids <> '{0}' THEN
-- 		PERFORM events.events_event_ressources_save (new_eve_id, prm_res_ids);
-- 	ELSE
-- 		PERFORM events.events_event_ressources_save (new_eve_id, NULL);
-- 	END IF;
-- 	IF prm_sec_ids <> '{0}' THEN
-- 		PERFORM events.events_event_secteurs_save (new_eve_id, prm_sec_ids);
-- 	ELSE
-- 		PERFORM events.events_event_secteurs_save (new_eve_id, NULL);
-- 	END IF;
-- 	RETURN new_eve_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_save_all(prm_eve_id integer, prm_uti_id integer, prm_intitule character varying, prm_eca_id integer, prm_ety_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]);
DROP FUNCTION IF EXISTS events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]);
CREATE OR REPLACE FUNCTION events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_journee boolean, prm_ponctuel boolean, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]) RETURNS integer
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
			eve_journee = prm_journee,
			eve_ponctuel = prm_ponctuel,
			eve_debut = prm_debut,
			eve_fin = prm_fin,
			eve__depenses_montant = prm__depenses_montant
			WHERE eve_id = prm_eve_id;
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (prm_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
		new_eve_id = prm_eve_id;
	ELSE
		INSERT INTO events.event (eve_intitule, eca_id, ety_id, eve_journee, eve_ponctuel, eve_debut, eve_fin, eve__depenses_montant, uti_id_creation, eve_date_creation) 
		VALUES (prm_intitule, (SELECT eca_id FROM events.event_type WHERE ety_id = prm_ety_id), prm_ety_id, prm_journee, prm_ponctuel, prm_debut, prm_fin, prm__depenses_montant, uti, CURRENT_TIMESTAMP) RETURNING eve_id INTO new_eve_id;
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'description', prm_description);
		INSERT INTO events.event_memo (eve_id, eme_timestamp, eme_type, eme_texte) VALUES (new_eve_id, CURRENT_TIMESTAMP, 'bilan', prm_bilan);
	END IF;
	IF prm_ponctuel AND prm_debut IS DISTINCT FROM prm_fin THEN
	    UPDATE events.event SET eve_fin = eve_debut WHERE eve_id = new_eve_id;
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
COMMENT ON FUNCTION events_event_save_all(prm_token integer, prm_eve_id integer, prm_intitule character varying, prm_ety_id integer, prm_journee boolean, prm_ponctuel boolean, prm_debut timestamp with time zone, prm_fin timestamp with time zone, prm__depenses_montant numeric, prm_description text, prm_bilan text, prm_per_ids integer[], prm_res_ids integer[], prm_sec_ids integer[]) IS
'Modifie un crée un événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement à modifier, ou NULL pour créer un nouvel événement
 - prm_intitule : Titre de l''événement
 - prm_ety_id : Identifiant du type d''événement
 - prm_journee : Indique si l''événement couvre une ou plusieurs journées complètes
 - prm_ponctuel : Indique si l''événement est ponctuel (sans durée particulière)
 - prm_debut : Date de début de l''événement
 - prm_fin : Date de fin de l''événement
 - prm__depenses_montant : Pour un événement de catégorie Dépenses, montant de la dépense
 - prm_description : Objet de l''événement
 - prm_bilan : Compte-rendu de l''événement
 - prm_per_ids : Tableau d''identifiants de personnes liées à l''événement
 - prm_res_ids : Tableau d''identifiants de ressources associées à l''événement
 - prm_sec_ids : Tableau d''identifiants de secteurs auxquel est affecté l''événement';

DROP FUNCTION IF EXISTS events_event_secteurs_save(prm_eve_id integer, prm_sec_ids integer[]);
CREATE OR REPLACE FUNCTION events_event_secteurs_save(prm_token integer, prm_eve_id integer, prm_sec_ids integer[]) RETURNS void
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
COMMENT ON FUNCTION events_event_secteurs_save(prm_token integer, prm_eve_id integer, prm_sec_ids integer[]) IS
'Modifie les secteurs auxquels est affecté un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement
 - prm_sec_ids : Tableau d''identifiants de secteurs';

DROP FUNCTION IF EXISTS events_event_supprime(prm_eve_id integer);
CREATE OR REPLACE FUNCTION events_event_supprime(prm_token integer, prm_eve_id integer) RETURNS void
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
COMMENT ON FUNCTION events_event_supprime(prm_token integer, prm_eve_id integer) IS
'Supprime un événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eve_id : Identifiant de l''événement';

DROP FUNCTION IF EXISTS events_event_type_ajoute(prm_eca_id integer, prm_intitule character varying);
CREATE OR REPLACE FUNCTION events_event_type_ajoute(prm_token integer, prm_eca_id integer, prm_intitule character varying) RETURNS integer
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
COMMENT ON FUNCTION events_event_type_ajoute(prm_token integer, prm_eca_id integer, prm_intitule character varying) IS
'Ajoute un type d''événement.
Entrées : 
 - prm_token : Token d''authentification
 - prm_eca_id : Catégorie d''événement à laquelle appartient le type
 - prm_intitule : Intitulé du type
Remarques :
Nécessite les droits à la configuration "Réseau"';

DROP FUNCTION IF EXISTS events_event_type_etablissement_get(prm_ety_id integer, prm_eta_id integer);
CREATE OR REPLACE FUNCTION events_event_type_etablissement_get(prm_token integer, prm_ety_id integer, prm_eta_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, TRUE, FALSE);
	RETURN EXISTS (SELECT 1 FROM events.event_type_etablissement WHERE ety_id = prm_ety_id AND eta_id = prm_eta_id);
END;
$$;
COMMENT ON FUNCTION events_event_type_etablissement_get(prm_token integer, prm_ety_id integer, prm_eta_id integer) IS
'Retourne TRUE si un établissement utilise un type d''événement donné, FALSE sinon.
Entrées : 
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement 
 - prm_eta_id : Identifiant de l''établissement
Remarques :
Nécessite les droits à la configuration "Établissement"';

DROP FUNCTION IF EXISTS events_event_type_etablissement_set(prm_ety_id integer, prm_eta_id integer, prm_b boolean);
CREATE OR REPLACE FUNCTION events_event_type_etablissement_set(prm_token integer, prm_ety_id integer, prm_eta_id integer, prm_b boolean) RETURNS void
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
COMMENT ON FUNCTION events_event_type_etablissement_set(prm_token integer, prm_ety_id integer, prm_eta_id integer, prm_b boolean) IS
'Indique si un établissement utilise un type d''événement donné.
Entrées : 
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement 
 - prm_eta_id : Identifiant de l''établissement
 - prm_b : TRUE si l''établissement utilise le type, FALSE sinon.
Remarques :
Nécessite les droits à la configuration "Établissement"';

DROP FUNCTION IF EXISTS events_event_type_get(prm_ety_id integer);
CREATE OR REPLACE FUNCTION events_event_type_get(prm_token integer, prm_ety_id integer) RETURNS event_type
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
COMMENT ON FUNCTION events_event_type_get(prm_token integer, prm_ety_id integer) IS
'Retourne les informations sur un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Type d''événement';

DROP FUNCTION IF EXISTS events_event_type_list();
-- CREATE OR REPLACE FUNCTION events_event_type_list() RETURNS SETOF event_type
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row events.event_type;
-- BEGIN
-- 	FOR row IN
-- 		SELECT * FROM events.event_type ORDER BY ety_intitule
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_type_list(prm_eca_id integer);
-- CREATE OR REPLACE FUNCTION events_event_type_list(prm_eca_id integer) RETURNS SETOF event_type
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row events.event_type;
-- BEGIN
-- 	FOR row IN
-- 		SELECT * FROM events.event_type WHERE eca_id = prm_eca_id ORDER BY ety_intitule
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_event_type_secteur_ajoute(prm_ety_id integer, prm_sec_id integer);
CREATE OR REPLACE FUNCTION events_event_type_secteur_ajoute(prm_token integer, prm_ety_id integer, prm_sec_id integer) RETURNS integer
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
COMMENT ON FUNCTION events_event_type_secteur_ajoute(prm_token integer, prm_ety_id integer, prm_sec_id integer) IS
'Affecte un type d''événement à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_sec_id : Identifiant du secteur
Remarques :
Nécessite les droits à la configuration "Réseau"';

DROP FUNCTION IF EXISTS events_event_type_secteur_list(prm_ety_id integer);
CREATE OR REPLACE FUNCTION events_event_type_secteur_list(prm_token integer, prm_ety_id integer) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION events_event_type_secteur_list(prm_token integer, prm_ety_id integer) IS
'Retourne la liste des secteurs auxquels est affecté un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement';

DROP FUNCTION IF EXISTS events_event_type_secteur_supprime(prm_ety_id integer, prm_sec_id integer);
CREATE OR REPLACE FUNCTION events_event_type_secteur_supprime(prm_token integer, prm_ety_id integer, prm_sec_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.event_type_secteur WHERE ety_id = prm_ety_id AND sec_id = prm_sec_id;
END;
$$;
COMMENT ON FUNCTION events_event_type_secteur_supprime(prm_token integer, prm_ety_id integer, prm_sec_id integer) IS
'Suprime l''affectation d''un type d''événement à un secteur.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_sec_id : Identifiant du secteur
Remarques :
Nécessite les droits à la configuration "Réseau"';

DROP FUNCTION IF EXISTS events_event_type_set_intitule(prm_ety_id integer, prm_intitule character varying);
CREATE OR REPLACE FUNCTION events_event_type_set_intitule(prm_token integer, prm_ety_id integer, prm_intitule character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE events.event_type SET ety_intitule = prm_intitule WHERE ety_id = prm_ety_id;
END;
$$;
COMMENT ON FUNCTION events_event_type_set_intitule(prm_token integer, prm_ety_id integer, prm_intitule character varying) IS
'Modifie l''intitulé d''un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_intitule : Nouvel intitulé
Remarques :
Nécessite les droits à la configuration "Réseau"';


DROP FUNCTION IF EXISTS events_event_type_set_intitule_individuel(prm_ety_id integer, prm_intitule_individuel boolean);
CREATE OR REPLACE FUNCTION events_event_type_set_intitule_individuel(prm_token integer, prm_ety_id integer, prm_intitule_individuel boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE events.event_type SET ety_intitule_individuel = prm_intitule_individuel WHERE ety_id = prm_ety_id;
END;
$$;
COMMENT ON FUNCTION events_event_type_set_intitule_individuel(prm_token integer, prm_ety_id integer, prm_intitule_individuel boolean) IS
'Indique si l''intitulé d''un événement ce ce type peut être personnalisé.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
 - prm_intitule_individuel : TRUE si l''intitulé peut être personnalisé 
Remarques :
Nécessite les droits à la configuration "Réseau"';

DROP FUNCTION IF EXISTS events_event_type_supprime(prm_ety_id integer);
CREATE OR REPLACE FUNCTION events_event_type_supprime(prm_token integer, prm_ety_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.event_type_secteur WHERE ety_id = prm_ety_id;
	DELETE FROM events.event_type WHERE ety_id = prm_ety_id;
END;
$$;
COMMENT ON FUNCTION events_event_type_supprime(prm_token integer, prm_ety_id integer) IS
'Supprime un type d''événement.
Entrées :
 - prm_token : Token d''authentification
 - prm_ety_id : Identifiant du type d''événement
Remarques :
Nécessite les droits à la configuration "Réseau"';

DROP FUNCTION IF EXISTS events_event_type_supprime_rec(prm_ety_id integer);
-- CREATE OR REPLACE FUNCTION events_event_type_supprime_rec(prm_ety_id integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	DELETE FROM events.event_type_secteur WHERE ety_id = prm_ety_id;
-- 	DELETE FROM events.event_type WHERE ety_id = prm_ety_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_events_categorie_list();
CREATE OR REPLACE FUNCTION events_events_categorie_list(prm_token integer) RETURNS SETOF events_categorie
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
COMMENT ON FUNCTION events_events_categorie_list(prm_token integer) IS
'Retourne la liste des catégories d''événements';

DROP FUNCTION IF EXISTS events_events_copie_et_ajoute_type(prm_evs_id integer, prm_ety_id integer);
CREATE OR REPLACE FUNCTION events_events_copie_et_ajoute_type(prm_token integer, prm_evs_id integer, prm_ety_id integer) RETURNS integer
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
COMMENT ON FUNCTION events_events_copie_et_ajoute_type(prm_token integer, prm_evs_id integer, prm_ety_id integer) IS
'Crée une nouvelle configuration de page d''événements en copiant une configuration existante et en y appliquant un type comme filtre.
Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : L''identifiant de la configuration de page événement à copier
 - prm_ety_id : Identifiant du type d''événement à appliquer à la nouvelle configuration
Remarques :
Nécessite les droits à la configuration de l''interface';

DROP FUNCTION IF EXISTS events_events_get(prm_code character varying);
-- CREATE OR REPLACE FUNCTION events_events_get(prm_code character varying) RETURNS events
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	ret events.events;
-- BEGIN
-- 	SELECT * INTO ret FROM events.events WHERE evs_code = prm_code;
-- 	RETURN ret;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_events_get(prm_id integer);
CREATE OR REPLACE FUNCTION events_events_get(prm_token integer, prm_id integer) RETURNS events
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
COMMENT ON FUNCTION events_events_get(prm_token integer, prm_id integer) IS
'Retourne les informations d''une configuration de page événement';

DROP FUNCTION IF EXISTS events_events_get_par_code(prm_code character varying);
CREATE OR REPLACE FUNCTION events_events_get_par_code(prm_token integer, prm_code character varying) RETURNS events
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
COMMENT ON FUNCTION events_events_get_par_code(prm_token integer, prm_code character varying) IS
'Retourne les informations d''une configuration de page événement, par son code';

DROP FUNCTION IF EXISTS events_events_list();
CREATE OR REPLACE FUNCTION events_events_list(prm_token integer) RETURNS SETOF events
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
COMMENT ON FUNCTION events_events_list(prm_token integer) IS
'Retourne la liste des configurations de page événement.
Remarques :
Nécessite les droits à la configuration de l''interface';

DROP FUNCTION IF EXISTS events_events_supprime (prm_evs_id integer);
CREATE OR REPLACE FUNCTION events_events_supprime (prm_token integer, prm_evs_id integer) RETURNS void
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
COMMENT ON FUNCTION events_events_supprime (prm_token integer, prm_evs_id integer) IS
'Supprime une configuration de page événement.
Remarques :
Nécessite les droits à la configuration de l''interface';

DROP FUNCTION IF EXISTS events_secteur_event_ajoute(prm_eve_id integer, prm_sec_id integer);
-- CREATE OR REPLACE FUNCTION events_secteur_event_ajoute(prm_eve_id integer, prm_sec_id integer) RETURNS integer
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	ret integer;
-- BEGIN
-- 	INSERT INTO events.secteur_event (eve_id, sec_id) VALUES (prm_eve_id, prm_sec_id) RETURNING set_id INTO ret;
-- 	RETURN ret;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_secteur_event_liste(prm_eve_id integer);
CREATE OR REPLACE FUNCTION events_secteur_event_liste(prm_token integer, prm_eve_id integer) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION events_secteur_event_liste(prm_token integer, prm_eve_id integer) IS
'Retourne la liste des secteurs auxquels est affecté un événement.';

DROP FUNCTION IF EXISTS events_secteur_event_liste(prm_eve_id integer, prm_est_prise_en_charge boolean);
-- CREATE OR REPLACE FUNCTION events_secteur_event_liste(prm_eve_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row meta.secteur;
-- BEGIN
-- 	FOR row IN
-- 		SELECT secteur.* FROM meta.secteur 
-- 		INNER JOIN events.secteur_event USING (sec_id)
-- 		WHERE eve_id = prm_eve_id
-- 		AND sec_est_prise_en_charge = prm_est_prise_en_charge
-- 		ORDER BY sec_nom
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_secteur_event_supprime(prm_eve_id integer);
-- CREATE OR REPLACE FUNCTION events_secteur_event_supprime(prm_eve_id integer) RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- BEGIN
-- 	DELETE FROM events.secteur_event WHERE eve_id = prm_eve_id;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_secteur_events_liste(prm_evs_id integer);
-- CREATE OR REPLACE FUNCTION events_secteur_events_liste(prm_evs_id integer) RETURNS SETOF meta.secteur
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row meta.secteur;
-- BEGIN
-- 	FOR row IN
-- 		SELECT secteur.* FROM meta.secteur 
-- 		INNER JOIN events.secteur_events USING (sec_id)
-- 		WHERE evs_id = prm_evs_id
-- 		ORDER BY sec_nom
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_secteur_events_liste(prm_evs_id integer, prm_eta_id integer);
CREATE OR REPLACE FUNCTION events_secteur_events_liste(prm_token integer, prm_evs_id integer, prm_eta_id integer) RETURNS SETOF meta.secteur
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
COMMENT ON FUNCTION events_secteur_events_liste(prm_token integer, prm_evs_id integer, prm_eta_id integer) IS
'Retourne la liste des secteurs sur lequels une page d''événements est spécialisée, filtrée sur la liste des secteurs pris en charge par un établissement';

DROP FUNCTION IF EXISTS events_secteur_events_liste_non_utilise(prm_evs_id integer, prm_est_prise_en_charge boolean);
-- CREATE OR REPLACE FUNCTION events_secteur_events_liste_non_utilise(prm_evs_id integer, prm_est_prise_en_charge boolean) RETURNS SETOF meta.secteur
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row meta.secteur;
-- BEGIN
-- 	FOR row IN
-- 		SELECT secteur.* FROM meta.secteur 
-- 		INNER JOIN events.secteur_events USING (sec_id)
-- 		WHERE evs_id = prm_evs_id
-- 		AND sec_est_prise_en_charge = prm_est_prise_en_charge
-- 		ORDER BY sec_nom
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events();
-- CREATE OR REPLACE FUNCTION tmp_cree_events() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN
-- /*
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		FOR row_secteurs IN
-- 			SELECT * FROM meta.secteur 
-- 		LOOP
-- 			INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' ' || row_secteurs.sec_nom, row_cats.eca_nom  || '_' || row_secteurs.sec_nom) RETURNING evs_id INTO new_evs_id;
-- 			INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
-- 			INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		END LOOP;
-- 	END LOOP;

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' (tous secteurs)', row_cats.eca_nom  || '_tous_secteurs') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		FOR row_secteurs IN
-- 			SELECT * FROM meta.secteur 
-- 		LOOP
-- 			INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
-- 		END LOOP;
-- 	END LOOP;

-- 	FOR row_secteurs IN
-- 		SELECT * FROM meta.secteur 
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) ' || row_secteurs.sec_nom, 'toutes_categories_' || row_secteurs.sec_nom) RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
-- 		FOR row_cats IN
-- 			select * FROM events.events_categorie
-- 		LOOP
-- 			INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		END LOOP;
-- 	END LOOP;
-- */
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) (tous secteurs)', 'toutes_categories_tous_secteurs') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	FOR row_secteurs IN
-- 		SELECT * FROM meta.secteur 
-- 	LOOP
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (row_secteurs.sec_id, new_evs_id);
-- 	END LOOP;	
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_administration();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_administration() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Administration', row_cats.eca_nom  || '_administration') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (11, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (20, new_evs_id);
-- 	END LOOP;
	
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Administration', 'toutes_categories_administration') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (11, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (20, new_evs_id);

-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_aide_financiere_directe();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_aide_financiere_directe() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Aide financière directe', row_cats.eca_nom  || '_aide_financiere_directe') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (26, new_evs_id);
-- 	END LOOP;
	
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Aide financière directe', 'toutes_categories_aide_financiere_directe') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (26, new_evs_id);
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_famille();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_famille() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Famille', row_cats.eca_nom  || '_famille') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (28, new_evs_id);
-- 	END LOOP;
	
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Famille', 'toutes_categories_famille') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (28, new_evs_id);
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_projet();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_projet() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Projet individuel', row_cats.eca_nom  || '_projet_individuel') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (29, new_evs_id);
-- 	END LOOP;
	
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Projet individuel', 'toutes_categories_projet') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (29, new_evs_id);
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_sejour();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_sejour() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN

-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Séjour et excursions', row_cats.eca_nom  || '_sejour') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (30, new_evs_id);
-- 	END LOOP;
	
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Séjour et excursions', 'toutes_categories_sejour') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (30, new_evs_id);
-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_events_vie_quotidienne();
-- CREATE OR REPLACE FUNCTION tmp_cree_events_vie_quotidienne() RETURNS void
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row_cats events.events_categorie;
-- 	row_secteurs meta.secteur;
-- 	new_evs_id integer;
-- BEGIN
-- /*
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.events (evs_titre, evs_code) VALUES (row_cats.eca_nom || ' Vie quotidienne', row_cats.eca_nom  || '_vie_quotidienne') RETURNING evs_id INTO new_evs_id;
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (21, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (8, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (9, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (7, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (23, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (10, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (1, new_evs_id);
-- 		INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (24, new_evs_id);
-- 	END LOOP;
-- 	*/
-- 	INSERT INTO events.events (evs_titre, evs_code) VALUES ('(toutes catégories) Vie quotidienne', 'toutes_categories_vie_quotidienne') RETURNING evs_id INTO new_evs_id;
-- 	FOR row_cats IN
-- 		select * FROM events.events_categorie
-- 	LOOP
-- 		INSERT INTO events.categorie_events (eca_id, evs_id) VALUES (row_cats.eca_id, new_evs_id);
-- 	END LOOP;
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (21, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (8, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (9, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (7, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (23, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (10, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (1, new_evs_id);
-- 	INSERT INTO events.secteur_events (sec_id, evs_id) VALUES (24, new_evs_id);

-- END;
-- $$;

DROP FUNCTION IF EXISTS tmp_cree_agressources ();
-- CREATE OR REPLACE FUNCTION tmp_cree_agressources () RETURNS void 
--        LANGUAGE plpgsql
--        AS $$
-- DECLARE
-- 	rowsec meta.secteur;
-- 	new_agr_id integer;
-- BEGIN
-- 	-- Ajot agenda tous secteurs
-- 	INSERT INTO events.agressources (agr_code, agr_titre) 
-- 	    	   VALUES ('ressources_tous_secteurs', 'Ressources tous secteurs')
-- 		   RETURNING agr_id INTO new_agr_id;
-- 	FOR rowsec IN SELECT * FROM meta.secteur LOOP
-- 	    INSERT INTO events.agressources_secteur (agr_id, sec_id) VALUES (new_agr_id, rowsec.sec_id);
-- 	END LOOP;

-- 	-- Ajout 1 agenda par secteur
-- 	FOR rowsec IN SELECT * FROM meta.secteur LOOP
-- 	    INSERT INTO events.agressources (agr_code, agr_titre) 
-- 	    	   VALUES ('ressources_'||rowsec.sec_code, 'Ressources ' || rowsec.sec_nom)
-- 		   RETURNING agr_id INTO new_agr_id;
-- 	    INSERT INTO events.agressources_secteur (agr_id, sec_id) VALUES (new_agr_id, rowsec.sec_id);
-- 	END LOOP;
-- END;
-- $$;

DROP FUNCTION IF EXISTS events_agressources_list();
CREATE OR REPLACE FUNCTION events_agressources_list(prm_token integer) RETURNS SETOF agressources
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
COMMENT ON FUNCTION events_agressources_list(prm_token integer) IS
'Retourne la liste des informations de configuration de pages d''agenda de ressources, à placer dans le menu principal ou usager.
Remarque : 
Nécessite le droit de configuration de l''interface';

CREATE OR REPLACE FUNCTION events.events_agressources_save (prm_token integer, prm_agr_id integer, prm_code varchar, prm_titre varchar) RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	IF prm_agr_id ISNULL THEN
		INSERT INTO events.agressources (agr_titre, agr_code) VALUES (prm_titre, prm_code) 
		       RETURNING agr_id INTO ret;
		RETURN ret;
	ELSE
		UPDATE events.agressources SET agr_titre = prm_titre, agr_code = prm_code WHERE agr_id = prm_agr_id;
		RETURN prm_agr_id;
	END IF;	
END;
$$;
COMMENT ON FUNCTION events.events_agressources_save (prm_token integer, prm_agr_id integer, prm_code varchar, prm_titre varchar) IS 
'Modifie les informations d''une vue de ressources ou crée une nouvelle vue.
Entrées :
 - prm_token : Token d''authentification
 - prm_agr_id : Identifiant de la vue à modifier ou NULL pour créer une nouvelle vue
 - prm_titre : Nouveau nom de vue
 - prm_code : Nouveau code de vue
';

DROP FUNCTION IF EXISTS events.events_agressources_list_details(prm_token integer);
DROP TYPE IF EXISTS events.events_agressources_list_details;
CREATE TYPE events.events_agressources_list_details AS (
  agr_id integer, 
  agr_code varchar,
  agr_titre varchar,
  themes varchar
);

CREATE OR REPLACE FUNCTION events_agressources_list_details(prm_token integer) RETURNS SETOF events.events_agressources_list_details
    LANGUAGE plpgsql
    AS $$
DECLARE
	row events.events_agressources_list_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT 
		  agr_id,
		  agr_code,
		  agr_titre,  
		  concatenate (DISTINCT secteur.sec_nom)
		FROM events.agressources
		LEFT JOIN events.agressources_secteur USING(agr_id)
		LEFT JOIN meta.secteur USING(sec_id)
		GROUP BY agr_id, agr_code, agr_titre
		ORDER BY agr_titre
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;
COMMENT ON FUNCTION events_agressources_list_details(prm_token integer) IS
'Retourne la liste des informations de configuration de pages d''agenda de ressources, à placer dans le menu principal ou usager.';

DROP FUNCTION IF EXISTS events_agressources_get(prm_agr_id integer);
CREATE OR REPLACE FUNCTION events_agressources_get(prm_token integer, prm_agr_id integer) RETURNS agressources
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
COMMENT ON FUNCTION events_agressources_get(prm_token integer, prm_agr_id integer) IS 
'Retourne les informations de configuration d''une page agenda de ressources.
Entrées :
 - prm_token : Token d''authentification
 - prm_agr_id : Identifiant de la configuration de page agenda de ressources';

DROP FUNCTION IF EXISTS events_agressources_get_par_code(prm_agr_code varchar);
CREATE OR REPLACE FUNCTION events_agressources_get_par_code(prm_token integer, prm_agr_code varchar) RETURNS agressources
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
COMMENT ON FUNCTION events_agressources_get_par_code(prm_token integer, prm_agr_code varchar) IS
'Retourne les informations de configuration d''une page agenda de ressources.
Entrées :
 - prm_token : Token d''authentification
 - prm_agr_code : Code de la configuration de page agenda de ressources';

DROP FUNCTION IF EXISTS events_agressources_secteur_list(prm_agr_id integer);
-- CREATE OR REPLACE FUNCTION events_agressources_secteur_list(prm_agr_id integer) RETURNS SETOF agressources_secteur
--     LANGUAGE plpgsql
--     AS $$
-- DECLARE
-- 	row events.agressources_secteur;
-- BEGIN
-- 	FOR row IN
-- 		SELECT * FROM events.agressources_secteur WHERE agr_id = prm_agr_id
-- 	LOOP
-- 		RETURN NEXT row;
-- 	END LOOP;
-- END;
-- $$;

CREATE OR REPLACE FUNCTION events.events_agressources_secteur_liste (prm_token integer, prm_agr_id integer) RETURNS SETOF meta.secteur
LANGUAGE plpgsql
AS $$
DECLARE
	row meta.secteur;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
		SELECT secteur.* FROM meta.secteur 
		  INNER JOIN events.agressources_secteur USING (sec_id)
		  WHERE agr_id = prm_agr_id
		  ORDER BY sec_nom
	LOOP
		RETURN NEXT row;
	END LOOP;
END;
$$;
COMMENT ON FUNCTION events.events_agressources_secteur_liste (prm_token integer, prm_agr_id integer)  IS
'Retourne la liste des secteurs sur lequels une vue de ressources est spécialisée.';

CREATE OR REPLACE FUNCTION events.events_agressources_secteurs_set(prm_token integer, prm_agr_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.agressources_secteur WHERE agr_id = prm_agr_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO events.agressources_secteur (agr_id, sec_id) VALUES (prm_agr_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;
COMMENT ON FUNCTION events.events_agressources_secteurs_set(prm_token integer, prm_agr_id integer, prm_secteurs character varying[]) IS
'Indique les secteurs sur lesquels est spécialisée une vue de ressources.

Entrées : 
 - prm_token : Token d''authentificaiton
 - prm_evs_id : Identifiant de la vue de ressources
 - prm_secteurs : Tableau de codes de secteurs
Remarques :
 - Nécessite les droits à la configuration "Réseau"';

CREATE OR REPLACE FUNCTION events.events_agressources_supprime (prm_token integer, prm_agr_id integer) RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
  	DELETE FROM events.agressources_secteur WHERE agr_id = prm_agr_id;
	DELETE FROM events.agressources WHERE agr_id = prm_agr_id;
END;
$$;
COMMENT ON FUNCTION events.events_agressources_supprime (prm_tpoken integer, prm_agr_id integer) IS
'Supprime une vue de ressources';

DROP FUNCTION IF EXISTS events_event_avec_ressource_liste (prm_start date, prm_end date, prm_agr_id integer) ;
DROP FUNCTION IF EXISTS events_event_avec_ressource_liste (prm_token integer, prm_start date, prm_end date, prm_agr_id integer) ;
DROP TYPE IF EXISTS events.events_event_avec_ressource_liste;
CREATE TYPE events.events_event_avec_ressource_liste AS (
       eve_id integer,
       res_id integer,
       res_nom varchar,
       eve_intitule varchar, 
       eve_debut integer,
       eve_fin integer
);

CREATE OR REPLACE FUNCTION events_event_avec_ressource_liste (prm_token integer, prm_start date, prm_end date, prm_agr_id integer) RETURNS SETOF events.events_event_avec_ressource_liste 
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
COMMENT ON FUNCTION events_event_avec_ressource_liste (prm_token integer, prm_start date, prm_end date, prm_agr_id integer) IS
'Retourne sous forme d''événement la liste des ressources utilisées lors d''événements
Entrées : 
 - prm_token : Token d''authentification
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_agr_id : Identification de la configuration de page d''agenda de ressources (pour trier sur les ressources du même secteur que la page)
';

DROP FUNCTION IF EXISTS events.events_event_bilan(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]);
DROP TYPE IF EXISTS events.events_event_bilan;
CREATE TYPE events.events_event_bilan AS (
       nombre integer,
       duree_heures numeric,
       duree_jours numeric,
       eca_nom varchar,
       ety_id integer, 
       ety_intitule varchar
);
COMMENT ON TYPE events.events_event_bilan IS '
 - nombre : nombre d''événements du type spécifié
 - duree_heures : nombre d''heures couvertes par des événements (uniquement les événements normaux : ni toute la journée, ni ponctuels)
 - duree_jours : nombre de jours couverts par les événements (uniquement pour les événements toute la journée)
 - eca_nom : nom de la catégorie du type
 - ety_id : identifiant du type
 - ety_intitule : intitulé du type
';

CREATE OR REPLACE FUNCTION events.events_event_bilan(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[])
  RETURNS SETOF events.events_event_bilan
LANGUAGE plpgsql
AS $$
DECLARE
	row events.events_event_bilan;
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
       	    select count(*), 
	           SUM(heures),
		   SUM(journees),
                   sub.eca_nom,
		   sub.ety_id,
		   sub.ety_intitule
       	     from (
                 SELECT DISTINCT
          	     eve_id,
		     (CASE WHEN eve_journee THEN 0 ELSE 1 END)*EXTRACT(epoch FROM age(eve_fin, eve_debut)/3600) AS heures,
		     (CASE WHEN eve_journee THEN 1 ELSE 0 END)*(1+EXTRACT(epoch FROM age(eve_fin, eve_debut)/3600/24)) AS journees,
                     event.eca_id,
                     eca_nom,
                     event.ety_id,
                     ety_intitule
                 FROM events.event
                 INNER JOIN events.event_type_secteur USING (ety_id)
                 INNER JOIN events.secteur_events ON event_type_secteur.sec_id = secteur_events.sec_id
                 INNER JOIN events.events USING(evs_id)
                 INNER JOIN events.categorie_events USING (evs_id)
                 LEFT JOIN events.events_categorie ON event.eca_id = events_categorie.eca_id
                 INNER JOIN events.event_personne USING(eve_id)
                 LEFT JOIN personne_groupe ON personne_groupe.per_id = event_personne.per_id AND (COALESCE (personne_groupe.peg_debut, '-Infinity'::timestamp), COALESCE (personne_groupe.peg_fin, 'Infinity'::timestamp)) OVERLAPS (COALESCE(event.eve_debut, '-Infinity'::timestamp), COALESCE (event.eve_fin, 'Infinity'::timestamp)) 
                 LEFT JOIN events.event_type ON event.ety_id=event_type.ety_id
                 WHERE 
                     secteur_events.evs_id = prm_evs_id AND categorie_events.eca_id = event.eca_id
                     AND (prm_per_id ISNULL OR event_personne.per_id = prm_per_id) 
		     AND (eve_debut BETWEEN p_start AND p_end OR eve_fin BETWEEN p_start AND p_end)
                     AND (prm_grp_id ISNULL OR prm_grp_id = personne_groupe.grp_id)
                     AND (prm_per_ids ISNULL OR event_personne.per_id = ANY(prm_per_ids))
                     AND (events.ety_id ISNULL OR events.ety_id = event.ety_id)) sub   
                 GROUP BY 
                     eca_nom,
		     ety_id,
                     ety_intitule
        LOOP
            RETURN NEXT row;
       END LOOP;
END;
$$;
COMMENT ON FUNCTION events.events_event_bilan(prm_token integer, prm_evs_id integer, prm_per_id integer, prm_start date, prm_end date, prm_grp_id integer, prm_per_ids integer[]) IS '
Retourne un bilan des événements sur une période donnée, regroupés par type d''événement. 

Entrées :
 - prm_token : Token d''authentification
 - prm_evs_id : Identification de la configuration de page d''événement (pour trier sur les événements du même secteur que la page)
 - prm_per_id : Identifiant d''un usager (pour spécialiser la recherche aux événements liés à cet usager) ou NULL
 - prm_start : Date de début de période de recherche
 - prm_end : Date de fin de période de recherche
 - prm_grp_id : Identifiant d''un groupe d''usagers, pour spécialiser la recherche aux événements liés aux usagers de ce groupe ou NULL
 - prm_per_ids : Tableau d''identifiants d''usagers, pour spécialiser la recherche aux événements liés à un de ces usagers au moins
';

DROP FUNCTION IF EXISTS events.events_events_liste_details (prm_token integer);
DROP TYPE IF EXISTS events.events_events_liste_details;
CREATE TYPE events.events_events_liste_details AS (
       evs_id integer,
       evs_titre varchar,
       evs_code varchar,
       themes varchar,
       categories varchar,
       typ varchar
);

CREATE FUNCTION events.events_events_liste_details (prm_token integer)
  RETURNS SETOF events.events_events_liste_details
  LANGUAGE plpgsql
  AS $$
DECLARE
	row  events.events_events_liste_details;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, FALSE);
	FOR row IN
	    SELECT 
	    	   evs_id,
		   evs_titre,
		   evs_code,
		   concatenate (DISTINCT secteur.sec_nom),
		   concatenate (DISTINCT events_categorie.eca_nom),
		   ety_intitule
	    FROM events.events
	    LEFT JOIN events.secteur_events USING(evs_id)
	    LEFT JOIN meta.secteur USING(sec_id)
	    LEFT JOIN events.categorie_events USING(evs_id)
	    LEFT JOIN events.events_categorie USING(eca_id)
	    LEFT JOIN events.event_type USING(ety_id)
	    GROUP BY evs_id, evs_titre, evs_code, ety_intitule
	LOOP
	    RETURN NEXT row;
	END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION events.events_events_update (prm_token integer, prm_evs_id integer, prm_titre varchar, prm_code varchar, prm_ety_id integer)
  RETURNS VOID
  LANGUAGE plpgsql
  AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	UPDATE events.events SET 
	       evs_titre = prm_titre,
	       evs_code = prm_code, 
	       ety_id = prm_ety_id
	       WHERE evs_id = prm_evs_id;
END;
$$;
COMMENT ON FUNCTION events.events_events_update (prm_token integer, prm_evs_id integer, prm_titre varchar, prm_code varchar, prm_ety_id integer) IS 
'Modifie les informations d''une vue d''événements.
Entrées : 
 - prm_token : Token d''authentification
 - prm_evs_id : Identifiant de la vue d''événements
 - prm_titre : Nouveau titre de la vue
 - prm_code : Nouveau code le la vue
 - prm_ety_id : Identifiant du type pour filtrer les événements affichées (ou NULL)

Remarques :
 - Nécessite les droits à la configuration "Réseau"';

CREATE OR REPLACE FUNCTION events.events_events_add (prm_token integer, prm_titre varchar, prm_code varchar, prm_ety_id integer)
  RETURNS integer
  LANGUAGE plpgsql
  AS $$
DECLARE
	ret integer;
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	INSERT INTO events.events (evs_titre, evs_code, ety_id) VALUES (prm_titre, prm_code, prm_ety_id) RETURNING evs_id INTO ret;
	RETURN ret;
END;
$$;
COMMENT ON FUNCTION events.events_events_add (prm_token integer, prm_titre varchar, prm_code varchar, prm_ety_id integer) IS 
'Crée une nouvelle une vue d''événements.
Entrées : 
 - prm_token : Token d''authentification
 - prm_titre : Titre de la nouvelle vue
 - prm_code : Code le la nouvelle vue
 - prm_ety_id : Identifiant du type pour filtrer les événements affichées (ou NULL)

Remarques :
 - Nécessite les droits à la configuration "Réseau"';

CREATE OR REPLACE FUNCTION events.events_secteur_events_set(prm_token integer, prm_evs_id integer, prm_secteurs character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.secteur_events WHERE evs_id = prm_evs_id;
	IF prm_secteurs NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_secteurs, 1) LOOP
			INSERT INTO events.secteur_events (evs_id, sec_id) VALUES (prm_evs_id, (SELECT sec_id FROM meta.secteur WHERE sec_code = prm_secteurs[i]));
		END LOOP;
	END IF;
END;
$$;
COMMENT ON FUNCTION events.events_secteur_events_set(prm_token integer, prm_evs_id integer, prm_secteurs character varying[]) IS
'Indique les secteurs sur lesquels est spécialisée une vue d''événements.

Entrées : 
 - prm_token : Token d''authentificaiton
 - prm_evs_id : Identifiant de la vue d''événements
 - prm_secteurs : Tableau de codes de secteurs
Remarques :
 - Nécessite les droits à la configuration "Réseau"';

CREATE OR REPLACE FUNCTION events.events_categorie_events_set(prm_token integer, prm_evs_id integer, prm_ecas character varying[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	PERFORM login._token_assert (prm_token, FALSE, TRUE);
	DELETE FROM events.categorie_events WHERE evs_id = prm_evs_id;
	IF prm_ecas NOTNULL THEN
		FOR i IN 1 .. array_upper(prm_ecas, 1) LOOP
			INSERT INTO events.categorie_events (evs_id, eca_id) VALUES (prm_evs_id, (SELECT eca_id FROM events.events_categorie WHERE eca_code = prm_ecas[i]));
		END LOOP;
	END IF;
END;
$$;
COMMENT ON FUNCTION events.events_categorie_events_set(prm_token integer, prm_evs_id integer, prm_ecas character varying[]) IS
'Indique les catégories d''événements sur lesquels est spécialisée une vue d''événements.

Entrées : 
 - prm_token : Token d''authentificaiton
 - prm_evs_id : Identifiant de la vue d''événements
 - prm_ecas : Tableau de codes de catégories d''événements
Remarques :
 - Nécessite les droits à la configuration "Réseau"';

-- TODO : 
-- events_agressources_supprime
