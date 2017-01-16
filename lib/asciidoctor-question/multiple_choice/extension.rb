require_relative '../extensions'

module Asciidoctor
  module Question

    class MultipleChoiceBlockProcessor < Extensions::BaseProcessor

      name_positional_attributes :shuffle

      def process(parent, source, tag)
        id = tag[:id]
        err = nil
        question = Array.new
        answers = Array.new ['[options=interactive]']
        switch = false

        source.lines.each do |line|
          switch = true if line =~ /^-\s?\[/
          if switch
            answers.push line
          else
            question.push line
          end
        end

        answers = prepare_answer_lines answers

        attrs = {'id' => "question_#{id}_type=mc"}

        attrs['id'] += '_shuffle' unless tag[:shuffle].nil?

        new_parent = Asciidoctor::Block.new parent, :open, {:attributes => attrs}

        reader = Asciidoctor::Reader.new(question)
        loop do
          block = Asciidoctor::Parser.next_block reader, new_parent
          break if block.nil?
          new_parent.blocks.push block
        end

        reader = Asciidoctor::Reader.new(answers)
        answers_block = Asciidoctor::Parser.next_block reader, new_parent
        if answers_block.nil?
          err = 'Es sind keine Antworten vorhanden!'
        end

        if err.nil?
          new_parent.blocks.push prepare_answers answers_block, tag
          post_answers new_parent, tag

        else
          process_error_push new_parent, err, answers
        end
        new_parent
      end

      def prepare_answer_lines(lines)
        lines
      end

      def prepare_answers(answers_block, tag)
        answers_block.blocks.shuffle! if tag[:shuffle]
        answers_block
      end

    end

    class PDFMultipleChoiceBlockProcessor < MultipleChoiceBlockProcessor
      def prepare_answers(answers_block, tag)
        super
        unless tag[:solution]
          answers_block.blocks.each do |answer|
            answer.attributes.delete('checked')
          end
        end
        answers_block
      end

      def post_answers(parent, tag)

      end
    end

    class HTMLMultipleChoiceBlockProcessor < MultipleChoiceBlockProcessor

      def prepare_answer_lines(lines)
        lines.map! do |answer|
          if answer =~ /^-\s?\[/ then
            answer.sub ']', '] +++ <span/> +++'
          else
            answer
          end
        end
        lines
      end

      def prepare_answers(answers_block, tag)
        id = tag[:id]
        aid = -1
        answers_block.attributes['id'] = "answers_mc_#{id}"

        answers_block.blocks.each do |answer|
          answer.attributes['id'] = "answer_mc_#{id}_#{aid += 1}"
        end
        answers_block
      end
    end
  end
end