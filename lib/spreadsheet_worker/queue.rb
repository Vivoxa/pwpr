require 'bunny'

module SpreadsheetWorker
  class Queue < Bunny::Queue
    QUEUE_NAME = 'spreadsheet_processing_queue'.freeze

    def initialize
      super

      @name = "#{ENV['RAILS_ENV']}-#{QUEUE_NAME}"
      @allow_retry = true
      @retry_delay = Integer(ENV['QUEUE_RETRY_DELAY'])
      @max_retry_attempts = Integer(ENV['QUEUE_RETRY_ATTEMPTS'])
      @max_retry_delay = Integer(ENV['QUEUE_MAX_RETRY_DELAY'])
    end
  end
end
