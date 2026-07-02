with orders as (

    SELECT *
    FROM {{ref('fct_orders')}}

),

customers as (

    SELECT *
    FROM {{ref('dim_customers')}}

),

final as(

    SELECT o.order_id, c.customer_unique_id
	FROM orders as o
	JOIN customers as c
	ON o.customer_id = c.customer_id

)

SELECT *
FROM final