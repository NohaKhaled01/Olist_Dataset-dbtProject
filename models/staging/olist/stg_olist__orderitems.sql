-- Data retrieval CTE:
with source as (
    select
        *
    from {{ source('olist', 'order_items') }}
),

-- Staging CTE (renaming columns, forcing datatypes just in case):
renamed as (
select 
    -- As is:
    order_id,

    -- Force data types:
    cast(order_item_id as INT) as order_item_id,

    -- As is:
    product_id,
    seller_id,
    shipping_limit_date,

    -- Force data types:
    cast(price as DECIMAL(10,2)) as price,
    cast(freight_value as DECIMAL(10,2)) as freight_value
    
FROM source
)

-- Getting the final output:
SELECT *
FROM renamed
