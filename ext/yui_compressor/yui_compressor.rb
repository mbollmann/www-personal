class YUICompressor

  def self.call(context)
    opts = get_options(context)
    cmd = make_command(opts)
    context.content = IO.popen(cmd, "r+") do |pipe|
      pipe.puts(context.content)
      pipe.close_write
      pipe.read
    end
    context
  end

  def self.get_options(context)
    opts = context.website.config['content_processor.yui_compressor.options']
    opts.merge({
      :bin => context.website.config['content_processor.yui_compressor.bin'],
      :type => ext2type(context.dest_node,
                        context.website.config['content_processor.yui_compressor.typemap'])
    })
  end

  def self.make_command(opts)
    recognized_opts = {
      "charset" => true,
      "line_break" => true,
      "nomunge" => false,
      "preserve_semi" => false,
      "disable_optimizations" => false
    }
    cmd = [opts[:bin], "--type", opts[:type]]
    opts.each do |key, value|
      if recognized_opts.key?(key)
        cmd << "--#{key}".sub("_", "-")
        if recognized_opts[key]
          cmd << value.to_s
        end
      end
    end
    cmd
  end

  def self.ext2type(dest_node, typemap)
    ext = File.extname(dest_node.cn)
    case ext
      when ".css", ".sass", ".scss"
        "css"
      when ".js"
        "js"
      else
        if !typemap.nil? && typemap.key?(ext)
          typemap[ext]
        else
          raise Webgen::RenderError.new("Unknown file extension: #{ext}",
                                        'content_processor.yui_compressor',
                                        dest_node)
        end
    end
  end
end
