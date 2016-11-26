require 'bunny'

module SpreadsheetWorker
  class Helper
    QUEUE_NAME = 'spreadsheet_processing_queue'.freeze
    CONNECTION ||= Bunny.new(hostname: 'queue_rabbitmq:5672', :automatically_recover => false)
    CONNECTION.start
    CHANNEL ||= CONNECTION.create_channel
    QUEUE ||= CHANNEL.queue(QUEUE_NAME, :durable => true)
  end
end
