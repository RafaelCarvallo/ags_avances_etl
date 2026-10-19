{% macro chemin_flux(nom_flux) %}
    {{ return(var('raw_chemin') ~ '/' ~ flux_date_courante() ~ '/' ~ nom_flux ~ '.xlsx') }}
{% endmacro %}