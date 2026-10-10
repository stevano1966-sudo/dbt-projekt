# dbt-projekt

dbt-Projekt für Snowflake (dbt Cloud), Ersteller: Milomir Stevanovic.

## Inhalt
- `models/tasty_bytes`: Bestell- und Umsatzmodelle (TASTY_BYTES_SAMPLE_DATA)
- `models/lesson_db`: Sessions, Leases, Kanäle (LESSON_DB)
- `models/powerflow`: Marketing-Attribution, LTV und ROI (POWERFLOW)
- `models/silver_screen`: monatliche Kinoauswertung (SILVER_SCREEN_DB)
- `macros/generate_schema_name.sql`: Schemas nach Ebene (DEV_/PROD_ BRONZE, SILVER, GOLD)
- `seeds/powerflow/campaign_cost.csv`: Kampagnenkosten

## Ausführen
dbt deps
dbt seed
dbt build
