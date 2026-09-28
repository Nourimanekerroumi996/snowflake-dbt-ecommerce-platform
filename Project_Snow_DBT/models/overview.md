{% docs __overview__ %}

# Project_Snow_DBT : Plateforme data e-commerce

Projet dbt construit sur **Snowflake** (base `ECOMMERCE_DB`), selon une **architecture médaillon**.

## Architecture

| Couche | Schéma Snowflake | Matérialisation | Rôle |
|---|---|---|---|
| Sources | RAW | tables | Données brutes chargées via COPY INTO (CSV + JSON) |
| Staging | STAGING | views | Nettoyage, renommage, typage, parsing JSON |
| Intermediate | INTERMEDIATE | views | Jointures et agrégations |
| Marts | MART | tables | Tables finales orientées métier |
| Snapshots | SNAPSHOTS | table | Historique des changements clients (SCD type 2) |

## Modèles clés
- **int_orders_enriched** : commandes + clients + produits
- **mart_revenue_by_country** : CA par pays (EUR et USD, via la macro `convert_amount`)
- **mart_top_products** : performance et classement des produits
- **fct_orders_incremental** : commandes chargées en incrémental (merge)
- **snap_customers** : historique des clients

## Qualité des données
Tests génériques (unique, not_null, relationships, accepted_values) et tests custom
(`assert_no_negative_amount`, `positive_amount`) sur toutes les colonnes critiques.

{% enddocs %}