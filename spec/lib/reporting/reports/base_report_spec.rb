require 'rails_helper'

RSpec.describe Reporting::Reports::BaseReport do
  subject(:base_report) { described_class.new }

  it 'expects the file to be uploaded to S3' do
    allow(subject).to receive(:upload_filled_pdf_form_s3).exactly(1).times
    allow(subject).to receive(:report_type).and_return('registration_form')
    base_report.upload_filled_pdf_form_s3({yesr: '2013'}, '2016', Business.first)
  end
end
