-- models/lesson_db/staging/stg_ads_benchmark.sql

/* 
  Model-Konfiguration:
  Erstellt das Staging-Model als View in der Datenbank.
*/
{{ config(materialized='view') }}

/* 
  1:1-Übernahme der unbereinigten Werbe-Benchmark-Daten aus der Quelle 'lesson.raw_ads_benchmark'.
  Dient als standardisiertes Staging-Interface für nachgelagerte Modelle.
*/
select *
from {{ source('lesson', 'raw_ads_benchmark') }}
