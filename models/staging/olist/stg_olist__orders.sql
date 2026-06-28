-- Data retrieval CTE:
with source as (
    select
        *
    from {{ source('olist', 'order') }}
),

-- Staging CTE (renaming columns, forcing datatypes just in case):
renamed as (
select 
    -- ids
    order_id, 
    customer_id,

    
    -- order status
    order_status,

    -- timestamps [forcing a datatype]
    cast(order_purchase_timestamp as timestamp) as purchased_at,
    cast(order_approved_at as timestamp) as approved_at,
    cast(order_delivered_carrier_date as timestamp) as delivered_carrier_at,
    cast(order_delivered_customer_date as timestamp) as delivered_customer_at,
    cast(order_estimated_delivery_date as timestamp) as estimated_delivery_at

FROM source
)

-- Getting the final output:
SELECT *
FROM renamed
