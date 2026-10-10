-- models/lesson_db/staging/stg_leases_month.sql

/* 
  Model-Konfiguration:
  Erstellt das Staging-Model als View in der Datenbank.
*/
{{ config(
    materialized='view'
) }}

/* 
  CTE: source
  Holt die unverarbeiteten Rohdaten der Leasing-Verträge aus der Quelle 'lesson.raw_leases_month'.
*/
WITH source AS (

    SELECT * 
    FROM {{ source('lesson', 'raw_leases_month') }}

),

/* 
  CTE: cleaned
  Bereinigt generische Spaltennamen (c1-c11), parst Datums- sowie Zahlenwerte und entfernt Header-Zeilen.
*/
cleaned AS (

    SELECT
        -- Entfernt Leerzeichen bei Identifikatoren
        TRIM(c1) AS leasing_contract_id,
        TRIM(c2) AS account_id,

        -- Parst Datumsfelder im Format MM/DD/YY (gibt NULL bei Fehlern zurück)
        TRY_TO_DATE(c3, 'mm/dd/yy') AS request_date,
        TRY_TO_DATE(c4, 'mm/dd/yy') AS contract_start_date,
        TRY_TO_DATE(c5, 'mm/dd/yy') AS contract_end_date,

        -- Bereinigung von Textattributen und Stati
        TRIM(c6) AS state,
        TRIM(c7) AS status, -- Geändert von 'status' auf 'c7'
        TRIM(c8) AS bike_type,
        TRIM(c9) AS bike_brand,

        -- Sichere Konvertierung des Verkaufspreises in ein numerisches Format
        TRY_CAST(c10 AS NUMERIC) AS saleprice_gross,

        -- Versicherungsoption
        TRIM(c11) AS insurance_type

    FROM source

    -- Filtert die ursprüngliche CSV-Header-Zeile heraus
    WHERE c1 != 'leasing_contract_id'

)

-- Finale Ausgabe der bereinigten Leasing-Vertragsdaten
SELECT * 
FROM cleaned
