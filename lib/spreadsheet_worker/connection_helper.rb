require 'bunny'

module SpreadsheetWorker
  module ConnectionHelper
    QUEUE_NAME = 'spreadsheet_processing_queue'.freeze

    private

    def queue
      @queue ||= channel.queue(QUEUE_NAME, :durable => true)
    end

    def channel
      connection.start
      connection.create_channel
    end

    def connection
      @connection ||= Bunny.new(hostname: 'queue_rabbitmq:5672', automatically_recover: false, log_file: 'log/spreadsheet_worker.rb', log_level: :info)
    end

    def log_error(error)
      connection.logger.log(3, error)
    end

    def log_info(msg)
      connection.logger.log(1, msg)
    end
  end
end
