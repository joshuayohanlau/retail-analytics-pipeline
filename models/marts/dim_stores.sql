with stores as (
    select * from {{ ref('stg_stores') }}
),

final as (
    select
        store_id,
        store_name,
        store_type,
        city,
        region,
        opened_date,
        is_future_store
    from stores
)

select * from final
