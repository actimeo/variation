--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = events, pg_catalog;

--
-- Data for Name: events_categorie; Type: TABLE DATA; Schema: events; Owner: accueil
--

COPY events_categorie (eca_id, eca_nom, eca_code, eca_icone) FROM stdin;
1	Incidents	incidents	/Images/IS_Real_vista_Communications/originals/png/NORMAL/%d/warnings_%d.png
2	Dépenses	depenses	/Images/IS_Real_vista_Accounting/originals/png/NORMAL/%d/coins_%d.png
3	Tâches et Rendez-vous	rendezvous	\N
4	Absences / Présences	absences	/Images/IS_real_vista_transportation/png/NORMAL/%d/baggage_%d.png
\.


--
-- Name: events_categorie_eca_id_seq; Type: SEQUENCE SET; Schema: events; Owner: accueil
--

SELECT pg_catalog.setval('events_categorie_eca_id_seq', 5, true);


--
-- PostgreSQL database dump complete
--

