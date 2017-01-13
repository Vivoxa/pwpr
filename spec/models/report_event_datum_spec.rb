require 'rails_helper'

RSpec.describe ReportEventDatum, type: :model do
  subject(:report_event_datum) { described_class.new }
  let(:business_ids) { '1,2,3,4,5,6,7,8,9,10' }

  before do
    report_event_datum.business_ids = business_ids
  end

  context 'when retrieving the business ids' do
    it 'expects an array of integers' do
      ids = report_event_datum.retrieve_business_ids
      expect(ids).to eq [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    end
  end
end
