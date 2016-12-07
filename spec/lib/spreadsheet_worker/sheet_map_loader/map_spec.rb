require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetMapLoader::Map do
  describe '#load' do
    context 'when file is joiners' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:joiners)).to be_a Hash
      end
    end

    context 'when file is leavers' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:leavers)).to be_a Hash
      end
    end

    context 'when file is subleavers' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:subleavers)).to be_a Hash
      end
    end

    context 'when file is registrations' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:registrations)).to be_a Hash
      end
    end

    context 'when file is subsidiaries' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:subsidiaries)).to be_a Hash
      end
    end

    context 'when file is targets' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:targets)).to be_a Hash
      end
    end

    context 'when file is licencees' do
      it 'returns a has with the yaml values' do
        expect(subject.load(:licencees)).to be_a Hash
      end
    end
  end
end
