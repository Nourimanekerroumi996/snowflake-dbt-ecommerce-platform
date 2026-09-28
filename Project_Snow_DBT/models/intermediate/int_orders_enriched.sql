-- Commandes enrichies : chaque commande avec les infos client et produit
with orders as (

    select * from {{ ref('stg_orders') }}

),

customers as (

    select * from {{ ref('stg_customers') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

enriched as (

    select
        -- Commande
        o.order_id,
        o.order_date,
        o.amount,

        -- Client
        o.customer_id,
        c.customer_name,
        c.country_code,

        -- Produit
        o.product_id,
        p.product_name,
        p.product_category

    from orders o
    left join customers c
        on o.customer_id = c.customer_id
    left join products p
        on o.product_id = p.product_id

)

select * from enriched