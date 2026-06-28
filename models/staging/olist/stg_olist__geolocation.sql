with source as (
    SELECT *
    FROM {{ source('olist', 'geolocation') }}
),
renamed as (
    SELECT 
        -- As is:
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state

    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed