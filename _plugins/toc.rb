module Jekyll
  module TOC
    class Tag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
      end

      def render(context)
        content = context["content"]

        return "" unless content

        headings = []
        content.scan(/<h([2-6])[^>]*id="([^"]*)"[^>]*>(.*?)<\/h\1>/m) do |level, id, text|
          # Remove HTML tags from heading text
          clean_text = text.gsub(/<[^>]+>/, '')
          headings << {
            level: level.to_i,
            id: id,
            text: clean_text
          }
        end

        return "" if headings.empty?

        output = '<nav class="table-of-contents">'
        output += '<ul>'

        current_level = 2
        headings.each do |heading|
          level = heading[:level]

          if level > current_level
            output += '<ul>' * (level - current_level)
          elsif level < current_level
            output += '</ul>' * (current_level - level)
          end

          output += %Q(<li><a href="##{heading[:id]}">#{heading[:text]}</a></li>)
          current_level = level
        end

        output += '</ul>' * (current_level - 1)
        output += '</nav>'

        output
      end
    end
  end
end

Liquid::Template.register_tag('toc', Jekyll::TOC::Tag)
