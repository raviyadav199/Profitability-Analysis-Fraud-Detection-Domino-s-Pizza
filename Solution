# Profitability-Analysis-Fraud-Detection-Domino-s-Pizza
Suppose you are a senior manager at Domino's Pizza and your job is to manage operations in Mumbai. The company has come up with an attractive offer for new customers: each new customer who signs up can avail a discount of 75% on their first order with a maximum cap of ?500. Everything seems to be going well in all the areas in Mumbai, except in Chembur. An unexpectedly number of customers are signing up on a daily basis. Find reason for this?

Problem statement: There are many customers who repeatedly tried to sign up to receive discounts on their orders.
One of the reasons can be that the same customers who signed up earlier are using different mobile numbers to avail the 75% discount on their orders. 
You could prevent this by extracting the customer IDs that have the same email address, residential address and other such details. In such cases, there is a strong likelihood of fraud customers.

**Profitability analysis:** Performed a profitability analysis on the 'market star' schema by identifying sustainable/profitable product categories so that the growth team can capitalise on them and increase sales. 
Calculated:
# Profits per product category---
USE market_star_schema;
Select p.Product_Category,
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
Order by p.Product_Category,
              sum(m.Profit);


## Profits per product subcategory
Select Ord_id, Order_Number
 from orders_dimen
 Group By 
   Ord_id, 
   Order_Number
Order By 
   Ord_id, 
   Order_Number;

# Average profit per order
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


## Average profit percentage per order
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



 # We also identified the ten most profitable customers.
 **Fraud detection: Finally, we found out the details of fraud customers after retrieving their data in the following 
 columns:**

'cust_id'
'cust_name'
'city'
'state'
'customer_segment'

## A flag to indicate that there is another customer with the exact same name and city but a different customer ID.
Select * 
  from 
  cust_dimen;
# list of customers who have not placed any orders--
Select c.* 
  from 
  cust_dimen as c
  Left Join
	market_fact_full as m
    on c.Cust_id= m.Cust_id
where m.Ord_id IS NULL;

select count(distinct cust_id) from cust_dimen;
## 1832


select count(distinct cust_id) from market_fact_full;
## 6
## Exploring order per user --

Select c.*,
	Count(distinct Ord_id) as order_count
  from 
  cust_dimen as c
  Left Join
	market_fact_full as m
    on c.Cust_id= m.Cust_id
group by Cust_id
Having Count(distinct Ord_id)<>1;

 # unique customer name and city check
 Select Customer_Name, City,
		count(cust_id) as cust_id_count
	From cust_dimen
group by Customer_Name,
		City
Having count(cust_id)>1;

# Final Output --
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

  
  
