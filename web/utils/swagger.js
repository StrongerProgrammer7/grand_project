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
                url: 'https://localhost:5000',
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
    apis: ['./controller/controller.js', './routers/router.js', './models/Api/*.js', './models/Api/docs/*.yaml'],
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

    logger.info(`Docs available at https://localhost:${ port }/docs`);
};

module.exports = swaggerDocs;