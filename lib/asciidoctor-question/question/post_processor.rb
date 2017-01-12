require 'nokogiri'

module Asciidoctor
  module Question
    class HTMLPostProcessor < Asciidoctor::Extensions::Postprocessor
      def process(document, output)
        doc = Nokogiri::HTML(output)
        head = doc.at_css 'head'
        puts `pwd`
        file = File.open('./res/asciidoctor-question/question.css')
        head.add_child("
          <style id=\"question\">
            #{file.read}
          </style>
        ")
        file.close

        file = File.open('./res/asciidoctor-question/question.js')
        head.add_child("<script type=\"text/javascript\">
                          #{file.read}
                        </script>")
        file.close

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