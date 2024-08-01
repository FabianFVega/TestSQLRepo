# TestSQLRepo
In the following repository, you can find a SQL file that has different queries based on the test interview. Please be aware of following the steps for testing the query. 

In my case, I have created and run my code in PHPMYADMIN, which works with XAMPP software. This is the link if you have never worked with: https://www.apachefriends.org/es/index.html

Once you have installed the software, you clip on buttons start of MYSQL  and apache, after that you clip on the button admin, create a data base and run all the code in a terminal web of PHPMYADMIN.

Note: the storage procedures run in a section of rutines and views after run the scrip you will be able to view on the same phpmyadmin.


# Explaniations of advance queries


### 1. **Basic Query Optimization Techniques**

**Indexing**
- **What**: Indexes improve the speed of data retrieval operations.
- **How**: Create indexes on columns that are frequently used in `WHERE`, `JOIN`, or `ORDER BY` clauses.
- **Example**: Indexing the `question_id` column in the `responses` table can speed up queries that join on this column.

```sql
CREATE INDEX idx_question_id ON responses(question_id);
```

**Avoiding SELECT ***
- **What**: Retrieving only the necessary columns reduces I/O and improves performance.
- **How**: Specify only the columns you need instead of using `SELECT *`.
- **Example**: Instead of `SELECT * FROM survey_scores`, use `SELECT survey_name, question_text FROM survey_scores`.

**Using Appropriate Data Types**
- **What**: Choosing the right data types reduces storage and improves performance.
- **How**: Use data types that match the data you are storing, such as `INT` for numbers and `VARCHAR` for text.
- **Example**: Use `VARCHAR(255)` for emails, but avoid using excessive lengths.

### 2. **Advanced Query Techniques**

**Aggregation and Grouping**
- **What**: Aggregation functions (e.g., `AVG`, `SUM`, `COUNT`) are used to perform calculations on grouped data.
- **How**: Use `GROUP BY` to aggregate results by specific columns.
- **Example**: To calculate the average score for each survey:

```sql
SELECT survey_name, AVG(response_number) AS avg_score
FROM surveys s
JOIN questions q ON s.survey_id = q.survey_id
JOIN responses r ON q.question_id = r.question_id
GROUP BY survey_name;
```

**Subqueries and Derived Tables**
- **What**: Subqueries (queries within queries) allow complex filtering and calculations.
- **How**: Use subqueries in `SELECT`, `FROM`, or `WHERE` clauses to break down complex queries.
- **Example**: To find the top 3 users with the highest average response score:

```sql
SELECT user_id, AVG(response_number) AS avg_score
FROM responses
GROUP BY user_id
ORDER BY avg_score DESC
LIMIT 3;
```

**Joins**
- **What**: Joins combine rows from multiple tables based on related columns.
- **How**: Use `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, or `FULL JOIN` to retrieve related data.
- **Example**: To retrieve responses along with survey names and question texts:

```sql
SELECT s.survey_name, q.question_text, r.response_number
FROM surveys s
JOIN questions q ON s.survey_id = q.survey_id
JOIN responses r ON q.question_id = r.question_id;
```

### 3. **Stored Procedures and Views**

**Stored Procedures**
- **What**: Stored procedures are precompiled SQL statements that can be executed with parameters.
- **How**: Use stored procedures to encapsulate complex logic and improve performance by reducing repeated query compilation.
- **Example**: `calculate_survey_score` procedure calculates and returns the total score for a survey.

**Views**
- **What**: Views are virtual tables created from SQL queries.
- **How**: Use views to simplify complex queries and encapsulate frequently accessed data.
- **Example**: `survey_scores` view provides a simplified way to access survey scores without writing complex joins repeatedly.

### 4. **Performance Considerations**

**Query Execution Plans**
- **What**: Execution plans show how SQL queries are executed by the database.
- **How**: Use `EXPLAIN` to analyze and optimize query performance.
- **Example**: `EXPLAIN SELECT * FROM responses WHERE user_id = 1;`

**Database Normalization**
- **What**: Normalization organizes tables to reduce redundancy and improve data integrity.
- **How**: Apply normalization rules (e.g., 1NF, 2NF, 3NF) to design efficient schemas.
- **Example**: Split a table into multiple tables to eliminate redundant data.

**Index Maintenance**
- **What**: Indexes require maintenance to stay optimal.
- **How**: Regularly analyze and optimize indexes based on query performance.
- **Example**: Use `ANALYZE TABLE` to update index statistics.

**Query Caching**
- **What**: Caching stores query results to speed up repeated queries.
- **How**: Enable and configure caching in your database settings.
- **Example**: Use `mysql_query_cache_size` in MySQL configuration.

**Partitioning**
- **What**: Partitioning divides large tables into smaller, more manageable pieces.
- **How**: Use partitioning to improve performance for large datasets.
- **Example**: Partition a table by date to manage large volumes of data efficiently.
