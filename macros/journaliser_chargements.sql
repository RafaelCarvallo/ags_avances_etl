{% macro journaliser_chargements(resultats) %}

    {%- if not execute or flags.WHICH not in ['run', 'build', 'retry'] -%}
        {{return('')}}  {#- On retourne vide lorsque le lancement ne correspond pas à un build. Par exemple un compile rentre dans cette condition -#}
    {%- endif -%}

    {%- set modeles = [] -%}

    {%- for res in resultats if res.node.resource_type == 'model' and 'bronze' in res.node.tags -%}
        {%- do modeles.append(res) -%}
    {%- endfor -%}

    {%- if modeles | length == 0 -%}
        {{return('')}}
    {%- endif -%}

    {%- set date_flux = var('date_flux') -%}
    {%- set date_flux_sql = "CAST('" ~ date_flux ~ "' AS DATE)" if date_flux is not none else "CAST(NULL AS DATE)" -%}

    INSERT INTO {{ relation_journal() }} (
        _dbt_invocation_id,
        commande,
        date_flux,
        modele,
        statut,
        nb_lignes,
        fichier_source,
        duree_secondes,
        date_execution
    )

    {%- for modele in modeles -%}
        {% if not loop.first %}
            UNION ALL
        {% endif %}

        SELECT
            '{{ invocation_id }}',
            '{{ flags.WHICH }}',
            {{ date_flux_sql }},
            '{{ modele.node.name }}',
            '{{ modele.status }}',
            VOLUMETRIE.nb_lignes,
            VOLUMETRIE.fichier_source,
            {{ modele.execution_time | round(3) }},
            cast('{{ run_started_at }}' as timestamp with time zone)
        FROM
            (
                {%- if modele.status == 'success' and date_flux is not none %}
                SELECT 
                    COUNT(*) AS nb_lignes, 
                    MAX(_fichier_source) as fichier_source
                FROM {{ modele.node.relation_name }}
                WHERE _date_flux = {{ date_flux_sql }}

                {%- else %}

                SELECT
                    CAST(NULL AS INTEGER) AS nb_lignes,
                    CAST(NULL AS VARCHAR) AS fichier_source
                
                {%- endif  %}
            ) AS VOLUMETRIE
    {%- endfor %}
{% endmacro %}

