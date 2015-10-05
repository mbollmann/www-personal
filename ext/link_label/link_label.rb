# -*- encoding: utf-8 -*-

require 'webgen/tag'

module Webgen
  class Tag
    module LinkLabel
      def self.call(tag, body, context)
        result = "["
        # insert icon
        result << "<i class=\"fa fa-" << context[:config]['tag.link_label.icon']
        result << "\"></i> "
        # insert text
        result << context[:config]['tag.link_label.text']
        # insert link
        result << "](" << context[:config]['tag.link_label.path']
        result << "){:.label.label-primary}"
        result
      end
    end
  end
end
