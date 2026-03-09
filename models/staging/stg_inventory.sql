with source as (
    select * from {{ source('raw', 'inventory') }}
),

cleaned as (
    select
        inventory_id,
        product_id,
        store_id,
        case
            when quantity_on_hand < 0 then 0
            else quantity_on_hand
        end as quantity_on_hand,
        case
            when reorder_point = '' or reorder_point is null then null
            else cast(reorder_point as integer)
        end as reorder_point,
        -- handle mixed date formats: try standard YYYY-MM-DD first
        case
            when last_restocked ~ '^\d{4}-\d{2}-\d{2}$' then cast(last_restocked as date)
            when last_restocked ~ '^\d{4}/\d{2}/\d{2}$' then cast(replace(last_restocked, '/', '-') as date)
            else null  -- non-standard formats flagged as null for safety
        end as last_restocked
    from source
    where inventory_id is not null
)

select * from cleaned
