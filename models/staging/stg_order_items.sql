with source as (
    select * from {{ source('raw', 'order_items') }}
),

cleaned as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        case
            when discount_pct < 0 then 0
            else discount_pct
        end as discount_pct
    from source
    where order_item_id is not null
      and quantity > 0
      and unit_price > 0
)

select * from cleaned
