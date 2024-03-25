// @ts-nocheck



let response = await fetch("/api/get_menu_sorted_by_type");
let result = await response.json();

let menu = [];
for (let i = 0; i < 10; i++)
{
    menu[i] = [];
}

for (let i = 0; i < result.data.length; i++)
{
    switch (result.data[i].food_type)
    {
        case "Салаты":
            menu[0].push(result.data[i])
            break;
        case "Домашнее":
            menu[1].push(result.data[i])
            break;
        case "Блины":
            menu[2].push(result.data[i])
            break;
        case "Десерты":
            menu[3].push(result.data[i])
            break;
        case "Супы":
            menu[4].push(result.data[i])
            break;
        case "Гарниры":
            menu[5].push(result.data[i])
            break;
        case "Каши":
            menu[6].push(result.data[i])
            break;
        case "Мясо":
            menu[7].push(result.data[i])
            break;
        case "Рыба":
            menu[8].push(result.data[i])
            break;
        case "Напитки":
            menu[9].push(result.data[i])
            break;
    }
}


let bar = document.querySelector(".menu");
let buttons = bar.children;

let dishes = document.querySelector('.dishes');

let clicked = buttons[1];


for (let i = 0; i < buttons.length; i++)
{
    buttons[i].addEventListener('click', () =>
    {
        clicked.classList.remove("nonclickable");
        clicked.classList.remove("dark");
        clicked.classList.add("black");

        buttons[i].classList.add("dark");
        buttons[i].classList.add("nonclickable");
        buttons[i].classList.remove("black");
        clicked = buttons[i];

        dishes.innerHTML = "";



        for (let j = 0; j < menu[i].length; j++)
        {
            let div = document.createElement('div');
            div.className = 'dish';
            div.innerHTML = `<img src="/images/${menu[i][j].food_id}.jpg" alt="${ menu[i][j].food_name }"/>
            <div>${ menu[i][j].food_name }</div>
            <div>${ menu[i][j].price } ₽</div>
            <div>${ menu[i][j].weight } ${ menu[i][j].unit_of_measurement }</div>`

            dishes.appendChild(div);
            // let img = document.querySelector(`img[src="/images/${menu[i][j].food_id}.jpg"]`);
            // img.addEventListener('click',(e)=>{
            //     e.stopPropagation();
            //     let popup = document.createElement('div');
            //     popup.className = 'center-screen';
            //     popup.innerHTML = `<img src="/images/${menu[i][j].food_id}.jpg" alt="${ menu[i][j].food_name }"/>`;
            //     document.querySelector('.bodyContent').appendChild(popup);
 

                
            // });
            

        }
        
    });
}
