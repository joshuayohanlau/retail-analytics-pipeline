-- fails if any non-null emails are missing the @ symbol
select
    customer_id,
    email
from {{ ref('dim_customers') }}
where email is not null
  and email not like '%@%'
