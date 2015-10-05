# -*- encoding: utf-8 -*-

require_relative('yui_compressor')

is_hash = lambda do |val|
  raise "The value has to be a hash" unless val.kind_of?(Hash)
  val
end

website.ext.content_processor.register YUICompressor, :name => 'yui_compressor'

option('content_processor.yui_compressor.bin', 'yui-compressor')
option('content_processor.yui_compressor.options', {}, &is_hash)
option('content_processor.yui_compressor.typemap', {}, &is_hash)
