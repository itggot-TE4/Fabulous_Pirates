function check_answers() {

    remove_p()

    studentboxes = document.querySelectorAll(".studentbox")
    for (let index = 0; index < studentboxes.length; index++) {
        studentbox = studentboxes[index];
        student = studentbox.querySelector(".input")

        x = document.createElement("p")
        if (student.name == student.value) {
            x.innerHTML = "correct"
        } else {
            x.innerHTML = "incorrect"
        }
        studentbox.appendChild(x)
    }
}

function remove_p() {
    p = document.querySelectorAll("p")
    for (let index = 0; index < p.length; index++) {
        p[index].outerHTML = "";
    }
}