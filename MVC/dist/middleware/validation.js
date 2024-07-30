import z from "zod";
const UserSchema = z.object({
    username: z
        .string()
        .min(5, "At least 5 characters")
        .max(50, "At most 50 characters"),
    email: z.string().email(),
});
const validateAccount = (req, res, next) => {
    const validation = UserSchema.safeParse(req.body);
    if (!validation.success) {
        return res.status(400).json({ errors: validation.error.issues });
    }
    next();
};
export default { validateAccount };
