-- tests/powerflow/positive_lifetime.sql

-- Sucht nach fehlerhaften Datensätzen, bei denen die Lifetime eines Nutzers negativ ist
-- dbt meldet einen Fehler, wenn diese Abfrage Zeilen zurückliefert
select
    user_id,
    lifetime
from {{ ref('ltv') }}
where lifetime < 0
