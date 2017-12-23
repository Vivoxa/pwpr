require 'rails_helper'

RSpec.describe Reporting::Worker do
  subject(:worker) { described_class.new('q_name', 'q_host', 'log/file.log') }
  let(:report_type) { 'Reporting::Reports::RegistrationForm' }
  let(:year) { 2016 }
  let(:scheme_operator) { SchemeOperator }
  let(:company_operator) { CompanyOperator }
  let(:admin) { Admin }
  let(:current_user_id) { 1 }
  let(:business_ids) { '1' }

  describe '#process' do
    context 'when SchemeOperator' do
      let(:report_event_datum) do
        ReportEventDatum.create(report_type:       report_type,
                                year:              year,
                                current_user_type: scheme_operator,
                                current_user_id:   current_user_id,
                                business_ids:      business_ids)
      end
      it 'when all values are correct' do
        expect_any_instance_of(Reporting::Reports::RegistrationForm).to receive(:process_report).with(1, year.to_s, SchemeOperator.find(1)).and_return true
        expect_any_instance_of(SchemeMailer).to receive(:scheme_director_info).exactly(1).times
        worker.process(report_event_datum.id)
      end
    end

    context 'when Admin' do
      let(:report_event_datum) do
        ReportEventDatum.create(report_type:       report_type,
                                year:              year,
                                current_user_type: admin,
                                current_user_id:   current_user_id,
                                business_ids:      business_ids)
      end
      it 'when all values are correct' do
        expect_any_instance_of(Reporting::Reports::RegistrationForm).to receive(:process_report).with(1, year.to_s, Admin.find(1)).and_return true
        expect_any_instance_of(SchemeMailer).to receive(:scheme_director_info).exactly(1).times
        worker.process(report_event_datum.id)
      end
    end

    context 'when SchemeOperator' do
      let(:report_event_datum) do
        ReportEventDatum.create(report_type:       report_type,
                                year:              year,
                                current_user_type: company_operator,
                                current_user_id:   current_user_id,
                                business_ids:      business_ids)
      end
      it 'when all values are correct' do
        expect_any_instance_of(Reporting::Reports::RegistrationForm).to receive(:process_report).with(1, year.to_s, CompanyOperator.find(1)).and_return true
        expect_any_instance_of(SchemeMailer).to receive(:scheme_director_info).exactly(1).times
        worker.process(report_event_datum.id)
      end
    end
  end
end
