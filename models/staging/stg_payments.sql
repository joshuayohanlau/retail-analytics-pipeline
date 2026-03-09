with source as (
    select * from {{ source('raw', 'payments') }}
),

deduped as (
    select *,
        row_number() over (partition by payment_id order by payment_date desc) as rn
    from source
),

cleaned as (
    select
        payment_id,
        order_id,
        case
            when payment_method in ('UNKNOWN', 'N/A', '???', 'other') then 'other'
            else lower(trim(payment_method))
        end as payment_method,
        case
            when payment_date = '' or payment_date is null then null
            else cast(payment_date as date)
        end as payment_date,
        amount,
        lower(trim(payment_status)) as payment_status
    from deduped
    where rn = 1
      and payment_id is not null
)

select * from cleaned
