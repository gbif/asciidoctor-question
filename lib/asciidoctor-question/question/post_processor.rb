require 'nokogiri'

module Asciidoctor
  module Question
    class HTMLPostProcessor < Asciidoctor::Extensions::Postprocessor
      def process(document, output)
        doc = Nokogiri::HTML(output)
        head = doc.at_css 'head'
        head.add_child('
          <style id="question">
            .hidden {
              display: none;
            }

            div[id*=question][data-type=gap] gap > input.incorrect {
              font-weight: bold;
              color: red;
            }


            div[id*=question][data-type=gap] gap > answer, div[id*=question][data-type=gap] gap > input.correct {
              font-weight: bold;
              color: green;
            }

            div[id*=question][data-type=mc] input[type="checkbox"]::before {
              display: inline-block;
              width: 24px;
              height: 24px;
              margin-top: -8px;
              margin-left: -25px;
            }

            div[id*=question][data-type=mc] input[type="checkbox"][data-correct="true"].show::before {
              content: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PjxzdmcgaGVpZ2h0PSIyNHB4IiB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0cHgiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxwYXRoIGZpbGw9Im9saXZlZHJhYiIgc3Ryb2tlPSJvbGl2ZWRyYWIiIGQ9Ik0yMS42NTIsMy4yMTFjLTAuMjkzLTAuMjk1LTAuNzctMC4yOTUtMS4wNjEsMEw5LjQxLDE0LjM0ICBjLTAuMjkzLDAuMjk3LTAuNzcxLDAuMjk3LTEuMDYyLDBMMy40NDksOS4zNTFDMy4zMDQsOS4yMDMsMy4xMTQsOS4xMywyLjkyMyw5LjEyOUMyLjczLDkuMTI4LDIuNTM0LDkuMjAxLDIuMzg3LDkuMzUxICBsLTIuMTY1LDEuOTQ2QzAuMDc4LDExLjQ0NSwwLDExLjYzLDAsMTEuODIzYzAsMC4xOTQsMC4wNzgsMC4zOTcsMC4yMjMsMC41NDRsNC45NCw1LjE4NGMwLjI5MiwwLjI5NiwwLjc3MSwwLjc3NiwxLjA2MiwxLjA3ICBsMi4xMjQsMi4xNDFjMC4yOTIsMC4yOTMsMC43NjksMC4yOTMsMS4wNjIsMGwxNC4zNjYtMTQuMzRjMC4yOTMtMC4yOTQsMC4yOTMtMC43NzcsMC0xLjA3MUwyMS42NTIsMy4yMTF6Ii8+PC9zdmc+);
            }

            div[id*=question][data-type=mc] input[type="checkbox"][data-correct="false"].show::before {
              content: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/PjxzdmcgaGVpZ2h0PSIyNHB4IiB2ZXJzaW9uPSIxLjEiIHZpZXdCb3g9IjAgMCAyNCAyNCIgd2lkdGg9IjI0cHgiIHhtbDpzcGFjZT0icHJlc2VydmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPjxwYXRoIGZpbGw9Im1hcm9vbiIgc3Ryb2tlPSJtYXJvb24iIGQ9Ik0yMi4yNDUsNC4wMTVjMC4zMTMsMC4zMTMsMC4zMTMsMC44MjYsMCwxLjEzOWwtNi4yNzYsNi4yN2MtMC4zMTMsMC4zMTItMC4zMTMsMC44MjYsMCwxLjE0bDYuMjczLDYuMjcyICBjMC4zMTMsMC4zMTMsMC4zMTMsMC44MjYsMCwxLjE0bC0yLjI4NSwyLjI3N2MtMC4zMTQsMC4zMTItMC44MjgsMC4zMTItMS4xNDIsMGwtNi4yNzEtNi4yNzFjLTAuMzEzLTAuMzEzLTAuODI4LTAuMzEzLTEuMTQxLDAgIGwtNi4yNzYsNi4yNjdjLTAuMzEzLDAuMzEzLTAuODI4LDAuMzEzLTEuMTQxLDBsLTIuMjgyLTIuMjhjLTAuMzEzLTAuMzEzLTAuMzEzLTAuODI2LDAtMS4xNGw2LjI3OC02LjI2OSAgYzAuMzEzLTAuMzEyLDAuMzEzLTAuODI2LDAtMS4xNEwxLjcwOSw1LjE0N2MtMC4zMTQtMC4zMTMtMC4zMTQtMC44MjcsMC0xLjE0bDIuMjg0LTIuMjc4QzQuMzA4LDEuNDE3LDQuODIxLDEuNDE3LDUuMTM1LDEuNzMgIEwxMS40MDUsOGMwLjMxNCwwLjMxNCwwLjgyOCwwLjMxNCwxLjE0MSwwLjAwMWw2LjI3Ni02LjI2N2MwLjMxMi0wLjMxMiwwLjgyNi0wLjMxMiwxLjE0MSwwTDIyLjI0NSw0LjAxNXoiLz48L3N2Zz4=);
            }
          </style>
        ')

        head.add_child('<script type="text/javascript">
                          function resolve(questionId) {
                            var q = document.getElementById("question_" + questionId)
                            var type = q.getAttribute("data-type")
                            if(type == "mc") {
                              for(var answer of q.getElementsByTagName("input")) {
                                answer.setAttribute("class", "show")
                              }
                            } else if(type == "gap") {
                              for(var gap of q.getElementsByTagName("gap")) {
                                input = gap.getElementsByTagName("input")[0]
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
                        </script>')

        questions = doc.css 'div[id*=question]'
        questions.each do |question|
          id = question['id']
          parts = id.split '_'
          question['id'] = "#{parts[0]}_#{parts[2]}"
          question['data-type'] = parts[1]
        end

        answers = doc.css 'div[id*=question][data-type=mc] input[type="checkbox"]'
        answers.each do |answer|
          answer['data-correct'] = answer.key?('checked')
          answer.delete('checked')
        end
        doc.to_html
      end
    end
  end
end