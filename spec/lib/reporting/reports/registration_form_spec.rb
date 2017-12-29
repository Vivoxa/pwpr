require 'rails_helper'

RSpec.describe Reporting::Reports::RegistrationForm do
  class DummyResponse
    def body
      {key: 'value'}.to_json
    end
  end

  subject(:reg_form) { described_class.new }
  let(:business) { Business.find(1) }
  describe '#process_report' do
    context 'with the correct params' do
      before do
        expect_any_instance_of(Reporting::Reports::BaseReport).to receive(:upload_filled_pdf_form_s3)
        allow_any_instance_of(Clients::V1::PdfServiceClient).to receive(:get_form_fields).and_return DummyResponse.new
        allow_any_instance_of(Clients::V1::PdfServiceClient).to receive(:create_pdf)
      end

      it 'expects a report to be emailed' do
        expect(SchemeMailer).to receive(:registration_email).exactly(1).times.and_return(double(deliver_now: true))
        reg_form.process_report(1, 2015, SchemeOperator.first)
      end
      it 'expects an EmailReport to be saved to the database' do
        expect { reg_form.process_report(1, 2015, SchemeOperator.first) }.to change { EmailedReport.count }.by(1)
      end

      it 'expects an error NOT to be raised' do
        expect { reg_form.process_report(1, 2015, SchemeOperator.first) }.not_to raise_error
      end
    end
  end
end
