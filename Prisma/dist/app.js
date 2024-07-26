import { PrismaClient, TrainerType } from "@prisma/client";
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
// const trainers = await prisma.trainer.findMany({
//   // include: {
//   //   pokemon: {
//   //     include: {
//   //       moves: {
//   //         include: {
//   //           move: true,
//   //         },
//   //       },
//   //     },
//   //   },
//   //   _count: true,
//   // },
//   where: {
//     pokemon: {
//       some: { moves: { some: {} } }, // Get only those who have at least 1 pokemon and the pokemon has at least one move
//     },
//   },
//   // Gets the properties I want just as in a regualar select clause
//   // Cannot be in same nesting as include as shown above so must define what to include in select
//   select: {
//     username: true,
//     pokemon: {
//       select: {
//         title: true,
//       },
//     },
//   },
// });
// // console.log(trainers);
// console.log(JSON.stringify(trainers, null, 2));
// // Working with filters
// // Filter for trainers with no pokemon
// const trainers = await prisma.trainer.findMany({
//   where: { pokemon: { none: {} } },
// });
// // Filter for trainers with no pokemon
// const trainers = await prisma.trainer.findMany({
//   where: { pokemon: { every: { owned: false } } }, // Every pokemon has the property set to ''
// });
// // Get the first trainer without a pokemon
// const trainer = await prisma.trainer.findFirst({
//   where: { pokemon: { none: {} } },
// });
// if (!trainer) {
//   console.log("All trainers have pokemon! Exiting...");
//   process.exit(1);
// }
// console.log("Trainer with no pokemon: ", trainer);
// // Create a pokemon for the trainer that doesnt yet have one
// const pokemon = await prisma.pokemon.create({
//   data: {
//     title: "Squirtle",
//     body: "Water turtle Pokémon",
//     trainerId: trainer.id,
//   },
// });
// console.log("Pokemon created: ", pokemon);
// const pokemons = await prisma.pokemon.findMany({
//   where: {
//     moves: { none: {} },
//   },
//   include: {
//     owner: true,
//   },
// });
// // Retrieving all pokemon that dont have any moves
// console.log("Pokemon without any moves: ", pokemons);
// // Finding trainers with username that starts with "P"
// const trainers = await prisma.trainer.findMany({
//   where: { username: { startsWith: "P", mode: "insensitive" } },
//   include: { pokemon: true },
// });
// console.log(
//   trainers.forEach((trainer) => {
//     console.log("Trainer: ", trainer.name);
//     console.log(trainer.pokemon);
//   })
// );
// // Going the other way to find trainers with username that starts with "P"
// // But now through the Pokemon in which may be owned by them.
// const pokemon = await prisma.pokemon.findMany({
//   where: {
//     owner: {
//       is: {
//         username: { startsWith: "P", mode: "insensitive" },
//       },
//     },
//   },
//   include: {
//     owner: true,
//   },
// });
// // Update a trainer to be verified
// const pokemon = (await prisma.pokemon.findFirst())!; // Can do this to tell TS that it wont be null. Dangerous...
// console.log("Pokemon to verify: ", pokemon);
// // Updating the pokemon to be verified
// const result = await prisma.pokemon.update({
//   where: { id: pokemon.id },
//   data: {
//     owner: {
//       update: {
//         verified: true,
//       },
//     },
//   },
//   include: {
//     owner: true,
//   },
// });
// const pokemon = await prisma.pokemon.findMany({
//   where: {
//     owner: {
//       is: {
//         // Grab all pokemon that are verified
//         verified: true,
//       },
//     },
//   },
//   include: {
//     owner: true,
//   },
// });
// console.log(pokemon);
// Creating TrainerType for a trainer
// const trainer = await prisma.trainer.create({
//   data: {
//     email: "trainerTypeTest@gmail.com",
//     name: "trainerTypeTest",
//     username: "typeTest",
//     trainerType: {
//       create: {
//         AceTrainer: true,
//         BugCatcher: true,
//         DragonTamer: true,
//       },
//     },
//   },
//   include: {
//     trainerType: true,
//   },
// });
// console.log(trainer);
// // Using Fluent API by chaining properties together
// const trainerTypes = await prisma.trainer;
//   .findUnique({
//     where: {
//       id: 7,
//     },
//   })
//   .trainerType();
// const pokemon = await prisma.pokemon.findFirst().owner().trainerType();
// console.log(trainerTypes);
const commentbreak = 0;
// Creating TrainerType for a trainer
const trainerTypes = await prisma.trainer.create({
    data: {
        email: "trainerTypeT@gmail.com",
        name: "trainerTypeT",
        username: "typeT",
        trainerType: [TrainerType.ACE_TRAINER, TrainerType.DRAGON_TAMER],
    },
});
console.log(trainerTypes);
