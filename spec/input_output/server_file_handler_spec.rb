require 'spec_helper'

RSpec.describe InputOutput::ServerFileHandler do
  let(:tmp_file) { 'test_file.pdf' }

  it 'expects the TMP DIR to be correct' do
    expect(described_class::SERVER_TMP_FILE_DIR).to eq('public')
  end

  it 'generated server file path to be correct' do
    file_path = described_class.server_file_path_for(tmp_file)
    expect(file_path).to eq('public/test_file.pdf')
  end

  it 'expects the file to be deleted' do
    expect(FileUtils).to receive(:rm).with(['public/test_file.pdf'], force: true)
    described_class.delete_file_from_server(tmp_file)
  end
end
