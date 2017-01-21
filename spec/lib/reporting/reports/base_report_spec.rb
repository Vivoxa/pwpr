require 'rails_helper'

RSpec.describe Reporting::Reports::BaseReport do
  subject(:base_report) { described_class.new }
  let(:bucket_name) { 'test-pwpr-reports' }
  let(:template_bucket_name) { 'test-pwpr-templates' }

  it 'expects bucket name' do
    expect(base_report.report_bucket_name).to eq bucket_name
  end

  it 'expects template bucket name' do
    expect(base_report.template_bucket_name).to eq template_bucket_name
  end

  it 'expects the file to be uploaded to S3' do
    expect_any_instance_of(Aws::S3::Object).to receive(:upload_file).exactly(1).times.with('public/registration_form_2016_NPWD-1.pdf')
    allow(subject).to receive(:report_type).and_return('registration_form')
    base_report.upload_to_S3('2016', Business.first)
  end
end
