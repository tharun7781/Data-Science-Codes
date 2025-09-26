-- 1.Find customers born after the year 1990.

SELECT cust_first_name, cust_last_name, cust_year_of_birth
FROM sh.customers
WHERE cust_year_of_birth > 1990;

-- 2.List all male customers (`CUST_GENDER = 'M'`).
SELECT cust_first_name, cust_last_name, cust_gender 
from sh.customers 
where cust_gender = 'M'

-- 3.Retrieve all female customers (`CUST_GENDER = 'F'`) living in Sydney.
select *from sh.customers
where cust_city = 'Sydney' 
and cust_gender = 'F'

-- 4. Find customers with income level `"G: 130,000 - 149,999"`.
select cust_first_name,cust_last_name , cust_income_level
from sh.customers 
where cust_income_level between  'G: 130,000'
and 'G: 149,999'

--5. Get all customers with a credit limit above 10,000.
select cust_first_name,cust_last_name ,cust_credit_limit
from sh.customers
where cust_credit_limit > 10000;

--6. Retrieve customers from the state "California".
select cust_first_name,cust_last_name , cust_city
from sh.customers
where cust_city = 'california';

--7. Find customers who have provided an email address.
select cust_first_name,cust_last_name ,cust_email
from sh.customers
where cust_email is not null

--8. List customers with missing marital status.
select cust_first_name,cust_last_name ,cust_marital_status
from sh.customers
where cust_marital_status is null

--9. Find customers whose postal code starts with "53".
select cust_first_name,cust_last_name ,cust_postal_code
from sh.customers
where cust_postal_code like '53%'

--10. Get customers born before 1980 with a credit limit above 5,000.
select cust_first_name,cust_last_name ,cust_year_of_birth,cust_credit_limit
from sh.customers
where cust_year_of_birth < 1980 
and cust_credit_limit > 5000;

--11. Retrieve customers from Almere or Amersfoort.
select cust_first_name,cust_last_name ,cust_city
from sh.customers
where cust_city = 'Amersfoort'

--12. Find customers who do not have a credit limit.
select cust_first_name,cust_last_name ,cust_credit_limit
from sh.customers
where cust_credit_limit is null

--13. List customers whose phone number starts with "487".
select cust_first_name,cust_last_name ,cust_main_phone_number
from sh.customers
where cust_main_phone_number like '487%'

--14 Find married customers with income level `"Medium"`.
select cust_first_name,cust_last_name ,cust_marital_status,cust_income_level
from sh.customers
where cust_marital_status = 'married' 
and cust_income_level = 'Medium';

--15  Get customers whose last name starts with "G".
select cust_first_name,cust_last_name , cust_first_name || cust_last_name 
from sh.customers
where cust_last_name  like 'G%';

--16. Find customers with city_id = 51057.
select cust_first_name,cust_last_name , cust_city_id , cust_first_name || cust_last_name 
from sh.customers
where cust_city_id = 51057

--17.Retrieve all customers who are valid (`CUST_VALID = 'A'`).

select cust_first_name,cust_last_name , cust_valid , cust_first_name || cust_last_name
from sh.customers 
where cust_valid = 'A';

-- 18. Find customers whose effective start date (`CUST_EFF_FROM`) is after 2020.
select cust_first_name,cust_last_name , cust_eff_from, cust_first_name || cust_last_name
from sh.customers 
where cust_eff_from > DATE '2020-01-01';

-- 19. Retrieve customers whose effective end date (`CUST_EFF_TO`) is before 2021.
select cust_first_name,cust_last_name , cust_eff_to, cust_first_name || cust_last_name
from sh.customers 
where cust_eff_to < DATE '2021-01-01';

--20. Find customers with credit limit between 5,000 and 9,000.
select cust_first_name, cust_last_name, cust_credit_limit
from sh.customers
where cust_credit_limit  between 5000 and 9000

--21. Get all customers from country_id = 101.
select cust_first_name, cust_last_name, COUNTRY_ID
from sh.customers
where country_id = 101

--22. Find customers whose email ends with `"@company.example.com"`.
select cust_first_name, cust_last_name, cust_email
from sh.customers
where cust_email like '@company.example.com%';

--23.  List customers with `CUST_TOTAL_ID = 52772`.

select cust_first_name, cust_last_name, cust_total_id
from sh.customers
where cust_total_id = 52772

--24 Find customers with `CUST_SRC_ID` in (10, 20, 30).

select cust_first_name, cust_last_name, cust_src_id
from sh.customers
where cust_src_id in (10,20,30)

--25. Retrieve customers who either do not have email or do not have a credit limit.
select cust_first_name, cust_last_name, cust_email,cust_credit_limit
from sh.customers
where cust_email and cust_credit_limit is null 

-- GroupBy and Having Functions --

-----------------------------------


-- 26. Count the number of customers in each city.

select cust_city, count(*)
from sh.customers 
group by cust_city

-- 27. Find cities with more than 100 customers.

select cust_city, count(*)
from sh.customers 
group by cust_city having count(*) >100

-- 28. Count the number of customers in each state.

select cust_state_province, count(*)
from sh.customers 
group by cust_state_province

-- 29. Find states with fewer than 50 customers.

select cust_state_province, count(*)
from sh.customers 
group by cust_state_province having count(*)<50

-- 30. Calculate the average credit limit of customers in each city.

select cust_city, avg(cust_credit_limit)
from sh.customers
group by cust_city

-- 31. Find cities with average credit limit greater than 8,000.

select cust_city, avg(cust_credit_limit)
from sh.customers
group by cust_city having avg(cust_credit_limit)>8000

-- 32. Count customers by marital status.

select cust_marital_status, count(*)
from sh.customers
group by cust_marital_status 

-- 33. Find marital statuses with more than 200 customers.

select cust_marital_status, count(*)
from sh.customers
group by cust_marital_status having count(*)>200

-- 34. Calculate the average year of birth grouped by gender.

select cust_gender, avg(cust_year_of_birth)
from sh.customers
group by cust_gender 

-- 35. Find genders with average year of birth after 1990.

select cust_gender, avg(cust_year_of_birth)
from sh.customers
group by cust_gender having avg(cust_year_of_birth)>1990

-- 36. Count the number of customers in each country.

select COUNTRY_ID, count(*)
from sh.customers 
group by country_id

-- 37. Find countries with more than 1,000 customers.

select COUNTRY_ID, count(*)
from sh.customers 
group by country_id having count(*)>1000

-- 38. Calculate the total credit limit per state.

select cust_state_province, sum(cust_credit_limit)
from sh.customers
group by cust_state_province 

-- 39. Find states where the total credit limit exceeds 100,000.

select cust_state_province, sum(cust_credit_limit)
from sh.customers
group by cust_state_province having sum(cust_credit_limit)>100000

-- 40. Find the maximum credit limit for each income level.

select cust_income_level, max(cust_credit_limit)
from sh.customers
group by cust_income_level

-- 41. Find income levels where the maximum credit limit is greater than 15,000.

select cust_income_level, max(cust_credit_limit)
from sh.customers
group by cust_income_level having max(cust_credit_limit)>15000

-- 42. Count customers by year of birth.

SELECT cust_year_of_birth,COUNT(*)
FROM sh.customers
GROUP BY cust_year_of_birth

-- 43. Find years of birth with more than 50 customers.

SELECT cust_year_of_birth,COUNT(*)
FROM sh.customers
GROUP BY cust_year_of_birth having COUNT(*)>50

-- 44. Calculate the average credit limit per marital status.

select cust_marital_status, avg(cust_credit_limit)
from sh.customers
group by cust_marital_status

-- 45. Find marital statuses with average credit limit less than 5,000.

select cust_marital_status, avg(cust_credit_limit)
from sh.customers
group by cust_marital_status having avg(cust_credit_limit)<5000

-- 46. Count the number of customers by email domain (e.g., company.example.com).

SELECT SUBSTR(cust_email, INSTR(cust_email, '@') + 1) AS email_domain,
       COUNT(*) AS customer_count
FROM sh.customers
GROUP BY SUBSTR(cust_email, INSTR(cust_email, '@') + 1)
ORDER BY customer_count DESC;
 
-- 47. Find email domains with more than 300 customers.

SELECT SUBSTR(cust_email, INSTR(cust_email, '@') + 1) AS email_domain,
       COUNT(*) AS customer_count
FROM sh.customers
GROUP BY SUBSTR(cust_email, INSTR(cust_email, '@') + 1)
HAVING COUNT(*) > 300
ORDER BY customer_count DESC;

-- 48. Calculate the average credit limit by validity (CUST_VALID).

SELECT cust_valid, AVG(cust_credit_limit) 
FROM sh.customers
GROUP BY cust_valid;

-- 49. Find validity groups where the average credit limit is greater than 7,000.

SELECT cust_valid, AVG(cust_credit_limit) 
FROM sh.customers
GROUP BY cust_valid having AVG(cust_credit_limit)>7000

-- 50. Count the number of customers per state and city combination where there are more than 50 customers.

SELECT cust_STATE_province,
       cust_CITY,
       COUNT(*) AS customer_count
FROM sh.customers
GROUP BY cust_STATE_province, cust_CITY
HAVING COUNT(*) > 50
ORDER BY customer_count DESC;