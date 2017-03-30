
require_relative '../extensions'
require_relative '../multiple_choice/extension'
require_relative '../gap/extension'
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
        block = nil
        err = nil

        type = tag[:type]
        type = tag[:type] = 'mc' if type == 'mc' or type == 'multiplechoice' or type == 'multiple_choice'
        tag[:id] = @id = @id + 1

        tag[:solution] = has_solution parent

        if type.nil?
          err = 'Typ fehlt.'
        end

        if err.nil?
          if type == 'mc'
            block = process_question_mc parent, source, tag
          elsif type == 'gap'
            block = process_question_gap parent, source, tag
          end
        else
          block = process_error parent, err, source.lines
        end

        block
      end

      def has_solution(parent)
        if not ( parent.document.attributes['solution'].nil? and parent.attributes['solution'].nil? )
          true
        else
          if parent.parent.nil?
            false
          else
            has_solution(parent.parent)
          end
        end
      end
    end


    class HTMLQuestionBlockProcessor < QuestionBlockProcessor
      name_positional_attributes [:type, :shuffle]

      def process_question_mc parent, source, tag
        HTMLMultipleChoiceBlockProcessor.new.process parent, source, tag
      end

      def process_question_gap parent, source, tag
        HTMLGAPBlockProcessor.new.process parent, source, tag
      end
    end


    class PDFQuestionBlockProcessor < QuestionBlockProcessor
      name_positional_attributes [:type, :shuffle]

      def process_question_mc parent, source, tag
        PDFMultipleChoiceBlockProcessor.new.process parent, source, tag
      end

      def process_question_gap parent, source, tag
        PDFGAPBlockProcessor.new.process parent, source, tag
      end
    end
  end
end