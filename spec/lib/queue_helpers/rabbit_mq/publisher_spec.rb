require 'rails_helper'

RSpec.describe QueueHelpers::RabbitMq::Publisher do
  subject(:publisher) { described_class.new(queue_name, 'queue_rabbitmq:5672', 'log/spreadsheet_worker.log') }
  let(:bunny) { Bunny.new(hostname: 'queue_rabbitmq:5672', automatically_recover: false, log_file: 'log/spreadsheet_worker.log', log_level: :info) }
  let(:channel) { double(Bunny::Channel) }
  let(:queue) { double(Bunny::Queue) }
  let(:event) { 'event message' }
  let(:queue_name) { 'test_queue_name' }

  context 'when publishing an event' do
    before do
      allow(Bunny).to receive(:new).and_return bunny
      allow(bunny).to receive(:start).and_return true
      allow(bunny).to receive(:create_channel).and_return channel
      allow(channel).to receive(:queue).and_return queue
      allow(queue).to receive(:name).and_return queue_name
    end

    after do
      publisher.publish(event)
    end

    xit 'publishes the event to the exchange' do
      expect(channel).to receive_message_chain(:default_exchange, :publish).with(event, routing_key: queue_name)
    end

    xit 'calls the logging method' do
      allow(channel).to receive_message_chain(:default_exchange, :publish)
      expect(publisher).to receive(:log).exactly(4).times
    end

    it 'closes the connection' do
      allow(channel).to receive_message_chain(:default_exchange, :publish)
      expect(bunny).to receive(:close)
    end
  end
end
