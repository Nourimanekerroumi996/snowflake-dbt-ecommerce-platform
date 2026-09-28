-- Staging des produits : renommage
with source as (

    select * from {{ source('raw', 'products') }}

),

renamed as (

    select
        product_id,
        name     as product_name,
        category as product_category
    from source

)

select * from renamed