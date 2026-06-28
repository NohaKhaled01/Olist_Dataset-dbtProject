-- Data retrieval CTE:
with source as (
    select
        *
    from {{ source('olist', 'reviews') }}
),

-- Staging CTE (renaming columns, forcing datatypes just in case):
renamed as (
select 
    -- As is:
    review_id,
    order_id,

    -- Force data types:
    cast(review_score as INT) as review_score,

    -- As is:
    review_comment_title,
    review_comment_message,

    -- Force data types:
    try_strptime(review_creation_date, '%-m/%-d/%Y %-H:%M') as review_creation_date,
    try_strptime(review_answer_timestamp, '%-m/%-d/%Y %-H:%M') as review_answer_timestamp

FROM source
)

-- Getting the final output:
SELECT *
FROM renamed
