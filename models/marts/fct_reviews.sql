with reviews as (

    SELECT *
    FROM {{ref('stg_olist__reviews')}}

),

orders as (

    SELECT *
    FROM {{ref('stg_olist__orders')}}

),

final as (

    SELECT reviews.*, orders.customer_id
    FROM reviews
    LEFT JOIN orders
    ON reviews.order_id = orders.order_id

)

SELECT *
FROM final