require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::SheetHandlers::BaseHandler do
  let(:a_template) { subject.instance_variable_get(:@agency_template) }
  let(:s_filename) { subject.instance_variable_get(:@sheet_filename) }
  let(:filename) { 'path/to/test.xls' }
  let(:agency_template_obj) { AgencyTemplateUpload.new(id: 1) }

  describe '#initialize' do
    subject { described_class.new(1) }

    before do
      allow(InputOutput::ServerFileHandler).to receive(:server_file_path_for).and_return filename
      allow(AgencyTemplateUpload).to receive(:find_by_id).with(1).and_return agency_template_obj
    end

    it 'loads the CORRECT agency template' do
      expect(a_template).to eq agency_template_obj
    end

    it 'loads the correct sheet filename' do
      expect(s_filename).to eq filename
    end
  end
end
