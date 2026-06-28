with source as (
    SELECT *
    FROM {{ source('olist', 'products') }}
),
renamed as (
    SELECT 
        -- As is:
        product_id,
        product_category_name,

        --Force data types:
        cast(product_name_lenght as INT) as product_name_length,
        cast(product_description_lenght as INT) as product_description_length,
        cast(product_photos_qty as INT) as product_photos_quantity,
        cast(product_weight_g as INT) as product_weight_g,
        cast(product_length_cm as INT) as product_length_cm,
        cast(product_height_cm as INT) as product_height_cm,
        cast(product_width_cm as INT) as product_width_cm

    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed