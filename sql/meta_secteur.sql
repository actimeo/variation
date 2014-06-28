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
-- Data for Name: secteur; Type: TABLE DATA; Schema: meta; Owner: accueil
--

COPY secteur (sec_id, sec_code, sec_nom, sec_est_prise_en_charge, sec_icone) FROM stdin;
22	protection_juridique	Protection juridique	f	/Images/IS_real_vista_security/png/NORMAL/%d/protection_%d.png
29	projet	Projet individuel	f	/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/prescription_%d.png
27	equipement_personnel	Vêture et autres fournitures	f	/Images/IS_Real_vista_Education_icons/originals/png/NORMAL/%d/backpack_%d.png
1	social	Socialisation	f	/Images/IS_Real_vista_Social/originals/png/NORMAL/%d/mutual_friends_%d.png
21	divertissement	Activités de divertissement	f	/Images/IS_Real_vista_Electrical_appliances/originals/png/NORMAL/%d/television_%d.png
2	education	Suivi éducatif	f	/Images/IS_Real_vista_Social/originals/png/NORMAL/%d/follow_%d.png
6	emploi	Stages, apprentissage et emploi	f	/Images/IS_real_vista_transportation/png/NORMAL/%d/Motor_mechanic_%d.png
28	famille	Famille et relations personnelles	f	/Images/IS_Real_vista_Education_icons/originals/png/NORMAL/%d/parent_coordinator_%d.png
19	financeur	Financement de prise en charge	t	/Images/IS_real_vista_project_managment/png/NORMAL/%d/budget_%d.png
26	aide_financiere_directe	Aides financières / allocations / ressources	t	/Images/IS_Real_vista_Accounting/originals/png/NORMAL/%d/withdrawal_%d.png
30	sejour	Séjours et excursions	f	/Images/IS_real_vista_real_state/png/NORMAL/%d/rest_area_%d.png
9	culture	Activités culturelles	f	/Images/IS_real_vista_real_state/png/NORMAL/%d/museum_%d.png
3	sante	Suivi médical	f	/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/first_aid_kit_%d.png
61	soins_infirmiers	Soins infirmiers	f	/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/nurse_%d.png
63	ergotherapie	Ergothérapie	f	/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/occupational_therapy_%d.png
64	physiotherapie	Physiothérapie	f	/Images/IS_real_vista_sports/originals/png/NORMAL/%d/floor_gymnastics_%d.png
65	kinesitherapie	Kinésithérapie	f	/Images/IS_Real_vista_3d_graphics/originals/png/NORMAL/%d/figure_%d.png
66	orthophonie	Orthophonie	f	/Images/IS_Real_vista_Communications/originals/png/NORMAL/%d/kiss_%d.png
67	psychomotricite	Psychomotricité	f	/Images/IS_real_vista_sports/originals/png/NORMAL/%d/balance_beam_%d.png
68	psychologie	Psychologie	f	/Images/IS_Real_vista_Medical/originals/png/NORMAL/%d/ophthalmology_%d.png
69	droits_de_sejour	Droits de séjour	f	/Images/IS_Real_vista_Flags/originals/png/NORMAL/%d/France_%d.png
70	aide_formalites	Aide aux formalités administratives	f	/Images/IS_Real_vista_Accounting/originals/png/NORMAL/%d/stamp_%d.png
24	entretien	Tâches collectives / entretien	f	/Images/IS_Real_vista_Electrical_appliances/originals/png/NORMAL/%d/vacuum_cleaner_%d.png
4	pedagogie	Scolarité / formation / réinsertion	f	/Images/IS_real_vista_real_state/png/NORMAL/%d/class_room_%d.png
25	aide_a_la_personne	Hygiène corporelle / aide à la personne	f	/Images/IS_Real_vista_Social/originals/png/NORMAL/%d/join_%d.png
62	dietetique	Accompagnement diététique	f	/Images/IS_Real_vista_Food/originals/png/NORMAL/%d/apples_%d.png
7	hebergement	Logement et equipement	f	/Images/IS_real_vista_real_state/png/NORMAL/%d/bedroom_%d.png
23	restauration	Restauration / alimentation	f	/Images/IS_Real_vista_Social/originals/png/NORMAL/%d/cuisines_%d.png
20	prise_en_charge	Admission et prise en charge	t	/Images/IS_Real_vista_Development/originals/png/NORMAL/%d/float_%d.png
11	decideur	Décision / orientation / mesure	t	/Images/IS_real_vista_project_managment/png/NORMAL/%d/legal_issues_%d.png
10	transport	Transport / déplacements	f	/Images/IS_Real_vista_Education_icons/originals/png/NORMAL/%d/transportation_service_%d.png
8	sport	Activités sportives	f	/Images/IS_real_vista_sports/originals/png/NORMAL/%d/marathon_%d.png
5	justice	Procédures judiciaires / incarcération	f	/Images/IS_Real_vista_Accounting/originals/png/NORMAL/%d/balance_%d.png
\.


--
-- Name: secteur_sec_id_seq; Type: SEQUENCE SET; Schema: meta; Owner: accueil
--

SELECT pg_catalog.setval('secteur_sec_id_seq', 70, true);


--
-- PostgreSQL database dump complete
--

