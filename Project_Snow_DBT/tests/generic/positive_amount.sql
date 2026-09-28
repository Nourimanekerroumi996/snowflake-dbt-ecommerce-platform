{#
    Test générique : positive_amount
    Vérifie qu'une colonne ne contient aucune valeur négative.
    Utilisation dans un fichier YAML :
        data_tests:
          - positive_amount
#}

{% test positive_amount(model, column_name) %}

    select *
    from {{ model }}
    where {{ column_name }} < 0

{% endtest %}