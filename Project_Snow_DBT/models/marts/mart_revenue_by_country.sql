-- Mart : analyse du chiffre d'affaires par pays
-- Utilise la macro convert_amount pour exprimer le CA en EUR et en USD

with orders as (

    select * from {{ ref('int_orders_enriched') }}

),

revenue_by_country as (

    select
        country_code,

        count(distinct order_id)                    as nb_orders,
        count(distinct customer_id)                 as nb_customers,

        -- CA en euros (devise d'origine)
        sum(amount)                                 as revenue_eur,

        -- CA converti en dollars grâce à la macro
        {{ convert_amount('sum(amount)', 1.08) }}   as revenue_usd,

        -- Panier moyen
        {{ convert_amount('avg(amount)') }}         as avg_order_value_eur,

        -- Part du CA total (en %)
        round(100 * sum(amount) / sum(sum(amount)) over (), 2) as revenue_share_pct

    from orders
    group by country_code

)

select * from revenue_by_country
order by revenue_eur desc