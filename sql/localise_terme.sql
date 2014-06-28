--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = localise, pg_catalog;

--
-- Data for Name: terme; Type: TABLE DATA; Schema: localise; Owner: accueil
--

COPY terme (ter_id, ter_code, ter_commentaire) FROM stdin;
1	info_groupe_date_demande	Entête colonne dans édition appartenance usagers aux groupe (avec cycle)
2	info_groupe_date_demande_renouvellement	Entête colonne dans édition appartenance usagers aux groupe (avec cycle)
3	info_groupe_etablissement	Etiquette dans popup édition appartenance usagers aux groupes
4	info_groupe_groupe	Etiquette dans popup édition appartenance usagers aux groupes
5	info_groupe_date_debut	"Etiquette dans popup édition appartenance usagers aux groupes
6	info_groupe_date_fin	"Etiquette dans popup édition appartenance usagers aux groupes
\.


--
-- Name: terme_ter_id_seq; Type: SEQUENCE SET; Schema: localise; Owner: accueil
--

SELECT pg_catalog.setval('terme_ter_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

