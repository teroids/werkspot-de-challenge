WITH final_model AS (
SELECT
    event_id,
    event_type,
    professional_id_anonymized AS professional_id,
    created_at,
    split_part(meta_data, '_', 1) as service_id,
    split_part(meta_data, '_', 2) as service_name_nl,
    split_part(meta_data, '_', 3) as service_name_en,
    split_part(meta_data, '_', 4) as lead_fee
FROM
    {{ source('raw','event_log') }}
)
SELECT * FROM final_model
