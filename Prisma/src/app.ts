import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// //MOCK DATA
// const users = await prisma.user.createMany({
//     data: [
//         { email: 'ben1@gmail.com', name: 'Benjamin Smith', username: 'ben_smith_1' },
//         { email: 'ben2@gmail.com', name: 'Benjamin Johnson', username: 'ben_johnson_2' },
//         { email: 'ben3@hotmail.com', name: 'Benjamin Brown', username: 'ben_brown_3' },
//         { email: 'ben4@hotmail.com', name: 'Benjamin Davis', username: 'ben_davis_4' },
//         { email: 'ben5@yahoo.com', name: 'Benjamin Wilson', username: 'ben_wilson_5' },
//         { email: 'ben6@yahoo.com', name: 'Benjamin Martinez', username: 'ben_martinez_6' },
//         { email: 'ben7@gmail.com', name: 'Benjamin Anderson', username: 'ben_anderson_7' },
//         { email: 'ben8@hotmail.com', name: 'Benjamin Garcia', username: 'ben_garcia_8' },
//         { email: 'ben9@yahoo.com', name: 'Benjamin Rodriguez', username: 'ben_rodriguez_9' },
//         { email: 'ben10@gmail.com', name: 'Benjamin Moore', username: 'ben_moore_10' },
//     ],
// });

// //Some basic queries

// //Updating data using prisma
const users = await prisma.user.update({
  where: { username: "ben_brown_3" },
  data: { username: "updated username now" },
});

// // Ordering outputed data
// const users = await prisma.user.findMany({ orderBy: { name: "asc" } });

// // Searching for data
// const users = await prisma.user.findMany({
//   where: { email: { endsWith: "gmail.com" } },
// });

// // Logical Operator OR
// const users = await prisma.user.findMany({
//   where: {
//     OR: [
//       { email: { endsWith: "gmail.com" } },
//       { email: { endsWith: "hotmail.com" } },
//     ],
//   },
// });

// // Find the first user
// const users = await prisma.user.findFirst();

// // Delete all users
// await prisma.user.deleteMany();

console.log(users);
