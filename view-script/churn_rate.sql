--- viewing the dataset
select * from databel

--- getting the number of rows

select count(*) from databel;

set search_path to churn_rate


                     --- Data cleaning
--1 Renaming the columns using the snake method
ALTER TABLE databel
RENAME column "Customer ID" TO  customer_id

alter table databel 
rename column "Churn Label" to churn_label;

alter table databel
rename column "Account Length (in months)" to account_length_months;

alter table databel
rename column "Local Calls" to local_calls;

alter table databel 
rename column "Local Mins" to local_mins;

alter table databel 
rename column "Intl Calls" to intl_calls;

alter table databel
rename column "Intl Mins" to intl_mins;

alter table databel
rename column "Intl Active" to intl_active;

alter table databel
rename column "Intl Plan" to intl_plan;

alter table databel
rename column "Avg Monthly GB Download" to avg_montly_gb_download;

----
alter table databel
rename column "Extra International Charges" to extra_international_charges;


alter table databel
rename column "Customer Service Calls" to customer_service_calls;

alter table databel
rename column "Avg Monthly GB Download" to avg_montly_gb_download;


alter table databel
rename column "Unlimited Data Plan" to unlimited_data_plan;

alter table databel
rename column "Extra Data Charges" to extra_data_charges;
--
alter table databel
rename column "State" to state;

alter table databel
rename column "Phone Number" to phone_number;

alter table databel
rename column "Gender" to gender;

alter table databel
rename column "Age" to age;


alter table databel
rename column "Under 30" to under_30;

alter table databel
rename column "Senior" to senior;


--- to check the datatypes 
select* 
from information_schema.columns
where table_schema='churn_rate'
  and table_name = 'databel'
  
 
  
--- checking for duplicates in customer_id
 select count(customer_id),phone_number
 from databel 
 group by customer_id,phone_number 
 having count(customer_id)>=1  
 
 --- checking for duplicates in customer_id
select count(customer_id),payment_method
from databel
group by customer_id,payment_method
having count(customer_id)>1;
  
--- checking the total number of customers 
 select count(distinct customer_id)from databel;

---updating the  column churn_reason missing blanks with "not defined"
update databel
set churn_reason = 'not defined'
where churn_reason = ''

-- checking the number of missing(blanks) in column churn_reason
select count (churn_reason) as missing from databel
where churn_reason = ''
  
  select * from databel
  
  set search_path to churn_rate
  ----                              Questions to consider
--1 What is the average churn rate?
select avg(case when churn_label='Yes' then 1 else 0 end)::numeric(10,2) as avg_churn
from databel;

-- 2 What are the main reasons customers churn?
select churn_reason, count(churn_reason) as reasons_for_count
from databel
group by churn_reason 
order by reasons_for_count desc
limit 5;


---3 Are there differences in churn rate between customers that consume less than 3 GB of data and more than that?

---3(i) using subquery: Customers that consume less than 3GB and more than that
select  usage_category,avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion
from ( select *, case when avg_montly_gb_download <= 3 then 'low usage (<=3)' else'high usage (>3)'end as usage_category
from databel)
group by usage_category; 

----(bi) using where clause LOW_USAGE
select avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion_less_than_3gb from databel
where avg_montly_gb_download <= 3

----(bii) High_asage
select avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion_more_than_3gb from databel
where avg_montly_gb_download > 3

---4 Do you see differences between customers with an unlimited subscription?
select  usage_category,avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion
from ( select *, case when avg_montly_gb_download <= 3 then 'low usage (<=3)' else'high usage (>3)'end as usage_category
from databel where unlimited_data_plan='Yes')
group by usage_category; 

--- 5 analysis Based on Demographics 
--- (i)gender
select gender,avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion_per_gender
from databel 
group by gender;

----(ii) age
select age_category, (avg(case when churn_label='Yes' then 1 else 0 end))::numeric (10,2) as avg_churn
from (select *, case 
	when age>0 and age<=30 then 'youths'
	when age>31 and age<=50 then 'adults'
	else 'seniors'
end as age_category
from databel)
group by age_category;


---6 analysis based on contract

----(i) contract_type
select contract_type,avg(case when churn_label='Yes' then 1 else 0 end )::NUMERIC(10,2) as churned_proportion_per_contract
from databel 
group by contract_type 
order by churned_proportion_per_contract desc;

----(iii) Churn Analysis based on payment method
select payment_method, (avg(case when churn_label='Yes' then 1 else 0 end))::numeric (10,2) as avg_churn
from databel
group by payment_method
order by avg_churn desc


---- 7 Analysis based on geographical location
-----(i)state
select state, (avg(case when churn_label='Yes' then 1 else 0 end))::numeric (10,2) as avg_churn_location
from databel 
group by state
order by avg_churn_location desc
limit 2;










 
  
  
--- 4 Average customers who did not churn 
select avg(case when churn_label <> 'Yes' then 1 else 0 end)::numeric(10,2) as avg_churn
from databel;

