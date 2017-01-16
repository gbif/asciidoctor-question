require 'nokogiri'

module Asciidoctor
  module Question
    class HTMLPostProcessor < Asciidoctor::Extensions::Postprocessor
      def process(document, output)
        doc = Nokogiri::HTML(output)
        head = doc.at_css 'head'
        doc.at_css('body')['onload'] = 'onLoad()'
        basedir = File.expand_path('../../../../', __FILE__)
        file = File.open("#{basedir}/res/asciidoctor-question/question.css")
        head.add_child("
          <style id=\"question\">
            #{file.read}
          </style>
        ")
        file.close

        file = File.open("#{basedir}/res/asciidoctor-question/question.js")
        head.add_child("<script type=\"text/javascript\">
                          #{file.read}
                        </script>")
        file.close

        questions = doc.css 'div[id*=question]'
        questions.each do |question|
          question.name = 'question'
          id = question['id']
          parts = id.split '_'
          question['id'] = "#{parts.shift}_#{parts.shift}"
          parts.each do |data|
            tmp = data.split '='
            question['data-' + tmp[0]] = (tmp[1].nil?)?nil:tmp[1]
          end
        end

        answers = doc.css 'question[id*=question][data-type=mc] input[type="checkbox"]'
        answers.each do |answer|
          answer['data-correct'] = answer.key?('checked')
          answer.delete('checked')
        end
        doc.to_html
      end
    end
  end
end