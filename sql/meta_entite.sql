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
-- Data for Name: entite; Type: TABLE DATA; Schema: meta; Owner: accueil
--

COPY entite (ent_id, ent_code, ent_libelle) FROM stdin;
1	usager	Usager
2	personnel	Personnel
3	contact	Contact
6	famille	Famille
\.


--
-- Name: entite_ent_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: accueil
--

SELECT pg_catalog.setval('entite_ent_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

