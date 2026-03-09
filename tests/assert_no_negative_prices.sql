-- fails if any line items have negative prices
select
    order_item_id,
    unit_price
from {{ ref('fct_order_items') }}
where unit_price < 0
