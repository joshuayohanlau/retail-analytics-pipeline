with payments as (
    select * from {{ ref('stg_payments') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        p.payment_id,
        p.order_id,
        o.customer_id,
        o.store_id,
        p.payment_method,
        p.payment_date,
        o.order_date,
        p.amount,
        p.payment_status
    from payments p
    inner join orders o on p.order_id = o.order_id
)

select * from final
