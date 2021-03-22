WITH calendar AS (
SELECT
    t.day::date AS calendar_day
FROM
	generate_series(
		(SELECT min(created_at) FROM {{ source('raw','event_log') }} ),
		timestamp '2020-03-11', -- Adding an extra day
		interval '1 day'
	) AS t(day)
),
transform_data AS (
SELECT
    professional_id_anonymized as professional_id,
	CASE WHEN event_type IN ('proposed', 'became_able_to_propose') THEN 1 ELSE 0 END AS is_working,
	created_at,
	LEAD(created_at,1,timestamp '2020-03-10') OVER (PARTITION BY professional_id_anonymized ORDER BY created_at) AS next_at
FROM
	{{ source('raw','event_log') }}
),
intermediate_model AS (
SELECT
    *,
    row_number() OVER (PARTITION BY professional_id, calendar_day ORDER BY created_at DESC) AS rn
FROM
    calendar
JOIN
    transform_data
ON
    calendar_day>=created_at AND calendar_day<=next_at
),
final_model AS (
SELECT
    calendar_day,
    SUM(COALESCE(is_working,0))
FROM
    intermediate_model
WHERE
    rn = 1
GROUP BY
    calendar_day
ORDER BY
    calendar_day
)
SELECT * FROM final_model
