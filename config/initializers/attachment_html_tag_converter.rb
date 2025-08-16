module ReverseMarkdown
  def self.convert(input, options = {}, attachables: [], article_slug: nil)
    config.with(options) do
      input = cleaner.force_encoding(input.to_s)

      root = case input
             when String                  then Nokogiri::HTML(input).root
             when Nokogiri::XML::Document then input.root
             when Nokogiri::XML::Node     then input
             end

      root or return ''

      result = ReverseMarkdown::Converters.lookup(root.name).convert(root, attachables: attachables, article_slug: article_slug)
      cleaner.tidy(result)
    end
  end

  module Converters
    class Base
      def treat_children(node, state, attachables: [], article_slug: nil)
        node.children.inject(+'') do |memo, child|
          memo << treat(child, state, attachables: attachables, article_slug: article_slug)
        end
      end

      def treat(node, state, attachables: [], article_slug: nil)
        ReverseMarkdown::Converters.lookup(node.name).convert(node, state, attachables: attachables, article_slug: article_slug)
      end
    end

    class Bypass < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        treat_children(node, state, attachables: attachables, article_slug: article_slug)
      end
    end

    register :document, Bypass.new
    register :html,     Bypass.new
    register :body,     Bypass.new
    register :span,     Bypass.new
    register :thead,    Bypass.new
    register :tbody,    Bypass.new
    register :tfoot,    Bypass.new

    unregister :a
    unregister :div
    unregister :br

    class Br < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        "  \n"
      end
    end

    class Blockquote < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        content = treat_children(node, state).strip
        content = ReverseMarkdown.cleaner.remove_newlines(content)
        +"\n\n> " << content.lines.to_a.join('> ') << "\n\n"
      end
    end

    class A < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        name  = treat_children(node, state)
        href  = node['href']

        if href.to_s.empty? || name.empty?
          name
        else
          "<Link href=\"#{href}\" >#{name}</Link>"
        end
      end
    end

    class Del < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        content = treat_children(node, state.merge(already_crossed_out: true))
        if disabled? || content.strip.empty? || state[:already_crossed_out]
          content
        else
          "~~#{content}~~"
        end
      end

      def enabled?
        ReverseMarkdown.config.github_flavored
      end

      def disabled?
        !enabled?
      end
    end

    class Div < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        +"\n" << treat_children(node, state) << "\n"
      end
    end

    class Em < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        content = treat_children(node, state.merge(already_italic: true))
        if content.strip.empty? || state[:already_italic]
          content
        else
          "#{content[/^\s*/]}_#{content.strip}_#{content[/\s*$/]}"
        end
      end
    end

    # TODO: Here the name ActionTextAttachment did not seem to work, but it would be cleaner to have ActionTextAttachment
    class Richtext < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        # Remove the first item from the mutable object attachables.
        attachable = attachables.shift
        case attachable
        when ActiveStorage::Blob
          "<Image src=\"images/#{article_slug}/#{attachables.first.filename}\" alt=\"#{attachables.first.filename.as_json}\" width=\"#{node['width']}\" height=\"#{node['height']}\" caption=\"#{node['caption']}\"/>"
        when Embed
          if attachable.url.match?(/(?:youtube|youtu\.be)/)
            "<Youtube videoId=\"#{attachable.url.match(%r{(?:youtube\.com/(?:[^/\n\s]+/\S+/|(?:v|e(?:mbed)?)/|.*[?&]v=)|youtu\.be/)([^&\n]{11})})[1]}\"/>"
          else
            "<Tweet tweet_url=\"#{attachable.url}\"/>"
          end
        else
          ""
        end
      end
    end

    class Iframe < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        extract_src(node)
      end
    end

    class H < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        prefix = '#' * node.name[/\d/].to_i
        ["\n", prefix, ' ', treat_children(node, state), "\n"].join
      end
    end

    class Ol < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        ol_count = state.fetch(:ol_count, 0) + 1
        +"\n" << treat_children(node, state.merge(ol_count: ol_count)) << "\n"
      end
    end

    class Li < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        contains_child_paragraph = node.first_element_child ? node.first_element_child.name == 'p' : false
        content_node             = contains_child_paragraph ? node.first_element_child : node
        content                  = treat_children(content_node, state)
        indentation              = indentation_from(state)
        prefix                   = prefix_for(node)

        "#{indentation}#{prefix}#{content.chomp}\n" +
          (contains_child_paragraph ? "\n" : '')
      end

      def prefix_for(node)
        if node.parent.name == 'ol'
          index = node.parent.xpath('li').index(node)
          "#{index.to_i + 1}. "
        else
          '- '
        end
      end

      def indentation_from(state)
        length = state.fetch(:ol_count, 0)
        '  ' * [length - 1, 0].max
      end
    end

    class Text < Base
      def convert(node, options = {}, attachables: [], article_slug: nil)
        if node.text.strip.empty?
          treat_empty(node)
        else
          treat_text(node)
        end
      end

      private

      def treat_empty(node)
        parent = node.parent.name.to_sym
        if [:ol, :ul].include?(parent)  # Otherwise the identation is broken
          ''
        elsif node.text == ' '          # Regular whitespace text node
          ' '
        else
          ''
        end
      end

      def treat_text(node)
        text = node.text
        text = preserve_nbsp(text)
        text = remove_border_newlines(text)
        text = remove_inner_newlines(text)
        text = escape_keychars(text)

        text = preserve_keychars_within_backticks(text)
        preserve_tags(text)
      end

      def preserve_nbsp(text)
        text.gsub("\u00A0", "&nbsp;")
      end

      def preserve_tags(text)
        text.gsub(/[<>]/, '>' => '\>', '<' => '\<')
      end

      def remove_border_newlines(text)
        text.gsub(/\A\n+/, '').gsub(/\n+\z/, '')
      end

      def remove_inner_newlines(text)
        text.tr("\r\n\t", ' ').squeeze(' ')
      end

      def preserve_keychars_within_backticks(text)
        text.gsub(/`.*?`/) do |match|
          match.gsub('\_', '_').gsub('\*', '*')
        end
      end
    end

    class Pre < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        content = treat_children(node, state)
        if ReverseMarkdown.config.github_flavored
          "\n```#{language(node)}\n" << content.strip << "\n```\n"
        else
          +"\n\n    " << content.lines.to_a.join("    ") << "\n\n"
        end
      end

      private

      def treat(node, state, attachables: [], article_slug: nil)
        case node.name
        when 'code', 'text'
          node.text.strip
        when 'br'
          "\n"
        else
          super
        end
      end

      def language(node)
        lang = language_from_highlight_class(node)
        lang || language_from_confluence_class(node)
      end

      def language_from_highlight_class(node)
        node.parent['class'].to_s[/highlight-([a-zA-Z0-9]+)/, 1]
      end

      def language_from_confluence_class(node)
        node['class'].to_s[/brush:\s?(:?.*);/, 1]
      end
    end

    class Strong < Base
      def convert(node, state = {}, attachables: [], article_slug: nil)
        content = treat_children(node, state.merge(already_strong: true))
        if content.strip.empty? || state[:already_strong]
          content
        else
          "#{content[/^\s*/]}**#{content.strip}**#{content[/\s*$/]}"
        end
      end
    end

    register :a, A.new
    register :br, Br.new
    register :blockquote, Blockquote.new
    register :strike, Del.new
    register :s,      Del.new
    register :del,    Del.new
    register :div, Div.new
    register :em, Em.new
    register :i,  Em.new
    register :iframe, Iframe.new
    register :h1, H.new
    register :h2, H.new
    register :h3, H.new
    register :h4, H.new
    register :h5, H.new
    register :h6, H.new
    register :li, Li.new
    register :ol, Ol.new
    register :ul, Ol.new
    register :pre, Pre.new
    register :richtext, Richtext.new
    register :strong, Strong.new
    register :b, Strong.new
    register :text, Text.new
  end
end
