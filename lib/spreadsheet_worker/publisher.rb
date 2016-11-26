require 'bunny'
require_relative 'connection_helper'

module SpreadsheetWorker
  class Publisher
    include ConnectionHelper

    def publish(event)
      channel.default_exchange.publish(event, routing_key: queue.name)
      log_info(" [x] Sent #{event}")

      connection.close
    rescue => e
      log_error(e)
    end
  end
end
