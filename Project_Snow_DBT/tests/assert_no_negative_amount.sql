-- Test custom : vérifie qu'aucune commande n'a un montant négatif.
-- Le test ÉCHOUE si cette requête renvoie au moins une ligne.

select
    order_id,
    amount
from {{ ref('stg_orders') }}
where amount < 0