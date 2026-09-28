-- Staging des commandes : typage explicite
with source as (

    select * from {{ source('raw', 'orders') }}

),

renamed as (

    select
        order_id,
        customer_id,
        product_id,
        cast(order_date as date)       as order_date,
        cast(amount as number(10, 2))  as amount
    from source

)

select * from renamed