require 'rails_helper'

RSpec.describe SpreadsheetWorker::SheetProcessor::Processor do
  let(:a_t_id) { 1 }
  subject(:processor) { described_class.new(a_t_id) }

  let(:agency_template) { AgencyTemplateUpload.new(id: 1) }
  let(:registration_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler.new(id: 1) }
  let(:subsidiaries_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::SubsidiariesHandler.new(id: 1) }
  let(:leavers_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::LeaversHandler.new(id: 1) }
  let(:subleavers_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::SubleaversHandler.new(id: 1) }
  let(:joiners_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::JoinersHandler.new(id: 1) }
  let(:licensors_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::LicensorsHandler.new(id: 1) }
  let(:targets_handler) { SpreadsheetWorker::SheetProcessor::SheetHandlers::TargetsHandler.new(id: 1) }

  before do
    allow(AgencyTemplateUpload).to receive(:find_by_id).and_return agency_template
  end

  describe '#initialize' do
    it 'sets agency_template_id' do
      expect(processor.instance_variable_get(:@agency_template_id)).to eq a_t_id
    end

    it 'sets template_upload' do
      expect(processor.instance_variable_get(:@template_upload)).to eq agency_template
    end
  end

  describe '#process_spreadsheet' do
    before do
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler).to receive(:new).and_return(registration_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::SubsidiariesHandler).to receive(:new).and_return(subsidiaries_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::LeaversHandler).to receive(:new).and_return(leavers_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::SubleaversHandler).to receive(:new).and_return(subleavers_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::JoinersHandler).to receive(:new).and_return(joiners_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::LicensorsHandler).to receive(:new).and_return(licensors_handler)
      allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::TargetsHandler).to receive(:new).and_return(targets_handler)
      allow(registration_handler).to receive(:process)
      allow(subsidiaries_handler).to receive(:process)
      allow(leavers_handler).to receive(:process)
      allow(subleavers_handler).to receive(:process)
      allow(joiners_handler).to receive(:process)
      allow(licensors_handler).to receive(:process)
      allow(targets_handler).to receive(:process)
    end

    it 'calls transaction on ActiveRecord::Base' do
    end

    context 'for registrations' do
      it 'creates registration handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      context 'when an error is raised' do
        it 'expects an exception to be raised' do
          allow(SpreadsheetWorker::SheetProcessor::SheetHandlers::RegistrationsHandler).to receive(:new).with(a_t_id).and_raise(SpreadsheetWorker::Exceptions::InvalidEventError)
          expect_any_instance_of(Logger).to receive(:error).with('AgencyTemplate processing failed for 1 with ERROR: Invalid Event.')
          processor.process_spreadsheet
        end
      end

      it 'calls process on the registration handler object' do
        expect(registration_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for subsidiaries' do
      it 'creates subsidiaries handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::SubsidiariesHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the subsidiaries handler object' do
        expect(subsidiaries_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for leavers' do
      it 'creates leavers handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::LeaversHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the leavers handler object' do
        expect(leavers_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for subleavers' do
      it 'creates subleavers handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::SubleaversHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the subleavers handler object' do
        expect(subleavers_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for joiners' do
      it 'creates joiners handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::JoinersHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the joiners handler object' do
        expect(joiners_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for licensors' do
      it 'creates licensors handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::LicensorsHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the licensors handler object' do
        expect(licensors_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end

    context 'for targets' do
      it 'creates targets handler object' do
        expect(SpreadsheetWorker::SheetProcessor::SheetHandlers::TargetsHandler).to receive(:new).with(a_t_id)
        processor.process_spreadsheet
      end

      it 'calls process on the targets handler object' do
        expect(targets_handler).to receive(:process)
        processor.process_spreadsheet
      end
    end
  end
end
