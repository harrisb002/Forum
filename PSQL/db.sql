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
CREATE OR REPLACE VIEW
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
CREATE OR REPLACE VIEW orphaned_posts AS
SELECT * FROM posts
WHERE user_id IS NULL;
--
-- 
SELECT * FROM orphaned_posts;
--
-- 
CREATE TABLE
    IF NOT EXISTS referrals (
        referral_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        referrer_id int REFERENCES users (user_id),
        referred_id int UNIQUE REFERENCES users (user_id)
    );
-- 
--
INSERT INTO
    referrals (referrer_id, referred_id)
VALUES
    (1, 2),
    (1, 3);
--
--
SELECT * FROM referrals
--
-- 
-- Now using self-join instead of having a seprate table for referral system as shown above
CREATE TABLE
    IF NOT EXISTS users (
        user_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        username varchar(30) UNIQUE,
        email varchar(255) UNIQUE,
        referred_by int REFERENCES users(user_id)
    );
--
-- 
INSERT INTO
    users (username, email, referred_by)
VALUES
    ('benH', 'BenH@gamil.com', NULL),
    ('nickM', 'NickH@gmail.com', 1),
    ('JoshL', 'JoshL@gmail.com', 1);
-- 
--
SELECT * FROM users;
--
-- 
SELECT
    referred.username,
    referred.email,
    referrer.username AS referred_by
FROM
    users AS referred
    INNER JOIN users AS referrer ON referred.referred_by = referrer.user_id;
--
-- Get all users even those who have not been referred
SELECT
    referred.username,
    referred.email,
    referrer.username AS referred_by
FROM
    users AS referred
    LEFT JOIN users AS referrer ON referred.referred_by = referrer.user_id;
CREATE OR REPLACE VIEW
    referrals AS
SELECT
    referred.username,
    referred.email,
    referrer.username AS referred_by
FROM
    users AS referred
    LEFT JOIN users AS referrer ON referred.referred_by = referrer.user_id;
--
-- 
SELECT username, email, referred_by FROM referrals;
--
--
CREATE TABLE
    IF NOT EXISTS comments (
        comment_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id int NOT NULL REFERENCES users (user_id),
        post_id int NOT NULL REFERENCES posts (post_id),
        body text NOT NULL,
        created_at timestamp NOT NULL DEFAULT current_timestamp
    );
--
--
INSERT INTO
    comments (user_id, post_id, body)
VALUES
    (1, 2, 'Sure'),
    (3, 2, 'Cool post');
--
--
SELECT
    users.username,
    posts.title AS "post title",
    posters.username AS "post author",
    comments.body,
    comments.created_at
FROM
    comments
    INNER JOIN users ON comments.user_id = users.user_id
    INNER JOIN posts ON comments.post_id = posts.post_id
    INNER JOIN users AS posters ON posts.user_id = posters.user_id
ORDER BY
    comments.created_at DESC
LIMIT
    5;
--
--
INSERT INTO comments (user_id, post_id, body, created_at)
VALUES 
(1, 2, 'That is very interesting. I completely agree with your point.', '2023-05-01 14:35:28'),
(3, 1, 'Thanks for sharing. This was a great read.', '2023-04-15 08:45:37'),
(2, 3, 'Very insightful post. I learned a lot.', '2023-03-21 16:17:46'),
(1, 1, 'I never thought about it that way before. Thanks for the new perspective.', '2023-02-28 09:26:55'),
(3, 2, 'I am looking forward to more posts like this one.', '2023-01-20 18:30:04'),
(2, 2, 'Good point. I completely agree.', '2023-04-10 13:33:28'),
(1, 3, 'Interesting perspective. Thanks for sharing.', '2023-03-15 11:45:37'),
(2, 1, 'This was very enlightening. Keep up the good work.', '2023-02-21 12:17:46'),
(3, 1, 'I look forward to your next post.', '2023-01-28 10:26:55'),
(1, 2, 'Very well-written post. I enjoyed reading this.', '2023-05-30 19:30:04'),
(2, 3, 'Thanks for the insights. I learned a lot from your post.', '2023-04-20 15:35:28'),
(3, 2, 'I agree with your points. Looking forward to your next post.', '2023-03-25 14:45:37'),
(1, 1, 'Great perspective. I never thought of it that way.', '2023-02-23 17:17:46'),
(2, 3, 'Good post. I look forward to more from you.', '2023-01-31 18:26:55'),
(3, 1, 'Thanks for sharing your thoughts. I enjoyed reading this.', '2023-05-15 20:30:04');
--
--
CREATE OR REPLACE VIEW
    latest_comments AS
SELECT
    users.username,
    posts.title AS "post title",
    posters.username AS "post author",
    comments.body,
    comments.created_at
FROM
    comments
    INNER JOIN users ON comments.user_id = users.user_id
    INNER JOIN posts ON comments.post_id = posts.post_id
    INNER JOIN users AS posters ON posts.user_id = posters.user_id
ORDER BY
    comments.created_at DESC
LIMIT
    5;
--
--
SELECT
    *
FROM
    latest_comments;
--
--
CREATE TABLE
    IF NOT EXISTS follows (
        follow_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id int NOT NULL REFERENCES users (user_id),
        following_id int NOT NULL REFERENCES users (user_id),
        UNIQUE (user_id, following_id)
    );
--
--
INSERT INTO
    follows (user_id, following_id)
VALUES
    (1, 2),
    (1, 3),
    (2, 1),
    (3, 2);
--
-- Get all accounts user_id 1 follows
SELECT follows.user_id, users.username AS "follows" FROM follows
JOIN users ON follows.following_id = users.user_id
WHERE follows.user_id = 1;
--
--
SELECT * FROM users;
SELECT * FROM follows;
-- For Reference1: 
-- benH  follows nickM
-- benH  follows JoshL
-- nickM follows benH
-- JoshL follows nickM
-- Now creating Reference1 View
CREATE
OR REPLACE VIEW following AS
SELECT
    u1.username AS username,
    u2.username AS "following"
FROM
    follows AS f
    JOIN users AS u1 ON f.user_id = u1.user_id
    JOIN users AS u2 ON f.following_id = u2.user_id;
-- For Reference2: 
-- nickM followed by benH
-- JoshL followed by benH
-- benH  followed  by nickM 
-- nickM followed by JoshL 
-- Now creating Reference2 View 
CREATE
OR REPLACE VIEW followers AS
SELECT
    u1.username AS username,
    u2.username AS "followed by"
FROM
    follows AS f
    JOIN users AS u1 ON f.following_id = u1.user_id
    JOIN users AS u2 ON f.user_id = u2.user_id;
--
--
SELECT
    *
FROM
    following
WHERE
    username = 'benH';
-- 
-- 
SELECT
    *
FROM
    followers
WHERE
    username = 'benH';
--
-- Creating table with Composite Primary Key instead of Surrogate Key
CREATE TABLE
    IF NOT EXISTS followsComp (
        user_id int NOT NULL REFERENCES users (user_id),
        following_id int NOT NULL REFERENCES users (user_id),
        PRIMARY KEY (user_id, following_id) -- Uses a Composite Key
    );
--
--
INSERT INTO
    followsComp (user_id, following_id)
VALUES
    (1, 2),
    (1, 3),
    (2, 1),
    (3, 2);
--
--
CREATE
OR REPLACE VIEW followersComp AS
SELECT
    u1.username AS username,
    u2.username AS "followed by"
FROM
    followsComp AS f
    JOIN users AS u1 ON f.following_id = u1.user_id
    JOIN users AS u2 ON f.user_id = u2.user_id;
--
--
SELECT
    *
FROM
    followersComp
WHERE
    username = 'benH';
--
-- 
SELECT
    *
FROM
    followsComp
WHERE
    user_id = 1
    AND following_id = 2;
--
-- Using previoius Surrogate Key for this example to demostrate usefullness 
CREATE TABLE
    IF NOT EXISTS follow_notifications (
        notification_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        follow_id int NOT NULL REFERENCES follows (follow_id),
        notification_text varchar(255) NOT NULL
    );
--
--
INSERT INTO
    follow_notifications (follow_id, notification_text)
VALUES
    (1, 'WOW look you followed who');
--
--
-- Now demostrating the same thing using a Composite Key (More Difficult!) 
CREATE TABLE
    IF NOT EXISTS follow_notificationsComp (
        notification_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        user_id int NOT NULL,
        following_id int NOT NULL,
        notification_text varchar(255) NOT NULL,
        FOREIGN KEY (user_id, following_id) REFERENCES followsComp (user_id, following_id)
    );
--
--
INSERT INTO
    follow_notificationsComp (following_id, user_id, notification_text)
VALUES
    (1, 2, 'WOW look you followed who');
--
--
SELECT * FROM follow_notificationsComp;
--
--
CREATE TABLE IF NOT EXISTS
    accounts (
        account_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        amount decimal(15, 2) NOT NULL
    );
--
--
INSERT INTO
    accounts (amount)
VALUES
    (1000.00),
    (1000.00)
--
-- Starting a Transaction
BEGIN;
-- subtract 500 from account 1
UPDATE accounts
SET
    amount = amount - 500
WHERE
    account_id = 1;
-- add 500 to account 2
UPDATE accounts
SET
    amount = amount + 500
WHERE
    account_id = 2;
COMMIT;
--
-- Varaibles using dollar quoting
DO 
$$ 
DECLARE 
    transfer_amount numeric := 100;
BEGIN
-- subtract 500 from account 1
UPDATE accounts
SET
    amount = amount - transfer_amount
WHERE
    account_id = 1;
-- add 500 to account 2
UPDATE accounts
SET
    amount = amount + transfer_amount
WHERE
    account_id = 2;
END;
$$

-- Using Procedures
CREATE OR REPLACE PROCEDURE transfer (
    from_account_id INT, 
    to_account_id INT, 
    transfer_amount NUMERIC
)
LANGUAGE plpgsql 
AS $$ 
BEGIN
    -- subtract 500 from account 1
    UPDATE accounts
    SET
        amount = amount - transfer_amount
    WHERE
        account_id = from_account_id;
    -- add 500 to account 2
    UPDATE accounts
    SET
        amount = amount + transfer_amount
    WHERE
        account_id = to_account_id;
END;
$$
--
-- Invoke the procedure
CALL transfer(1, 2, 200)