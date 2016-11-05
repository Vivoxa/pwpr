require 'rails_helper'

RSpec.describe AgencyTemplateUpload, type: :model do
  subject(:agency_template_upload) { described_class.new }
  context 'Validation' do
    %i(scheme_id year uploaded_at uploaded_by_id uploaded_by_type).each do |field|
      it { is_expected.to validate_presence_of(field) }
    end
  end
end
