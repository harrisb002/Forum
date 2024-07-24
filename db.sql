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
    ('JoshL', 'JoshL@gmail.com');
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
    (3, 'Is a BS in CS worth it?', 'School Qs');
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
-- Creating a lookup table for available categories
CREATE TABLE IF NOT EXISTS categories (
 category_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 name varchar(255) NOT NULL UNIQUE
);
-- 
-- Drop the posts table to add the catgeory reference
DROP TABLE IF EXISTS posts;
--
--
CREATE TABLE
    IF NOT EXISTS posts (
        post_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        -- user_id int REFERENCES users (user_id), -- Commenting out for now
        title varchar(255) NOT NULL,
        body text NOT NULL,
        created_at timestamp DEFAULT current_timestamp,
        category_id int REFERENCES categories (category_id)
    );
-- 
-- 
INSERT INTO categories (name)
VALUES ('career'), ('code'), ('off topic');
-- 
-- 
INSERT INTO
    posts (title, body, category_id)
VALUES
    ('Will Postgres resuse IDs?', 'IDENTITY Qs', 2),
    ('How do FKs work in Postgres?', 'Foreign Key Qs', 2),
    ('Is a BS in CS worth it?', 'School Qs', 1);
-- 
-- 
SELECT title, body, name FROM posts
INNER JOIN categories
ON posts.category_id = categories.category_id;
-- 
-- 
UPDATE posts 
SET category_id = (SELECT category_id FROM categories WHERE name = 'career')
WHERE post_id = 1;
-- 
--
ALTER TABLE posts
DROP COLUMN category_id;
-- 
--
DROP TABLE categories;
-- 
-- Using check constraint instead of lookup table used above 'categories
ALTER TABLE posts
ADD COLUMN catgeory varchar(255) CHECK (catgeory IN ('career', 'code', 'off topic'));
-- 
--
UPDATE posts 
SET catgeory = 'code' -- Anything not in the check constraint above will NOT work!
WHERE post_id = 1;
-- 
-- Gets all users and corresponding posts, EVEN IF they havent posted
SELECT username, title, body 
FROM users
LEFT JOIN posts
ON posts.user_id = users.user_id;

-- Now if we orphan a post to have no corresponding user we can show the same the other way
-- This only works becuase the user_id in the posts table is nullable! 
UPDATE posts
SET user_id = NULL
WHERE post_id = 1;
--
--
-- Gets all posts and corresponding users, EVEN IF the user for the post has been deleted
SELECT username, title, body 
FROM posts
LEFT JOIN users
ON posts.user_id = users.user_id;
-- 
-- 
-- Making it so if the user is deleted, the posts table user_id is set to null
-- This can be done by using the ON DELETE constraint
ALTER TABLE posts 
DROP CONSTRAINT posts_user_id_fkey,
ADD FOREIGN KEY (user_id)
REFERENCES users (user_id)
ON DELETE SET NULL;
-- 
-- 
-- This will now cascade when the user is deleted 
-- So that the corresponding user_id in the posts table is set to NULL
DELETE FROM users 
WHERE user_id = 3;
-- 
--
CREATE VIEW
    all_posts AS
SELECT
    u.username,
    p.title,
    p.body
FROM
    posts AS p
    LEFT JOIN users AS u 
    ON p.user_id = u.user_id;
-- 
--
CREATE VIEW orphaned_posts AS
SELECT * FROM posts
WHERE user_id IS NULL;
--
-- 
SELECT * FROM orphaned_posts;
