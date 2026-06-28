with sellers as (

    SELECT *
    FROM {{ref('stg_olist__sellers')}}

),

geolocation as (

    SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
    FROM {{ref('stg_olist__geolocation')}}

),

geolocation_one_grain as (

    SELECT geolocation_zip_code_prefix, AVG(geolocation_lat) as geolocation_lat, AVG(geolocation_lng) as geolocation_lng
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix

),

final as (

    SELECT sellers.*, geo.geolocation_lat, geo.geolocation_lng,
        geo.geolocation_lat IS NOT NULL as has_geolocation
    FROM sellers
    LEFT JOIN geolocation_one_grain as geo
    ON sellers.seller_zip_code_prefix = geo.geolocation_zip_code_prefix

)

SELECT *
FROM final