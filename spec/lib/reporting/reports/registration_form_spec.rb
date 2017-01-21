require 'rails_helper'

RSpec.describe Reporting::Reports::RegistrationForm do
  subject(:reg_form) { described_class.new }
  let(:business) { Business.find(1) }
  describe '#process_report' do
    context 'when the template is missing' do
      it 'expects an error to be raised' do
        expect { reg_form.process_report(1, 2015, SchemeOperator.first, nil) }.to raise_error('Report template not supplied and is required!')
      end
    end

    context 'when an error occurs' do
      let(:template) { File.join(File.dirname(__FILE__), 'default_registration_form.pdf') }

      it 'expects a log to be recorded' do
        allow_any_instance_of(PdfForms::PdftkWrapper).to receive(:fill_form).and_raise('PdfForms cant continue!')
        allow(subject).to receive(:form_values_hash).and_return({})
        expect_any_instance_of(Logger).to receive(:error).with('process_report() ERROR: PdfForms cant continue!')
        expect { reg_form.process_report(1, 2015, SchemeOperator.first, template) }.to raise_error('PdfForms cant continue!')
      end
    end

    context 'with the correct params' do
      let(:template) { File.join(File.dirname(__FILE__), 'default_registration_form.pdf') }
      before do
        expect_any_instance_of(Reporting::Reports::BaseReport).to receive(:upload_to_S3).with(2015, business)
        expect_any_instance_of(Reporting::Reports::BaseReport).to receive(:cleanup).with(2015, business)
      end

      it 'expects a report to be emailed' do
        expect(SchemeMailer).to receive(:registration_email).exactly(1).times.and_return(double(deliver_now: true))
        reg_form.process_report(1, 2015, SchemeOperator.first, template)
      end
      it 'expects an EmailReport to be saved to the database' do
        expect { reg_form.process_report(1, 2015, SchemeOperator.first, template) }.to change { EmailedReport.count }.by(1)
      end

      it 'expects an error NOT to be raised' do
        expect { reg_form.process_report(1, 2015, SchemeOperator.first, template) }.not_to raise_error
      end
    end
  end
end
