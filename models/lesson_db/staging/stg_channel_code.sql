-- models/lesson_db/staging/stg_channel_code.sql

/* 
  Model-Konfiguration:
  Erstellt das Staging-Model als View in der Datenbank.
*/
{{ config(materialized='view') }}

/* 
  Bereinigung und Typkonvertierung der Kanal-Code-Stammdaten aus der Quelle 'lesson.channel_code'.
*/
select
    -- Entfernt führende und nachstehende Leerzeichen beim Kanal-Typ (z. B. 'paid ')
    trim(channel_type) as channel_type,

    -- Konvertiert den Kanal-Code explizit in den Datentyp INTEGER
    cast(channel_code as integer) as channel_code

from {{ source('lesson', 'channel_code') }}
