# frozen_string_literal: true

require 'inky'
require 'premailer'
require 'net/http'

module EmailStylist
  class StyledErbTemplate

    def self.render( # rubocop:disable Metrics/ParameterLists
      template_path:,
      layout_path: nil,
      compiled_path: nil,
      css_string: nil,
      disable_caching: false,
      view_context: nil
    )
      template_id = "#{layout_path}#{template_path}"

      @cache ||= {}
      @cache[template_id] = nil if disable_caching

      erb_template = @cache[template_id] ||=
        begin
          html = compile(template_path, layout_path).gsub(/<%.*?%>/m) { |s| "base64___#{Base64.strict_encode64(s)}___base64" }

          html = Inky::Core.new.release_the_kraken(html)

          pm = Premailer.new(
            html,
            css_string:         css_string,
            with_html_string:   true,
            include_link_tags:  true,
            adapter:            :nokogiri,
            generate_text_part: false,
            css_to_attributes:  false,
            remove_scripts:     false,
          )

          html = pm.to_inline_css.force_encoding('ASCII-8BIT').gsub(/base64___(.+?)___base64/) { Base64.strict_decode64(Regexp.last_match(1)) }

          if compiled_path
            write_compiled_erb(html, compiled_path)
            Tilt::ERBTemplate.new(compiled_path)
          else
            Tilt::ERBTemplate.new { html }
          end
        end

      erb_template.render(view_context)
    end

    class << self

      private def write_compiled_erb(html, compiled_path)
        dir_name = File.dirname(compiled_path)
        FileUtils.mkdir_p(dir_name)

        File.binwrite(compiled_path, html)
      end

      private def compile(template, layout)
        html = File.binread(layout || template)

        if layout
          html = html.each_line.map { |s|
            if s.include?('INCLUDE_BODY')
              File.binread(template)
            else
              s
            end
          }.join
        end

        compile_components(html)
      end

      private def compile_components(html)
        html.each_line.map { |s|
          if (m = s.match(/INCLUDE_COMPONENT.*path="(.*)"/)) && m[1]
            compile_components(File.binread(m[1]))
          else
            s
          end
        }.join
      end

    end

  end
end
