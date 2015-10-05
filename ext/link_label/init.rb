# -*- encoding: utf-8 -*-

require_relative('link_label')

is_string = lambda do |val|
  raise "The value has to be a string" unless val.kind_of?(String)
  val
end

website.ext.tag.register('Webgen::Tag::LinkLabel',
                         names: ['link_label', 'label_link'],
                         mandatory: ['path'],
                         config_prefix: 'tag.link_label')
website.config.define_option('tag.link_label.path', nil, &is_string)
website.config.define_option('tag.link_label.icon', "file-pdf-o", &is_string)
website.config.define_option('tag.link_label.text', "PDF", &is_string)
