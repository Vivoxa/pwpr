module SpreadsheetWorker
  module ConnectionHelper

    def queue
      initialise_connection unless connection_initialised?
      @queue ||= channel.queue("spreadsheet_processing_queue", :durable => true)
    end

    def channel
      initialise_connection unless connection_initialised?
      @channel ||= connection.create_channel
    end

    def connection
      if @connection
        return @connection
      else
        initialise_connection unless connection_initialised?
        return @connection
      end
    end

    private

    def initialise_connection
      @connection ||= Bunny.new(hostname: 'queue_rabbitmq:5672', :automatically_recover => true)
      @connection.start
      channel
      queue
    end

    def connection_initialised?
      @connection && @queue && @channel
    end

    def process(event)
      puts " [x] Event #{event} has been processed!"
    end
  end
end