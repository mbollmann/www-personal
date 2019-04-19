# -*- encoding: utf-8 -*-

require 'webgen/error'
require 'webgen/path'
require_relative 'utils'

module WebgenBibtex
  class Tag
    module Base
      def make_objects(tag, context)
        bibtex = make_bibtex(tag, context)
        citeproc = make_citeproc(bibtex, context)
        [bibtex, citeproc]
      end

      private

      def make_bibtex(tag, context)
        filename = context[:config]['tag.bibliography.bibfile']
        if filename.nil?
          raise Webgen::RenderError.new("Bibliography file is not set",
                                        "tag.#{tag}", context.dest_node, context.ref_node)
        end
        filename = File.join(context.website.directory, 'src', filename) unless filename =~ /^(\/|\w:)/
        if !File.exists?(filename)
          raise Webgen::RenderError.new("Bibliography file '#{filename}' does not exist",
                                        "tag.#{tag}", context.dest_node, context.ref_node)
        end
        BibTeX.open filename, filter: :latex
      end

      def make_citeproc(bibtex, context)
        format_options = context[:config]['tag.bibliography.format']
        locale = context[:config]['tag.bibliography.locale']
        locale = context.content_node.lang if locale.nil?
        options = {
          style: context[:config]['tag.bibliography.style'],
          format: CiteProc::Ruby::Formats::Html.new(format_options),
          locale: locale
        }
        cp = CiteProc::Processor.new options
        cp.import bibtex.to_citeproc
      end
    end
  end
end
