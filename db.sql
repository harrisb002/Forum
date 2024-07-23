CREATE TABLE
    IF NOT EXISTS users (
        user_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        username varchar(30) UNIQUE,
        email varchar(255) UNIQUE
    );

CREATE TABLE
    IF NOT EXISTS posts (
        post_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id int REFERENCES users (user_id),
        title varchar(255) NOT NULL,
        body text NOT NULL,
        created_at timestamp DEFAULT current_timestamp
    );

-- INSERT INTO
--     users (username, email)
-- VALUES
--     ('benH', 'BenH@gamil.com'),
--     ('nickM', 'NickH@gmail.com'),
--     ('JoshL', 'JoshL@gmail.com')

SELECT
    *
FROM
    users;

-- INSERT INTO
--     posts (user_id, title, body)
-- VALUES
--     (2, 'Will Postgres resuse IDs?', 'IDENTITY Qs'),
--     (
--         2,
--         'How do FKs work in Postgres?',
--         'Foreign Key Qs'
--     ),
--     (3, 'Is a BS in CS worth it?', 'School Qs')

SELECT
    *
FROM
    posts;

