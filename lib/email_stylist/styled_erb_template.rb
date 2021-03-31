# frozen_string_literal: true

require 'inky'
require 'premailer'

module EmailStylist
  class StyledErbTemplate

    class << self

      def get(template:, layout: nil, pack: 'email.css', css_string: nil)
        @cache ||= {}

        template_id = "#{layout}#{template}"

        @cache[template_id] = nil if defined?(Rails) && Rails.env.development?
        
        @cache[template_id] ||=
          begin
            # без замены erb символов <% %> ломается Inky и Premailer
            html = compile(template, layout).gsub('<%', '1~~2~~3').gsub('%>', '9~~8~~7')
            html = Inky::Core.new.release_the_kraken(html)

            pm = Premailer.new(
              html,
              css_string:         css_string || webpacker_css_string(pack),
              output_encoding:    'utf-8',
              with_html_string:   true,
              include_link_tags:  true,
              adapter:            :nokogiri,
              generate_text_part: false,
              css_to_attributes:  false,
              remove_scripts:     false,
            )

            html = pm.to_inline_css.gsub('1~~2~~3', '<%').gsub('9~~8~~7', '%>').gsub('&amp;&amp;', '&&').gsub('&gt;', '>').gsub('&lt;', '<').gsub('&amp;', '&')

            CGI.unescape(html)
          end
      end

      private def compile(template, layout)
        html = File.read(layout || template)

        if layout
          html = html.each_line.map { |s|
            if s.include?('INCLUDE_BODY')
              File.read(template)
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
            compile_components(File.read(m[1]))
          else
            s
          end
        }.join
      end

      private def webpacker_css_string(pack)
        return unless defined? Webpacker

        uri = Webpacker.manifest.lookup!(pack)

        raise "Unable to lookup webpacker pack #{pack}" unless uri

        if Webpacker.dev_server.running?
          url = URI.join("#{Webpacker.dev_server.protocol}://#{Webpacker.dev_server.host_with_port}", uri)
          Http.get(url).to_s
        else
          Rails.public_path.join(uri.delete_prefix('/')).read
        end
      end

    end

  end
end
