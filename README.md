## Basic Forum using PostgreSQL

### Postgres Shell Command Notes

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

---

NOTES - PRIMARY KEY

- `CREATE TABLE users (`
  `user_id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,`
  `username varchar(30) UNIQUE,`
  `email varchar(255) UNIQUE);`
-
- ECT: `UNIQUE` does not have the contraint of being `NOT NULL` while in contrast Primary Keys do.
- Surregate Keys and Natural Keys.

---

Start a Session: `psql -h localhost -d forum -U postgres`
SQL from a File: `\i <file>`

---

NOTES - GENERAL:

- `ALTER` is for DDL used to change the structure of the table, whereas `UPDATE` is DML used to change the actual data in the table.
- Similiar to `DELETE` and `DROP` where DELETE is used to delete rows which is Data Manipulation, whereas DROP is used to drop tables.

- `SET NULL`: If the parent row is deleted then the child row is orpaned (set to null) instead of being deleted as seen in `ON DELETE CASCADE`

---

#### NOTES

- DDL: Data Definition Language = Focuses on the defined structure of the db
- DML: Data Manipulation Language = CRUD capabilities

---

#### DDL includes the following:
- CREATE
- DROP
- ALTER

#### DML includes the following:
- SELECT
- UPDATE
- INSERT

---

#### Lookup tables and check contraints - Enforces integrity!
- Lookup tables are more flexible in that adding new feilds is available.
- Check contraints do NOT have this capability and one must drop the constraint to add a new field.
- Lookup tables do add another table which is more data being stored.
- Lookup tables are also available for all RDMS that allow for FK's which is all of them.
- Check constraints are not available for all RDMS's
- Loading all possible check contraints values is also a difficulty (at least in Postgres)
- Check contraints are simplier however, as joins are not needed as they are in Lookup tables

---







