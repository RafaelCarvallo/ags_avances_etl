{% macro flux_date_courante() %}

    {%- set d = var('date_flux') -%}

    {%- if d is none -%} {#- Vérification de la présence de la variable date_flux -#}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Variable obligatoire : --vars '{\"date_flux\": \"AAAA-MM-JJ\"}'") }}
        {%- endif -%}
        {{ return('1000-01-01')}} {#- Jamais éxécuté -#}
    {%- endif -%}

    {% set d = d | string -%}

    {%- if not modules.re.match('^[0-9]{4}-[0-9]{2}-[0-9]{2}$', d) -%} {#- Vérification du bon format du date_flux passé en variable -#}
        {{ exceptions.raise_compiler_error("Le format de date_flux ('" ~ d ~ "') est invalide, le format attendu est : AAAA-MM-JJ") }}
    {%- endif -%}

    {{ return(d) }}
{% endmacro %}