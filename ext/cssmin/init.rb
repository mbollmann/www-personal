# -*- encoding: utf-8 -*-

require_relative('cssmin')

website.ext.content_processor.register CSSMinWrapper, :name => 'cssmin'
