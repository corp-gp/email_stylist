# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmailStylist::StyledErbTemplate do
  describe '.render' do
    it 'template with layout' do
      html = described_class.render(
        layout_path:   'spec/templates/layout.html.inky',
        template_path: 'spec/templates/template.html.inky',
      )

      expect(html).to eq(<<~HTML)
        <!DOCTYPE html>
        <html>
          <body>
            <table class="container" align="center"><tbody><tr><td>
        <table class="wrapper" align="center"><tr><td class="wrapper-inner">
        template: erb_here
        <div class="test-class">
        component_content
        </div>
        </td></tr></table>
            </td></tr></tbody></table>
          </body>
        </html>
      HTML
    end

    it 'template without layout' do
      html = described_class.render(
        template_path: 'spec/templates/template.html.inky',
      )

      expect(html).to eq(<<~HTML)
        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
        <html><body>
        <table class="wrapper" align="center"><tr><td class="wrapper-inner">
        template: erb_here
        <div class="test-class">
        component_content
        </div>
        </td></tr></table>
        </body></html>
      HTML
    end
  end
end
