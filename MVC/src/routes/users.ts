import express from "express";
import usersController from "../controllers/users.js";
import validation from "../middleware/validation.js";

const router = express.Router();

router.get("/", usersController.getMany);
router.post("/", validation.validateUsername, usersController.create);
router.get("/:id", usersController.get);

export default router;
