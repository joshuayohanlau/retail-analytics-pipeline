with source as (
    select * from {{ source('raw', 'web_activity') }}
),

cleaned as (
    select
        session_id,
        case
            when customer_id = '' or customer_id is null then null
            else customer_id
        end as customer_id,
        trim(page_url) as page_url,
        lower(trim(event_type)) as event_type,
        cast(event_timestamp as timestamp) as event_timestamp,
        lower(trim(device_type)) as device_type,
        trim(browser) as browser,
        case
            when referrer_source = '' or referrer_source is null then 'direct'
            else lower(trim(referrer_source))
        end as referrer_source
    from source
    where session_id is not null
      and device_type != 'bot'
      and cast(event_timestamp as timestamp) >= '2020-01-01'
      and cast(event_timestamp as timestamp) <= current_timestamp
)

select * from cleaned
