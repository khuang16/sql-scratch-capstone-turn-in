/*
Kristy Huang
Codeacademy Intensive: Learn SQL from Scratch
Capstone Project: Usage Funnels with Warby Parker
Course Date: July 3, 2018 - August 28, 2018
*/
-- Quiz Funnel
-- Task 1
SELECT *
FROM survey 
LIMIT 10;
-- columns: question, user_id, response
 
-- Task 2: create a quiz funnel
SELECT question,
	COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;
/* number of responses for each question:
 1 - 500
 2 - 475
 3 - 380
 4 - 361
 5 - 270 */
 
/* Task 3: use a spreadsheet program to calculate completion rates
 1 - 100%
 2 - 95%
 3 - 80%
 4 - 95%
 5 - 75%
Question 5 then 3 have the lowest completion rates. This is most likely because these questions require the most work from the user. They have to figure out when their last eye exam was and go through different shapes. */
 
-- Home Try-On Funnel
-- Task 4: examine data tables
SELECT *
FROM quiz
LIMIT 5;
SELECT *
FROM home_try_on
LIMIT 5;
SELECT *
FROM purchase
LIMIT 5;
/* column names
 quiz: user_id, style, fit, shape, color
 home_try_on: user_id, number_of_pairs, address
 purchase: user_id, product_id, style, model_name, color, price */
 
-- Task 5: create new table
SELECT DISTINCT q.user_id,
	h.user_id IS NOT NULL AS 'is_home_try_on',
 	h.number_of_pairs,
	p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
LEFT JOIN purchase p
	ON h.user_id = p.user_id
LIMIT 10;
    
-- Task 6: analyze data for actionable insights
-- compare funnel conversion rates
WITH funnels AS (
	SELECT DISTINCT q.user_id,
		h.user_id IS NOT NULL AS 'is_home_try_on',
 		h.number_of_pairs,
 		p.user_id IS NOT NULL AS 'is_purchase'
	FROM quiz q
	LEFT JOIN home_try_on h
		ON q.user_id = h.user_id
	LEFT JOIN purchase p
		ON h.user_id = p.user_id
)
SELECT COUNT (*) AS 'num_quiz',
	SUM(is_home_try_on) AS 'num_home_try_on',
  SUM(is_purchase) AS 'sum_purchase',
  1.0 * SUM(is_home_try_on) / COUNT(user_id) 
  	AS 'quiz_to_home_try_on',
  1.0 * SUM(is_purchase) / SUM(is_home_try_on) 
  	AS 'home_try_on_to_purchase'
FROM funnels;
-- quiz to home try on - 75%
-- home try on to purchase - 66%

-- calculate the difference in purchase rates between customers who had 3 pairs and those with 5 pairs
WITH ab_funnels AS (
	SELECT number_of_pairs,
  	h.user_id IS NOT NULL AS 'is_home_try_on',
 		p.user_id IS NOT NULL AS 'is_purchase'
 	FROM home_try_on h
  LEFT JOIN purchase p
  	ON h.user_id = p.user_id
)
SELECT number_of_pairs,
	SUM(is_home_try_on) AS 'num_home_try_on',
  SUM(is_purchase) AS 'num_purchase',
  ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) 
  	AS 'home_try_on_to_purchase'
FROM ab_funnels
GROUP BY number_of_pairs;
-- purchase rate with 3 pairs - 53%
-- purchase rate with 5 pairs - 79%
-- the purchase rate is much higher with 5 pairs

-- calculate most common results of style quiz
SELECT style,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 1000, 2)
FROM quiz
GROUP BY style;

SELECT fit,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 1000, 2)
FROM quiz
GROUP BY fit;

SELECT shape,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 1000, 2)
FROM quiz
GROUP BY shape;

SELECT color,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 1000, 2)
FROM quiz
GROUP BY color;

-- calculate most common types of purchases made
SELECT product_id,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 495, 2)
FROM purchase
GROUP BY product_id;

SELECT style,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 495, 2)
FROM purchase
GROUP BY style;

SELECT model_name,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 495, 2)
FROM purchase
GROUP BY model_name;

SELECT color,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 495, 2)
FROM purchase
GROUP BY color;

SELECT price,
	COUNT(*),
	ROUND(1.0 * COUNT(*) / 495, 2)
FROM purchase
GROUP BY price;