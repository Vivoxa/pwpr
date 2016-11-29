require 'bunny'

module SpreadsheetWorker
  module ConnectionHelper
    QUEUE_NAME = 'spreadsheet_processing_queue'.freeze

    private

    def queue
      @queue ||= channel.queue(QUEUE_NAME, durable: true)
    end

    def channel
      connection.start
      log(:info, " [x] Connection started!")

      connection.create_channel
    end

    def connection
      @connection ||= Bunny.new(hostname: 'queue_rabbitmq:5672', automatically_recover: false, log_file: 'log/spreadsheet_worker.log', log_level: :info)
    end

    def log(level, msg)
      connection.logger.log(logger_levels[level], msg)
    end

    def logger_levels
      { error: Logger::ERROR, warning: Logger::WARN, info: Logger::INFO }
    end
  end
end
