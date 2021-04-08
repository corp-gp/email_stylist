# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmailStylist::StyledErbTemplate do
  describe '.get' do
    it 'template with layout' do
      html = described_class.get(
        layout:     'spec/templates/layout.html.inky',
        template:   'spec/templates/template.html.inky',
        css_string: '.test-class { font-size: 10; }',
      )

      expect(html).to eq(<<~HTML)
        <!DOCTYPE html>
        <html>
          <body>
            <table class="container" align="center"><tbody><tr><td>
        <table class="wrapper" align="center"><tr><td class="wrapper-inner">
        template: <%= 'erb_here' -%>
        <div class="test-class" style="font-size: 10;">
        component_content
        </div>
        </td></tr></table>
            </td></tr></tbody></table>
          </body>
        </html>
      HTML
    end

    it 'template without layout' do
      html = described_class.get(
        template: 'spec/templates/template.html.inky',
      )

      expect(html).to include('component_content')
    end
  end
end
