with orderitems as (
    
    SELECT *
    FROM {{ref('stg_olist__orderitems')}}

),

orders as (

    SELECT *
    FROM {{ref('stg_olist__orders')}}

),

final as (

    SELECT ot.*, orders.customer_id, orders.order_status, orders.purchased_at,
            orders.approved_at, orders.delivered_carrier_at, orders.delivered_customer_at, orders.estimated_delivery_at
    FROM orderitems as ot
    LEFT JOIN orders 
    ON ot.order_id = orders.order_id

)

SELECT *
FROM final