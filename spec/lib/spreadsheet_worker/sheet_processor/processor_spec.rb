require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::Processor do
  let(:a_t_id) { 1 }
  let(:agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:registration_handler) { SheetHandlers::RegistrationsHandler.new(id: 1) }
  let(:subsidiaries_handler) { SheetHandlers::SubsidiariesHandler.new(id: 1) }
  let(:leavers_handler) { SheetHandlers::LeaversHandler.new(id: 1) }
  let(:subleavers_handler) { SheetHandlers::SubleaversHandler.new(id: 1) }
  let(:joiners_handler) { SheetHandlers::JoinersHandler.new(id: 1) }
  let(:licensors_handler) { SheetHandlers::LicensorsHandler.new(id: 1) }
  let(:targets_handler) { SheetHandlers::TargetsHandler.new(id: 1) }

  subject { described_class.new(a_t_id) }

  before do
    allow(AgencyTemplateUpload).to receive(:find_by_id).and_return agency_template
  end

  describe '#initialize' do
    it 'sets agency_template_id' do
      expect(subject.instance_variable_get(:@agency_template_id)).to eq a_t_id
    end

    it 'sets template_upload' do
      expect(subject.instance_variable_get(:@template_upload)).to eq agency_template
    end
  end

  describe '#process_spreadsheet' do
    before do
      allow(SheetHandlers::RegistrationsHandler).to receive(:new).and_return(registration_handler)
      allow(SheetHandlers::SubsidiariesHandler).to receive(:new).and_return(subsidiaries_handler)
      allow(SheetHandlers::LeaversHandler).to receive(:new).and_return(leavers_handler)
      allow(SheetHandlers::SubleaversHandler).to receive(:new).and_return(subleavers_handler)
      allow(SheetHandlers::JoinersHandler).to receive(:new).and_return(joiners_handler)
      allow(SheetHandlers::LicensorsHandler).to receive(:new).and_return(licensors_handler)
      allow(SheetHandlers::TargetsHandler).to receive(:new).and_return(targets_handler)
      allow(registration_handler).to receive(:process)
      allow(subsidiaries_handler).to receive(:process)
      allow(leavers_handler).to receive(:process)
      allow(subleavers_handler).to receive(:process)
      allow(joiners_handler).to receive(:process)
      allow(licensors_handler).to receive(:process)
      allow(targets_handler).to receive(:process)
      subject.process_spreadsheet
    end

    it 'calls transaction on ActiveRecord::Base' do
    end

    context 'for registrations' do
      it 'creates registration handler object' do
        expect(SheetHandlers::RegistrationsHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the registration handler object' do
        expect(registration_handler).to receive(:process)
      end
    end

    context 'for subsidiaries' do
      it 'creates subsidiaries handler object' do
        expect(SheetHandlers::SubsidiariesHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the subsidiaries handler object' do
        expect(subsidiaries_handler).to receive(:process)
      end
    end

    context 'for leavers' do
      it 'creates leavers handler object' do
        expect(SheetHandlers::LeaversHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the leavers handler object' do
        expect(leavers_handler).to receive(:process)
      end
    end

    context 'for subleavers' do
      it 'creates subleavers handler object' do
        expect(SheetHandlers::SubleaversHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the subleavers handler object' do
        expect(subleavers_handler).to receive(:process)
      end
    end

    context 'for joiners' do
      it 'creates joiners handler object' do
        expect(SheetHandlers::JoinersHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the joiners handler object' do
        expect(joiners_handler).to receive(:process)
      end
    end

    context 'for licensors' do
      it 'creates licensors handler object' do
        expect(SheetHandlers::LicensorsHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the licensors handler object' do
        expect(licensors_handler).to receive(:process)
      end
    end

    context 'for targets' do
      it 'creates targets handler object' do
        expect(SheetHandlers::TargetsHandler).to receive(:new).with(a_t_id)
      end

      it 'calls process on the targets handler object' do
        expect(targets_handler).to receive(:process)
      end
    end
  end
end
