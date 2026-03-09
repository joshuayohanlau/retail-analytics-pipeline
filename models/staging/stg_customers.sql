with source as (
    select * from {{ source('raw', 'customers') }}
),

-- deduplicate on customer_id, keep first occurrence
deduped as (
    select *,
        row_number() over (partition by customer_id order by signup_date desc) as rn
    from source
),

cleaned as (
    select
        customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        trim(first_name) || ' ' || trim(last_name) as full_name,
        case
            when email = '' then null
            when email not like '%@%' then null
            else lower(trim(email))
        end as email,
        case
            when phone = '' then null
            else trim(phone)
        end as phone,
        cast(signup_date as date) as signup_date,
        trim(city) as city,
        trim(region) as region,
        lower(trim(customer_type)) as customer_type
    from deduped
    where rn = 1
      and customer_id is not null
)

select * from cleaned
