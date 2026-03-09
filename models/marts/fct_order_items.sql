with order_items as (
    select * from {{ ref('stg_order_items') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

final as (
    select
        oi.order_item_id,
        oi.order_id,
        o.customer_id,
        oi.product_id,
        o.store_id,
        o.order_date,
        o.order_status,
        o.shipping_method,
        oi.quantity,
        oi.unit_price,
        oi.discount_pct,
        round(cast(oi.quantity * oi.unit_price as numeric), 2) as gross_amount,
        round(cast(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100) as numeric), 2) as line_total
    from order_items oi
    inner join orders o on oi.order_id = o.order_id
)

select * from final
