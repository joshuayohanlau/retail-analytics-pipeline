-- fails if any orders have dates in the future
select
    order_item_id,
    order_date
from {{ ref('fct_order_items') }}
where order_date > current_date
