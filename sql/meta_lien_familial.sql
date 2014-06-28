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
-- Data for Name: lien_familial; Type: TABLE DATA; Schema: meta; Owner: accueil
--

COPY lien_familial (lfa_id, lfa_nom) FROM stdin;
1	Père
2	Mère
3	Frère
4	Soeur
5	Oncle
6	Tante
7	Grand-père
8	Grand-mère
9	Belle-mère
10	Beau-père
11	Tuteur/trice
12	Parrain
13	Marraine
14	Cousin
15	Cousine
16	Famille d'accueil
\.


--
-- Name: lien_familial_lfa_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: accueil
--

SELECT pg_catalog.setval('lien_familial_lfa_id_seq', 16, true);


--
-- PostgreSQL database dump complete
--

