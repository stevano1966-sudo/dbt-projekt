-- models/tasty_bytes/staging/stg_menu.sql

/* 
  CTE: source
  Holt die unverarbeiteten Menü- und Speisekarten-Stammdaten aus der Quelle 'TASTY_BYTES_SAMPLE_DATA.RAW_POS.menu'.
*/
WITH source AS (

    SELECT * 
    FROM TASTY_BYTES_SAMPLE_DATA.RAW_POS.menu

)

-- 1:1-Übernahme der Stammdaten als Staging-Layer für nachgelagerte Transformationen
SELECT * FROM source
