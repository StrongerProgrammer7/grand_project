const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUI = require('swagger-ui-express');
const { version, description } = require('../package.json');
const csrf = require('csurf');
const csrfProtection = csrf({ cookie: true });

const BASE_URL = 'grandproject.k-lab.su';
const TEST_URL = 'localhost:5000'
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
                url: `https://${ process.env.NODE_ENV === 'development' ? TEST_URL : BASE_URL }`,
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

    app.get("docs.json", csrfProtection, (req, res, next) =>
    {
        res.setHeader("Content-Type", "application/json");
        res.send(swaggerSpec);
    });

    console.log(`Docs available at https://${ process.env.NODE_ENV === 'development' ? TEST_URL : BASE_URL }/docs`);
};

module.exports = swaggerDocs;