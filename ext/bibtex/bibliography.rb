# -*- encoding: utf-8 -*-

require_relative 'base'

module WebgenBibtex
  class Tag
    module Bibliography
      extend WebgenBibtex::Tag::Base

      def self.call(tag, _, context)
        _, proc = make_objects(tag, context)
        conditions = context[:config]['tag.bibliography.conditions']
        proc.bibliography(conditions).to_s
      end
    end
  end
end
