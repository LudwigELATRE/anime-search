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
