with source as (
    SELECT *
    FROM {{ ref('product_category_name_translation') }}
),
renamed as (
    SELECT 
        -- As is:
        product_category_name,
        product_category_name_english
        
    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed