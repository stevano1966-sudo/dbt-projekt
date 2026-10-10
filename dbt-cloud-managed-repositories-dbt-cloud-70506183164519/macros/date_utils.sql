-- macros/date_util.sql
{# 
  Schneidet einen Timestamp auf die Tagesebene (00:00:00) ab.
  Eingabe: Spaltenname als String (z. B. 'order_ts')
#}
{% macro format_order_date(order_date_column) %}
    DATE_TRUNC('day', {{ order_date_column }})
{% endmacro %}


