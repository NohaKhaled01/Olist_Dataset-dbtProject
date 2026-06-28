with source as (
    SELECT *
    FROM {{ source('olist', 'customers') }}
),
renamed as (
    SELECT 
        -- As is:
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
       
    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed