with source as (
    select * from {{ source('raw', 'products') }}
),

cleaned as (
    select
        product_id,
        trim(product_name) as product_name,
        case
            when category = '' or category is null then 'Unknown'
            when lower(trim(category)) = 'electornics' then 'Electronics'
            when lower(trim(category)) = 'home and garden' then 'Home & Garden'
            when lower(trim(category)) = 'home&garden' then 'Home & Garden'
            when lower(trim(category)) = 'apparel' then 'Clothing'
            when lower(trim(category)) = 'sport' then 'Sports'
            else initcap(lower(trim(category)))
        end as category,
        trim(subcategory) as subcategory,
        unit_price,
        trim(supplier) as supplier
    from source
    where product_id is not null
      and unit_price > 0
)

select * from cleaned
