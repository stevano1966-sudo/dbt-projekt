{#
  Dateiname: _docs.md
  models/silver_screen/_docs.md
  =========================================================================
  dbt & Snowflake Analytics Engineering
  Projekt: Silver Screen - Movie Theater Monthly Performance Pipeline
  Snowflake · dbt Cloud
  Ersteller: Milomir Stevanovic
  Datum: 06.10.2026
  Änderung: 06.10.2026 - Erklärende Kommentare hinzugefügt
  =========================================================================

  WAS MACHT DIESE DATEI?
  Hier stehen zentrale Spaltenbeschreibungen ("Doc Blocks"). Sie werden
  einmal definiert und können in den YAML-Dateien (_staging.yml,
  _intermediate.yml, _marts.yml, sources.yml) bei jeder Spalte
  wiederverwendet werden, z. B. so:

      columns:
        - name: revenue
          description: '{{ doc("revenue") }}'

  Der Text erscheint dann in der dbt-Dokumentation (dbt docs / dbt Studio)
  bei jeder Spalte, die darauf verweist. Ändert man den Text hier, ändert
  er sich überall automatisch.

  WICHTIG:
  - Der Name nach "docs" (z. B. month) ist der Schlüssel, auf den
    doc('month') verweist. Er muss im ganzen Projekt eindeutig sein.
  - Kommentare im Format {# ... #} werden von dbt ignoriert und
    erscheinen nicht in der Dokumentation.
  - Änderungen werden erst nach "dbt docs generate" sichtbar.
#}


{# --- Zeit ---------------------------------------------------------------- #}
{# Monatsebene, auf die die Kennzahlen aggregiert werden (Mart-Granularität) #}
{% docs month %}
Kalendermonat der Vorführungen bzw. Umsätze (erster Tag des Monats).
{% enddocs %}


{# --- Schlüssel: Film und Standort ---------------------------------------- #}
{# Fremdschlüssel zur Filmdimension, verbindet Verkäufe mit dem Katalog #}
{% docs movie_id %}
Eindeutige ID des Films.
{% enddocs %}

{# Fremdschlüssel zum Kinostandort #}
{% docs location_id %}
Eindeutige ID des Kinostandorts.
{% enddocs %}

{# Lesbarer Name des Standorts, ergänzend zur technischen location_id #}
{% docs location %}
Name bzw. Kennung des Kinostandorts.
{% enddocs %}


{# --- Verkäufe und Umsatz ------------------------------------------------- #}
{# Menge: Basis für die Umsatzberechnung #}
{% docs tickets_sold %}
Anzahl der verkauften Tickets.
{% enddocs %}

{# Einzelpreis: wird mit tickets_sold multipliziert #}
{% docs ticket_price %}
Preis pro Ticket.
{% enddocs %}

{# Abgeleitete Kennzahl: tickets_sold * ticket_price #}
{% docs revenue %}
Umsatz aus Ticketverkäufen (Tickets × Ticketpreis).
{% enddocs %}

{# Schlüssel der Rechnungsdaten (stg_invoices) #}
{% docs transaction_id %}
Eindeutige ID der Transaktion bzw. Rechnung.
{% enddocs %}


{# --- Filmkatalog (Stammdaten) -------------------------------------------- #}
{% docs movie_title %}
Titel des Films.
{% enddocs %}

{% docs genre %}
Genre des Films.
{% enddocs %}

{% docs studio %}
Produktionsstudio des Films.
{% enddocs %}

{% docs release_date %}
Veröffentlichungsdatum des Films.
{% enddocs %}

{# Kostenseite: Gebühr, die das Kino für den Film an den Verleih zahlt #}
{% docs rental_cost %}
Leihgebühr, die für den Film berechnet wurde.
{% enddocs %}
