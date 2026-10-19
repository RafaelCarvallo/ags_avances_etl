{% macro fichier_existe(chemin) %}

    {%- if not execute -%}
        {{ return(false)}}
    {%- endif -%}

    {%- set n = run_query("SELECT COUNT(*) FROM GLOB('"~ chemin ~"')").columns[0].values()[0] -%}
    {{ return(n > 0) }}

{% endmacro %}