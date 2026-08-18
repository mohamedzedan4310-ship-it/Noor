# Noor Pro content pipeline

## Goal
Offline-first religious content with auditable provenance. Every imported dataset must have a source record, license status, retrieval timestamp, byte hash, parser version, and validation result.

## Import stages
1. Acquire source payload.
2. Record source URL/provider, version, license and redistribution status.
3. Compute SHA-256 of the original payload before transformation.
4. Parse into normalized staging tables.
5. Validate canonical keys (surah/ayah, book/chapter/hadith, etc.).
6. Deduplicate using stable content fingerprints without deleting provenance.
7. Build SQLite indexes and FTS5 indexes.
8. Run integrity checks (`PRAGMA integrity_check`, foreign keys, row counts, hash manifest).
9. Produce a machine-readable PASS/FAIL report.
10. Package the offline database and manifest together.

## Important licensing rule
A source being publicly reachable is not sufficient permission to redistribute it inside the app. A dataset is eligible for the bundled offline corpus only when its redistribution terms are explicit and compatible with Noor Pro. Otherwise it remains an online/provider integration or a user-supplied import.

## Quran Foundation integration
Use Quran Foundation APIs for provider-backed content where appropriate. Keep API credentials out of the mobile client. For offline releases, material must pass the separate redistribution/license gate before being bundled.

## Update model
The app should compare provider/content versions and local SHA-256 manifests before replacing a local dataset. Updates are atomic: download -> verify -> stage -> validate -> swap -> rebuild FTS -> record provenance.
