const logRequest = (req, res, next) => {
    console.log(`request to ${req.path}.`);
    next();
};
export default { logRequest };
