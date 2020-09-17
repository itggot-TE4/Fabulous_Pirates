var counter = 0;
var tempstorage = [];
var correct = [];
var filesList;
var total_bricks = 10;
var ul = document.getElementById('brickor')


document.getElementById("file-selector").onchange = function() {
    counter = 0;
    filesList = shuffle(getFilesList());

    namn(filesList).forEach(render);
}

function getFilesList() {
    return Object.values(document.getElementById("file-selector").files);
}

function shuffle(arr) {
    return arr.sort(() => Math.random() - 0.5);
}

function getName(file) {
    var name = file.name.split('.').slice(0, -1).join('.');
    return name;
}

function format(str) {
    return str.split('_').join(' ');
}

function namn(array) {
    var i;
    var lista = [];
    for (i = 0; i < array.length; i++) {
        lista.push([getName(array[i]), i]);
        lista.push([array[i], i]);
    }
    lista = shuffle(lista);
    total_bricks = lista.length
    return lista;
}


function render(val, index) {
    var li = document.createElement('button')
    li.className = 'card';
    li.classname = val[1];
    li.id = index;
    li.addEventListener("click", function() { update(index); });
    if (typeof val[0] == "string") {
        li.innerHTML = `<div class="content"><span>${format(val[0])}</span></div>`;
        li.value = val[0];
    } else {
        li.innerHTML = `<div class="content"><img src="${URL.createObjectURL(val[0])}"></div>`;
        li.value = getName(val[0]);
    }
    ul.appendChild(li)
}


//check if game is over
function gameover() {
    if (total_bricks == correct.length) {
        alert("you win");
    }
}

async function demo() {
    await sleep(1000);
}


function update(id) {

    var elem = document.getElementById(id);
    if (tempstorage.includes(elem) || correct.includes(elem)) {} else {
        counter++;
        elem.classList.add('flipped');
        tempstorage.push(elem);
        if (counter % 2 == 0) {
            counter = 0;
            if (tempstorage[0].value == tempstorage[1].value) {
                correct.push(tempstorage[0]);
                correct.push(tempstorage[1]);
                tempstorage = [];

            } else {
                setTimeout(function() {
                    //your code to be executed after 1 second
                    for (var i = 0; i < tempstorage.length; i++) {
                        tempstorage[i].classList.remove('flipped');
                    }
                    tempstorage = [];
                }, 200);
            }
            gameover();
        }

    }

}