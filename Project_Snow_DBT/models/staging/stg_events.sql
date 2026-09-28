-- Staging des événements : extraction des champs du JSON (VARIANT)
with source as (

    select * from {{ source('raw', 'events') }}

),

parsed as (

    select
        raw_data:user_id::string            as user_id,
        raw_data:event_type::string         as event_type,
        raw_data:timestamp::timestamp_ntz   as event_timestamp
    from source

)

select * from parsed