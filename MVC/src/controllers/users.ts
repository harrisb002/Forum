import express from "express";

const router = express.Router();

router.get("/", async (req, res) => {
  const users = await res.render("users", { users });
});

export default router;
