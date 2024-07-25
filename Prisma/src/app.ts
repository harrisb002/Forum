import { PrismaClient } from "@prisma/client";

// Can pass an object to look at queires being made. Super cool
// const prisma = new PrismaClient({ log: ["query"] });
const prisma = new PrismaClient();

// //Some basic queries & other practice stuff
// //MOCK DATA FOR TRAINER
// const trainer = await prisma.trainer.create({
//   data: {
//     email: "Satoshi@email.com",
//     name: "Ash Ketchum",
//     username: "OG Trainer",
//   },
// });

// //Updating data using prisma
// const trainers = await prisma.trainer.update({
//   where: { username: "ben_brown_3" },
//   data: { username: "updated username now" },
// });

// // Ordering outputed data
// const trainers = await prisma.trainer.findMany({ orderBy: { name: "asc" } });

// // Searching for data
// const trainers = await prisma.trainer.findMany({
//   where: { email: { endsWith: "gmail.com" } },
// });

// // Logical Operator OR
// const trainers = await prisma.trainer.findMany({
//   where: {
//     OR: [
//       { email: { endsWith: "gmail.com" } },
//       { email: { endsWith: "hotmail.com" } },
//     ],
//   },
// });

// // Find the first trainer
// const trainers = await prisma.trainer.findFirst();
// // Delete all trainers
// await prisma.trainer.deleteMany();
// console.log(trainers);

// console.log(trainer);

// // MOCK DATA FOR TRAINERS
// const trainers = await prisma.trainer.createMany({
//   data: [
//     { email: "Misty@gmail.com", name: "Misty", username: "CeruleanGymLeader" },
//     { email: "Brock@gmail.com", name: "Brock", username: "PewterGymLeader" },
//     { email: "Gary@gmail.com", name: "Gary Oak", username: "BlueOak" },
//     { email: "Dawn@gmail.com", name: "Dawn", username: "TwinleafTrainer" },
//     { email: "May@gmail.com", name: "May", username: "PetalburgTrainer" },
//   ],
// });

// // MOCK DATA FOR TRAINERS
// const response = await prisma.pokemon.createMany({
//   data: [
//     {
//       title: "Charizard",
//       body: "Flame-breathing dragon",
//       trainerId: trainer.id,
//     },
//     { title: "Pikachu", body: "Electric mouse Pokémon", trainerId: trainer.id },
//     { title: "Bulbasaur", body: "Seed-plant dinosaur", trainerId: trainer.id },
//     { title: "Squirtle", body: "Water turtle Pokémon", trainerId: trainer.id },
//     {
//       title: "Jigglypuff",
//       body: "Singing balloon Pokémon",
//       trainerId: trainer.id,
//     },
//     { title: "Meowth", body: "Coin-loving cat", trainerId: trainer.id },
//     { title: "Gengar", body: "Ghostly shadow Pokémon", trainerId: trainer.id },
//     { title: "Snorlax", body: "Sleeping giant Pokémon", trainerId: trainer.id },
//     { title: "Eevee", body: "Evolutionary fox Pokémon", trainerId: trainer.id },
//     { title: "Machamp", body: "Four-armed fighter", trainerId: trainer.id },
//     { title: "Magikarp", body: "Weak fish Pokémon", trainerId: trainer.id },
//   ],

// });
// console.log("rows inserted", response);
// const pokemon = await prisma.pokemon.findMany({
//   where: { trainerId: 1 },
// });

// pokemon.forEach((pokemon) => {
//   console.log(pokemon.title);
// });

// const trainer = await prisma.trainer.findUnique({
//   where: { username: "OG Trainer" },
//   include: { pokemon: true }, // SO COOL, accessing pokemon through the trainer using the ORM
// });

// // Needed in TS just in case trainer is null
// if (!trainer) {
//   process.exit(1);
// }

// trainer.pokemon.forEach((pokemon) => {
//   console.log(pokemon.title);
// });

// // Finding the Brock trainer
// const trainer = await prisma.trainer.findFirst({ where: { name: "Brock" } });

// if (!trainer) {
//   process.exit(1);
// }

// // Setting the new pokemon to Brock Trainer
// const pokemon = await prisma.pokemon.create({
//   data: {
//     title: "Lucario",
//     body: "Fighting/Steel-type",
//     trainerId: trainer.id,
//     moves: {
//       // Can also create the move at the SAME TIME! Pretty cool
//       create: [
//         // Must move through the intermediate PokemonMoves table using, create
//         { move: { create: { name: "Aura Sphere" } } },
//         { move: { create: { name: "Bone Rush" } } },
//       ],
//     },
//   },
//   // Can also define other properties related to the newly created move
//   // This will eagerly load them, meaning load them up front and be able to access them immediately
//   include: { moves: { include: { move: true } }, owner: true },
// });

// console.log(pokemon);

// const pokemon = await prisma.pokemon.findFirst({
//   where: { id: 12 },
//   include: { moves: { include: { move: true } } },
// });

// if (!pokemon) {
//   process.exit(1);
// }

// pokemon.moves.forEach((pokemon) => {
//   console.log(pokemon.move.name);
// });

const trainer = await prisma.trainer.findMany();

console.log(trainer);
