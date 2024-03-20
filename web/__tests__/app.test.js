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
//            console.log(result);
            expect(result.data.length > 0 && result.data[0].table_id);

            const res1 = await postData("https://grandproject.k-lab.su/api/get_current_orders");
//            console.log(res1);
            expect(res1.data.length > 0 && res1.data[0].id_order);

            const order_history = await postData("https://grandproject.k-lab.su/api/get_order_history");
//            console.log(order_history);
            expect(order_history.data.length > 0 && order_history.data[0].id_order);
            expect(order_history.message).toBe("Success!");


            const get_ingredients_info = await postData("https://grandproject.k-lab.su/api/get_ingredients_info");
//            console.log(get_ingredients_info);
            expect(get_ingredients_info.data.length > 0 && get_ingredients_info.data[0].name);
            expect(get_ingredients_info.message).toBe("Success!");


            const get_menu_sorted_by_type = await postData("https://grandproject.k-lab.su/api/get_menu_sorted_by_type");
//            console.log(get_menu_sorted_by_type);
            expect(get_menu_sorted_by_type.data.length > 0 && get_menu_sorted_by_type.data[0].food_id);
            expect(get_menu_sorted_by_type.message).toBe("Success!");


            const get_reorder_ingredients_list = await postData("https://grandproject.k-lab.su/api/get_reorder_ingredients_list");
//            console.log(get_reorder_ingredients_list);
            expect(get_reorder_ingredients_list.data.length > 0 && get_reorder_ingredients_list.data[0].name);
            expect(get_reorder_ingredients_list.message).toBe("Success!");


            const get_name_storehouse = await postData("https://grandproject.k-lab.su/api/get_name_storehouse");
//            console.log(get_name_storehouse);
            expect(get_name_storehouse.data.length > 0 && get_name_storehouse.data[0].name);
            expect(get_name_storehouse.message).toBe("Success!");


            const get_worker_list = await postData("https://grandproject.k-lab.su/api/get_worker_list");
//            console.log(get_worker_list);
            expect(get_worker_list.data.length > 0 && get_worker_list.data[0].phone);
            expect(get_worker_list.message).toBe("Success!");

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



        });
    });

})