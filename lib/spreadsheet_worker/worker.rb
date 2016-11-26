require 'bunny'

module SpreadsheetWorker
  class Worker
    def self.start
      prefecth

      queue.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
        handle_event(body, delivery_info.delivery_tag)
      end

    rescue Interrupt => _
      close_connection
    end

    private

    def self.handle_event(event, delivery_tag)
      puts " [x] Received '#{event}'"
      # imitate some work
      process(event)
      sleep 1
      puts " [x] Done"
      acknowledge(delivery_tag)
    end

    def self.queue
      Helper::QUEUE
    end

    def self.prefecth
      Helper::CHANNEL.prefetch(1)
      puts " [*] Waiting for messages. To exit press CTRL+C"
    end

    def self.process(event)
      puts " [x] Event #{event} has been processed!"
    end

    def self.acknowledge(tag)
      Helper::CHANNEL.ack(tag)
    end

    def self.close_connection
      Helper::CONNECTION.close
    end
  end
end
