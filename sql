Question 1:
A .1First date company created
MySQL [employees]> SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees);
+--------+
| emp_no |
+--------+
| 110022 |
| 110085 |
| 110183 |
| 110303 |
| 110511 |
| 110725 |
| 111035 |
| 111400 |
| 111692 |
+--------+
9 rows in set (0.495 sec)

MySQL [employees]> SELECT COUNT(emp_no)
    -> FROM employees
    -> WHERE hire_date=(SELECT MIN(hire_date) FROM employees);
+---------------+
| COUNT(emp_no) |
+---------------+
|             9 |
+---------------+
1 row in set (0.488 sec)


A.2 What was the average yearly salary?
SELECT YEAR(from_date),AVG(salary)
    FROM salaries
     WHERE salaries.emp_no IN(SELECT emp_no
    FROM employees
     WHERE hire_date=(SELECT MIN(hire_date) FROM employees)) AND YEAR(from_date)=1985
    GROUP BY YEAR(from_date);

+-----------------+-------------+
| YEAR(from_date) | AVG(salary) |
+-----------------+-------------+
|            1985 |  57290.7778 |
+-----------------+-------------+
1 row in set (0.351 sec)


A.3 What titles the employees have? How many employees were there in each title? What was the average yearly salary for each title? 
MySQL [employees]> SELECT DISTINCT(titles.title)
    FROM titles
    WHERE titles.emp_no IN(SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees));
+------------------+
| title            |
+------------------+
| Manager          |
| Senior Staff     |
| Staff            |
| Technique Leader |
+------------------+
4 rows in set (0.489 sec)





MySQL [employees]> SELECT titles.title,COUNT(*)
    FROM titles
    WHERE titles.emp_no IN(SELECT emp_no
    ROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees))
    GROUP BY titles.title;
+------------------+----------+
| title            | COUNT(*) |
+------------------+----------+
| Manager          |        9 |
| Senior Staff     |        2 |
| Staff            |        4 |
| Technique Leader |        3 |
+------------------+----------+
4 rows in set (0.491 sec)

SELECT titles.title,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM titles
    JOIN salaries ON titles.emp_no=salaries.emp_no
    WHERE titles.emp_no IN(SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees)) AND YEAR(salaries.from_date)=1985
    GROUP BY titles.title,YEAR(salaries.from_date);

+------------------+--------------------------+----------------------+
| title            | YEAR(salaries.from_date) | AVG(salaries.salary) |
+------------------+--------------------------+----------------------+
| Manager          |                     1985 |           57290.7778 |
| Senior Staff     |                     1985 |           65596.0000 |
| Staff            |                     1985 |           58087.2500 |
| Technique Leader |                     1985 |           50692.0000 |
+------------------+--------------------------+----------------------+
4 rows in set (0.348 sec)




A.4 What departments did the company have? How many employees were there in each department? What was the average yearly salary in each department? 
MySQL [employees]> SELECT departments.dept_name
    FROM departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no
    WHERE dept_emp.emp_no IN(SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees));
+--------------------+
| dept_name          |
+--------------------+
| Marketing          |
| Finance            |
| Human Resources    |
| Production         |
| Development        |
| Quality Management |
| Sales              |
| Research           |
| Customer Service   |
+--------------------+
9 rows in set (0.496 sec)

MySQL [employees]> SELECT departments.dept_name,COUNT(*)
    -> FROM departments
    -> JOIN dept_emp ON departments.dept_no=dept_emp.dept_no
    -> WHERE dept_emp.emp_no IN(SELECT emp_no
    -> FROM employees
    -> WHERE hire_date=(SELECT MIN(hire_date) FROM employees))
    -> GROUP BY departments.dept_name;
+--------------------+----------+
| dept_name          | COUNT(*) |
+--------------------+----------+
| Customer Service   |        1 |
| Development        |        1 |
| Finance            |        1 |
| Human Resources    |        1 |
| Marketing          |        1 |
| Production         |        1 |
| Quality Management |        1 |
| Research           |        1 |
| Sales              |        1 |
+--------------------+----------+
9 rows in set (0.509 sec)
   
SELECT departments.dept_name,YEAR(salaries.from_date),AVG(salary)
    FROM ((departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    JOIN salaries ON salaries.emp_no=dept_emp.emp_no)
    WHERE dept_emp.emp_no IN(SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees)) AND YEAR(salaries.from_date)=1985
    GROUP BY departments.dept_name,YEAR(salaries.from_date);

+--------------------+--------------------------+-------------+
| dept_name          | YEAR(salaries.from_date) | AVG(salary) |
+--------------------+--------------------------+-------------+
| Customer Service   |                     1985 |  40000.0000 |
| Development        |                     1985 |  48626.0000 |
| Finance            |                     1985 |  60026.0000 |
| Human Resources    |                     1985 |  48291.0000 |
| Marketing          |                     1985 |  71166.0000 |
| Production         |                     1985 |  42093.0000 |
| Quality Management |                     1985 |  61357.0000 |
| Research           |                     1985 |  72446.0000 |
| Sales              |                     1985 |  71612.0000 |
+--------------------+--------------------------+-------------+
9 rows in set (0.341 sec)


A.5 Who was the employee who earned the highest salary? What was the salary amount? What was his/her title?



SELECT employees.first_name,employees.last_name,salaries.salary,titles.title,salaries.from_date,salaries.to_date,titles.from_date,titles.to_date
    FROM ((employees
    JOIN salaries
    ON employees.emp_no = salaries.emp_no)
    JOIN titles
    ON employees.emp_no = titles.emp_no)
    WHERE employees.emp_no IN(SELECT emp_no
    FROM employees
    WHERE hire_date=(SELECT MIN(hire_date) FROM employees)) AND YEAR(titles.from_date)=1985 AND YEAR(salaries.from_date)=1985
    ORDER BY salaries.salary DESC
    LIMIT 1;

+------------+-----------+--------+---------+
| first_name | last_name | salary | title   |
+------------+-----------+--------+---------+
| Arie       | Staelin   |  72446 | Manager |
+------------+-----------+--------+---------+
1 row in set (0.343 sec)



Q2.
B.1 Five years after the company was created
 SELECT MIN(hire_date) FROM employees;
+----------------+
| MIN(hire_date) |
+----------------+
| 1985-01-01     |
+----------------+
1 row in set (0.267 sec)
⇒ The date is 1990-01-01

SELECT  COUNT(emp_no)
    FROM dept_emp
    WHERE ('1990/01/01'  BETWEEN from_date AND to_date);

+---------------+
| COUNT(emp_no) |
+---------------+
|         95296 |
+---------------+
1 row in set (0.269 sec)



B.2 What was the average yearly salary? 
SELECT YEAR(from_date),AVG(salary)
    FROM salaries
    WHERE salaries.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE ('1990/01/01' BETWEEN from_date AND to_date))  AND YEAR(from_date)=1990
    GROUP BY YEAR(from_date);

+-----------------+-------------+
| YEAR(from_date) | AVG(salary) |
+-----------------+-------------+
|            1990 |  58850.9856 |
+-----------------+-------------+
1 row in set (1.308 sec)


B.3 What titles the employees have? How many employees were there in each title? What was the average yearly salary for each title? 
SELECT titles.title,COUNT(*)
    FROM titles
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('1990/01/01'  BETWEEN from_date AND to_date)) AND titles.from_date<='1990/01/01' AND titles.to_date>='1990/01/01'
    GROUP BY titles.title;
+--------------------+----------+
| title              | COUNT(*) |
+--------------------+----------+
| Assistant Engineer |     4782 |
| Engineer           |    33474 |
| Manager            |        9 |
| Senior Engineer    |     9683 |
| Senior Staff       |     8412 |
| Staff              |    34167 |
| Technique Leader   |     4768 |
+--------------------+----------+
7 rows in set (1.996 sec)


SELECT titles.title,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM titles
    JOIN salaries ON titles.emp_no=salaries.emp_no
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('1990/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=1990 AND titles.from_date<='1990/01/01'
    GROUP BY titles.title,YEAR(salaries.from_date);
+--------------------+--------------------------+----------------------+
| title              | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Assistant Engineer |                     1990 |           54348.0352 |
| Engineer           |                     1990 |           54476.7313 |
| Manager            |                     1990 |           63690.6667 |
| Senior Engineer    |                     1990 |           54252.0259 |
| Senior Staff       |                     1990 |           64444.1121 |
| Staff              |                     1990 |           64317.6041 |
| Technique Leader   |                     1990 |           54353.3272 |
+--------------------+--------------------------+----------------------+
7 rows in set (2.953 sec)


B.4 What departments did the company have? How many employees were there in each department? What was the average yearly salary in each department? 
   SELECT departments.dept_name,COUNT(DISTINCT(dept_emp.emp_no))
    FROM (departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('1990/01/01'  BETWEEN from_date AND to_date)) AND dept_emp.from_date<='1990/01/01' AND dept_emp.to_date>='1990/01/01'
    GROUP BY departments.dept_name;

+--------------------+----------------------------------+
| dept_name          | COUNT(DISTINCT(dept_emp.emp_no)) |
+--------------------+----------------------------------+
| Customer Service   |                             5640 |
| Development        |                            25972 |
| Finance            |                             5277 |
| Human Resources    |                             5308 |
| Marketing          |                             5267 |
| Production         |                            21176 |
| Quality Management |                             5390 |
| Research           |                             5468 |
| Sales              |                            15798 |
+--------------------+----------------------------------+
9 rows in set (1.091 sec)




SELECT departments.dept_name,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM ((departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    JOIN salaries ON salaries.emp_no=dept_emp.emp_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('1990/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=1990 AND dept_emp.from_date<='1990/01/01' AND dept_emp.to_date>='1990/01/01'
    GROUP BY departments.dept_name,YEAR(salaries.from_date);

+--------------------+--------------------------+----------------------+
| dept_name          | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Customer Service   |                     1990 |           50551.7955 |
| Development        |                     1990 |           54613.2830 |
| Finance            |                     1990 |           66242.8628 |
| Human Resources    |                     1990 |           49920.3020 |
| Marketing          |                     1990 |           66589.7654 |
| Production         |                     1990 |           54796.0541 |
| Quality Management |                     1990 |           51867.9032 |
| Research           |                     1990 |           54684.7433 |
| Sales              |                     1990 |           75972.3977 |
+--------------------+--------------------------+----------------------+
9 rows in set (2.077 sec)



B.5 Who was the employee who earned the highest salary? What was the salary amount? What was his/her title?
SELECT employees.first_name,employees.last_name,salaries.salary,titles.title    
FROM ((employees    
JOIN salaries    ON employees.emp_no = salaries.emp_no)    
JOIN titles    ON employees.emp_no = titles.emp_no)    
WHERE salaries.emp_no IN(SELECT  emp_no    
                        FROM salaries   
                        WHERE ('1990/01/01'  BETWEEN from_date AND to_date))
    AND YEAR(salaries.to_date)=1990 AND ('1990/01/01' BETWEEN salaries.from_date AND salaries.to_date) AND titles.from_date<='1990/01/01' AND titles.to_date>='1990/01/01'
    ORDER BY salaries.salary DESC
    LIMIT 1 ;

+------------+-----------+--------+-------+
| first_name | last_name | salary | title |
+------------+-----------+--------+-------+
| Tsutomu    | Alameldin | 132196 | Staff |
+------------+-----------+--------+-------+

1 row in set (3.607 sec)



C. Fifteen years after the company was created.
C.1 How many employees were hired (How many employees were in a hiring relationship with this company)? 
 SELECT MIN(hire_date) FROM employees;
+----------------+
| MIN(hire_date) |
+----------------+
| 1985-01-01     |
+----------------+
1 row in set (0.267 sec)
⇒ The date is 1995-01-01

SELECT  COUNT(emp_no)
    FROM dept_emp
    WHERE ('1995/01/01'  BETWEEN from_date AND to_date);

+---------------+
| COUNT(emp_no) |
+---------------+
|        183503 |
+---------------+
1 row in set (0.260 sec)




C.2 What was the average yearly salary? 
SELECT YEAR(from_date),AVG(salary)
    FROM salaries
    WHERE salaries.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE ('1995/01/01' BETWEEN from_date AND to_date))  AND YEAR(from_date)=1995
    GROUP BY YEAR(from_date);
+-----------------+-------------+
| YEAR(from_date) | AVG(salary) |
+-----------------+-------------+
|            1995 |  63750.0327 |
+-----------------+-------------+
1 row in set (2.106 sec)


C.3  What titles the employees have? How many employees were there in each title? What was the average yearly salary for each title? 
SELECT titles.title,COUNT(*)
    FROM titles
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('1995/01/01'  BETWEEN from_date AND to_date)) AND titles.from_date<='1995/01/01' AND titles.to_date>='1995/01/01'
    GROUP BY titles.title;


+--------------------+----------------------------------+
| dept_name          | COUNT(DISTINCT(dept_emp.emp_no)) |
+--------------------+----------------------------------+
| Customer Service   |                            11468 |
| Development        |                            49163 |
| Finance            |                             9882 |
| Human Resources    |                            10174 |
| Marketing          |                            10600 |
| Production         |                            40508 |
| Quality Management |                            10561 |
| Research           |                            10949 |
| Sales              |                            30198 |
+--------------------+----------------------------------+
9 rows in set (2.348 sec)



SELECT titles.title,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM titles
    JOIN salaries ON titles.emp_no=salaries.emp_no
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('1995/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=1995 AND titles.from_date<='1995/01/01' AND titles.to_date>='1995/01/01'
    GROUP BY titles.title,YEAR(salaries.from_date);

+--------------------+--------------------------+----------------------+
| title              | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Assistant Engineer |                     1995 |           56585.8382 |
| Engineer           |                     1995 |           57178.2808 |
| Manager            |                     1995 |           67784.0000 |
| Senior Engineer    |                     1995 |           62557.5871 |
| Senior Staff       |                     1995 |           72756.9087 |
| Staff              |                     1995 |           66680.5747 |
| Technique Leader   |                     1995 |           59209.5075 |
+--------------------+--------------------------+----------------------+
7 rows in set (5.513 sec)


C.4 What departments did the company have? How many employees were there in each department? What was the average yearly salary in each department? 
    SELECT departments.dept_name,COUNT(DISTINCT(dept_emp.emp_no))
    FROM (departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('1995/01/01'  BETWEEN from_date AND to_date)) AND dept_emp.from_date<='1995/01/01' AND dept_emp.to_date>='1995/01/01'
    GROUP BY departments.dept_name;




+--------------------+----------------------------------+
| dept_name          | COUNT(DISTINCT(dept_emp.emp_no)) |
+--------------------+----------------------------------+
| Customer Service   |                            11468 |
| Development        |                            49163 |
| Finance            |                             9882 |
| Human Resources    |                            10174 |
| Marketing          |                            10600 |
| Production         |                            40508 |
| Quality Management |                            10561 |
| Research           |                            10949 |
| Sales              |                            30198 |
+--------------------+----------------------------------+
9 rows in set (2.061 sec)



SELECT departments.dept_name,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM ((departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    JOIN salaries ON salaries.emp_no=dept_emp.emp_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('1995/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=1990 AND dept_emp.from_date<='1995/01/01' AND dept_emp.to_date>='1995/01/01'
    GROUP BY departments.dept_name,YEAR(salaries.from_date);
+--------------------+--------------------------+----------------------+
| dept_name          | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Customer Service   |                     1990 |           51039.9592 |
| Development        |                     1990 |           53575.1081 |
| Finance            |                     1990 |           65103.2095 |
| Human Resources    |                     1990 |           49193.3359 |
| Marketing          |                     1990 |           65825.9160 |
| Production         |                     1990 |           53728.5799 |
| Quality Management |                     1990 |           51175.9268 |
| Research           |                     1990 |           53794.9671 |
| Sales              |                     1990 |           74833.4722 |
+--------------------+--------------------------+----------------------+
9 rows in set (3.324 sec)


162 rows in set (12.978 sec)

C.5 Who was the employee who earned the highest salary? What was the salary amount? What was his/her title?

SELECT employees.first_name,employees.last_name,salaries.salary,titles.title    
FROM ((employees    
JOIN salaries    ON employees.emp_no = salaries.emp_no)    
JOIN titles    ON employees.emp_no = titles.emp_no)    
WHERE salaries.emp_no IN(SELECT  emp_no    
                        FROM salaries   
                        WHERE ('1995/01/01'  BETWEEN from_date AND to_date))
    AND YEAR(salaries.to_date)=1995 AND ('1995/01/01' BETWEEN salaries.from_date AND salaries.to_date) AND titles.from_date<='1995/01/01' AND titles.to_date>='1995/01/01'
    ORDER BY salaries.salary DESC
    LIMIT 1 ;


+------------+-----------+--------+--------------+
| first_name | last_name | salary | title        |
+------------+-----------+--------+--------------+
| Tsutomu    | Alameldin | 143182 | Senior Staff |
+------------+-----------+--------+--------------+
1 row in set (8.154 sec)





D. Fifteen years after the company was created.

D.1 How many employees were hired (How many employees were in a hiring relationship with this company)? 
SELECT  COUNT(DISTINCT(emp_no))
    FROM dept_emp
    WHERE ('2000/01/01'  BETWEEN from_date AND to_date);

+-------------------------+
| COUNT(DISTINCT(emp_no)) |
+-------------------------+
|                  257311 |
+-------------------------+
1 row in set (0.407 sec)


D.2 What was the average yearly salary? 
SELECT YEAR(from_date),AVG(salary)
    FROM salaries
    WHERE salaries.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE ('2000/01/01' BETWEEN from_date AND to_date))  AND YEAR(from_date)=2000
    GROUP BY YEAR(from_date);
+-----------------+-------------+
| YEAR(from_date) | AVG(salary) |
+-----------------+-------------+
|            2000 |  68658.4590 |
+-----------------+-------------+
1 row in set (2.447 sec)


D.3 What titles the employees have? How many employees were there in each title? What was the average yearly salary for each title? 

SELECT titles.title,COUNT(*)
    FROM titles
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('2000/01/01'  BETWEEN from_date AND to_date)) AND titles.from_date<='2000/01/01' AND titles.to_date>'2000/01/01'
    GROUP BY titles.title;
+--------------------+----------+
| title              | COUNT(*) |
+--------------------+----------+
| Assistant Engineer |     6277 |
| Engineer           |    49092 |
| Manager            |        9 |
| Senior Engineer    |    73822 |
| Senior Staff       |    70619 |
| Staff              |    44544 |
| Technique Leader   |    12930 |
+--------------------+----------+
7 rows in set (4.923 sec)

SELECT titles.title,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM titles
    JOIN salaries ON titles.emp_no=salaries.emp_no
    WHERE titles.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('2000/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=2000 AND titles.from_date<='2000/01/01' AND titles.to_date>='2000/01/01'
    GROUP BY titles.title,YEAR(salaries.from_date);

+--------------------+--------------------------+----------------------+
| title              | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Assistant Engineer |                     2000 |           56713.1446 |
| Engineer           |                     2000 |           58093.9909 |
| Manager            |                     2000 |           74947.1111 |
| Senior Engineer    |                     2000 |           68829.1564 |
| Senior Staff       |                     2000 |           78901.0501 |
| Staff              |                     2000 |           66606.9886 |
| Technique Leader   |                     2000 |           64225.9423 |
+--------------------+--------------------------+----------------------+
7 rows in set (7.216 sec)

D.4 What departments did the company have? How many employees were there in each department? What was the average yearly salary in each department? 

   SELECT departments.dept_name,COUNT(DISTINCT(dept_emp.emp_no))
    FROM (departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE  ('2000/01/01'  BETWEEN from_date AND to_date)) AND dept_emp.from_date<='2000/01/01' AND dept_emp.to_date>='2000/01/01'
    GROUP BY departments.dept_name;
+--------------------+----------------------------------+
| dept_name          | COUNT(DISTINCT(dept_emp.emp_no)) |
+--------------------+----------------------------------+
| Customer Service   |                            17332 |
| Development        |                            67443 |
| Finance            |                            13557 |
| Human Resources    |                            14044 |
| Marketing          |                            15355 |
| Production         |                            56981 |
| Quality Management |                            15252 |
| Research           |                            15906 |
| Sales              |                            41451 |
+--------------------+----------------------------------+
9 rows in set (3.108 sec)

SELECT departments.dept_name,YEAR(salaries.from_date),AVG(salaries.salary)
    FROM ((departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    JOIN salaries ON salaries.emp_no=dept_emp.emp_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
    FROM dept_emp
    WHERE ('2000/01/01'  BETWEEN from_date AND to_date)) AND YEAR(salaries.from_date)=2000 AND dept_emp.from_date<='2000/01/01' AND dept_emp.to_date>='2000/01/01'
    GROUP BY departments.dept_name,YEAR(salaries.from_date);
+--------------------+--------------------------+----------------------+
| dept_name          | YEAR(salaries.from_date) | AVG(salaries.salary) |
+--------------------+--------------------------+----------------------+
| Customer Service   |                     2000 |           63080.2540 |
| Development        |                     2000 |           64244.4072 |
| Finance            |                     2000 |           75451.5091 |
| Human Resources    |                     2000 |           60245.2703 |
| Marketing          |                     2000 |           76666.7889 |
| Production         |                     2000 |           64502.8093 |
| Quality Management |                     2000 |           62058.1410 |
| Research           |                     2000 |           64760.4187 |
| Sales              |                     2000 |           85484.5241 |
+--------------------+--------------------------+----------------------+
9 rows in set (5.189 sec)
D.5 Who was the employee who earned the highest salary? What was the salary amount? What was his/her title?

SELECT employees.first_name,employees.last_name,salaries.salary,titles.title    
FROM ((employees    
JOIN salaries    ON employees.emp_no = salaries.emp_no)    
JOIN titles    ON employees.emp_no = titles.emp_no)    
WHERE salaries.emp_no IN(SELECT  emp_no    
                        FROM salaries   
                        WHERE ('2000/01/01'  BETWEEN from_date AND to_date))
    AND YEAR(salaries.to_date)=2000 AND ('2000/01/01' BETWEEN salaries.from_date AND salaries.to_date) AND titles.from_date<='2000/01/01' AND titles.to_date>='2000/01/01'
    ORDER BY salaries.salary DESC
    LIMIT 1 ;

+------------+-----------+--------+--------------+
| first_name | last_name | salary | title        |
+------------+-----------+--------+--------------+
| Tsutomu    | Alameldin | 154885 | Senior Staff |
+------------+-----------+--------+--------------+
1 row in set (11.773 sec)

1 row in set (5.741 sec)

E.The final state of the company.

E.1How many employees were hired (How many employees were in a hiring relationship with this company)? 
SELECT COUNT(emp_no)
    FROM dept_emp
    WHERE to_date=(SELECT MAX(to_date) FROM dept_emp);
+---------------+
| COUNT(emp_no) |
+---------------+
|        240124 |
+---------------+
1 row in set (0.696 sec)


E.2 What was the average yearly salary? 

SELECT YEAR(to_date),AVG(salary)
    FROM salaries
    WHERE salaries.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01')  AND YEAR(to_date)=9999
    GROUP BY YEAR(to_date);
+---------------+-------------+
| YEAR(to_date) | AVG(salary) |
+---------------+-------------+
|          9999 |  72012.2359 |
+---------------+-------------+
1 row in set (4.637 sec)

E.3 What titles the employees have? How many employees were there in each title? What was the average yearly salary for each title? 
SELECT titles.title,COUNT(*)
    FROM titles
    WHERE titles.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01') AND titles.to_date='9999/01/01'
    GROUP BY titles.title;
+--------------------+----------+
| title              | COUNT(*) |
+--------------------+----------+
| Assistant Engineer |     3588 |
| Engineer           |    30983 |
| Manager            |        9 |
| Senior Engineer    |    85939 |
| Senior Staff       |    82024 |
| Staff              |    25526 |
| Technique Leader   |    12055 |
+--------------------+----------+
7 rows in set (9.293 sec)


SELECT titles.title,YEAR(salaries.to_date),AVG(salaries.salary)
    FROM titles
    JOIN salaries ON titles.emp_no=salaries.emp_no
    WHERE titles.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01') AND YEAR(salaries.to_date)=9999 AND titles.to_date='9999/01/01'
    GROUP BY titles.title,YEAR(salaries.to_date);


+--------------------+------------------------+----------------------+
| title              | YEAR(salaries.to_date) | AVG(salaries.salary) |
+--------------------+------------------------+----------------------+
| Assistant Engineer |                   9999 |           57317.5736 |
| Engineer           |                   9999 |           59602.7378 |
| Manager            |                   9999 |           77723.6667 |
| Senior Engineer    |                   9999 |           70823.4376 |
| Senior Staff       |                   9999 |           80706.4959 |
| Staff              |                   9999 |           67330.6652 |
| Technique Leader   |                   9999 |           67506.5903 |
+--------------------+------------------------+----------------------+
7 rows in set (14.689 sec)


E.4
   SELECT departments.dept_name,COUNT(DISTINCT(dept_emp.emp_no))
    FROM (departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01') AND dept_emp.to_date='9999/01/01'
    GROUP BY departments.dept_name;
+--------------------+----------------------------------+
| dept_name          | COUNT(DISTINCT(dept_emp.emp_no)) |
+--------------------+----------------------------------+
| Customer Service   |                            17569 |
| Development        |                            61386 |
| Finance            |                            12437 |
| Human Resources    |                            12898 |
| Marketing          |                            14842 |
| Production         |                            53304 |
| Quality Management |                            14546 |
| Research           |                            15441 |
| Sales              |                            37701 |
+--------------------+----------------------------------+
9 rows in set (6.328 sec)

SELECT departments.dept_name,YEAR(salaries.to_date),AVG(salaries.salary)
    FROM ((departments
    JOIN dept_emp ON departments.dept_no=dept_emp.dept_no)
    JOIN salaries ON salaries.emp_no=dept_emp.emp_no)
    WHERE dept_emp.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01') AND YEAR(salaries.from_date)=9999 AND dept_emp.to_date='9999/01/01'
    GROUP BY departments.dept_name,YEAR(salaries.to_date);
+--------------------+------------------------+----------------------+
| dept_name          | YEAR(salaries.to_date) | AVG(salaries.salary) |
+--------------------+------------------------+----------------------+
| Customer Service   |                   9999 |           67285.2302 |
| Development        |                   9999 |           67657.9196 |
| Finance            |                   9999 |           78559.9370 |
| Human Resources    |                   9999 |           63921.8998 |
| Marketing          |                   9999 |           80058.8488 |
| Production         |                   9999 |           67843.3020 |
| Quality Management |                   9999 |           65441.9934 |
| Research           |                   9999 |           67913.3750 |
| Sales              |                   9999 |           88852.9695 |
+--------------------+------------------------+----------------------+
9 rows in set (8.773 sec)

E.5
SELECT employees.first_name,employees.last_name,salaries.salary,titles.title    
FROM ((employees    
JOIN salaries    ON employees.emp_no = salaries.emp_no)    
JOIN titles    ON employees.emp_no = titles.emp_no)    
WHERE salaries.emp_no IN(SELECT  emp_no
                                FROM dept_emp
                                WHERE to_date= '9999/01/01')
    AND YEAR(salaries.to_date)=9999 AND YEAR(salaries.to_date)=9999 AND titles.to_date='9999/01/01'
    ORDER BY salaries.salary DESC
    LIMIT 1 ;
+------------+-----------+--------+--------------+
| first_name | last_name | salary | title        |
+------------+-----------+--------+--------------+
| Tokuyasu   | Pesch     | 158220 | Senior Staff |
+------------+-----------+--------+--------------+
1 row in set (8.953 sec)
