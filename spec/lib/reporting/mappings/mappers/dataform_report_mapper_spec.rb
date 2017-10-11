require 'rails_helper'

RSpec.describe Reporting::Mappings::Mappers::DataformReportMapper do
  subject(:mapper) { described_class.new }
  let(:maps) { mapper.load_maps }

  it 'expects the form fields to be loaded as a hash' do
    expect(maps).to be_a Hash
  end

  it 'expects the form fields to be loaded correctly' do
    expect(maps['fields']['tb_company_name']['control_type']).to eq 'text_box'
  end
end
