require 'rails_helper'

RSpec.describe Clients::V1::PdfServiceClient do
  class DummyNetHttpClient
    def start
    end
  end

  subject(:pdf_service_client) { described_class.new }
  include AuthHelper

  before do
    spoof_env_vars
  end

  describe '#create_pdf' do
    it 'expects an error message' do
      allow(Net::HTTP).to receive(:new).and_return(DummyNetHttpClient.new)
      pdf_service_client.create_pdf(a: 'b')
      expect(Net::HTTP).to have_received(:new).with('pdf_server', 2030)
    end
  end

  describe '#get_form_fields' do
    it 'expects an error message' do
      report = 'registration_form'
      allow(Net::HTTP).to receive(:start)
      pdf_service_client.get_form_fields(report)
      expect(Net::HTTP).to have_received(:start).with('pdf_server', 2030)
    end
  end
end
