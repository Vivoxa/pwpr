require 'bunny'

module SpreadsheetWorker
  module ConnectionHelper
    private

    def queue
      @queue ||= channel.queue(ENV['SPREADSHEET_QUEUE_NAME'], durable: true)
    end

    def channel
      connection.start
      log(:info, " [x] Connection started!")

      connection.create_channel
    end

    def connection
      @connection ||= Bunny.new(connection_params)
    end

    def log(level, msg)
      connection.logger.log(logger_levels[level], msg)
    end

    def logger_levels
      { error: Logger::ERROR, warning: Logger::WARN, info: Logger::INFO }
    end

    def connection_params
      {
        hostname: ENV['SPREADSHEET_QUEUE_HOST'],
        automatically_recover: false,
        log_file: ENV['SPREADSHEET_WORKER_LOG_PATH'],
        log_level: :info
      }
    end
  end
end
