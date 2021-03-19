WITH calendar AS (
	SELECT
		t.day::date AS date
	FROM
		generate_series(
			(SELECT min(created_at) FROM {{ source('raw','event_log') }} ),
			timestamp '2020-03-11', -- Adding an extra day
			interval '1 day'
		) AS t(day)
),
intermediate_model AS (
SELECT
	CASE WHEN event_type IN ('proposed', 'became_able_to_propose') THEN 1 ELSE 0 END AS is_working,
	created_at,
	LEAD(created_at,1,timestamp '2020-03-10') OVER (PARTITION BY professional_id_anonymized ORDER BY created_at) AS next_at
FROM
	{{ source('raw','event_log') }}
),
final_model AS (
SELECT
    date,
    COALESCE(SUM(is_working),0)
FROM
    calendar
LEFT JOIN
    intermediate_model
ON
    date>=created_at and date<=next_at
GROUP BY
    date
ORDER BY
    date
)
SELECT * FROM final_model



