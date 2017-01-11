#require 'asciidoctor-pdf'
require_relative '../lib/asciidoctor-question'

Asciidoctor.convert_file 'test/test.adoc', {:safe => :safe}
#Asciidoctor.convert_file 'test/test.adoc', {:safe => :safe, :backend => 'pdf'}
