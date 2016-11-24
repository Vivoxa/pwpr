require 'bunny'

module SpreadsheetWorker
  class Publish
    def initialize
      @connection ||= Bunny.new(hostname: 'queue_rabbitmq:5672', :automatically_recover => true)
      @connection.start

      @channel    ||= @connection.create_channel
      @queue      ||= @channel.queue("spreadsheet_processing_queue", :durable => true)
    end

    def publish(event)
      @channel.default_exchange.publish(event, :routing_key => @queue.name)
      puts " [x] Sent #{event}"

      conn.close
    end
  end
end
