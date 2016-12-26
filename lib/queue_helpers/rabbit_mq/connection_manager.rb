require 'bunny'

module QueueHelpers
  module RabbitMq
    class ConnectionManager
      def initialize(queue_name, host, log_file_path)
        @queue_name = queue_name
        @host = host
        @log_file_path = log_file_path
      end

      def queue
        @queue ||= channel.queue(@queue_name, durable: true)
      end

      def channel
        connection.start
        log(:info, ' [x] Connection started!')

        connection.create_channel
      end

      def connection
        @connection ||= Bunny.new(connection_params)
      end

      def log(level, msg)
        connection.logger.log(logger_levels[level], msg)
      end

      def logger_levels
        {error: Logger::ERROR, warning: Logger::WARN, info: Logger::INFO}
      end

      def connection_params
        {
          hostname:              @host,
          automatically_recover: false,
          log_file:              @log_file_path,
          log_level:             :info
        }
      end
    end
  end
end
