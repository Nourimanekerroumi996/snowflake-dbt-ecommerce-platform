-- Mart : analyse de la performance des produits
with orders as (

    select * from {{ ref('int_orders_enriched') }}

),

product_performance as (

    select
        product_id,
        product_name,
        product_category,

        count(distinct order_id)        as nb_orders,
        count(distinct customer_id)     as nb_customers,
        count(distinct country_code)    as nb_countries,

        sum(amount)                     as total_revenue,
        {{ convert_amount('avg(amount)') }} as avg_order_value,

        min(order_date)                 as first_sale_date,
        max(order_date)                 as last_sale_date

    from orders
    group by product_id, product_name, product_category

),

ranked as (

    select
        *,
        -- Part du CA total (en %)
        round(100 * total_revenue / sum(total_revenue) over (), 2)   as revenue_share_pct,

        -- Classement : d'abord par nombre de ventes, puis par CA
        rank() over (order by nb_orders desc, total_revenue desc)    as sales_rank

    from product_performance

)

select * from ranked
order by sales_rank