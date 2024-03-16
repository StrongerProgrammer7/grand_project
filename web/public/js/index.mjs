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
