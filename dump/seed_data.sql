--
-- PostgreSQL database dump
--

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: animes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.animes (id, title, description, total_episodes, start_chapter, total_chapters, ongoing, created_at) FROM stdin;
2	Naruto	Naruto suit l'histoire d'un jeune ninja, Naruto Uzumaki, qui rêve de devenir Hokage, le leader de son village. Il doit surmonter de nombreux défis et adversaires tout en découvrant ses propres pouvoirs et son passé.	220	245	700	f	2026-01-15 16:15:47.554334
3	Attack on Titan	Dans un monde où l'humanité vit retranchée derrière d'immenses murs pour se protéger de titans mangeurs d'hommes, Eren Jäger jure d'exterminer ces créatures après avoir vu sa mère dévorée.	87	139	139	f	2026-01-15 16:20:39.734927
4	Demon Slayer: Kimetsu no Yaiba	Tanjiro Kamado devient pourfendeur de démons après que sa famille a été massacrée et sa sœur Nezuko transformée en démon. Il cherche un remède pour la guérir.	55	98	205	f	2026-01-15 16:20:39.838672
5	My Hero Academia	Dans un monde où 80% de la population possède un super-pouvoir, Izuku Midoriya naît sans don mais rêve de devenir un héros. Son destin change quand il rencontre All Might.	138	329	430	f	2026-01-15 16:20:39.922781
7	One Piece	Monkey D. Luffy part à l'aventure pour trouver le légendaire One Piece et devenir le roi des pirates. Il rassemble un équipage de compagnons aux rêves aussi grands que le sien.	1122	1100	1139	t	2026-01-15 16:20:40.098484
8	Naruto Shippuden	Deux ans après son départ, Naruto revient au village de Konoha plus fort que jamais. Il doit affronter l'organisation Akatsuki qui cherche à capturer tous les démons à queues.	500	700	700	f	2026-01-15 16:20:40.196548
9	Tokyo Revengers	Takemichi Hanagaki découvre qu'il peut voyager dans le temps après avoir appris la mort de son ex-petite amie. Il décide de changer le passé pour la sauver.	37	132	278	f	2026-01-15 16:20:40.299957
10	Chainsaw Man	Denji, un jeune homme endetté, fusionne avec son démon-tronçonneuse Pochita et devient Chainsaw Man. Il rejoint une organisation gouvernementale de chasseurs de démons.	12	38	185	t	2026-01-15 16:20:40.393321
11	Spy x Family	Un espion d'élite doit créer une fausse famille pour sa mission. Il adopte une télépathe sans le savoir et épouse une assassin. Chacun cache son identité aux autres.	37	38	107	t	2026-01-15 16:20:40.480518
12	Blue Lock	300 lycéens footballeurs sont enfermés dans un programme d'entraînement pour créer le meilleur attaquant du monde. Seul l'égoïsme permet de survivre dans Blue Lock.	24	95	287	t	2026-01-15 16:20:40.558499
13	Death Note	Light Yagami, lycéen surdoué, trouve un carnet permettant de tuer quiconque dont le nom y est inscrit. Il décide de créer un monde sans criminels.	37	108	108	f	2026-01-15 16:20:40.632993
14	Fullmetal Alchemist: Brotherhood	Deux frères alchimistes cherchent la pierre philosophale pour récupérer leurs corps perdus lors d'une transmutation humaine interdite visant à ressusciter leur mère.	64	108	108	f	2026-01-15 16:20:40.735207
15	Hunter x Hunter	Gon Freecss part à la recherche de son père, un légendaire Hunter. Pour le retrouver, il doit d'abord réussir l'examen Hunter, réputé mortel.	148	339	400	t	2026-01-15 16:20:40.806188
1	Vinland Saga	Thorfinn, fils d'un grand guerrier viking, jure de venger la mort de son père. Son voyage le mène à questionner la violence et à chercher la terre légendaire de Vinland.	48	100	212	t	2026-01-15 16:14:53.929563
17	Bleach: Thousand-Year Blood War	Le dernier arc de Bleach. Les Quincy attaquent la Soul Society et menacent de détruire l'équilibre des mondes. Ichigo doit découvrir ses vraies origines pour vaincre.	39	617	686	f	2026-01-15 16:20:40.944168
18	Kingdom	Kingdom est un anime basé sur le manga du même nom, qui suit l'histoire de Shin, un jeune garçon qui aspire à devenir un grand général durant la période des Royaumes combattants en Chine. L'anime met en avant des batailles épiques et des stratégies militaires complexes.	75	346	749	t	2026-01-15 16:43:25.994723
19	Ao Ashi	Ao Ashi suit l'histoire d'Aoi Ashito, un jeune footballeur talentueux qui rêve de devenir professionnel. Il est repéré par un entraîneur lors d'un tournoi et se voit offrir une chance de jouer dans une académie de football prestigieuse.	24	98	175	t	2026-01-15 20:50:20.57692
20	Sakamoto Days	Sakamoto Days suit les aventures de Taro Sakamoto, un ancien assassin légendaire devenu un homme ordinaire et propriétaire d'un magasin. Sa vie paisible est bouleversée lorsqu'il est entraîné dans des situations dangereuses par ses anciens collègues et des ennemis.	12	84	150	t	2026-01-15 21:21:21.333938
21	The Fragrant Flower Blooms With Dignity	Cet anime suit l'histoire de jeunes femmes dans un cadre historique, mettant en avant des thèmes de dignité et de détermination. Les personnages principaux luttent pour leur place dans un monde souvent dominé par des normes strictes.	12	50	100	f	2026-01-15 21:41:10.86723
22	Berserk	Berserk suit l'histoire de Guts, un guerrier solitaire en quête de vengeance contre son ancien ami devenu un puissant démon. L'anime explore des thèmes sombres tels que la lutte, la trahison et la survie dans un monde médiéval fantastique brutal.	24	351	364	f	2026-01-15 22:16:28.439554
23	Blue Exorcist	Blue Exorcist suit Rin Okumura, un adolescent qui découvre qu'il est le fils de Satan. Pour protéger ses amis et combattre les forces démoniaques, il décide de devenir exorciste.	25	46	136	f	2026-01-15 22:16:36.9878
6	Jujutsu Kaisen	Jujutsu Kaisen suit Yuji Itadori, un lycéen qui rejoint une école d'exorcisme pour combattre des malédictions après avoir ingéré un doigt maudit. L'anime mélange action, horreur et éléments surnaturels, captivant les fans avec son animation dynamique et son intrigue profonde.	24	65	236	t	2026-01-16 17:09:38.588
24	Détective Conan	Détective Conan suit les aventures d'Edogawa Conan, un jeune détective dont le corps a été transformé en celui d'un enfant. Il résout des mystères tout en cherchant un moyen de retrouver son corps d'origine et de démasquer l'organisation criminelle responsable de sa transformation.	1070	1000	1040	t	2026-01-16 15:37:03.348021
26	Dragon Ball	Dragon Ball suit les aventures de Son Goku depuis son enfance jusqu'à l'âge adulte alors qu'il s'entraîne dans les arts martiaux et explore le monde à la recherche des Dragon Balls. Ces boules magiques peuvent exaucer des vœux lorsqu'elles sont réunies.	153	195	519	f	2026-01-16 17:10:36.942415
27	Terraformars	Terraformars est un anime de science-fiction qui suit une équipe d'explorateurs envoyée sur Mars pour combattre des créatures humanoïdes appelées Terraformars. Ces créatures sont le résultat d'expérimentations génétiques visant à terraformer la planète.	24	57	130	f	2026-01-17 12:19:12.48173
29	The Beginning After the End	The Beginning After the End suit l'histoire d'un roi puissant qui se réincarne dans un monde fantastique après sa mort. Il doit naviguer dans ce nouveau monde tout en découvrant ses propres pouvoirs et en affrontant des défis.	12	51	100	t	2026-01-22 09:53:09.082089
\.


--
-- Name: animes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animes_id_seq', 29, true);


--
-- PostgreSQL database dump complete
--
