const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUI = require('swagger-ui-express');
const { version, description } = require('../package.json');
const logger = require('../logger/logger');

const options =
{
    definition:
    {
        openapi: '3.0.0',
        info:
        {
            title: 'Restaurant API Docs',
            version,
            description
        },
        servers: [
            {
                url: 'https://grandproject.k-lab.su',
                description: 'Deveopment server'
            }
        ],
        components:
        {
            securitySchemas:
            {
                bearerAuth:
                {
                    type: 'https',
                    scheme: 'bearer',
                    bearerFormat: "JWT"
                },
            },
        },
        security: [
            {
                bearerAuth: [],

            },
        ],
    },
    apis: ['./routers/router.js', './models/Api/GET/*.js', './models/Api/docs/GET/*', './models/Api/docs/*.yaml',
        './models/Api/docs/DELETE/*'],
};

const swaggerSpec = swaggerJsdoc(options);


function swaggerDocs(app, port)
{
    //Page
    app.use("/docs", swaggerUI.serve, swaggerUI.setup(swaggerSpec));

    //Json

    app.get("docs.json", (req, res, next) =>
    {
        res.setHeader("Content-Type", "application/json");
        res.send(swaggerSpec);
    });

    logger.info(`Docs available at https://grandproject.k-lab.su/docs`);
};

module.exports = swaggerDocs;