with source as (
    select * from {{ source('raw', 'orders') }}
),

deduped as (
    select *,
        row_number() over (partition by order_id order by order_date desc) as rn
    from source
),

cleaned as (
    select
        order_id,
        customer_id,
        store_id,
        cast(order_date as date) as order_date,
        case
            when status = '' or status is null then 'unknown'
            else lower(trim(status))
        end as order_status,
        lower(trim(shipping_method)) as shipping_method
    from deduped
    where rn = 1
      and order_id is not null
      and order_date != ''
      and cast(order_date as date) <= current_date
)

select * from cleaned
