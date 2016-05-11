# -*- encoding: utf-8 -*-

module WebgenBibtex
  class StringNotFoundError < StandardError; end

  def self.wrap_link(text, link, link_text = nil, downcase = false)
    # Wraps a substring of a string in a hyperlink
    if link_text.nil?
      link_text = link
    end
    if downcase
      idx = text.downcase.index(link_text.downcase)
    else
      idx = text.index(link_text)
    end
    text[0, idx] +
      "<a href=\"" + link + "\">" + link_text + "</a>" +
      text[idx + link_text.length, 1_000_000]
  end

  def self.resolve_link(url, context)
    # Resolves a link that is either external, or absolute to the project
    if url.include?("://") # URL has protocol -- leave unchanged
      ''
    else
      dest_node = context.ref_node.resolve(url.to_s, context.dest_node.lang, true)
      if dest_node
        context.website.ext.item_tracker.add(context.dest_node, :node_meta_info, dest_node)
        url = context.dest_node.route_to(dest_node)
      end
    end
    url
  end

  def self.add_hyperlinks(text, context)
    # Adds hyperlinks to URLs/DOIs contained in a text
    # ---
    # Note: explicitly added schemes because URI.extract matches very
    # liberally otherwise (like "HiTS: ...")
    schemes = ["http", "https", "ftp"]
    URI.extract(text, schemes) do |url|
      text = WebgenBibtex.wrap_link(text, url)
    end
    # Wrap doi:<...> in hyperlink
    text.scan(/\bdoi:\S+/) do |doi_text|
      doi = doi_text[4, 1_000_000]
      text = WebgenBibtex.wrap_link(text, "http://dx.doi.org/#{doi}", doi_text)
    end
    text
  end
end
