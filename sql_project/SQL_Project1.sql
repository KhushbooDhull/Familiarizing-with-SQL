create database sql_project1;
use sql_project1;

select * from customer; -- C_ID,M_ID,C_NAME,C_EMAIL_ID,C_TYPE,C_ADDR,C_CONT_NO
select * from employee_details; -- E_ID,E_NAME,E_DESIGNATION,E_ADDR,E_BRANCH,E_CONT_NO
select * from employee_manages_shipment;-- Employee_E_ID,Shipment_Sh_ID,Status_Sh_ID
select * from membership; -- M_ID,Start_date,End_date
select * from payment_details; -- Payment_ID,C_ID,SH_ID,AMOUNT,Payment_Status,Payment_Mode,Payment_Date
select * from shipment_details; -- SH_ID,C_ID,SH_CONTENT,SH_DOMAIN,SER_TYPE,SH_WEIGHT,SH_CHARGES,SR_ADDR,DS_ADDR
select * from status; -- SH_ID,Current_Status,Sent_date,Delivery_date

-- SQL_Project_Questions:

-- Q1) Select count of customers based on customer type
select c_type,count(c_type) from customer
group by c_type;

-- Q2) Select branch wise count of emp in descending order of count
select e_branch, count(e_branch) from employee_details
group by e_branch
order by count(e_branch) desc;

-- Q3) Select designation wise count of emp ID in descending order of count
select e_designation, count(e_designation) from employee_details
group by e_designation
order by count(e_designation) desc;

select e_designation, count(e_id) from employee_details
group by e_designation
order by count(e_designation) desc;

-- Q4) Select Count of customer based on payment status in descending order of count
select payment_status, count(c_id) as No_Of_Customers from payment_details
group by payment_status
order by count(c_id) desc;

-- Q5) Select Count of customer based on payment mode in descending order of count
select payment_mode, count(c_id) as No_Of_Customers from payment_details
group by payment_mode
order by count(c_id) desc;

-- Q6) Select Count of customer based on shipment_domain in descending order of count
select SH_DOMAIN, count(c_id) as No_Of_Customers from shipment_details
group by SH_DOMAIN
order by count(c_id) desc;

-- Q7) Select Count of customer based on ser_type in descending order of count
select ser_type, count(c_id) as No_Of_Customers from shipment_details
group by ser_type
order by count(c_id) desc;

-- Q8) Select Count of customer based on sh_content in descending order of count
select sh_content, count(c_id) as No_Of_Customers from shipment_details
group by sh_content
order by count(c_id) desc;

-- Q9) Find C_ID,M_ID and tenure for those customers whose membership tenure is over 10 years.
-- Sort them in decreasing order of Tenure
select timestampdiff(year,start_date,end_date) as tenure from membership;

select c.c_id, m.m_id, timestampdiff(year,m.start_date,m.end_date) as tenure from customer c
join membership m
on c.m_id=m.m_id
having tenure > 10
order by tenure desc;

-- Q10) Find average payment amount based on Customer Type where payment mode as COD
select avg(p.amount) as avg_payment ,c.c_type, p.payment_mode from customer c
join payment_details p
on c.c_id=p.c_id
where p.payment_mode ='COD'
group by c.c_type
order by avg_payment;

select avg(p.amount) as avg_payment ,c.c_type from customer c
join payment_details p
on c.c_id=p.c_id
where p.payment_mode ='COD'
group by c.c_type
order by avg_payment;

-- Q11) Find avg payment amount based on payment mode where payment date is not null
select avg(amount), payment_mode from payment_details
where payment_date!=''
group by payment_mode;

select avg(amount) ,payment_mode 
from payment_details
where year(Payment_Date)>1
group by payment_mode;

select avg(amount), payment_mode from payment_details
group by payment_mode;

select avg(amount), payment_mode from payment_details
where payment_date is not null 
group by payment_mode;


select avg(amount), payment_mode from payment_details
where payment_status ='PAID'
group by payment_mode;

-- Q12) Find sum of shipment charges based on payment_mode where service type is not regular
select sum(s.sh_charges),p.payment_mode from payment_details p
join shipment_details s
on p.SH_ID=s.SH_ID
where s.ser_type !='regular'
group by p.payment_mode;

-- Q13) Find avg shipment weight based on payment_status where shipment content does not start with H
select s.SH_content,avg(s.SH_WEIGHT),p.Payment_Status from payment_details p
join shipment_details s
on p.SH_ID=s.SH_ID
group by p.Payment_Status,s.SH_content;

select s.SH_content,avg(s.SH_WEIGHT),p.Payment_Status from payment_details p
join shipment_details s
on p.SH_ID=s.SH_ID
where s.SH_content not like 'h%'
group by p.Payment_Status,s.SH_content;

select avg(s.SH_WEIGHT),p.Payment_Status from payment_details p
join shipment_details s
on p.SH_ID=s.SH_ID
where s.SH_content not like 'h%'
group by p.Payment_Status;

-- Q14) Find mean of payment amount based on shipping domain where service type 
-- is Express and payment status is paid
select avg(p.amount),s.SH_DOMAIN from payment_details p
join shipment_details s
on p.SH_ID=s.SH_ID
where s.ser_type='express' and p.Payment_Status='paid'
group by s.SH_DOMAIN;

-- Q15) Find avg of shipment weight and shipment charges based on shipment status
select avg(s.SH_WEIGHT),avg(s.SH_CHARGES),q.Current_Status from status q
join shipment_details s
on q.SH_ID=s.SH_ID
group by q.Current_Status;

-- Q16) Display Sh_ID, shipment status,shipment_weight and delivery date where 
-- shipment weight is over 1000 and payment is done is Quarter 3 
-- (format - month date year)
select s.sh_id, sh.current_status, s.sh_weight, sh.delivery_date 
from shipment_details s, status sh , payment_details p
where sh.SH_ID=s.sh_id  and p.SH_ID=sh.SH_ID 
and monthname(p.payment_date) in('july','august', 'september')
order by sh.delivery_date desc;

-- Q17) Display Sh_ID, shipment charges and shipment_weight and sent date where 
-- current_status is Not delivered and payment mode is Card_Payment
select s.sh_id,s.SH_CHARGES,s.SH_weight ,q.sent_date from status q
join shipment_details s
on q.SH_ID=s.SH_ID
join payment_details p
on s.SH_ID=p.SH_ID
where q.current_status ='NOT DELIVERED' and p.payment_mode='CARD PAYMENT';

-- Q18) Select all records from shipment_details where shipping charges is greater than 
-- avg shipping charges for all the customers
select * from shipment_details
where SH_CHARGES >(select avg(SH_CHARGES)from shipment_details); -- avg sh_charges --> 937.9700

-- Q19) Select average shipping weight and sum of shipping charges based on
-- shipping domain.
select avg(sh_weight),sum(sh_charges),sh_domain from shipment_details
group by sh_domain;

-- Q20) Find customer names, their email, contact,c_type and payment amount where C_type 
-- is either Wholesale or Retail
select c_name,c.C_EMAIL_ID, c.C_CONT_NO, c.C_TYPE, p.amount from customer c
join payment_details p
on c.C_ID=p.C_ID
where c.c_type= 'Wholesale' or c.c_type='retail'
order by c.c_type,p.amount;

-- Q21) Find Emp_Id,Emp_Name, C_Id, shipping charges  the employees are managing customers 
-- whose shipping charges are over 1000
select e1.Employee_e_id,e.e_name,s.c_id,s.SH_CHARGES from shipment_details s
join employee_manages_shipment e1
on e1.Shipment_Sh_ID = s.SH_ID
join employee_details e
on e1.Employee_E_ID = e.E_ID
where s.SH_CHARGES > 1000
order by s.SH_CHARGES desc;

-- Q22) Find Emp_deisgnation wise the count of Customers that the employees of different
-- designation are handling in decreasing order of customer count
select count(c.c_id) as no_of_customer_handled, e.e_designation
from employee_details e , customer c , shipment_details s , employee_manages_shipment ems
where c.c_id=s.C_ID and ems.Employee_E_ID= e.e_id and s.sh_id=ems.Shipment_Sh_ID
group by e.E_DESIGNATION
order by no_of_customer_handled desc;


-- Q23) Find Emp_deisgnation wise the count of Customers that the employees of different
-- designation are handling in decreasing order of customer count where the employess are
-- handling customers whose payment amount is greater than 
-- avg payment amount by all other customers
select count(c.c_id) as no_of_customers_handled , e.e_designation
from employee_details e , customer c , shipment_details s , employee_manages_shipment ems, payment_details p
where c.c_id=s.C_ID and ems.Employee_E_ID= e.e_id and s.sh_id=ems.Shipment_Sh_ID and p.c_id=c.c_id and
p.amount>(select avg(amount) from payment_details)
group by e.E_DESIGNATION
order by no_of_customers_handled desc;

-- Q24) Find Employee branch and employee designation wise count of employee designation
-- who have managed customers whose shipping weight < 500. 
-- Display result in descending order of count
select count(c.c_id), e.e_branch , e.E_DESIGNATION
from employee_details e , customer c , shipment_details s , employee_manages_shipment ems
where c.c_id=s.C_ID and ems.Employee_E_ID= e.e_id and s.sh_id=ems.Shipment_Sh_ID
and s.SH_WEIGHT<500
group by e.E_DESIGNATION,e.e_branch
order by count(c.c_id) desc;

-- Q25) Find shipping content wise count of Employees for the employees who have managed
-- customers where shipping domain is International and shipping charges are greater 
-- than average shiiping charges for all the cutomers.
-- Display result in descending order of count.
select count(e.employee_e_id), s.sh_content
from employee_manages_shipment e 
join shipment_details s 
on e.Shipment_Sh_ID=s.sh_id
where s.SH_DOMAIN ='International'
and s.SH_CHARGES>(select avg(s.SH_CHARGES) from shipment_details s)
group by s.SH_CONTENT
order by count(e.employee_e_id) desc;


