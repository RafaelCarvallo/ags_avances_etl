{% macro charger_flux_excel(nom_flux, colonnes)%}

{#- Charge <raw_chemin>/<date_flux>/<source>.xlsx si il existe -#}

{%- set date_flux = flux_date_courante() -%}

{%- set chemin = chemin_flux(nom_flux) -%}

{%- set fichier_present = fichier_existe(chemin) -%}
{%- if execute -%}
    {{ log(nom_flux ~ " @ " ~ date_flux ~ " : " ~ ("fichier trouvé : " ~ chemin if fichier_present else "aucun fichier : " ~ chemin), info=true) }}
{%- endif %}
select
{%- for col in colonnes %}
    cast(src."{{ col }}" as varchar) AS "{{ col }}",
{%- endfor %}
    cast('{{ date_flux }}' as date) AS _date_flux,
    current_timestamp AS _date_ingestion,
    '{{ chemin }}' AS _fichier_source, 
    '{{ invocation_id }}' AS _dbt_invocation_id
{%- if fichier_present %}
FROM read_xlsx('{{ chemin }}', header=true, all_varchar=true) AS src
{%- else %}
FROM (select {% for col in colonnes %}null AS "{{ col }}"{% if not loop.last %}, {% endif %}{% endfor %}) as src
WHERE false
{%- endif %}
{% endmacro %}