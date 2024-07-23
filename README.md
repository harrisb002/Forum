## Basic Forum using PostgreSQL

### Postgres Shell Command Nots
- `\?` : Gives examples of commands
- `\!` : Goes back to regualr terminal commands 
- `\c` : Change the current db
- `\dt` : Lists the tables/relations
- `\dn` : Lists all schemas
- `\di` : Lists all indexes
- `\q` : Exits
---
- `SELECT current_databse();` : Selects the current db
- `SELECT current_databse();` : You guessed it, selects the current schema
- `SELECT current_user;` : Selects the current user
- `SELECT proname FROM pg_catalog.pg_proc;` : Lists all the available functions
---
- `CREATE DATABASE forum` : Create the db forum
- `DROP DATABASE forum` : Drop it 
---
- Some SQL (DDL)
- `CREATE TABLE posts (post_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,`
`title varchar(255) NOT NULL,`
`body text NOT NULL,`
`created_at timestamp NOT NULL DEFAULT current_timestamp);` 
- `ALTER TABLE posts ADD COLUMN poster varchar(50) NOT NULL;`  

---
- Some SQL (DML)
- `INSERT INTO posts (title, body)`
`VALUES ('How do I use Postgres?', 'I need help');` 
- `ALTER TABLE posts`
`ADD COLUMN poster varchar(50) NOT NULL DEFAULT 'deleted';`  
- `INSERT INTO posts (title, body, poster)`
`VALUES ('Hey there this is a test', 'Here is my test...', 'Ben');`  
- `SELECT title, body, to_char(created_at, 'YYYY/MM/DD') as date FROM posts;` 
: Uses the to_char function to alter (temporary for just viewing the table) the created_at column. 
- `SELECT * FROM posts WHERE post_id = 2` 
: Using the WHERE clause
- `INSERT INTO posts (title, body, poster)`
`VALUES ('C++ vs C', 'Whats the difference', 'Some Guy');` 
: Adding some more data
- `SELECT * FROM posts WHERE poster = 'Some Guy' ORDER BY created_at DESC;` 
: Using ORDER BY 
- `UPDATE posts`
`SET title='(Solved) How do I use Postgres?'`
`WHERE post_id=1;` : MUST USE `WHERE` or it will update EVERYTHING!

NOTES: 
- `ALTER` is for DDL used to change the structure of the table, whereas `UPDATE` is DML used to change the actual data in the table.
- Similiar to `DELETE` and `DROP` where DELETE is used to delete rows which is Data Manipulation, whereas DROP is used to drop tables.

### Other Notes
---
- DDL: Data Definition Language = Focuses on the defined structure of the db
-  DML: Data Manipulation Language = CRUD capabilities