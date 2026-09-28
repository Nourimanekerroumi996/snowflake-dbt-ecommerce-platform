{#
    Macro : convert_amount
    Convertit un montant dans une autre devise en appliquant un taux de change.

    Paramètres :
      - column_name : la colonne qui contient le montant (ex : 'amount')
      - rate        : le taux de change à appliquer (par défaut 1.0 = pas de conversion)
      - decimals    : le nombre de décimales du résultat (par défaut 2)

    Exemple d'appel :
      {{ convert_amount('amount', 1.08) }}  →  round(amount * 1.08, 2)
#}

{% macro convert_amount(column_name, rate=1.0, decimals=2) %}
    round({{ column_name }} * {{ rate }}, {{ decimals }})
{% endmacro %}