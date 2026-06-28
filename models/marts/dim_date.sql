with date_range as (

    SELECT CAST(day as DATE) as day_date
    FROM 
        generate_series
            (
            DATE '2016-01-01',
            DATE '2018-12-31',
            INTERVAL 1 DAY
            ) as date_table(day)      

        

),

final as (

    SELECT
        day_date,
        EXTRACT(year from day_date) as year,
        EXTRACT(quarter from day_date) as quarter,
        EXTRACT(month from day_date) as month,
        monthname(day_date) as month_name,
        EXTRACT(day from day_date) as day,
        EXTRACT(dow from day_date) as day_number_of_week,
        dayname(day_date) as day_name_of_week,
        CASE 
            WHEN dayname(day_date) = 'Saturday' OR dayname(day_date) = 'Sunday' THEN true
            ELSE false
        END as is_weekend
    FROM date_range

)

SELECT *
FROM final