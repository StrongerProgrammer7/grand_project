const supertest = require('supertest');
const request = require("supertest");
// const https = require('https');
// const fs = require('fs');
//const db = require('../models/db');
const app = require('../app');


describe("Prepare test environment", () =>
{
    describe("Connect and get data", () =>
    {

        describe("Test API GET Server", () =>
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

            it("Test get_all_booked_tables", async () =>
            {
            const result = await postData("https://grandproject.k-lab.su/api/get_all_booked_tables");
            //console.log(result);
            console.log(result.message)
            expect(result.message).toBe("Success!");
            });

            it("Test get_current_orders", async () =>
            {
            const result = await postData("https://grandproject.k-lab.su/api/get_current_orders");
//            console.log(res1);
            expect(result.data.length > 0 && result.data[0].id_order);
            });

            it("Test get_order_history ", async () =>
            {
            const order_history = await postData("https://grandproject.k-lab.su/api/get_order_history");
//            console.log(order_history);
            expect(order_history.message).toBe("Success!");

            });

            it("Test get_ingredients_info", async () =>
            {
            const get_ingredients_info = await postData("https://grandproject.k-lab.su/api/get_ingredients_info");
//            console.log(get_ingredients_info);
            expect(get_ingredients_info.message).toBe("Success!");
            });

            it("Test get_menu_sorted_by_type", async () =>
            {
            const get_menu_sorted_by_type = await postData("https://grandproject.k-lab.su/api/get_menu_sorted_by_type");
//            console.log(get_menu_sorted_by_type);
            expect(get_menu_sorted_by_type.message).toBe("Success!");
            });

            it("Test get_reorder_ingredients_list", async () =>
            {
            const get_reorder_ingredients_list = await postData("https://grandproject.k-lab.su/api/get_reorder_ingredients_list");
//            console.log(get_reorder_ingredients_list);
            expect(get_reorder_ingredients_list.message).toBe("Success!");
            });


            it("Test get_name_storehouse", async () =>
            {
            const get_name_storehouse = await postData("https://grandproject.k-lab.su/api/get_name_storehouse");
//            console.log(get_name_storehouse);
            expect(get_name_storehouse.message).toBe("Success!");
            });

            it("Test ", async () =>
            {
            const get_worker_list = await postData("https://grandproject.k-lab.su/api/get_worker_list");
//            console.log(get_worker_list);
            expect(get_worker_list.message).toBe("Success!");
            });

//            it("Test ", async () =>
//            {
//
//            });

        });

        describe("Test API POST Server", () =>
        {
             // Example POST method implementation:
            async function postData(url = "", data = {}) {
              // Default options are marked with *
              const response = await fetch(url, {
                method: "POST", // *GET, POST, PUT, DELETE, etc.
                mode: "cors", // no-cors, *cors, same-origin
                cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
                credentials: "same-origin", // include, *same-origin, omit
                headers: {
                  "Content-Type": "application/json",
                  // 'Content-Type': 'application/x-www-form-urlencoded',
                },
                redirect: "follow", // manual, *follow, error
                referrerPolicy: "no-referrer", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url
                body: JSON.stringify(data), // body data type must match "Content-Type" header
              });
              return response.json(); // parses JSON response into native JavaScript objects
            }

            it("Test add_table", async () =>
            {
            const data = await postData("https://grandproject.k-lab.su/api/add_table", { human_slots: 4 });
            expect(data.message).toBe("Table added successfully!");
            });

            it("Test book_table Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/book_table",
                {
                      id_table: 1,
                      id_worker: 3,
                      phone_client: "+79848718618",
                      order_time: "2024-03-26 13:11:31",
                      start_booking_date: "2024-03-16 11:11:31",
                      end_booking_date: "2024-03-26 16:11:31"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!");
            });
            it("Test book_table", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/book_table",
                {
                      id_table: 1,
                      id_worker: 3,
                      phone_client: "+79848718618",
                      order_time: "2024-03-26, 13:11:31",
                      start_booking_date: "2024-03-16, 11:11:31",
                      end_booking_date: "2024-03-26, 16:11:31"
                 });
                expect(data.message === "Table is book successfully!" || data.message === "Table is already book or don't exists table/worker, check your data");
            });

            it("Test book_table_client Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/book_table_client",
                {
                      id_table: 1,
                      phone_client: "+79848718618",
                      order_time: "2024-03-24 13:11:31",
                      start_booking_date: "2024-03-26 13:11:31",
                      end_booking_date: "2024-03-26 16:11:31"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!");
            });

            it("Test book_table_client", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/book_table_client",
                {
                      id_table: 1,
                      phone_client: "+79848718618",
                      order_time: "2024-03-24, 13:11:31",
                      start_booking_date: "2024-03-26, 13:11:31",
                      end_booking_date: "2024-03-26, 16:11:31"
                 });
                expect(data.message === "Table is book successfully!" || data.message === "Table is already book or don't exists table/worker, check your data");
            });

                it("Test cancel_booking Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/cancel_booking",
                {
                      "id_table": 1,
                      "desired_booking_date": "2024-03-26 13:11:31"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!");
            });
            it("Test cancel_booking Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/cancel_booking",
                {
                      "id_table": 1,
                      "desired_booking_date": "2024-03-26"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31], [00-24]:[00-60]:{2}!");
            });

                it("Test cancel_booking canceling a table", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/cancel_booking",
                {
                      "id_table": 1,
                      "desired_booking_date": "2024-03-26, 13:11:31"
                 });
                expect(data.message === "Booking table is cancel" || data.message === "Internal error with cancel booking table!");
            });


                it("get_booked_tables_on_date", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/get_booked_tables_on_date",
                {
                       "date": "2024-03-23"
                 });
                expect(data.message).toBe("Success!");
            });

                it("get_free_time_all_booked_tables_by_date", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/get_free_time_all_booked_tables_by_date",
                {
                       "date": "2024-03-23"
                 });
                expect(data.message).toBe("Success!");
            });

            it("get_time_for_booked_table_on_date Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/get_time_for_booked_table_on_date",
                {
                       id_table: 20,
                       date: "03-2024-23"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31]!");
            });

            it("get_time_for_booked_table_on_date Date does not match the format", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/get_time_for_booked_table_on_date",
                {
                       id_table: 20,
                       date: "03-23-2024"
                 });
                expect(data.message).toBe("Date does not match the format 2{4}-[01-12]-[01-31]!");
            });

            it("get_time_for_booked_table_on_date", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/get_time_for_booked_table_on_date",
                {
                       "id_table": 1,
                       "date": "2024-03-23"
                 });
                expect(data.message).toBe("Success!");
            });

                it("add_order_ingredient Invalid data", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/add_order_ingredient",
                {
                      "worker_id": 1,
                      "storage_name": "storage_name",
                      "ingredient_id": 1,
                      "ingredient_quantity": 1,
                      "ingredient_weight": 100,
                      "ingredient_expiry_date": "2024-03-30",
                      "supplied_date": "2024-03-31",
                      "supplied_weight": 100,
                      "supplied_quantity": 2
                 });
                expect(data.message).toBe("Internal error with add order ingredient!");
            });

                it("add_order_ingredient valid data", async () =>
            {
                const data = await postData("https://grandproject.k-lab.su/api/add_order_ingredient",
                {
                      "worker_id": 1,
                      "storage_name": "Сундук",
                      "ingredient_id": 1,
                      "ingredient_quantity": 1,
                      "ingredient_weight": 100,
                      "ingredient_expiry_date": "2024-03-30, 13:11:31",
                      "supplied_date": "2024-03-3, 13:11:31",
                      "supplied_weight": 100,
                      "supplied_quantity": 2
                 });
                expect(data.message).toBe("Order ingredient added!");
            });

        });

    });

})