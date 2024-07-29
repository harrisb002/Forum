import prisma from "./prisma.js";
await prisma.user.deleteMany();
await prisma.user.createMany({
    data: [
        { email: "1@email.com", username: "one" },
        { email: "2@email.com", username: "two" },
        { email: "3@email.com", username: "three" },
    ],
});
const user = await prisma.user.findFirst();
await prisma.post.createMany({
    data: [
        { title: "first post", body: "This is my first post", userId: user?.id },
        {
            title: "second post",
            body: "This is my second  post",
            userId: user?.id,
        },
        { title: "third post", body: "This is my third post", userId: user?.id },
    ],
});
