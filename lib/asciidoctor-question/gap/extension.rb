require_relative '../extensions'

module Asciidoctor
  module Question

    class GAPBlockProcessor < Extensions::BaseProcessor

      def process(parent, source, tag)
        id = tag[:id]
        err = nil

        question = source.lines

        question.map! do |line|
          line.gsub /__([^_]+?)__/ do |value|
            prepare_gap value.gsub '_', ''
          end
        end

        new_parent = Asciidoctor::Block.new parent, :open, {:attributes => {'id' => "question_gap_#{id}"}}

        reader = Asciidoctor::Reader.new question

        loop do
          block = Asciidoctor::Parser.next_block reader, new_parent
          break if block.nil?
          new_parent.blocks.push block
        end

        if err.nil?
          post_answers new_parent, tag
        else
          process_error_push new_parent, err, source.lines
        end

        new_parent
      end

      def prepare_gap(value)
        value
      end
   end

    class PDFGAPBlockProcessor < GAPBlockProcessor
      def prepare_gap(value)
        "+++ #{'_' * (value.size + Random.rand(6))} +++"
      end

      def post_answers(parent, tag)

      end

    end

    class HTMLGAPBlockProcessor < GAPBlockProcessor

      def prepare_gap(value)
        '+++<gap> <input type="text"/> <answer class="hidden">' + value + '</answer> </gap>+++'
      end
    end
  end
end