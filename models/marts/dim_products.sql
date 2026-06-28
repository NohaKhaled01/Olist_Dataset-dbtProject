with products as (

    SELECT *
    FROM {{ref('stg_olist__products')}}

),

translation as (

    SELECT *
    FROM{{ref('stg_olist__translation')}}

),

final as (

    SELECT 
        products.product_id,
        coalesce(
            translation.product_category_name_english,
            products.product_category_name
        ) as product_category,
        products.product_weight_g,
        products.product_length_cm,
        products.product_height_cm,
        products.product_width_cm,
        products.product_photos_quantity

    FROM products
    LEFT JOIN translation
    ON products.product_category_name = translation.product_category_name

)

SELECT *
FROM final
