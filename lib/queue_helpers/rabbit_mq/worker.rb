require 'bunny'

module QueueHelpers
  module RabbitMq
    class Worker

      def initialize(queue_name, host, log_path)
        @queue_manager = QueueHelpers::RabbitMq::ConnectionManager.new(queue_name, host, log_path)
      end

      def start
        prefetch

        @queue_manager.queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
          handle_event(body, delivery_info.delivery_tag)
        end

      rescue Interrupt => _
        @queue_manager.connection.close
        puts ' [x] Connection closed!'
      end

      private

      def handle_event(event, delivery_tag)
        @queue_manager.log(:info, " [x] Received '#{event}'")
        # imitate some work
        process(event)
        sleep 1

        @queue_manager.log(:info, ' [x] Done')
        acknowledge(delivery_tag)
        @queue_manager.log(:info, ' [*] Waiting for events...')

      rescue => e
        @queue_manager.log(:error, e)
      end

      def prefetch
        puts ' [x] Worker started!'
        @queue_manager.channel.prefetch(1)
        puts ' [*] Waiting for events... Press CTRL+C to stop worker'
      end

      def process(_event)
        raise NotImplementedError.new
      end

      def acknowledge(tag)
        @queue_manager.channel.ack(tag)
      end
    end
  end
end
