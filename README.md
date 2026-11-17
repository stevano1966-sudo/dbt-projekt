<!--
  Dateiname: README.md
  Projekt:   dbt-projekt
  Ersteller: Milomir Stevanovic
  Version:   v02
  Änderungshistorie:
    v01 | 10.2026    | Erstfassung (Inhaltsliste, Ausführen)
    v02 | 17.11.2026 | Silver Screen als Hauptprojekt hervorgehoben, Übungen getrennt aufgeführt
-->

# dbt-projekt

dbt-Projekt für Snowflake (dbt Cloud), Ersteller: Milomir Stevanovic.
Entstanden in der Weiterbildung *AI-Powered Data Analyst* (Masterschool / MSIT).

## Hauptprojekt: Silver Screen – monatliche Kinoauswertung

📁 [`models/silver_screen`](models/silver_screen)

Eine Kinokette will wissen, wie sich Filme Monat für Monat und je Standort entwickeln:
Ticketumsätze aus mehreren Standorten werden mit Filmkatalog und Verleihrechnungen
zusammengeführt.

**Aufbau (Medallion-Architektur in `SILVER_SCREEN_DB`):**

| Schicht | Schema | Modelle |
|---|---|---|
| Staging | BRONZE | `stg_nj_001` bis `stg_nj_003`, `stg_location_sales`, `stg_movie_catalogue`, `stg_invoices` |
| Intermediate | SILVER | `int_monthly_sales_by_location` |
| Mart | GOLD | `fct_monthly_movie_performance` |

**Qualitätssicherung**
- Generische Tests (`not_null`, `relationships`, `unique_combination_of_columns`) und ein
  Singular-Test gegen doppelte Rechnungen
- Datenbereinigung: Dubletten in den Rechnungen entfernt, fehlende Genres als „Unknown“,
  Studionamen vereinheitlicht
- Kennzeichnung von Filmen ohne Verleihrechnung (`has_rental_invoice`)
- Ergebnis mit Rohdaten in Snowflake abgeglichen
- Production-Job in dbt Cloud: `dbt build --select path:models/silver_screen`

## Weitere Übungen aus der Weiterbildung

- `models/tasty_bytes`: Bestell- und Umsatzmodelle (TASTY_BYTES_SAMPLE_DATA)
- `models/lesson_db`: Sessions, Leases, Kanäle (LESSON_DB)
- `models/powerflow`: Marketing-Attribution, LTV und ROI (POWERFLOW),
  Kampagnenkosten als Seed `seeds/powerflow/campaign_cost.csv`

## Projektweit

- `macros/generate_schema_name.sql`: Schemas nach Ebene (DEV_/PROD_ BRONZE, SILVER, GOLD)

## Ausführen

```bash
dbt deps
dbt build                                     # alles
dbt build --select path:models/silver_screen  # nur Silver Screen
```

---

**Milomir Stevanovic** · [LinkedIn](https://www.linkedin.com/in/milomir-stevanovi%C4%87-2734752ba/)
