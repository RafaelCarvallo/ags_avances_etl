{% macro relation_journal() %}
    {{ return(api.Relation.create(
        database=target.database,
        schema=generate_schema_name('bronze', none) | trim,
        identifier='journal_chargements'
    )) }}
{% endmacro %}