require 'spec_helper'
require 'digest'

RSpec.describe Pdf::RegistrationFormEmailedBusinesses do
  context 'when an email run has been processed' do
    let(:businesses) { Business.where(id: [1, 2]) }

    it 'expects the file_path to be correctly formatted' do
      filename = described_class.file_path(Scheme.find(1), 2010)
      expect(filename).to eq('public/regForm_1_2010.pdf')
    end

    it 'expects the tmp file to be removed' do
      file = described_class.file_path(businesses.first.scheme, 2010)
      described_class.pdf(businesses, 2010)

      expect(File.exist?(file)).to eq(true)

      described_class.cleanup(businesses.first.scheme, 2010)

      expect(File.exist?(file)).to eq(false)
    end

    it 'expects the pdf to be generated correctly' do
      file_sha_hash = '7476f58f7cf6f32ce5c48a3ceb9d3b8d63191792b0ee96d25dbd890b4e2cb175'
      file_path = described_class.file_path(businesses.first.scheme, 2010)
      described_class.pdf(businesses, 2010)
      sha256 = Digest::SHA256.file file_path
      described_class.cleanup(businesses.first.scheme, 2010)

      expect(sha256.hexdigest).to eq(file_sha_hash)
    end
  end
end
