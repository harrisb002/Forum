require("dotenv").config();
const connectionString = process.env.DATABASE_URL;

db = connect(connectionString);

let result = db.users.find();
console.log(result);

// CREATE TABLE "users" (
//     "user_id" SERIAL NOT NULL,
//     "email" TEXT NOT NULL,
//     "username" TEXT NOT NULL,
//     "name" TEXT NOT NULL,
//     "verified" BOOLEAN NOT NULL DEFAULT false,

//     CONSTRAINT "users_pkey" PRIMARY KEY ("user_id")
// );

// db.users.create({
//     email: 'Ben@test.com',
//     name: 'Ben Harris',
//     username: 'benH',
//     verified: true,
//     notificationSettings: { security: true, comms: false, marketing: false },
// });

// db.posts.insertMany([
//     {
//         title: 'My 1st post',
//         author: 'Ben Harris',
//         body: 'let me tell you about cool mongoDB...',
//         tags: ['intro', 'story time'],
//         created_at: new Date(),
//         updated_at: new Date(),
//     },
//     {
//         title: 'Guess what just happened in the DB...',
//         author: 'Ben Harris',
//         body: 'My collection just just got dropped and...',
//         tags: ['software', 'story time'],
//         created_at: new Date(),
//         updated_at: new Date(),
//     },
// ]);

// 2 posts using the tag story time. Can retrieve all posts with the a particular tag like so:
// db.posts.find({ tags: 'software' });

// And adjust a document’s tags with $push and $pull:
// db.posts.updateOne(
//     { _id: ObjectId('647b85e5139831beb73b7478') },
//     {
//         $pull: { tags: 'software' },
//         //$push: { tags: 'tech' }, // one at a time
//     }
// );

// This structure also works fine with a more complex inner object:
// db.posts.insertOne({
//     title: 'My first post',
//     author: 'Caleb Curry',
//     body: 'let me tell you about myself...',
//     tags: [
//         { name: 'intro', addedAt: new Date() },
//         { name: 'story time', addedAt: new Date() },
//     ],
//     created_at: new Date(),
//     updated_at: new Date(),
// });

// a document inside of a document.
//The searching works the same way just with qualifying the property as tags.name (in quotes):
// db.posts.find({ 'tags.name': 'intro' });

// And updating a particular post’s tags would look like this (to remove a tag, in this example):
// db.posts.updateOne(
//     { _id: ObjectId('647b85e5139831beb73b7478') },
//     {
//         $pull: { tags: { name: 'intro' } },
//     }
// );

// This design would be a similar scenario with users and posts.
// This is a one-to-many relationship so we could define the posts within a user document.
// db.users.insertOne({
//     email: 'Ben@test.com',
//     name: 'Ben Harris',
//     username: 'benH',
//     verified: true,
//     notificationSettings: { security: true, comms: false, marketing: false },
//     posts: [
//         {
//             title: 'My first post',
//             body: 'let me tell you about MongoDB...',
//             tags: ['intro', 'story time'],
//             created_at: new Date(),
//             updated_at: new Date(),
//         },
//         {
//             title: 'Guess what just happened in the DB...',
//             author: 'Ben Harris',
//             body: 'My collection was dropped and...',
//             tags: ['software', 'story time'],
//             created_at: new Date(),
//             updated_at: new Date(),
//         },
//     ],
// });

// Retrieve all users with posts:
// db.users.find({
//   posts: { $exists: true },
// });

// And sort them like so.
// We can use $match to remove users that don’t have posts and $project to alter the fields being returned.
// db.users.aggregate([
//     {
//         $match: {
//             posts: { $exists: true, $ne: null },
//         },
//     },
//     {
//         $project: {
//             _id: 0,
//             username: 1,
//             posts: {
//                 $sortArray: { input: '$posts', sortBy: { title: 1 } },
//             },
//         },
//     },
// ]);

// This should work, however one thing to be aware of is that a document database
// retrieves the entire document, so you’re always working through a user object.
// [
//     {
//       "username": "benh",
//       "posts": [
//         //...
//       ]
//     },
//     //...
//   ]

// Referencing documents allows us to split collections up but still keep data connected.
// This is another way to design one-to-many relationships.

// One-to-Many with Document References
// Looking at `users` and `posts` again. I will design
// this in a similar way to how I would design a one-to-many relationship
// in a relational databasewith a reference back to the user in a `posts` collection.

// const user = db.users.insertOne({
//     email: 'Jan@test.com',
//     name: 'Jan Uary',
//     username: 'January1',
//     verified: true,
//     notificationSettings: { security: true, comms: false, marketing: false },
// });

// db.posts.insertOne({
//     title: 'What is your favorite Language?',
//     body: 'mine is Go!',
//     tags: ['software', 'languages'],
//     createdAt: new Date(),
//     updatedAt: new Date(),
//     userId: user.insertedId,
// });

// - `from` - What collection to join,
// - `localField` - What field in `posts` to join with,
// - `foreignField` - What field in `from` (`users`) to join with,
// - `as` - What alias to call the field in the result.
// db.posts.aggregate([
//     {
//         $lookup: {
//             from: 'users',
//             localField: 'userId',
//             foreignField: '_id',
//             as: 'user',
//         },
//     },
// ]);
