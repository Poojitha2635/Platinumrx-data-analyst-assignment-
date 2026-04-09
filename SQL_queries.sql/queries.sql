SECTION A- SQL PROFICIENCY (HOTEL MANAGEMENT SYSTEM)

Q1. For every user get user_id and last booked room_no
  
    SELECT u.user_id, b.room_no
    FROM users u
    JOIN bookings b ON u.user_id = b.user_id
    WHERE b.booking_date = (
    SELECT MAX(booking_date)
    FROM bookings b2
    WHERE b2.user_id = u.user_id
    );

Q2. Get booking_id and total billing amount of every booking created in November,2021
  
    SELECT booking_id, SUM(item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE MONTH(bill_date) = 11 AND YEAR(bill_date) = 2021
    GROUP BY booking_id;

Q3.Get bill_id and bill amount of all the bills raised in October,2021 having bill amount > 1000
  
    SELECT bill_id, SUM(item_quantity * i.item_rate) AS bill_amount
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE MONTH(bill_date) = 10 AND YEAR(bill_date) = 2021
    GROUP BY bill_id
    HAVING bill_amount > 1000;

Q4.Determine the most ordered and least ordered item of each month of year 2021

  SELECT MONTH(bill_date) AS month,item_id,
  SUM(item_quantity) AS total_quantity
  FROM booking_commercials
  WHERE YEAR(bill_date) = 2021
  GROUP BY month, item_id
  ORDER BY month, total_quantity DESC;

Q5.Find the customers with the second highest bill value of each month of year 2021

   SELECT *
   FROM (
   SELECT MONTH(bill_date) AS month,user_id,
   SUM(item_quantity * item_rate) AS total_bill,
   DENSE_RANK() OVER(PARTITION BY MONTH(bill_date)
   ORDER BY SUM(item_quantity * item_rate) DESC) rnk
   FROM bookings b
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
   JOIN items i ON bc.item_id = i.item_id
  WHERE YEAR(bill_date) = 2021
  GROUP BY month, user_id
  ) t
    WHERE rnk = 2;


SECTION -B  SQL PROFICIENCY (CLINIC MANAGEMENT SYSTEM)

Q1.  Find the revenue we got from each sales channel in a given year
     SELECT sales_channel, SUM(amount) AS revenue
     FROM clinic_sales
    WHERE YEAR(datetime) = 2021
     GROUP BY sales_channel;


Q2.Find top 10 the most valuable customers for a given year
     SELECT uid, SUM(amount) AS total_spent
     FROM clinic_sales
     WHERE YEAR(datetime) = 2021
     GROUP BY uid
     ORDER BY total_spent DESC
     LIMIT 10;

Q3.Find month wise revenue,expense,profit,status(profitable/not-profitable) for a given year

    SELECT MONTH(cs.datetime) AS month,
     SUM(cs.amount) AS revenue,
    SUM(e.amount) AS expense,(SUM(cs.amount) - SUM(e.amount)) AS profit,
    CASE 
    WHEN (SUM(cs.amount) - SUM(e.amount)) > 0 
    THEN 'Profitable'
    ELSE 'Not Profitable'
    END AS status
    FROM clinic_sales cs
    JOIN expenses e ON cs.cid = e.cid
     GROUP BY month;
  
Q4. For each city find the most profitable clinic for a given month

    SELECT city, clinic_name, MAX(profit)
    FROM (
     SELECT c.city, c.clinic_name,SUM(cs.amount) - SUM(e.amount) AS profit
     FROM clinics c
      JOIN clinic_sales cs ON c.cid = cs.cid
      JOIN expenses e ON c.cid = e.cid
     GROUP BY c.city, c.clinic_name
     ) t
     GROUP BY city;

Q5.For each state find the second least profitable clinic for a given month

SELECT *
FROM (
 SELECT c.state, c.clinic_name,
SUM(cs.amount) - SUM(e.amount) AS profit,
 DENSE_RANK() OVER(PARTITION BY state ORDER BY SUM(cs.amount) - SUM(e.amount)) rnk
 FROM clinics c
JOIN clinic_sales cs ON c.cid = cs.cid
 JOIN expenses e ON c.cid = e.cid
GROUP BY c.state, c.clinic_name
) t
WHERE rnk = 2;












