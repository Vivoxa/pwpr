require 'bunny'
require_relative '../spreadsheet_worker/connection_helper'

module SpreadsheetWorker
  class Worker
    include SpreadsheetWorker::ConnectionHelper

    def start
      channel.prefetch(1)
      puts " [*] Waiting for messages. To exit press CTRL+C"

      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        puts " [x] Received '#{body}'"
        # imitate some work
        process(body)
        sleep 1
        puts " [x] Done"
        channel.ack(delivery_info.delivery_tag)
      end
    rescue Interrupt => _
      connection.close
    end

    private

    def process(event)
      puts " [x] Event #{event} has been processed!"
    end
  end
end