with customers as (
    select * from {{ ref('stg_customers') }}
),

order_stats as (
    select
        customer_id,
        count(distinct order_id) as total_orders,
        min(order_date) as first_order_date,
        max(order_date) as last_order_date
    from {{ ref('stg_orders') }}
    group by customer_id
),

spend_stats as (
    select
        o.customer_id,
        sum(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100)) as lifetime_spend
    from {{ ref('stg_order_items') }} oi
    inner join {{ ref('stg_orders') }} o on oi.order_id = o.order_id
    group by o.customer_id
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        c.full_name,
        c.email,
        c.phone,
        c.signup_date,
        c.city,
        c.region,
        c.customer_type,
        coalesce(os.total_orders, 0) as total_orders,
        os.first_order_date,
        os.last_order_date,
        coalesce(round(cast(ss.lifetime_spend as numeric), 2), 0) as lifetime_spend,
        case
            when coalesce(os.total_orders, 0) = 0 then 'never_purchased'
            when os.total_orders = 1 then 'one_time'
            when os.total_orders >= 2 then 'repeat'
        end as purchase_segment
    from customers c
    left join order_stats os on c.customer_id = os.customer_id
    left join spend_stats ss on c.customer_id = ss.customer_id
)

select * from final
