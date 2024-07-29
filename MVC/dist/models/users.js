import prisma from '../prisma.js';
let getMany = async () => {
    return await prisma.user.findMany();
};
let get = async (id) => {
    return await prisma.user.findFirst({
        where: { id: id },
        include: {
            posts: true
        }
    });
};
export default { getMany, get };
