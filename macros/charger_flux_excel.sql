{% macro charger_flux_excel(source, colonnes)%}

{#- Charge <raw_chemin>/<date_flux>/<source>.xlsx si il existe -#}

{%- set date_flux = var('date_flux') -%}
{%- if execute and date_flux is none -%}
    {{exceptions.raise_compiler_error("Variable date_flux obligatoire pour charger le flux")}}
{%- endif   -%}
{%- set chemin = var('raw_chemin') ~ '/' ~ date_flux ~ '/' ~ source ~ '.xlsx' -%}

{%- set fichier_present = false -%}
{%- if execute -%}
    {%- set fichier_present = run_query("SELECT COUNT(*) 
                                      FROM GLOB('"~ chemin ~"')").columns[0].values()[0] > 0
    -%}
    {{ log(source ~ " @ " ~ date_flux ~ " : " ~ ("fichier trouvé" if fichier_present else "aucun fichier, pas de chargement"), 
           info=true)}}
{%- endif -%}

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