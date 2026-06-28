with source as (
    SELECT *
    FROM {{ source('olist', 'payments') }}
),
renamed as (
    SELECT 
        -- As is:
        order_id,

        -- Force data types:
        cast(payment_sequential as INT) as payment_sequential,

        --As is:
        payment_type,
        
        -- Force data types:
        cast(payment_installments as INT) as payment_installments,
        cast(payment_value as DECIMAL(10,2)) as payment_value

    FROM source
)
-- Getting the final output:
SELECT *
FROM renamed