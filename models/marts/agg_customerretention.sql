with customer_orders as (

    SELECT *
    FROM {{ref('int_customersorders')}}

),
final as(

    SELECT customer_unique_id, COUNT(*) as num_of_orders
    FROM customer_orders
    GROUP BY customer_unique_id

)

SELECT *
FROM final
