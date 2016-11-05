require 'rails_helper'

class AgencyTemplateUpload
  attr_accessor :filename, :scheme_id, :year
end

RSpec.describe S3::AgencyTemplateUploader do
  subject(:uploader) { described_class.new }
  let(:agt) { AgencyTemplateUpload.new }
  before do
    agt.filename = 'test.csv'
    agt.scheme_id = Scheme.last.id
    agt.year = '2010'
    ENV['AWS_REGION'] = 'eu-west-1'
  end
  context '#PUT' do
    it 'expects S3 to receive a call to store the file' do
      expect_any_instance_of(Aws::S3::Object).to receive(:upload_file).with('public/test.csv')
      uploader.put(agt)
    end
  end
end
