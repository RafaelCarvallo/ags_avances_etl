WITH flux_source AS (
    SELECT
        *
    FROM {{ ref('chargement_demandes_avance') }}
),

table_typage AS (
    SELECT
        NULLIF(TRIM(ref_demande_avance), '') AS ref_demande_avance,
        NULLIF(TRIM(ref_salarie), '') AS ref_salarie,
        NULLIF(TRIM(rang_creance), '') AS rang_creance,
        TRY_CAST(NULLIF(TRIM(montant_demande), '') AS decimal(18,2)) AS montant_demande,
        date '1899-12-30' + TRY_CAST(NULLIF(TRIM(date_reception), '') AS integer) as date_reception,
        _date_flux,
        _date_ingestion,
        _fichier_source
    FROM flux_source
)

SELECT
    ref_demande_avance,
    ref_salarie,
    rang_creance,
    montant_demande,
    date_reception,
    MD5(CONCAT_WS(
        COALESCE(ref_salarie, '#NULL#'),
        COALESCE(rang_creance, '#NULL#'),
        COALESCE(CAST(montant_demande AS varchar), '#NULL#'),
        COALESCE(CAST(date_reception AS varchar), '#NULL#')
    )) AS _hash_ligne,
    _date_flux,
    _date_ingestion,
    _fichier_source
FROM table_typage