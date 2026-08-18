# Noor Pro architecture

## Layers
- `app/`: Flutter UI and navigation.
- `core/database/`: Drift/SQLite database, migrations and FTS5 search.
- `core/content/`: source registry, manifests, importers and atomic update engine.
- `core/security/`: local integrity checks; no provider secrets in the client.
- `features/quran/`: Quran reader, bookmarks, memorization and search.
- `features/tafsir/`: tafsir lookup linked by surah/ayah.
- `features/hadith/`: hadith books, grading metadata and narrator/search indexes.
- `features/adhkar/`: adhkar/duas, counters and audio references.
- `features/fiqh/` and `features/aqidah/`: independently versioned corpora with provenance.

## Offline-first contract
The reader and search features must work without network access. Network access is optional and used for licensed provider integrations and updates. A failed update must never destroy the last known-good local dataset.

## Database invariants
- Every content row belongs to a dataset.
- Every dataset has a source/provenance record.
- Foreign keys are enforced.
- Stable IDs are deterministic where possible.
- FTS is derived data and can be rebuilt from canonical tables.
- Hash manifests cover packaged source artifacts and database exports.
