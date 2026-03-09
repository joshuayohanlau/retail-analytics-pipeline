with source as (
    select * from {{ source('raw', 'stores') }}
),

cleaned as (
    select
        store_id,
        trim(store_name) as store_name,
        lower(trim(store_type)) as store_type,
        trim(city) as city,
        trim(region) as region,
        cast(opened_date as date) as opened_date,
        case
            when cast(opened_date as date) > current_date then true
            else false
        end as is_future_store
    from source
    where store_id is not null
)

select * from cleaned
