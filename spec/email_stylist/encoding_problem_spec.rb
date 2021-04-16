# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'EncodingProblem' do
  it 'gsub error' do
    html = EmailStylist::StyledErbTemplate.render(
      template_path: 'spec/templates/encoding_problem.html',
    )
    puts html
  end
end
