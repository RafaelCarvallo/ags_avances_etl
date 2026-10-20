{% macro creer_journal_chargements() %}

    CREATE TABLE IF NOT EXISTS {{ relation_journal() }} (
        _dbt_invocation_id varchar,
        commande varchar,
        date_flux date,
        modele varchar,
        statut varchar,
        nb_lignes integer,
        fichier_source varchar,
        duree_secondes decimal(18,2),
        date_execution timestamp
    )

{% endmacro %}