## MongoDB Notes

- REFERENCE: https://www.mongodb.com/docs/manual/reference/sql-comparison/

- The key difference with MongoDB compared to a structured database is that the attributes are included in the object (JSON-like structure).
- This allows you to customize the structure for each object including nested objects.

---

### Mongo Commands

- Finding Data by ID:

`db.users.findOne({_id: user.insertedId})`

- With the value of an ID one can convert it to a valid ID type with ObjectId:

` db.users.findOne() //retrieve an example ID`
`db.users.findOne({_id: ObjectId("347b3551f23e04d7a0154bde")})`

- Finding by Nested Data, find all users with a particular nested value:

`db.users.find({"notificationSettings.security": true});`

---

### Updating Data with $set:

- Updating data will require one to identify what data to update, typically by \_id, and then use $set. The $ is how operators are identified in MongoDB, operating on some data as opposed to using a field called set.

```
db.users.updateOne(
    { _id: ObjectId("347b3551f23e04d7a0154bde") },
    { $set: { "notificationSettings.comms": true } }
);
```

- In addition to changing data, one can add new data to a nested object.

```
db.users.updateOne(
    { _id: ObjectId("347b3551f23e04d7a0154bde") },
    { $set: { "notificationSettings.affiliate": true } }
);
```

---

### Sorting:

- Here is an example of sorting by name descending:

`db.users.find().sort({ name: -1 });`

One can also chain the limit or skip method to reduce the number of results or skip a number of users.

`db.users.find().sort({ name: -1 }).limit(1);`

---

### Aggregation Pipeline:

- MongoDB has a pipeline to transform and manipulate data. This is the aggregation pipeline. Here is a basic example where I will use $match to match all users that have notificationSettings.comms set to true. The result will move to the next step in the pipeline called $group, which will use $sum to add up how many there are.

```
db.users.aggregate([
    {$match: { 'notificationSettings.comms': true }},
{$group: { _id: '$notificationSettings.comms', count: { $sum: 1 }}},
]);
```

The `$notificationSettings.commms` refers to the notificationSettings.comms of the current document being processed. Essentially, it ($) is required when you want to specifically refer to a field value as opposed to a static string. In some scenarios it is not required as it is expecting a field and not a value (such as in $match).

`db.users.aggregate([{ $project: { name: '$name' } }]);`

Here one can decide which attributes to return using $project. The resulting objects look like this:

`{ _id: ObjectId("64f6e842ff14b2fe89489536"), name: 'Caleb Curry' }`

Failure to use $ tells MongoDB we want the string value name, not the value of the name property on the document.

`db.users.aggregate([{ $project: { name: 'name' } }]);`

Results in the following: `{ _id: ObjectId("64f6e842ff14b2fe89489536"), name: 'name' }`

- One can use `$match` to remove users that don’t have posts and `$project` to alter the fields being returned.

```
db.users.aggregate([
    {
        $match: {
            posts: { $exists: true, $ne: null },
        },
    },
    {
        $project: {
            _id: 0,
            username: 1,
            posts: {
                $sortArray: { input: '$posts', sortBy: { title: 1 } },
            },
        },
    },
]);
```

---

## 6. Document References

Referencing documents allows us to split collections up but still keep data connected. This is another way to design one-to-many relationships.

- One-to-Many with Document References

Looking at `users` and `posts` again. Here is a how design of a one-to-many relationship would look in a relational database with a reference back to the user in a `posts` collection.

```
const user = db.users.insertOne({
    email: 'Ben@test.com',
    name: 'Ben Uary',
    username: 'Ben1',
    verified: true,
    notificationSettings: { security: true, comms: false, marketing: false },
});

db.posts.insertOne({
    title: 'What is your favorite Language?',
    body: 'Goooooooo',
    tags: ['software', 'languages'],
    createdAt: new Date(),
    updatedAt: new Date(),
    userId: user.insertedId,
});
```

---

### Many-to-Many with Document References

In a many-to-many relationship one could modify this to make `userId` an array. Now, one can reference many users from a single document. This eliminates the need for a junction table as one would have in a structured database design.! Which has its perks.

### Join Collections with $lookup

When spliting data up now one has to worry about retrieving data across multiple collections. Here one can use `aggregate`. The first step will be to use `$lookup`, which defines the join.

- `from` - What collection to join,
- `localField` - What field in `posts` to join with,
- `foreignField` - What field in `from` (`users`) to join with,
- `as` - What alias to call the field in the result.

```
db.posts.aggregate([
    {
        $lookup: {
            from: 'users',
            localField: 'userId',
            foreignField: '_id',
            as: 'user',
        },
    },
]);
```

1. `$unwind` - `$lookup` returns an array. With only one user one can remove the array with this.
2. `$project` - Remove unneeded attributes from the document, such as the `userId` (`userId` exists in the `user` that is being joined). Remove attributes such as the `user.notificationSettings` if they aren’t needed.

```
db.createView('postsWithUser', 'posts', [
    {
        $lookup: {
            from: 'users',
            localField: 'userId',
            foreignField: '_id',
            as: 'user',
        },
    },
    {
        $unwind: '$user',
    },
    {
        $project: {
            userId: 0,
            'user.notificationSettings': 0,
        },
    },
]);
```

`db.postsWithUser.find();`

---

### Schema Validation Within MongoDB (Can also be done in Atlas)

The use of $lookup does filter out any data that doesn’t meet the requirements. In the previous case, any posts with an invalid userId will not show up. If one inserted a bad document in to posts, you wouldn’t see it in the previous query:

```
db.posts.insertOne({
    test: 'invalid user',
    userId: new ObjectId(),
});
```

`db.postsWithUser.find();`

This will show up with `db.posts.find()` but not `db.postsWithUser.find()` even though it has a userId.

Data validation can be done at different “levels”:

1. At the database level (with schema validation),
2. At the provider level (Atlas, in our case),
3. At the application level, the backend app that interacts with the database.

```
db.runCommand({
    collMod: 'posts',
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: [
                //required fields
            ],
            properties:
            //paste schema validation here
        },
    },
    validationLevel: 'strict',
});
```

Here is an example for posts:

```
db.runCommand({
    collMod: 'posts',
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: [
                'title',
                'body',
                'createdAt',
                'updatedAt',
                'userId'
            ],
            properties: {
                body: {
                    bsonType: 'string',
                },
                createdAt: {
                    bsonType: 'date',
                },
                tags: {
                    bsonType: 'array',
                    items: {
                        bsonType: 'string',
                    },
                },
                title: {
                    bsonType: 'string',
                },
                updatedAt: {
                    bsonType: 'date',
                },
                userId: {
                    bsonType: 'objectId',
                },
            },
        },
    },
    validationLevel: 'strict',
});
```

Now, this document would work:

```
db.users.insertOne({
    email: 'Feb@test.com',
    name: 'Feb Ruary',
    username: 'FabulousFeb',
    verified: true,
    notificationSettings: ['security', 'comms'],
});
```

But this one fails:

```
db.users.insertOne({
    email: 'Feb@test.com',
    name: 'Feb Ruary',
    username: 'FabulousFeb',
    verified: true,
    notificationSettings: ['junk'],
});
```

### Working with Mongoose (Can also use Prisma as ORM)

```
import mongoose from 'mongoose';
import { Schema } from 'mongoose';
import dotenv from 'dotenv';
import { Post, User } from './models.js';

dotenv.config();

const connectionString = process.env.MONGO_URL!;
mongoose.connect(connectionString);

//await User.deleteMany(); if desired
//await Post.deleteMany(); if desired

const user = await User.create({
    email: 'mon@goose.com',
    username: 'mongoose man',
    address: {
        city: 'city name',
        country: 'USA',
        state: 'CA',
        street: 'Ben St',
        zipCode: '94928',
    },
    notificationSettings: ['sales'],
});

const post = await Post.insertMany([
    {
        title: 'first',
        body: 'first post of mine',
        userId: user._id,
        tags: ['hello'],
    },
    {
        title: 'second',
        body: 'second post I like posting it is alright',
        userId: user._id,
        tags: ['hello', 'discussion'],
    },
]);

const posts = await Post.find({ userId: user._id }).exec();

console.log(JSON.stringify(posts, null, 2));

mongoose.connection.close();
```

---

#### Other...

- Good note!: Occasionally seeing values embedded in objects, specifically \_id containing an object with $oid. This is just a syntactical thing, as the data is being displayed in JSON, but is stored differently as BSON (binary JSON). This is just a difference in representation as JSON cannot natively have ObjectId types as a value.

- Using the playground extension for MongoDb is preety awesome!  
  `https://www.mongodb.com/docs/mongodb-vscode/playgrounds/`

- Change these settings:

`"mdb.useDefaultTemplateForPlayground": false,`

`"mdb.confirmRunAll": false`

---

#### CLI commands

- Load file from outside the interactive shell:
  `mongosh --nodb --file <filename>`

- Install Atlas in terminal
  `brew install mongodb-atlas`

- Login to atlas
  `atlas auth login`
