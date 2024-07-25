SELECT
    'Hey there' AS message;

-- Single-line comment
/*
Multi-line comment
 */
CREATE TABLE
    IF NOT EXISTS users (
        user_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        username varchar(30) UNIQUE,
        email varchar(255) UNIQUE
    );

INSERT INTO
    users (username, email)
VALUES
    ('BenH', 'har@gmail,com');