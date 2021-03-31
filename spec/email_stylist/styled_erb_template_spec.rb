# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EmailStylist::StyledErbTemplate do
  describe '.call' do
    it 'template with layout' do
      html = described_class.get(
        layout:     'spec/templates/layout.html.inky',
        template:   'spec/templates/template.html.inky',
        css_string: '.test-class { font-size: 10; }',
      )

      expect(html).to include("<%= 'erb_here' -%>")
      expect(html).to include('font-size: 10')
      expect(html).to include('component')
    end

    it 'template without layout' do
      html = described_class.get(
        template: 'spec/templates/template.html.inky',
      )

      expect(html).to include('template')
    end
  end
end
