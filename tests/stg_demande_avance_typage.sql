SELECT
    bronze._date_flux,
    bronze.ref_demande_avance,
    bronze.montant_demande AS montant_brut,
    bronze.date_reception AS date_brut
FROM {{ ref('chargement_demandes_avance') }} AS bronze
LEFT JOIN {{ ref('stg_demandes_avance') }} AS silver
    ON bronze._date_flux = silver._date_flux
    AND NULLIF(TRIM(bronze.ref_demande_avance), '') = silver.ref_demande_avance
WHERE (NULLIF(TRIM(bronze.montant_demande), '') IS NOT NULL AND silver.montant_demande IS NULL)
OR (NULLIF(TRIM(bronze.date_reception), '') IS NOT NULL AND silver.date_reception IS NULL)