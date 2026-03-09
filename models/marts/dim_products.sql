with products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        product_id,
        product_name,
        category,
        subcategory,
        unit_price,
        supplier,
        case
            when unit_price < 25 then 'budget'
            when unit_price < 100 then 'mid_range'
            when unit_price < 300 then 'premium'
            else 'luxury'
        end as price_tier
    from products
)

select * from final
