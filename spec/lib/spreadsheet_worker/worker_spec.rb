require 'rails_helper'

RSpec.describe SpreadsheetWorker::Worker do
  subject(:publisher) { described_class.new(queue_name, 'queue_rabbitmq:5672', 'log/spreadsheet_worker.log') }
  let(:bunny) do
    Bunny.new(hostname:              'queue_rabbitmq:5672',
              automatically_recover: false,
              log_file:              'log/spreadsheet_worker.log',
              log_level:             :info)
  end
  let(:channel) { double(Bunny::Channel) }
  let(:queue) { double(Bunny::Queue) }
  let(:event) { 'event message' }
  let(:queue_name) { 'test_queue_name' }

  context 'when starting the worker' do
    before do
      allow(Bunny).to receive(:new).and_return bunny
      allow(bunny).to receive(:start).and_return true
      allow(bunny).to receive(:create_channel).and_return channel
      allow(channel).to receive(:queue).and_return queue
      allow(queue).to receive(:name).and_return queue_name
      allow(queue).to receive(:subscribe)
      allow(channel).to receive(:prefetch)
    end

    after do
      publisher.start
    end

    it 'calls prefetch' do
      expect(publisher).to receive(:prefetch).once
    end

    it 'subscribed with the correct params' do
      expect(queue).to receive(:subscribe).with(manual_ack: true, block: true)
    end
  end
end
