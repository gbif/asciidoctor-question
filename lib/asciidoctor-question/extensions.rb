require 'asciidoctor' unless defined? ::Asciidoctor::VERSION
require 'asciidoctor/extensions'

require_relative 'version'

module Asciidoctor
  module Question
    module Extensions
      class BaseProcessor < Asciidoctor::Extensions::BlockProcessor
        use_dsl

        def self.inherited(subclass)
          subclass.option :contexts, [:example, :literal, :open]
          subclass.option :content_model, :simple
        end

        def process_error(parent, err, source_lines)
          lines = ['[NOTE]', '====', 'Fehler! ' + err, '====']
          block = Asciidoctor::Parser.next_block Asciidoctor::Reader.new(lines), parent
          block.blocks.push Asciidoctor::Parser.next_block Asciidoctor::Reader.new(['[source, asciidoc]', '----'] + source_lines + ['----']), block
          block
        end

        def process_error_push(parent, err, source_lines)
          parent.blocks.push process_error parent, err, source_lines
        end

        def post_answers(parent, tag)
          id = tag[:id]
          parent.blocks.push Asciidoctor::Block.new parent, :pass, :source => "
            <p style=\"margin-bottom: 25px\">
              <button onclick='resolve(#{id})'>resolve</button>
            </p>"
          parent
        end
      end
    end
  end
end
