require 'bunny'
require_relative 'connection_helper'

module SpreadsheetWorker
  class Publisher
    include ConnectionHelper

    def publish(event)
      channel.default_exchange.publish(event, routing_key: queue.name)
      log(:info, " [x] Sent event: '#{event}'")

      connection.close
      log(:info, " [x] Connection closed!")
    rescue => e
      log(:error, e)
    end
  end
end
