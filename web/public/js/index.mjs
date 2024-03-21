// let user = {
//     "phone": "+1234567890",
//     "name_client": "Глеб",
//     "last_contact_date": "2024-02-18 02:55:51"
//   };

//   let response = await fetch('/api/add_client', {
//     method: 'POST',
//     headers: {
//       'Content-Type': "application/json"
//     },
//     body: JSON.stringify(user)
//   });

//   let result = await response.json();
//   console.log(result)

// let food = {
//   "food_type": "Салаты",
//   "name": "Бурбон123",
//   "unit_of_measurement": "Грамм",
//   "price": 10,
//   "weight": 200
// };

// let response = await fetch('/api/add_food', {
//   method: 'POST',
//   headers: {
//     'Content-Type': "application/json"
//   },
//   body: JSON.stringify(food)
// });

// let result = await response.json();
// console.log(result)

let response = await fetch("/api/get_current_orders");

let result = await response.json();
console.log(result);



/**
 * Test request to localhost
 */
async function postData(url = "", data = {})
{
    // Default options are marked with *
    const response = await fetch(url, {
        method: "GET", // *GET, POST, PUT, DELETE, etc.
        mode: "cors", // no-cors, *cors, same-origin
        cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
        credentials: "include", // include, *same-origin, omit
        headers: {
            "Content-Type": "application/json",
            // 'Content-Type': 'application/x-www-form-urlencoded',
        },
        redirect: "follow", // manual, *follow, error
        referrerPolicy: "origin", // no-referrer, *no-referrer-when-downgrade, origin, origin-when-cross-origin, same-origin, strict-origin, strict-origin-when-cross-origin, unsafe-url

    });
    return response.json(); // parses JSON response into native JavaScript objects
}

postData("https://localhost:5000/api/get_current_orders", { answer: 42 }).then((data) =>
{
    console.log(data); // JSON data parsed by `data.json()` call
});