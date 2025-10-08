-- 1.Find the total, average, minimum, and maximum credit limit of all customers.

select
cust_first_name,
cust_last_name,
sum(cust_credit_limit) as total_credit,
avg(cust_credit_limit) as avg_credit,
min(cust_credit_limit) as min_credit,
max(cust_credit_limit) as max_credit
from sh.customers
group by cust_first_name, cust_last_name;

-- 2.Count the number of customers in each income level.
SELECT 
    CUST_INCOME_LEVEL,
    COUNT(*) AS num_customers
FROM SH.CUSTOMERS
GROUP BY CUST_INCOME_LEVEL;

--3.Show total credit limit by state and country.

SELECT 
    CUST_STATE_PROVINCE,
    COUNTRY_ID,
    SUM(CUST_CREDIT_LIMIT) AS total_credit
FROM SH.CUSTOMERS
GROUP BY CUST_STATE_PROVINCE, COUNTRY_ID;

--4. Display average credit limit for each marital status and gender combination.

select 
    cust_marital_status,
    cust_gender,
    avg(cust_credit_limit) as avg_credit
    from sh.customers
    group by cust_marital_status,
    cust_gender;

--5. Find the top 3 states with the highest average credit limit.
SELECT *
FROM (
    SELECT 
        CUST_STATE_PROVINCE,
        AVG(CUST_CREDIT_LIMIT) AS avg_credit
    FROM SH.CUSTOMERS
    GROUP BY CUST_STATE_PROVINCE
    ORDER BY avg_credit DESC
) 
WHERE ROWNUM <= 3;

--6.Find the country with the maximum total customer credit limit.
SELECT *
FROM (
    SELECT 
        COUNTRY_ID,
        SUM(CUST_CREDIT_LIMIT) AS total_credit
    FROM SH.CUSTOMERS
    GROUP BY COUNTRY_ID
    ORDER BY total_credit DESC
)
WHERE ROWNUM = 1;

--7.Show the number of customers whose credit limit exceeds their state average.

WITH state_avg AS (
    SELECT 
        CUST_STATE_PROVINCE,
        AVG(CUST_CREDIT_LIMIT) AS avg_credit
    FROM SH.CUSTOMERS
    GROUP BY CUST_STATE_PROVINCE
)
SELECT COUNT(*) AS num_customers_above_state_avg
FROM SH.CUSTOMERS c
JOIN state_avg s
ON c.CUST_STATE_PROVINCE = s.CUST_STATE_PROVINCE
WHERE c.CUST_CREDIT_LIMIT > s.avg_credit;

--8.Calculate total and average credit limit for customers born after 1980.

SELECT 
    SUM(CUST_CREDIT_LIMIT) AS total_credit,
    AVG(CUST_CREDIT_LIMIT) AS avg_credit
FROM SH.CUSTOMERS
WHERE CUST_YEAR_OF_BIRTH > 1980;

--9.Find states having more than 50 customers.

SELECT 
    CUST_STATE_PROVINCE,
    COUNT(*) AS num_customers
FROM SH.CUSTOMERS
GROUP BY CUST_STATE_PROVINCE
HAVING COUNT(*) > 50;

--10. List countries where the average credit limit is higher than the global average.

SELECT 
    COUNTRY_ID,
    AVG(CUST_CREDIT_LIMIT) AS avg_credit
FROM SH.CUSTOMERS
GROUP BY COUNTRY_ID
HAVING AVG(CUST_CREDIT_LIMIT) > (
    SELECT AVG(CUST_CREDIT_LIMIT) FROM SH.CUSTOMERS
);



--11. Calculate the variance and standard deviation of customer credit limits by country

SELECT 
    COUNTRY_ID,
    VARIANCE(CUST_CREDIT_LIMIT) AS credit_variance,
    STDDEV(CUST_CREDIT_LIMIT) AS credit_stddev
FROM SH.CUSTOMERS
GROUP BY COUNTRY_ID;

--12.Find the state with the smallest range (max–min) in credit limits.

SELECT *
FROM (
    SELECT 
        CUST_STATE_PROVINCE,
        MAX(CUST_CREDIT_LIMIT) - MIN(CUST_CREDIT_LIMIT) AS credit_range
    FROM SH.CUSTOMERS
    GROUP BY CUST_STATE_PROVINCE
    ORDER BY credit_range ASC
)
WHERE ROWNUM = 1;

--13.Show the total number of customers per income level and the percentage contribution of each.

WITH total_customers AS (
    SELECT COUNT(*) AS total FROM SH.CUSTOMERS
)
SELECT 
    CUST_INCOME_LEVEL,
    COUNT(*) AS num_customers,
    ROUND((COUNT(*) / total_customers.total) * 100, 2) AS percent_contribution
FROM SH.CUSTOMERS, total_customers
GROUP BY CUST_INCOME_LEVEL, total_customers.total;

--14. For each income level, find how many customers have NULL credit limits.

SELECT 
    CUST_INCOME_LEVEL,
    COUNT(*) AS null_credit_count
FROM SH.CUSTOMERS
WHERE CUST_CREDIT_LIMIT IS NULL
GROUP BY CUST_INCOME_LEVEL;

--15. Display countries where the sum of credit limits exceeds 10 million.

SELECT 
    COUNTRY_ID,
    SUM(CUST_CREDIT_LIMIT) AS total_credit
FROM SH.CUSTOMERS
GROUP BY COUNTRY_ID
HAVING SUM(CUST_CREDIT_LIMIT) > 10000000;


--16.Find the state that contributes the highest total credit limit to its country

WITH country_totals AS (
    SELECT 
        COUNTRY_ID,
        CUST_STATE_PROVINCE,
        SUM(CUST_CREDIT_LIMIT) AS state_total
    FROM SH.CUSTOMERS
    GROUP BY COUNTRY_ID, CUST_STATE_PROVINCE
)
SELECT *
FROM (
    SELECT COUNTRY_ID, CUST_STATE_PROVINCE, state_total,
           RANK() OVER (PARTITION BY COUNTRY_ID ORDER BY state_total DESC) AS rnk
    FROM country_totals
)
WHERE rnk = 1;


--17. Show total credit limit per year of birth, sorted by total descending.

SELECT 
    CUST_YEAR_OF_BIRTH,
    SUM(CUST_CREDIT_LIMIT) AS total_credit
FROM SH.CUSTOMERS
GROUP BY CUST_YEAR_OF_BIRTH
ORDER BY total_credit DESC;

--18. Identify customers who hold the maximum credit limit in their respective country.

WITH country_max AS (
    SELECT 
        COUNTRY_ID,
        MAX(CUST_CREDIT_LIMIT) AS max_credit
    FROM SH.CUSTOMERS
    GROUP BY COUNTRY_ID
)
SELECT c.*
FROM SH.CUSTOMERS c
JOIN country_max m
ON c.COUNTRY_ID = m.COUNTRY_ID
AND c.CUST_CREDIT_LIMIT = m.max_credit;

--19.Show the difference between maximum and average credit limit per country.

SELECT 
    COUNTRY_ID,
    MAX(CUST_CREDIT_LIMIT) - AVG(CUST_CREDIT_LIMIT) AS max_minus_avg
FROM SH.CUSTOMERS
GROUP BY COUNTRY_ID;

--20.Display the overall rank of each state based on its total credit limit (using GROUP BY + analytic rank).

SELECT 
    CUST_STATE_PROVINCE,
    SUM(CUST_CREDIT_LIMIT) AS total_credit,
    RANK() OVER (ORDER BY SUM(CUST_CREDIT_LIMIT) DESC) AS state_rank
FROM SH.CUSTOMERS
GROUP BY CUST_STATE_PROVINCE;