require 'rails_helper'

RSpec.describe SpreadsheetWorker::ConnectionHelper do
  context 'Constants' do
    it 'sets SHARED_PERMISSIONS' do
      expect(subject.class::QUEUE_NAME).to eq 'spreadsheet_processing_queue'
    end
  end
end
