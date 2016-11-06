require 'rails_helper'

RSpec.describe CommonHelpers::AgencyTemplateUploadStatus do
  context 'Constants' do
    it 'sets ACTIVE' do
      expect(subject.class::ACTIVE).to eq 'Active'.freeze
    end

    it 'sets PENDING' do
      expect(subject.class::PENDING).to eq 'Pending'.freeze
    end

    it 'sets FAILED' do
      expect(subject.class::PENDING).to eq 'Pending'.freeze
    end
  end
end
