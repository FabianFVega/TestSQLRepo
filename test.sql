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
    response_text TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (question_id) REFERENCES questions(question_id)
);

-- Inserting sample data into surveys table
INSERT INTO surveys (survey_name) VALUES
('Customer Satisfaction Survey'),
('Employee Feedback Survey'),
('Product Feedback Survey');

-- Inserting sample data into questions table
INSERT INTO questions (survey_id, question_text) VALUES
(1, 'How satisfied are you with our service?'),
(1, 'Would you recommend our service to others?'),
(2, 'How do you rate your overall job satisfaction?'),
(2, 'Do you feel valued at work?'),
(3, 'How would you rate the quality of our product?');

-- Inserting sample data into users table
INSERT INTO users (user_name, user_email) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Alice Johnson', 'alice.johnson@example.com'),
('Bob Brown', 'bob.brown@example.com'),
('Charlie Davis', 'charlie.davis@example.com');

-- Insert sample data into responses table
INSERT INTO responses (user_id, question_id, response_text) VALUES
(1, 1, 'Very satisfied'),
(1, 2, 'Yes'),
(2, 3, 'Satisfied'),
(2, 4, 'Yes'),
(3, 5, 'Good'),
(4, 1, 'Satisfied'),
(4, 2, 'Maybe'),
(5, 3, 'Neutral'),
(5, 4, 'No'),
(1, 5, 'Excellent'),
(2, 1, 'Very satisfied'),
(3, 2, 'Yes'),
(4, 3, 'Satisfied'),
(5, 4, 'Yes'),
(1, 1, 'Satisfied'),
(2, 2, 'Yes'),
(3, 3, 'Neutral'),
(4, 4, 'Maybe'),
(5, 5, 'Good');

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
    r.response_text
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
    AVG(CAST(r.response_text AS DECIMAL(10, 2))) AS average_score
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
    AVG(CAST(r.response_text AS DECIMAL(10, 2))) AS average_score
FROM users u
JOIN 
    responses r ON u.user_id = r.user_id
GROUP BY 
    u.user_id
ORDER BY 
    average_score DESC
LIMIT 3;

-- Advanced Query: Determine the Distribution of Responses for Each Question in a Specific Survey
SELECT 
    q.question_text,
    r.response_text,
    COUNT(*) AS response_count
FROM questions q
JOIN 
    responses r ON q.question_id = r.question_id
WHERE 
    q.survey_id = 1
GROUP BY 
    q.question_text,
    r.response_text
ORDER BY 
    q.question_text,
    response_count DESC;



------------------------------------------------------------------------------
DELIMITER //

CREATE PROCEDURE calculate_survey_score(IN survey_id INT, OUT total_score INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE question_id INT;
    DECLARE response_text VARCHAR(255);
    DECLARE weight INT;
    DECLARE score_sum INT DEFAULT 0;

    DECLARE cursor_responses CURSOR FOR
        SELECT q.question_id, r.response_text
        FROM questions q
        JOIN responses r ON q.question_id = r.question_id
        WHERE q.survey_id = survey_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cursor_responses;

    read_loop: LOOP
        FETCH cursor_responses INTO question_id, response_text;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Get the weight for the response
        SELECT rw.weight INTO weight
        FROM response_weights rw
        WHERE rw.response_text = response_text;

        -- Add the weight to the total score
        SET score_sum = score_sum + weight;
    END LOOP;

    CLOSE cursor_responses;

    -- Set the total score
    SET total_score = score_sum;
END //

DELIMITER ;
------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE calculate_survey_score(IN survey_id INT, OUT total_score INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE question_id INT;
    DECLARE response_text VARCHAR(255);
    DECLARE weight INT;
    DECLARE score_sum INT DEFAULT 0;

    DECLARE cursor_responses CURSOR FOR
        SELECT q.question_id, r.response_text
        FROM questions q
        JOIN responses r ON q.question_id = r.question_id
        WHERE q.survey_id = survey_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cursor_responses;

    read_loop: LOOP
        FETCH cursor_responses INTO question_id, response_text;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Get the weight for the response
        SELECT rw.weight INTO weight
        FROM response_weights rw
        WHERE rw.response_text = response_text;

        -- Add the weight to the total score
        SET score_sum = score_sum + weight;
    END LOOP;

    CLOSE cursor_responses;

    -- Set the total score
    SET total_score = score_sum;
END //

DELIMITER ;

CREATE VIEW survey_scores AS
SELECT 
    s.survey_name,
    q.question_text,
    r.response_text,
    rw.weight AS response_score
FROM 
    surveys s
JOIN 
    questions q ON s.survey_id = q.survey_id
JOIN 
    responses r ON q.question_id = r.question_id
JOIN 
    response_weights rw ON r.response_text = rw.response_text;
