function onLoad() {
    var questions = document.getElementsByTagName("question")
    for (var pos = 0; pos < questions.length; pos++) {
        var question = questions[pos]
        if (question.getAttribute('data-type') == 'mc') {
            if (question.getAttribute('data-shuffle') != null) shuffleAnswers(question)
        }
    }
}

function shuffleAnswers(question) {
    var answers = null
    var content = question.children[0]
    for (var i = content.children.length-1; i >= 0; i--) {
        if(content.children[i].className.indexOf('checklist') > -1) {
            answers = content.children[i].children[0]
            break;
        }
    }
    if(answers == null) return

    for (var i = answers.children.length; i >= 0; i--) {
        answers.appendChild(answers.children[Math.random() * i | 0]);
    }
}

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