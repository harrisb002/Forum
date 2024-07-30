import { Request, Response } from "express";
import prisma from "../prisma.js";

const getMany = async (req: Request, res: Response) => {
  const users = await prisma.user.findMany();
  res.json({ users });
};

const get = async (req: Request, res: Response) => {
  const user = await prisma.user.findFirst({
    where: { id: parseInt(req.params.id) },
    include: {
      posts: true,
    },
  });
  if (!user) {
    res.json({ error: "User not found" });
    return;
  }
  res.json({ user });
};

const create = async (req: Request, res: Response) => {
  const user = await prisma.user.create({
    data: { email: req.body.email, username: req.body.username },
  });
  res.status(201).json({ user });
};

export default { get, getMany, create };
