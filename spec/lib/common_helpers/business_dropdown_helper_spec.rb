require 'rails_helper'

RSpec.describe CommonHelpers::BusinessDropdownHelper do
  class DummyClass
    include CommonHelpers::BusinessDropdownHelper
    def params
      {scheme_id: Scheme.last.id}
    end

    def respond_to
      yield File.new
    end

    class File
      def js
      end
    end
  end

  subject(:bd_helper) { described_class }
  let(:dummy_class) { DummyClass.new }

  context 'when updating the business dropdown' do
    it 'expects it to be populated with the correct businesses' do
      allow(Scheme).to receive(:where).and_return [Scheme.last]
      dummy_class.update_businesses
      expect(dummy_class.instance_variable_get(:@businesses)).to eq Scheme.last.businesses
    end
  end
end
