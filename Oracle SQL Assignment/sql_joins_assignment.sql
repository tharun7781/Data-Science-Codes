--  CLEANUP: Drop old tables if they exist

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Orders';
EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE Clients';
EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
/


-- CREATE TABLE STRUCTURE


-- Table 1: Clients
CREATE TABLE Clients (
    Client_ID NUMBER PRIMARY KEY,
    Full_Name VARCHAR2(60),
    Email_ID VARCHAR2(60),
    City VARCHAR2(40),
    Nation VARCHAR2(40)
);

-- Table 2: Orders
CREATE TABLE Orders (
    Order_ID NUMBER PRIMARY KEY,
    Item_Name VARCHAR2(60),
    Item_Type VARCHAR2(40),
    Unit_Price NUMBER,
    Client_ID NUMBER
);

------------------------------------------------------------
-- INSERT SAMPLE DATA
------------------------------------------------------------

-- Insert into Clients
INSERT INTO Clients VALUES (101, 'Emma Wilson', 'emma.wilson@gmail.com', 'Toronto', 'Canada');
INSERT INTO Clients VALUES (102, 'Rahul Mehta', 'rahul.mehta@gmail.com', 'Mumbai', 'India');
INSERT INTO Clients VALUES (103, 'Olivia Perez', NULL, 'Barcelona', 'Spain');
INSERT INTO Clients VALUES (104, 'Ahmed Ali', 'ahmed.ali@gmail.com', NULL, 'UAE');
INSERT INTO Clients VALUES (105, 'William Green', 'will.green@gmail.com', 'Manchester', NULL);

-- Insert into Orders
INSERT INTO Orders VALUES (201, 'Gaming Laptop', 'Electronics', 950, 101);
INSERT INTO Orders VALUES (202, 'Bluetooth Speaker', 'Accessories', 120, 101);
INSERT INTO Orders VALUES (203, 'Smartwatch', 'Electronics', 280, 102);
INSERT INTO Orders VALUES (204, 'Handbag', 'Fashion', 90, NULL);
INSERT INTO Orders VALUES (205, 'DSLR Camera', 'Electronics', 720, 102);
INSERT INTO Orders VALUES (206, 'Sneakers', 'Fashion', 75, 104);
INSERT INTO Orders VALUES (207, 'Travel Bag', 'Travel', NULL, 104);
INSERT INTO Orders VALUES (208, 'Sunglasses', 'Accessories', 150, 103);

COMMIT;

------------------------------------------------------------
-- VERIFY CREATION
------------------------------------------------------------
SELECT table_name FROM user_tables WHERE table_name IN ('CLIENTS', 'ORDERS');

------------------------------------------------------------
-- INNER JOIN → Common records between Clients & Orders
------------------------------------------------------------
SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID;

------------------------------------------------------------
--  LEFT OUTER JOIN → All Clients + Matching Orders
------------------------------------------------------------
SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
LEFT OUTER JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID;

------------------------------------------------------------
--  RIGHT OUTER JOIN → All Orders + Matching Clients
------------------------------------------------------------
SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
RIGHT OUTER JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID;

------------------------------------------------------------
-- FULL OUTER JOIN → All records from both tables
------------------------------------------------------------
SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
FULL OUTER JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID;

------------------------------------------------------------
--  SYMMETRIC DIFFERENCE → Unmatched rows from both tables
------------------------------------------------------------
SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
LEFT JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID
WHERE 
    o.Client_ID IS NULL

UNION

SELECT 
    c.Client_ID,
    c.Full_Name,
    o.Item_Name,
    o.Unit_Price
FROM 
    Clients c
RIGHT JOIN 
    Orders o
ON 
    c.Client_ID = o.Client_ID
WHERE 
    c.Client_ID IS NULL;
