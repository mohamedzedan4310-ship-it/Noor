PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS dataset (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  version TEXT NOT NULL,
  kind TEXT NOT NULL,
  language TEXT,
  license TEXT,
  redistribution_status TEXT NOT NULL CHECK (redistribution_status IN ('approved','restricted','unknown','provider_only')),
  source_url TEXT,
  retrieved_at TEXT NOT NULL,
  source_sha256 TEXT NOT NULL,
  parser_version TEXT NOT NULL,
  row_count INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS provenance_event (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dataset_id TEXT NOT NULL REFERENCES dataset(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  details_json TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS quran_ayah (
  id INTEGER PRIMARY KEY,
  surah INTEGER NOT NULL,
  ayah INTEGER NOT NULL,
  text TEXT NOT NULL,
  dataset_id TEXT NOT NULL REFERENCES dataset(id),
  UNIQUE(surah, ayah, dataset_id)
);

CREATE TABLE IF NOT EXISTS tafsir_entry (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dataset_id TEXT NOT NULL REFERENCES dataset(id),
  surah INTEGER NOT NULL,
  ayah INTEGER NOT NULL,
  text TEXT NOT NULL,
  UNIQUE(dataset_id, surah, ayah)
);

CREATE TABLE IF NOT EXISTS adhkar_entry (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  dataset_id TEXT NOT NULL REFERENCES dataset(id),
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  text TEXT NOT NULL,
  count INTEGER,
  UNIQUE(dataset_id, category, title, text)
);

CREATE VIRTUAL TABLE IF NOT EXISTS quran_ayah_fts USING fts5(text, content='quran_ayah', content_rowid='id');
CREATE VIRTUAL TABLE IF NOT EXISTS tafsir_fts USING fts5(text, content='tafsir_entry', content_rowid='id');
CREATE VIRTUAL TABLE IF NOT EXISTS adhkar_fts USING fts5(title, text, content='adhkar_entry', content_rowid='id');

CREATE TABLE IF NOT EXISTS integrity_manifest (
  artifact TEXT PRIMARY KEY,
  sha256 TEXT NOT NULL,
  bytes INTEGER NOT NULL,
  created_at TEXT NOT NULL
);
