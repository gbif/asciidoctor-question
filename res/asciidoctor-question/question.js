function resolve(questionId) {
    var q = document.getElementById("question_" + questionId)
    var type = q.getAttribute("data-type")
    var elems
    var pos
    var answer

    if(type == "mc") {
        elems = q.getElementsByTagName("input")
        for(pos = 0; pos < elems.length; pos++) {
            answer = elems[pos]
            answer.setAttribute("class", "show")
        }
    } else if(type == "gap") {
        elems = q.getElementsByTagName("gap")
        for(pos = 0; pos < elems.length; pos++) {
            var gap = elems[pos]
            var input = gap.getElementsByTagName("input")[0]
            answer = gap.getElementsByTagName("answer")[0]
            if(input.value == answer.textContent) {
                input.setAttribute("class", "correct")
            } else {
                input.setAttribute("class", "incorrect")
                answer.setAttribute("class", "")
            }
        }
    }
}

function reset(questionId) {
    var q = document.getElementById("question_" + questionId)
    var type = q.getAttribute("data-type")
    var elems
    var pos
    var answer

    if(type == "mc") {
        elems = q.getElementsByTagName("input")
        for(pos = 0; pos < elems.length; pos++) {
            answer = elems[pos]
            answer.setAttribute("class", "")
            answer.checked = false
        }
    } else if(type == "gap") {
        elems = q.getElementsByTagName("gap")
        for(pos = 0; pos < elems.length; pos++) {
            var gap = elems[pos]
            var input = gap.getElementsByTagName("input")[0]
            answer = gap.getElementsByTagName("answer")[0]
            input.setAttribute("class", "")
            answer.setAttribute("class", "hidden")
        }
    }
}