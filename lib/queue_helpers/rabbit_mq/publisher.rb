module QueueHelpers
  module RabbitMq
    class Publisher
      def initialize(queue_name, host, log_path)
        @queue_manager = QueueHelpers::RabbitMq::ConnectionManager.new(queue_name, host, log_path)
      end

      def publish(event)
        @queue_manager.channel.default_exchange.publish(event, routing_key: @queue_manager.queue.name)
        @queue_manager.log(:info, " [x] Sent event: '#{event}'")

        @queue_manager.connection.close
        @queue_manager.log(:info, ' [x] Connection closed!')
      rescue => e
        @queue_manager.log(:error, e)
      end
    end
  end
end
