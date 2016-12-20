
require_relative '../extensions'
require_relative '../multiple_choice/extension'
require_relative './post_processor'

module Asciidoctor
  module Question
    class QuestionBlockProcessor < Extensions::BaseProcessor
      name_positional_attributes [:type, :shuffle]

      def initialize name = nil, config = {}
        super name, config
        @id = 0
      end

      def process(parent, source, tag)
        err = nil
        type = tag[:type]
        @id = @id + 1
        tag[:id] = @id

        if type.nil?
          err = 'Typ fehlt.'
        end

        if err.nil?
          if type == 'mc' or type == 'multiplechoice' or type == 'multiple_choice'
            process_question_mc parent, source, tag
          end
        else
          process_error parent, err, source.lines
        end
      end
    end


    class HTMLQuestionBlockProcessor < QuestionBlockProcessor
      name_positional_attributes [:type, :shuffle]

      def process_question_mc parent, source, tag
        HTMLMultipleChoiceBlockProcessor.new.process parent, source, tag
      end
    end


    class PDFQuestionBlockProcessor < QuestionBlockProcessor
      name_positional_attributes [:type, :shuffle]

      def process_question_mc parent, source, tag
        PDFMultipleChoiceBlockProcessor.new.process parent, source, tag
      end
    end
  end
end