require 'rails_helper'

RSpec.describe SpreadsheetWorker::Exceptions::InvalidEventError do
  subject(:invalid_event_error) { described_class }

  it 'expects an error message' do
    expect(invalid_event_error.new.message).to eq 'Invalid Event.'
  end

  it 'expects a custom error message' do
    expect(invalid_event_error.new('Custom invalid event').message).to eq 'Custom invalid event'
  end
end
