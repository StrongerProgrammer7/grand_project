const supertest = require('supertest');
const request = require("supertest");
// const https = require('https');
// const fs = require('fs');
const db = require('../models/db');
const app = require('../app');


describe("Prepare test environment", () =>
{
    describe("Connect and get data", () =>
    {
        let client;
        beforeEach(async () =>
        {
            client = await db.connect(); // up db

        });
        afterEach(() =>
        {
            client.release(); // down db
        });

        it('should success', async () =>
        {
            //console.log(client);
            //const result = await client.query('SELECT * FROM view_all_booked_tables();')
            // console.log(result.rows);
            expect(client).toBeTruthy(); // check db
        });
        it("should respond with a 200 status code", async () =>
        {
            const response = await request(app).get("/");
            expect(response.status).toBe(200);
        });
        it("should respond with a 201 status code API GET current orders", async () =>
        {
            const response = await request(app).get("/api/get_current_orders");
            expect(response.status).toBe(201);
        });
        it("should return current orders", async() =>
        {
            const response = await request(app).get("/api/get_current_orders");
           // Проверка сообщения об успехе
            expect(response.body.message).toBe("Success!");

            // Проверка значений полей заказа
            expect(response.body.data[0].id_order).toBe(1);
        });


        it("NEED TEST PROBLEM WITH CERTIFICATE", async () =>
        {

            /* let response = await fetch("https://grandproject.k-lab.su", {
                 agent: new https.Agent({ ca: fs.readFileSync(__dirname + "/ca.pem") })
             });
             let fetchHtml = await response.text();
             console.log(fetchHtml);*/
            async function postData(url = "", data = {})
            {
                // Default options are marked with *
                const response = await fetch(url, {
                    method: "GET", // *GET, POST, PUT, DELETE, etc.
                    mode: "cors", // no-cors, *cors, same-origin
                    cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
                    credentials: "same-origin", // include, *same-origin, omit
                    headers: {
                        "Content-Type": "application/json",
                        // 'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    redirect: "follow", // manual, *follow, error
                    referrerPolicy: "no-referrer", // no-referrer, *client
                });
                return await response.json(); // parses JSON response into native JavaScript objects
            }

            const result = await postData("https://grandproject.k-lab.su/api/get_all_booked_tables");

            console.log(result);
            expect(result.data.length > 0 && result.data[0].table_id);

            const res1 = await postData("https://grandproject.k-lab.su/api/get_current_orders");

            console.log(res1);
            expect(res1.data.length > 0 && res1.data[0].id_order);


        });
    });

})