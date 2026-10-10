-- Dateiname: generate_schema_name.sql
-- macros/generate_schema_name.sql
-- =========================================================================
-- dbt & Snowflake Analytics Engineering
-- Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
-- Snowflake · dbt Cloud
-- Ersteller: Milomir Stevanovic
-- Datum: 01.10.2026
-- Änderung: 01.10.2026 - Header hinzugefügt und Schema-Generierungslogik
--                        (Prod vs. Dev Medallion-Layer) ausführlich dokumentiert
-- =========================================================================

/*
  Hinweis zur Logik:
  Standardmäßig überschreibt dieses Makro das dbt-Verhalten für Schema-Namen.
  Es unterscheidet strikt zwischen Production (PROD_) und Development (DEV_) 
  basierend auf dem Präfix des Ziel-Schemas (`dbt_` / `DBT_`).
  
  Mapping der Medallion-Architektur:
  - 'staging' in fqn      -> BRONZE (Rohdaten-Transformationen)
  - 'intermediate' in fqn -> SILVER (Aufbereitete & aggregierte Daten)
  - 'marts' in fqn        -> GOLD   (Finale Business-Marts & Fakten)
*/

{% macro generate_schema_name(custom_schema_name, node) -%}

    {# Ermittle das im Target-Profil definierte Standard-Schema #}
    {%- set default_schema = target.schema -%}

    {# ========================================================================= #}
    {# 1. Production Mode: Greift, wenn kein Entwickler-Schema (dbt_...) vorliegt #}
    {#    Erzeugt Schemas wie PROD_BRONZE, PROD_SILVER, PROD_GOLD                  #}
    {# ========================================================================= #}
    {%- if not default_schema.startswith('dbt_') and not default_schema.startswith('DBT_') -%}
        
        {%- if custom_schema_name is not none -%}
            PROD_{{ custom_schema_name | trim | upper }}
        {%- elif 'staging' in node.fqn -%}
            PROD_BRONZE
        {%- elif 'intermediate' in node.fqn -%}
            PROD_SILVER
        {%- elif 'marts' in node.fqn -%}
            PROD_GOLD
        {%- else -%}
            PROD_{{ default_schema | trim | upper }}
        {%- endif -%}

    {# ========================================================================= #}
    {# 2. Development Mode: Greift für persönliche Developer-Schemas (dbt_...)  #}
    {#    Erzeugt Schemas wie DEV_BRONZE, DEV_SILVER, DEV_GOLD                     #}
    {# ========================================================================= #}
    {%- else -%}
        
        {%- if custom_schema_name is not none -%}
            DEV_{{ custom_schema_name | trim | upper }}
        {%- elif 'staging' in node.fqn -%}
            DEV_BRONZE
        {%- elif 'intermediate' in node.fqn -%}
            DEV_SILVER
        {%- elif 'marts' in node.fqn -%}
            DEV_GOLD
        {%- else -%}
            DEV_{{ default_schema | trim | upper }}
        {%- endif -%}

    {%- endif -%}

{%- endmacro %}