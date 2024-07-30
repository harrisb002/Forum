import xss from "xss";
const sanitize = (obj) => {
    for (const key in obj) {
        if (typeof obj[key] === "string") {
            obj[key] = xss(obj[key], {
                whiteList: {},
                stripIgnoreTag: true,
                stripIgnoreTagBody: ["script"],
            });
        }
        else if (typeof obj[key] === "object" && obj[key] !== null) {
            // Recurse into nested objects
            obj[key] = sanitize(obj[key]);
        }
    }
    return obj;
};
const xssMiddleware = (req, res, next) => {
    if (req.body) {
        req.body = sanitize(req.body);
    }
    next();
};
export default xssMiddleware;
