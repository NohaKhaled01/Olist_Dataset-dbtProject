with orders as (

    SELECT *
    FROM {{ref('stg_olist__orders')}}

),

order_items as (

    SELECT *
    FROM {{ref('stg_olist__orderitems')}}

),

order_items_coarse as (

    SELECT order_id, COUNT(*) as items_in_order
    FROM order_items
    GROUP BY order_id

),

final as (

    SELECT orders.*, order_items_coarse.items_in_order,
            order_items_coarse.items_in_order IS NOT NULL as has_item_record
    FROM orders
    LEFT JOIN order_items_coarse 
    ON orders.order_id = order_items_coarse.order_id

)

SELECT *
FROM final