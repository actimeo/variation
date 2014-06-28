--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = meta, pg_catalog;

--
-- Data for Name: infos_type; Type: TABLE DATA; Schema: meta; Owner: accueil
--

COPY infos_type (int_id, int_code, int_libelle, int_multiple, int_historique) FROM stdin;
9	etablissement	Affectation à organisme	t	t
11	famille	Famille	t	f
1	texte	Champ texte	t	t
2	date	Champ date	t	t
3	textelong	Texte multi-ligne	f	f
4	coche	Case à cocher	f	t
5	selection	Boîtier de sélection	t	t
7	contact	Lien	t	t
8	metier	Métier	t	t
10	affectation	Affectation de personnel	t	f
12	statut_usager	Statut d'usager	f	f
6	groupe	Affectation d'usager	f	f
\.


--
-- Name: infos_type_int_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: accueil
--

SELECT pg_catalog.setval('infos_type_int_id_seq', 12, true);


--
-- PostgreSQL database dump complete
--

