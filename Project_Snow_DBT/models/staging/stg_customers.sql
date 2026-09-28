-- Staging des clients : renommage et normalisation
with source as (

    select * from {{ source('raw', 'customers') }}

),

renamed as (

    select
        customer_id,
        name                 as customer_name,
        upper(trim(country)) as country_code
    from source

)

select * from renamed