-- Modèle incrémental des commandes :
-- au premier run, charge tout ; aux runs suivants, n'ajoute que les nouvelles commandes

{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge'
    )
}}

with orders as (

    select * from {{ ref('stg_orders') }}

)

select
    order_id,
    customer_id,
    product_id,
    order_date,
    amount,
    current_timestamp() as dbt_loaded_at

from orders

{% if is_incremental() %}
    -- Ce filtre ne s'applique QUE lors des runs incrémentaux (pas au premier run)
    where order_date >= (select max(order_date) from {{ this }})
{% endif %}