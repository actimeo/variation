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
-- Name: localisation_loc_id_seq; Type: SEQUENCE SET; Schema: localise; Owner: accueil
--

SELECT pg_catalog.setval('localisation_loc_id_seq', 28, true);


--
-- Data for Name: localisation_secteur; Type: TABLE DATA; Schema: localise; Owner: accueil
--

COPY localisation_secteur (loc_id, ter_id, loc_valeur, sec_id) FROM stdin;
1	1	Date demande	\N
2	2	Date demande<br/>renouvellement	\N
27	5	Début	\N
28	6	Fin	\N
3	3	Autorité de placement	11
6	4	Type de placement	11
7	3	Établissement	\N
8	4	Groupe	\N
9	3	Établissement	20
10	4	Modalité	20
11	3	Établissement	23
12	4	Unité	23
13	3	Club	8
14	4	Équipe	8
16	4	Poste de travail	6
17	3	Organisme	10
18	4	Circuit	10
19	3	Organisme	30
20	4	Centre/camps	30
21	3	Établissement	4
22	4	Classe	4
23	3	Établissement	7
24	4	Unité	7
25	3	Établissement	2
26	4	Groupe	2
15	3	Entreprise	6
\.


--
-- PostgreSQL database dump complete
--

