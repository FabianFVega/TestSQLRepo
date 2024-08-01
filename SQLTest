----- Creating surveys table
CREATE TABLE surveys (
    survey_id INT AUTO_INCREMENT PRIMARY KEY,
    survey_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating questions table
CREATE TABLE questions (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    survey_id INT NOT NULL,
    question_text TEXT NOT NULL,
    FOREIGN KEY (survey_id) REFERENCES surveys(survey_id)
);

-- Creating users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL UNIQUE
);

-- Creating responses table
CREATE TABLE responses (
    response_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    question_id INT NOT NULL,
    response_number INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

-- Inserting sample data into surveys table--------------------------------------------------------------------------------------------------
INSERT INTO surveys (survey_name) VALUES
('Customer Satisfaction Survey'),
('Employee Feedback Survey'),
('Product Feedback Survey');

-- Inserting sample data into questions table
INSERT INTO questions (survey_id, question_text) VALUES
(1, 'How satisfied are you with our service? rate 1 to 5 being 1=BAD, 2=IT´S NOT GOOD, 3=NORMAL, 4=GOOD and 5 EXCELENT?'),
(1, 'Would you recommend our service to others? rate 1 to 5 being 1=BAD, 2=IT´S NOT GOOD, 3=NORMAL, 4=GOOD and 5 EXCELENT?'),
(2, 'How do you rate your overall job satisfaction? rate 1 to 5 being 1=BAD, 2=IT´S NOT GOOD, 3=NORMAL, 4=GOOD and 5 EXCELENT?'),
(2, 'Do you feel valued at work? rate 1 to 5 being 1=BAD, 2=IT´S NOT GOOD, 3=NORMAL, 4=GOOD and 5 EXCELENT?' ),
(3, 'How would you rate the quality of our product? rate 1 to 5 being 1=BAD, 2=IT´S NOT GOOD, 3=NORMAL, 4=GOOD and 5 EXCELENT?');

-- Inserting sample data into users table
INSERT INTO users (user_name, user_email) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Brown', 'bob.brown@example.com'),
('Charlie Davis', 'charlie.davis@example.com');

-- Insert sample data into responses table
INSERT INTO responses (user_id, question_id, response_number) VALUES
(1, 1, 5),
(1, 2, 3),
(2, 3, 4),
(2, 4, 3),
(3, 5, 3),
(4, 1, 4),
(4, 2, 2),
(5, 3, 1),
(5, 4, 1),
(1, 5, 5),
(2, 1, 5),
(3, 2, 3),
(4, 3, 4),
(5, 4, 3),
(1, 1, 4),
(2, 2, 3),
(3, 3, 1),
(4, 4, 2),
(5, 5, 3);

-- Adding indexes to optimize query performance
CREATE INDEX idx_survey_id ON questions(survey_id);
CREATE INDEX idx_user_id ON responses(user_id);
CREATE INDEX idx_question_id ON responses(question_id);
CREATE INDEX idx_user_email ON users(user_email);


------------------------------------------------------------------------------
-- Basic Query: Retrieve All Responses for a Given Survey
SELECT 
    s.survey_name,
    q.question_text,
    CASE
        WHEN r.response_number = 1 THEN "BAD"
        WHEN r.response_number = 2 THEN "IT'S NOT GOOD"
        WHEN r.response_number = 3 THEN "NORMAL"
        WHEN r.response_number = 4 THEN "GOOD"
        ELSE "EXCELENT"
    END AS "response text"
FROM surveys s
JOIN 
    questions q ON s.survey_id = q.survey_id
JOIN 
    responses r ON q.question_id = r.question_id
WHERE 
    s.survey_id = 1;

-- Advanced Query: Calculate the Average Score for Each Survey
SELECT 
    s.survey_name,
    AVG(CAST(r.response_number AS DECIMAL(10, 2))) AS average_score
FROM surveys s
JOIN 
    questions q ON s.survey_id = q.survey_id
JOIN 
    responses r ON q.question_id = r.question_id
GROUP BY 
    s.survey_name;

-- Advanced Query: Find the Top 3 Users with the Highest Average Response Score
SELECT 
    u.user_name,
    AVG(CAST(r.response_number AS DECIMAL(10, 2))) AS average_score
FROM users u
JOIN 
    responses r ON u.user_id = r.user_id
GROUP BY 
    u.user_id
ORDER BY 
    average_score DESC
LIMIT 3;

-------------------------------------------------------------------------------------------------------
-- Advanced Query: Determine the Distribution of Responses for Each Question in a Specific Survey
SELECT 
    q.question_text,
    r.response_number,
    COUNT(*) AS response_count
FROM questions q
JOIN 
    responses r ON q.question_id = r.question_id
WHERE 
    q.survey_id = 1
GROUP BY 
    q.question_text,
    r.response_number
ORDER BY 
    q.question_text,
    response_count DESC;

------------------------------------------------------------------------------
---Creating storage procedure
DELIMITER //

CREATE PROCEDURE calculate_survey_score(IN survey_id INT, OUT total_score INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE question_id INT;
    DECLARE response_number INT;
    DECLARE score_sum INT DEFAULT 0;

    DECLARE cursor_responses CURSOR FOR
        SELECT q.question_id, r.response_number
        FROM questions q
        JOIN responses r ON q.question_id = r.question_id
        WHERE q.survey_id = survey_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN cursor_responses;
    read_loop: LOOP
        FETCH cursor_responses INTO question_id, response_number;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET score_sum = score_sum + response_number;
    END LOOP;
    CLOSE cursor_responses;
    SET total_score = score_sum;
END //

DELIMITER ;

-------------------------------------------------------------------------------------------------
--Calling Storage procedure
SET @total_score = 0;
-- Call the stored procedure with survey_id = 1 and store the result in @total_score
CALL calculate_survey_score(1, @total_score);
SELECT @total_score;

DELIMITER //
----Creating view---------------------------------------------------------------------------------------------------------

CREATE VIEW survey_scores AS
SELECT 
    s.survey_name,
    q.question_text,
    r.response_number,
    rw.weight AS response_score
FROM 
    surveys s
JOIN 
    questions q ON s.survey_id = q.survey_id
JOIN 
    responses r ON q.question_id = r.question_id
JOIN 
    response_weights rw ON r.response_number = rw.response_number;
