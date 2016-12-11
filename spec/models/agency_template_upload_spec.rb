require 'rails_helper'

RSpec.describe AgencyTemplateUpload, type: :model do
  context 'Validations' do
    describe '#validates_presence_of' do
      %i(scheme_id year uploaded_at uploaded_by_id uploaded_by_type filename).each do |field|
        it { is_expected.to validate_presence_of(field) }
      end
    end
  end
end
