require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AdminsHelper. For example:
#
# describe AdminsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
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
