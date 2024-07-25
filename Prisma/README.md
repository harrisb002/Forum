## Prisma ORM (Object Relational Mapper) Notes

- Prefix with `npx` not `npm` when running Prisma commands, due to differences in versioning.

#### Useful Commands

Starting project:

- `npm init -y`
- `npm install prisma typescript @types/node --save-dev`: Install deps.
- `npx tsc --init` : Initialize Typescript Project
- `npx prisma init --datasource-provider postgresql`: Create the Prisma file to describe the stricture of the prismaDB.
- Update Connection string with updated info using Postgres
- `npx prisma migrate dev`: Updates changes in databse structure.
- `npx prisma generate`: Creates the code that interacts with the DB.
