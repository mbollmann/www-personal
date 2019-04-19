# -*- encoding: utf-8 -*-

require 'bibtex'
require 'citeproc'
require 'citeproc/ruby'
require 'csl/styles'

require_relative 'bibitem'
require_relative 'bibliography'

is_string = lambda do |val|
  raise "The value has to be a string" unless val.kind_of?(String)
  val
end

symbolic_hash = lambda do |val|
  raise 'The value has to be a hash' unless val.kind_of?(Hash)
  val.each_with_object({}) {|(k,v), h| h[k.to_sym] = v}
end

### Options that apply to all bibtex-related tags
website.config.define_option('tag.bibliography.bibfile', nil, &is_string)
website.config.define_option('tag.bibliography.style', 'apa', &is_string)
website.config.define_option('tag.bibliography.format', nil, &symbolic_hash)
website.config.define_option('tag.bibliography.link_style', 'append', &is_string)
website.config.define_option('tag.bibliography.locale', nil, &is_string)

### Producing bibliography entries for specific bibtex items
website.ext.tag.register('WebgenBibtex::Tag::BibItem',
                         names: ['bib_item', 'bibitem'],
                         mandatory: ['key'],
                         config_prefix: 'tag.bibliography')
website.config.define_option('tag.bibliography.key', nil, &is_string)

### Producing a full bibliography
website.ext.tag.register('WebgenBibtex::Tag::Bibliography',
                         names: 'bibliography',
                         config_prefix: 'tag.bibliography')
website.config.define_option('tag.bibliography.conditions', nil, &symbolic_hash)
