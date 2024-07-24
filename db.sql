CREATE TABLE
    IF NOT EXISTS users (
        user_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        username varchar(30) UNIQUE,
        email varchar(255) UNIQUE
    );
--
--
CREATE TABLE
    IF NOT EXISTS posts (
        post_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id int REFERENCES users (user_id),
        title varchar(255) NOT NULL,
        body text NOT NULL,
        created_at timestamp DEFAULT current_timestamp
    );
--
--
INSERT INTO
    users (username, email)
VALUES
    ('benH', 'BenH@gamil.com'),
    ('nickM', 'NickH@gmail.com'),
    ('JoshL', 'JoshL@gmail.com')
--
--
SELECT
    *
FROM
    users;
--
--
INSERT INTO
    posts (user_id, title, body)
VALUES
    (2, 'Will Postgres resuse IDs?', 'IDENTITY Qs'),
    (
        2,
        'How do FKs work in Postgres?',
        'Foreign Key Qs'
    ),
    (3, 'Is a BS in CS worth it?', 'School Qs')
--
--
SELECT
    *
FROM
    posts;
--
--
-- Implicit join using WHERE clause
SELECT
    *
FROM
    posts,
    users
WHERE
    users.user_id = posts.user_id;
--
--
-- Explicit join using INNER JOIN 
SELECT
    *
FROM
    posts
    INNER JOIN users ON posts.user_id = users.user_id;
-- Change displayed order 
SELECT
    *
FROM
    users
    INNER JOIN posts ON posts.user_id = users.user_id;
--
--
-- Creating a post without a user
-- Shows that FK relationships can be NULLABLE
INSERT INTO posts (title, body)
VALUES ('orphan row', 'I dont have a poster');
--
--
SELECT u.username, p.title, p.body
FROM users as u
INNER JOIN posts as p
ON u.user_id = p.user_id;
--
--
SELECT * FROM posts;
--
--
-- DOES NOT CHANGE DATA
-- Cannot use IF NOT EXISTS, must instead use OR REPLACE instead
CREATE
OR REPLACE VIEW post_summary AS
SELECT
    u.username,
    p.title,
    p.body
FROM
    users as u
    INNER JOIN posts as p ON u.user_id = p.user_id;
-- 
-- 
SELECT
    *
FROM
    post_summary;
-- 
--
CREATE INDEX ON posts(user_id);
-- 
--
EXPLAIN SELECT * FROM post_summary
-- 
--
DROP INDEX posts_user_id_idx;
-- 
--
REMOVE EXISTING FK
ALTER TABLE posts 
DROP CONSTRAINT posts_user_id_fkey;
-- 
--
ALTER TABLE posts
ADD FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE CASCADE;
-- 
--
DELETE FROM users
WHERE user_id = 3;
-- 
--
ALTER TABLE posts
ALTER COLUMN user_id DROP NOT NULL;
-- 
--
ALTER TABLE posts
DROP CONSTRAINT posts_user_id_fkey,
ADD FOREIGN KEY (user_id)
REFERENCES users(user_id)
ON DELETE SET NULL;
-- 
--
SELECT * FROM posts;
SELECT * FROM users;
-- 
--
DELETE FROM users
WHERE user_id = 2;
-- 
--