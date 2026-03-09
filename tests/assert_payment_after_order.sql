-- fails if any payment was processed before its order was placed
select
    payment_id,
    payment_date,
    order_date
from {{ ref('fct_payments') }}
where payment_date is not null
  and payment_date < order_date
