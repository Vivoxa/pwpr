require 'bunny'

module SpreadsheetWorker
  class Publisher
    def self.publish(event)
      channel.default_exchange.publish(event, :routing_key => queue.name)
      puts " [x] Sent #{event}"

      close_connection
    end

    private

    def self.queue
      Helper::QUEUE
    end

    def self.channel
      Helper::CHANNEL
    end

    def self.close_connection
      Helper::CONNECTION.close
    end
  end
end
