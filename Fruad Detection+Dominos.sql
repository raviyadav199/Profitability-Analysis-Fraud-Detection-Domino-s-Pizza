/*----------------------------------------------------------------------

Problem statement:
We can look at the profit per product category.
We can look at the profit per product sub-category.
We can check average profit per order.
Also consider average profit % per order
---------------------------------------------------------------------------*/
USE market_star_schema;

Select
  p.Product_Category,
  sum(m.Profit) as Profits,
 round(Sum(m.Profit)/count(distinct o.Order_Number),2)as Avg_Profit_Order
from market_fact_full as m 
Inner Join 
prod_dimen as p
on m.prod_id = p.prod_id
inner join 
orders_dimen as o
on m.Ord_id= o.Ord_id
group by 
 p.Product_Category
Order by  p.Product_Category,
              sum(m.Profit);
 
 Select Ord_id, Order_Number
 
 from orders_dimen
 Group By 
   Ord_id, 
   Order_Number
Order By 
   Ord_id, 
   Order_Number;
   
   -- average profit per order ---
   Select
  p.Product_Category,
  sum(m.Profit) as Profits,
 round(Sum(m.Profit)/count(distinct o.Order_Number),2)as Avg_Profit_Order
from market_fact_full as m 
Inner Join 
prod_dimen as p
on m.prod_id = p.prod_id
inner join 
orders_dimen as o
on m.Ord_id= o.Ord_id
group by 
 p.Product_Category
Order by  p.Product_Category,
              sum(m.Profit);
-- profit percentage --
Select
  p.Product_Category,
  sum(m.Profit) as Profits,
  count(distinct o.Order_number) as total_orders,
  round(Sum(m.Profit)/count(distinct o.Order_Number),2)as Avg_Profit_Order,
  round(Sum(m.Sales)/count(distinct o.Order_Number),2) as Avg_Sale_per_Order,
  round(Sum(m.Profit)/Sum(m.Sales),4)*100 as Profit_percentage
from 
  market_fact_full as m 
 Inner Join 
	prod_dimen as p
		on m.prod_id = p.prod_id
			inner join 
				orders_dimen as o
					on m.Ord_id= o.Ord_id
	group by 
		p.Product_Category
		Order by  p.Product_Category,
	    sum(m.Profit);
      
/*---- Problem Statement: get the details of top 10 profitable customers in form of a table shown below:
cust_id
rank
customer_name
profit
customer_city
customer_State
Sales
--------------*/
-- Exploring cust_dimen table
Select
   cust_id,
   customer_name,
   city as customer_city,
   State as customer_state
   from
    cust_dimen;
-- ranking --

with cust_summary As
(select
   c.Cust_id,
   rank() over (order by sum(Profit)desc) as customer_rank,  
   customer_name,
   round(sum(Profit),2) as profit,
   city as customer_city,
   State as customer_state,
   round(sum(Sales),2) as sales
from
    cust_dimen as c
    Inner Join 
		market_fact_full as m 
		on c.Cust_id = m.Cust_id
        group by (Cust_id)
)
select * from cust_summary
 where customer_rank<=10; 
  
/*-- Problem statement: Extract the required details of the customers who have not placed an order yet.
Expected columns: The columns that are required as the output are as follows:

'cust_id'
'cust_name'
'city'
'state'
'customer_segment'
A flag to indicate that there is another customer with the exact same name and city but a different customer ID.----*/
-- exploring cust-dimen table ---
Select * 
  from 
  cust_dimen;
-- list of customers who have not placed any orders--
Select c.* 
  from 
  cust_dimen as c
  Left Join
	market_fact_full as m
    on c.Cust_id= m.Cust_id
where m.Ord_id IS NULL;

select count(distinct cust_id) from cust_dimen;
-- 1832
select count(distinct cust_id) from market_fact_full;
-- 6
/*-- Problem statement: Extract the required details of the customers who have placed only one order.
Expected columns: The columns that are required as the output are as follows:

'cust_id'
'cust_name'
'city'
'state'
'customer_segment'
A flag to indicate that there is another customer with the exact same name and city but a different customer ID.----*/
-- exploring cust-dimen table ---

-- Exploring order per user --

Select c.*,
	Count(distinct Ord_id) as order_count
  from 
  cust_dimen as c
  Left Join
	market_fact_full as m
    on c.Cust_id= m.Cust_id
group by Cust_id
Having Count(distinct Ord_id)<>1;

-- unique customer name and city check --

Select Customer_Name, City,
		count(cust_id) as cust_id_count
	From cust_dimen
group by Customer_Name,
		City
Having count(cust_id)>1;

-- Final Output --
with Cust_Details as
(
Select c.*,
	Count(distinct Ord_id) as order_count
  from 
  cust_dimen as c
  Left Join
	market_fact_full as m
    on c.Cust_id= m.Cust_id
group by Cust_id
Having Count(distinct Ord_id)<>1
),
fraud_cust_list as
(Select Customer_Name, City,
		count(cust_id) as cust_id_count
	From cust_dimen
group by Customer_Name,
		City
Having count(cust_id)>1
)
Select 
     CD.*, 
	 Case when FC.cust_id_count is not NUll 
			Then 'Fruad Customer' 
		else 'Normal' 
	end as fruad_flag
	From Cust_Details as CD
    Left Join fraud_cust_list as FC
    on CD.Customer_Name = FC.Customer_Name AND
    CD.City = FC.City;
