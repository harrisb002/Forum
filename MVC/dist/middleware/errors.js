const errorHandler = (err, req, res, next) => {
    console.log("Error message:", err.message);
    console.log("Error code:", err.code);
    console.log("Error stack:", err.stack);
    res.status(500).json({ error: "Something is not right!" });
};
export default { errorHandler };
