with date_spine as (
    select
        generate_series(
            '2020-01-01'::date,
            '2026-12-31'::date,
            '1 day'::interval
        )::date as date_key
),

final as (
    select
        date_key,
        date_key as full_date,
        extract(day from date_key)::int as day_of_month,
        to_char(date_key, 'Day') as day_name,
        extract(dow from date_key)::int as day_of_week,
        extract(week from date_key)::int as week_number,
        extract(month from date_key)::int as month_number,
        to_char(date_key, 'Month') as month_name,
        extract(quarter from date_key)::int as quarter,
        extract(year from date_key)::int as year,
        case
            when extract(dow from date_key) in (0, 6) then true
            else false
        end as is_weekend
    from date_spine
)

select * from final
