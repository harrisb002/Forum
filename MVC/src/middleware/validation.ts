import { Request, Response, NextFunction } from "express";
import addFormats from "ajv-formats";
import Ajv from "ajv";
import { betterAjvErrors } from "@apideck/better-ajv-errors";

const ajv = new Ajv();
addFormats.default(ajv);

const schema = {
  type: "object",
  properties: {
    username: {
      type: "string",
      minLength: 5,
      maxLength: 30,
    },
    email: {
      type: "string",
      format: "email",
    },
  },
  required: ["username", "email"],
};

const validate = ajv.compile(schema);

const validateAccount = (req: Request, res: Response, next: NextFunction) => {
  const valid = validate(req.body);

  if (!valid) {
    res.status(400).json({
      error: "Invalid request body",
      details: validate.errors,
    });
    return;
  }

  next();
};

export default { validateAccount };
