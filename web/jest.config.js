process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
module.exports =
{
    testEnvironment: "node",
    testMatch: ["**/*.test.js"],
    verbose: true,
    forceExit: true
}