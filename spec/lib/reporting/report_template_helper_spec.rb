require 'rails_helper'

RSpec.describe Reporting::ReportTemplateHelper do
  subject(:helper) { described_class }
  let(:key) { 'default_registration_form.pdf' }
  let(:template_bucket_name) { 'test-pwpr-templates' }
  let(:bucket_name) { 'test-pwpr-templates' }
  let(:tmp_filepath) { 'public/filetest.pdf' }
  let(:params) { {bucket: bucket_name, key: key} }

  describe '#get_default_template' do
    it 'expects to retrieve an object from the bucket' do
      expect_any_instance_of(Aws::S3::Client).to receive(:get_object).with(params, target: tmp_filepath).and_return(double(body: 'the body'))
      helper.get_default_template('registration_form')
    end
  end

  describe '#cleanup' do
    it 'expects the temp file to be removed' do
      expect(FileUtils).to receive(:rm).with([tmp_filepath], force: true)
      helper.cleanup
    end
  end

  describe '#report_template_bucket_name' do
    it 'expects the correct template bucket name' do
      expect(helper.report_template_bucket_name).to eq(template_bucket_name)
    end
  end
end
