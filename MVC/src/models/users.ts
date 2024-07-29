import prisma from '../prisma.js'

let getMany = async () => {
    return await prisma.user.findMany()
}

let get = async (id: number) => {
    return await prisma.user.findFirst({
        where: { id: id },
        include: {
            posts: true
        }
    })
}

export default { getMany, get };

