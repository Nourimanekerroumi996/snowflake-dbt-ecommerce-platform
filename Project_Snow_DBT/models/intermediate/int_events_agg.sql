-- Agrégation des événements : nombre d'événements par utilisateur
with events as (

    select * from {{ ref('stg_events') }}

),

aggregated as (

    select
        user_id,

        -- Total
        count(*)                                              as total_events,

        -- Détail par type d'événement
        count_if(event_type = 'view')                         as nb_views,
        count_if(event_type = 'click')                        as nb_clicks,
        count_if(event_type = 'purchase')                     as nb_purchases,

        -- Période d'activité
        min(event_timestamp)                                  as first_event_at,
        max(event_timestamp)                                  as last_event_at

    from events
    group by user_id

)

select * from aggregated