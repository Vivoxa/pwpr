require 'rails_helper'

RSpec.describe ReportFormData, type: :model do
  subject(:report_form_data) { described_class.new }

  context 'expects attributes to be present' do
    it { is_expected.to respond_to :business_id }
    it { is_expected.to respond_to :business_name }
    it { is_expected.to respond_to :email }
    it { is_expected.to respond_to :email_contact_present }
    it { is_expected.to respond_to :emailed_report }

    it 'expects the model to always be persisted' do
      expect(report_form_data.persisted?).to eq true
    end
    context 'when contact is NOT present' do
      it 'expects email_contact not to be present' do
        expect(report_form_data.email_contact_present?).to eq false
      end
    end

    context 'when contact is present' do
      it 'expects email_contact not to be present' do
        report_form_data.email_contact_present = true
        expect(report_form_data.email_contact_present?).to eq true
      end
    end
  end
end
