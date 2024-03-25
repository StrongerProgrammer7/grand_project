// @ts-nocheck
const UTC_MOSCOW = 3;

function convertDateFormat(date)
{
    // Получаем компоненты даты
    let year = date.getFullYear();
    let month = (date.getMonth() + 1).toString().padStart(2, '0'); // +1, так как меѝѝцы в JavaScript начинаютѝѝ ѝ 0
    let day = date.getDate().toString().padStart(2, '0');
    let hours = date.getHours().toString().padStart(2, '0');
    let minutes = date.getMinutes().toString().padStart(2, '0');
    let seconds = date.getSeconds().toString().padStart(2, '0');

    // Формируем новую ѝтроку ѝ нужным форматом
    let newDateString = `${ year }-${ month }-${ day } ${ hours }:${ minutes }:${ seconds }`;

    return newDateString;
}
function formatDatefromIsoString(dateISOString)
{
    // Преобразовать ѝтроку в объект Date
    let date = new Date(dateISOString);

    // Получить компоненты даты и времени
    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let day = String(date.getDate()).padStart(2, '0');
    let hours = String(date.getHours() - UTC_MOSCOW).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');

    // Сформировать ѝтроку в нужном формате
    let formattedDate = `${ year }-${ month }-${ day } ${ hours }:${ minutes }`;

    return formattedDate;
}

const get_interval = (start_date, end_date) =>
{
    const start = new Date(start_date).getHours();
    const end = new Date(end_date).getHours();

    return end - start;
}

function combineDateAndTime(dateString, timeString)
{
    // Разбиваем дату на компоненты
    let [year, month, day] = dateString.split('-');

    // Разбиваем времѝ на чаѝы и минуты
    let [hours, minutes] = timeString.split(':');

    // Получаем текущую дату
    let currentDate = new Date();

    // Уѝтанавливаем полученные значениѝ даты и времени
    currentDate.setFullYear(year);
    currentDate.setMonth(month - 1); // -1, так как меѝѝцы в JavaScript начинаютѝѝ ѝ 0
    currentDate.setDate(day);
    currentDate.setHours(hours);
    currentDate.setMinutes(minutes);
    currentDate.setSeconds(0);

    // Получаем компоненты даты
    let yearResult = currentDate.getFullYear();
    let monthResult = (currentDate.getMonth() + 1).toString().padStart(2, '0'); // +1, так как меѝѝцы в JavaScript начинаютѝѝ ѝ 0
    let dayResult = currentDate.getDate().toString().padStart(2, '0');
    let hoursResult = currentDate.getHours().toString().padStart(2, '0');
    let minutesResult = currentDate.getMinutes().toString().padStart(2, '0');
    let secondsResult = currentDate.getSeconds().toString().padStart(2, '0');

    // Формируем новую ѝтроку ѝ нужным форматом
    let newDateString = `${ yearResult }-${ monthResult }-${ dayResult } ${ hoursResult }:${ minutesResult }:${ secondsResult }`;

    return newDateString;
}

function formatDate(inputDate) {
    // Разделение даты и времени
    var parts = inputDate.split(', ');
    var datePart = parts[0];
    var timePart = parts[1];

    // Разделение компонентов даты
    var dateComponents = datePart.split('.');
    var day = dateComponents[0];
    var month = dateComponents[1];
    var year = dateComponents[2];

    // Разделение компонентов времени
    var timeComponents = timePart.split(':');
    var hours = timeComponents[0];
    var minutes = timeComponents[1];
    var seconds = timeComponents[2];

    // Формирование новой строки в нужном формате
    var formattedDate = year + '-' + month + '-' + day + ', ' + hours + ':' + minutes + ':' + seconds;

    return formattedDate;
}

function parseRangeString(rangeString) {
    const ranges = rangeString.split(',');
    const result = [];

    ranges.forEach(range => {
        const [startStr, endStr] = range.split('-');
        if (startStr !== "null" && endStr !== "null") {
            const start = parseInt(startStr);
            const end = parseInt(endStr);
            const rangeArray = [];
            for (let i = start; i <= end; i++) {
                rangeArray.push(i);
            }
            result.push(rangeArray);
        }
    });

    return result;
}
let width = window.innerWidth;

function booking()
{   
    console.log('gp')
    width = window.innerWidth;
    if (width < 1391)
    {
        let booking = document.querySelector(".booking");
        // let popup = document.querySelector('.Absolute-Center');
        let scale = width / 1391;
        booking.style.transform = `scale(${ scale })`;
        // popup.style.transform = `scale(${scale})`;
        booking.style.height = scale * 880 + "px";
        // popup.style.top = parseInt(popup.style.top)*scale+"px";
    }
    else {
        let booking = document.querySelector(".booking");
        booking.style.transform = `scale(1)`;
        booking.style.height = 880 + "px";
    }
}



booking();

window.onresize = booking;

/////////////////

let seats = document.querySelectorAll('.seats')[0].children;

for (let i of seats)
{
    i.list = [];
    i.freeTime = [];
    i.num = 0;
}

const dateControl = document.querySelector('input[type="date"]');
var now = new Date();
var day = ("0" + now.getDate()).slice(-2);
var month = ("0" + (now.getMonth() + 1)).slice(-2);
var today = now.getFullYear() + "-" + (month) + "-" + (day);
dateControl.min = today;

dateControl.onchange = async () =>
{

    let tables = document.querySelector('.tables');
    let popup = document.querySelector('.popup');
    let blr = document.querySelector('.seats');

    popup.innerHTML = '<h1>Выберите стол</h1>';
    // popup.outerHTML ="";

    // tables.classList.remove('blured');
    blr.classList.remove("blured");

    let req = {
        "date": `${ dateControl.value }`
    };

    let response = await fetch('/api/get_booked_tables_on_date', {
        method: 'POST',
        headers: {
            'Content-Type': "application/json"
        },
        body: JSON.stringify(req)
    });

    let result = await response.json();

    let num_respone = await fetch('/api/get_count_place_all_tables');
    let num_result = await num_respone.json();

    let ft_req = {
        "date": `${ dateControl.value }`
      };

      let ft_response = await fetch('/api/get_free_time_all_booked_tables_by_date', {
        method: 'POST',
        headers: {
            'Content-Type': "application/json"
        },
        body: JSON.stringify(ft_req)
    });

    let ft_result = await ft_response.json();


    for (let i = 0; i < result.data.length; i++)
    {
        seats[result.data[i].id - 1].list.push(result.data[i]);
    }

    for (let i = 0; i < num_result.data.length; i++)
    {
        if (seats[num_result.data[i].id - 1] !== undefined)
        {seats[num_result.data[i].id - 1].num = num_result.data[i].human_slots;}
    }

    for (let i=0; i<ft_result.data.length;i++) {
        seats[ft_result.data[i].table_id - 1].freeTime = parseRangeString(ft_result.data[i].free_time);
    }


    let selected = seats[0];

    for (let i = 0; i < seats.length; i++)
    {
        if (seats[i].freeTime.length==1 && Array.isArray(seats[i].freeTime[0])) {
            seats[i].children[0].setAttribute("stroke", 'red');
            seats[i].classList.remove('clickable');
            continue;
        } 

        seats[i].onmouseover = () =>
        {   

            popup.innerHTML = "";

            let places = document.createElement('div');
            places.className='booked';
            places.innerHTML = `Количество мест: ${seats[i].num}`;
            popup.appendChild(places);

            // if (seats[i].list.length == 0)
            // {
            //     let div = document.createElement('div');
            //     div.className = 'booked';
            //     div.innerHTML = 'Стол ѝвободен';
            //     popup.appendChild(div);
            // }
            // else
            // {
            //     for (let j = 0; j < seats[i].list.length; j++)
            //     {
            //         let div = document.createElement('div');
            //         div.className = 'booked';

            //         const interval = get_interval(seats[i].list[j].start_booking_date, seats[i].list[j].end_booking_date);
            //         div.innerText = `${ convertDateFormat(new Date(seats[i].list[j].start_booking_date)) } на ${ interval } чаѝа`;
            //         popup.appendChild(div);
            //     }
            // }

            if (seats[i].freeTime.length == 0)
            {
                let div = document.createElement('div');
                div.className = 'booked';
                div.innerHTML = 'Стол свободен целый день';
                popup.appendChild(div);
            }
            else
            {
                let div = document.createElement('div');
                div.className = 'booked';
                div.innerHTML = 'Стол свободен:';
                popup.appendChild(div);
                for (let j = 0; j < seats[i].freeTime.length; j++)
                {
                    let div = document.createElement('div');
                    div.className = 'booked';



                    div.innerText = `С ${seats[i].freeTime[j][0]} до ${seats[i].freeTime[j][seats[i].freeTime[j].length-1]} ч.`;
                    popup.appendChild(div);
                }
            }

        };

        seats[i].onclick = () =>
        {


            selected.children[0].setAttribute("stroke", 'black');
            seats[i].children[0].setAttribute("stroke", '#1400FF');
            selected = seats[i];

            popup.innerHTML = "";
            for (let i = 0; i < seats.length; i++)
            {
                seats[i].onmouseover = '';
                seats[i].onclick = '';
                seats[i].classList.remove('clickable');
                // tables.classList.add('blured');
                blr.classList.add('blured');
            }

            let h1 = document.createElement("h1");
            h1.innerHTML = `Бронирование стола №${ i + 1 }`;

            


            let form = document.createElement('form');
            form.method = 'get';
            form.innerHTML = `
            <input class="chosen" type="time" min="08:00" max="23:00" id="desired-time" name="desired-time" required placeholder="Время"  step="3600"/>
            
            <input class="chosen" type="number" min="1" max="24" id="interval" name="interval" required placeholder="Часы"/>
            <input class="chosen" type="text" id="name" name="name" required placeholder="Имя" "/>
            <input class="chosen" type="email" id="email" name="email" required placeholder="Почта" value="example@mail.com"/>
            
            <input class="chosen" type="tel" id="tel" name="tel" required placeholder="Телефон" value="+79330339678"/>
            <input class="button orange right" type="submit"/>`;
            popup.appendChild(h1);

            let places = document.createElement('div');
            places.className='booked';
            places.innerHTML = `Количество мест: ${seats[i].num}`;
            popup.appendChild(places);


            if (seats[i].freeTime.length == 0)
            {
                let div = document.createElement('div');
                div.className = 'booked';
                div.innerHTML = 'Стол свободен целый день';
                popup.appendChild(div);
            }
            else
            {
                let div = document.createElement('div');
                div.className = 'booked';
                div.innerHTML = 'Стол свободен:';
                popup.appendChild(div);
                for (let j = 0; j < seats[i].freeTime.length; j++)
                {
                    let div = document.createElement('div');
                    div.className = 'booked';



                    div.innerText = `С ${seats[i].freeTime[j][0]} до ${seats[i].freeTime[j][seats[i].freeTime[j].length-1]} ч.`;
                    popup.appendChild(div);
                }
            }

            popup.appendChild(form);



            form.onsubmit = async (e) =>
            {
                e.preventDefault();
                let phone = document.querySelector('input[type="tel"]').value;
                let orderTime = new Date().toLocaleString();
                let booked_date = combineDateAndTime(dateControl.value, document.querySelector('input[type="time"]').value);
                let interval = Number(document.querySelector('input[type="number"]').value);
                let name = document.querySelector('input[type="text"]').value;
                let email = document.querySelector('input[type="email"]').value;
                //console.log(booked_date);
                let start_date = new Date(booked_date);
                booked_date = new Date(booked_date);
                booked_date.setHours(booked_date.getHours() + interval);

                //console.log(booked_date);
                req = {
                    "id_table": i + 1,
                    "phone_client": phone,
                    "order_time": formatDate(orderTime),
                    "start_booking_date":formatDate(new Date(start_date).toLocaleString()),
                    "end_booking_date": formatDate(new Date(booked_date).toLocaleString())
                };

                response = await fetch('/api/book_table_client', {
                    method: 'POST',
                    headers: {
                        'Content-Type': "application/json"
                    },
                    body: JSON.stringify(req)
                });

                result = await response.json();
                console.log(req);
                console.log(result);

                if (response.ok)
                {
                    popup.innerHTML = "";
                    h1.innerHTML = `Оплата...`;
                    popup.appendChild(h1);
                    setTimeout(() =>
                    {
                        popup.innerHTML = "";
                        h1.innerHTML = `Успешно забронирован стол №${ i + 1 } ${ start_date.toLocaleDateString() } ${ start_date.toLocaleTimeString() } по ${ booked_date.toLocaleDateString() } ${ booked_date.toLocaleTimeString() }!`;
                        popup.appendChild(h1);
                    }, 3000);
                }
                else
                {   
                    let reg_req = {
                        "phone": phone,
                        "name_client": name,
                        "last_contact_date": formatDate(orderTime),
                        "email": email
                      };
    
    
                    let reg_response = await fetch('/api/add_client', {
                        method: 'POST',
                        headers: {
                            'Content-Type': "application/json"
                        },
                        body: JSON.stringify(reg_req)
                    });
    
                    let reg_result = await reg_response.json();
                    console.log(reg_result);
    

                    if (reg_response.ok) {
                        response = await fetch('/api/book_table_client', {
                            method: 'POST',
                            headers: {
                                'Content-Type': "application/json"
                            },
                            body: JSON.stringify(req)
                        });
        
                        result = await response.json();

                        if (response.ok)
                        {
                            popup.innerHTML = "";
                            h1.innerHTML = `Оплата...`;
                            popup.appendChild(h1);
                            setTimeout(() =>
                            {
                                popup.innerHTML = "";
                                h1.innerHTML = `Успешно забронирован стол №${ i + 1 } ${ start_date.toLocaleDateString() } ${ start_date.toLocaleTimeString() } по ${ booked_date.toLocaleDateString() } ${ booked_date.toLocaleTimeString() }!`;
                                popup.appendChild(h1);
                            }, 3000);
                        }
                        else {
                            popup.innerHTML = "";
                            h1.innerHTML = `Ошибка бронирования стола №${ i + 1 }`;
                            popup.appendChild(h1);
                        }




                    }
                    else {
                        popup.innerHTML = "";
                        h1.innerHTML = `Ошибка бронирования стола №${ i + 1 }`;
                        popup.appendChild(h1);
                    }


                    // popup.innerHTML = "";
                    // h1.innerHTML = `Ошибка бронирования стола №${ i + 1 }`;
                    // popup.appendChild(h1);
                }
            };


        };
    }



};




