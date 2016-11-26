require 'bunny'
require_relative '../spreadsheet_worker/connection_helper'

module SpreadsheetWorker
  class Publish
    include SpreadsheetWorker::ConnectionHelper

    def publish(event)
      channel.default_exchange.publish(event, :routing_key => @queue.name)
      puts " [x] Sent #{event}"
    end
  end
end
