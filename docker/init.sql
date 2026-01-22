-- Initialisation de la base de données anime-search-scan

CREATE TABLE IF NOT EXISTS animes (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL UNIQUE,
  description TEXT,
  total_episodes INTEGER NOT NULL,
  start_chapter INTEGER NOT NULL,
  total_chapters INTEGER,
  ongoing BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Index pour améliorer les performances de recherche
CREATE INDEX IF NOT EXISTS idx_animes_title ON animes USING gin(to_tsvector('simple', title));
CREATE INDEX IF NOT EXISTS idx_animes_created_at ON animes(created_at);

-- Données initiales
INSERT INTO "public"."animes" ("id", "title", "description", "total_episodes", "start_chapter", "total_chapters", "ongoing", "created_at") VALUES
('1', 'Vinland Saga', 'Thorfinn, fils d''un grand guerrier viking, jure de venger la mort de son père. Son voyage le mène à questionner la violence et à chercher la terre légendaire de Vinland.', '48', '100', '212', 'true', '2026-01-15 16:14:53.929563'),
('2', 'Naruto', 'Naruto suit l''histoire d''un jeune ninja, Naruto Uzumaki, qui rêve de devenir Hokage, le leader de son village. Il doit surmonter de nombreux défis et adversaires tout en découvrant ses propres pouvoirs et son passé.', '220', '245', '700', 'false', '2026-01-15 16:15:47.554334'),
('3', 'Attack on Titan', 'Dans un monde où l''humanité vit retranchée derrière d''immenses murs pour se protéger de titans mangeurs d''hommes, Eren Jäger jure d''exterminer ces créatures après avoir vu sa mère dévorée.', '87', '139', '139', 'false', '2026-01-15 16:20:39.734927'),
('4', 'Demon Slayer: Kimetsu no Yaiba', 'Tanjiro Kamado devient pourfendeur de démons après que sa famille a été massacrée et sa sœur Nezuko transformée en démon. Il cherche un remède pour la guérir.', '55', '98', '205', 'false', '2026-01-15 16:20:39.838672'),
('5', 'My Hero Academia', 'Dans un monde où 80% de la population possède un super-pouvoir, Izuku Midoriya naît sans don mais rêve de devenir un héros. Son destin change quand il rencontre All Might.', '138', '329', '430', 'false', '2026-01-15 16:20:39.922781'),
('6', 'Jujutsu Kaisen', 'Yuji Itadori, lycéen aux capacités physiques hors normes, avale un doigt maudit appartenant au roi des fléaux Sukuna et intègre l''école d''exorcisme de Tokyo.', '47', '134', '271', 'false', '2025-01-01 16:20:40.018907'),
('7', 'One Piece', 'Monkey D. Luffy part à l''aventure pour trouver le légendaire One Piece et devenir le roi des pirates. Il rassemble un équipage de compagnons aux rêves aussi grands que le sien.', '1122', '1100', '1139', 'true', '2026-01-15 16:20:40.098484'),
('8', 'Naruto Shippuden', 'Deux ans après son départ, Naruto revient au village de Konoha plus fort que jamais. Il doit affronter l''organisation Akatsuki qui cherche à capturer tous les démons à queues.', '500', '700', '700', 'false', '2026-01-15 16:20:40.196548'),
('9', 'Tokyo Revengers', 'Takemichi Hanagaki découvre qu''il peut voyager dans le temps après avoir appris la mort de son ex-petite amie. Il décide de changer le passé pour la sauver.', '37', '132', '278', 'false', '2026-01-15 16:20:40.299957'),
('10', 'Chainsaw Man', 'Denji, un jeune homme endetté, fusionne avec son démon-tronçonneuse Pochita et devient Chainsaw Man. Il rejoint une organisation gouvernementale de chasseurs de démons.', '12', '38', '185', 'true', '2026-01-15 16:20:40.393321'),
('11', 'Spy x Family', 'Un espion d''élite doit créer une fausse famille pour sa mission. Il adopte une télépathe sans le savoir et épouse une assassin. Chacun cache son identité aux autres.', '37', '38', '107', 'true', '2026-01-15 16:20:40.480518'),
('12', 'Blue Lock', '300 lycéens footballeurs sont enfermés dans un programme d''entraînement pour créer le meilleur attaquant du monde. Seul l''égoïsme permet de survivre dans Blue Lock.', '24', '95', '287', 'true', '2026-01-15 16:20:40.558499'),
('13', 'Death Note', 'Light Yagami, lycéen surdoué, trouve un carnet permettant de tuer quiconque dont le nom y est inscrit. Il décide de créer un monde sans criminels.', '37', '108', '108', 'false', '2026-01-15 16:20:40.632993'),
('14', 'Fullmetal Alchemist: Brotherhood', 'Deux frères alchimistes cherchent la pierre philosophale pour récupérer leurs corps perdus lors d''une transmutation humaine interdite visant à ressusciter leur mère.', '64', '108', '108', 'false', '2026-01-15 16:20:40.735207'),
('15', 'Hunter x Hunter', 'Gon Freecss part à la recherche de son père, un légendaire Hunter. Pour le retrouver, il doit d''abord réussir l''examen Hunter, réputé mortel.', '148', '339', '400', 'true', '2026-01-15 16:20:40.806188'),
('17', 'Bleach: Thousand-Year Blood War', 'Le dernier arc de Bleach. Les Quincy attaquent la Soul Society et menacent de détruire l''équilibre des mondes. Ichigo doit découvrir ses vraies origines pour vaincre.', '39', '617', '686', 'false', '2026-01-15 16:20:40.944168'),
('18', 'Kingdom', 'Kingdom est un anime basé sur le manga du même nom, qui suit l''histoire de Shin, un jeune garçon qui aspire à devenir un grand général durant la période des Royaumes combattants en Chine. L''anime met en avant des batailles épiques et des stratégies militaires complexes.', '75', '346', '749', 'true', '2026-01-15 16:43:25.994723'),
('19', 'Ao Ashi', 'Ao Ashi suit l''histoire d''Aoi Ashito, un jeune footballeur talentueux qui rêve de devenir professionnel. Il est repéré par un entraîneur lors d''un tournoi et se voit offrir une chance de jouer dans une académie de football prestigieuse.', '24', '98', '175', 'true', '2026-01-15 20:50:20.57692'),
('20', 'Sakamoto Days', 'Sakamoto Days suit les aventures de Taro Sakamoto, un ancien assassin légendaire devenu un homme ordinaire et propriétaire d''un magasin. Sa vie paisible est bouleversée lorsqu''il est entraîné dans des situations dangereuses par ses anciens collègues et des ennemis.', '12', '84', '150', 'true', '2026-01-15 21:21:21.333938'),
('21', 'The Fragrant Flower Blooms With Dignity', 'Cet anime suit l''histoire de jeunes femmes dans un cadre historique, mettant en avant des thèmes de dignité et de détermination. Les personnages principaux luttent pour leur place dans un monde souvent dominé par des normes strictes.', '12', '50', '100', 'false', '2026-01-15 21:41:10.86723'),
('22', 'Berserk', 'Berserk suit l''histoire de Guts, un guerrier solitaire en quête de vengeance contre son ancien ami devenu un puissant démon. L''anime explore des thèmes sombres tels que la lutte, la trahison et la survie dans un monde médiéval fantastique brutal.', '24', '351', '364', 'false', '2026-01-15 22:16:28.439554'),
('23', 'Blue Exorcist', 'Blue Exorcist suit Rin Okumura, un adolescent qui découvre qu''il est le fils de Satan. Pour protéger ses amis et combattre les forces démoniaques, il décide de devenir exorciste.', '25', '46', '136', 'false', '2026-01-15 22:16:36.9878')
ON CONFLICT (id) DO NOTHING;

-- Reset sequence to max id
SELECT setval('animes_id_seq', (SELECT MAX(id) FROM animes));
