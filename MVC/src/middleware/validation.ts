import { Request, Response, NextFunction } from "express";

const validateUsername = (req: Request, res: Response, next: NextFunction) => {
  const username = req?.body?.username;

  if (!username || username.length < 5 || username.length > 30) {
    res.status(400).json({
      error: "Username must be between 5 and 30 characters",
    });
    return; // don't invoke next after response is sent
  }
  next();
};

export default { validateUsername };
