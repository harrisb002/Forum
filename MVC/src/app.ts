import express from "express";
import usersRouter from "./routes/users.js";
import pug from 'pug'
const app = express();
const port = 3000;

app.engine('pug', (pug as any).__express)
app.set("view engine", "pug");
app.set("views", "./src/views");

app.use("/users", usersRouter);

app.listen(port, () => {
  console.log(`App listening http://localhost:${port}.`);
});
