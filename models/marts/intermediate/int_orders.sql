with
orders as (
Select * from  {{ ref("stg_orders") }}
),

payment as (
Select * from  {{ ref("stg_payment") }}
where payment_status != 'fail'
),

order_totals as (
    Select
    order_id,
    payment_status,
    sum(payment_amount) as order_value_dollars
    from payment
    group by 1,2

),

order_values_joined as (

    select
    orders.*,
    order_totals.payment_status,
    order_totals.order_value_dollars
    from orders
    left join order_totals
        on orders.order_id = order_totals.order_id
)

select * from order_values_joined