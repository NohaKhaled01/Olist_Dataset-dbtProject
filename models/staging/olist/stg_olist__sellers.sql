with source as (
    SELECT *
    FROM {{ source('olist', 'sellers') }}
),
renamed as (
    SELECT 
        -- As is:
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
        
    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed