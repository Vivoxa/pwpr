require 'bunny'
require_relative 'connection_helper'

module SpreadsheetWorker
  class Worker
    include ConnectionHelper

    def start
      prefetch

      queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
        handle_event(body, delivery_info.delivery_tag)
      end

    rescue Interrupt => _
      connection.close
      puts " [x] Connection closed!"
    end

    private

    def handle_event(event, delivery_tag)
      log(:info, " [x] Received '#{event}'")
      # imitate some work
      process(event)
      sleep 1

      log_info(' [x] Done')
      acknowledge(delivery_tag)
      log(:info, ' [*] Waiting for events...')

    rescue => e
      log(:error, e)
    end

    def prefetch
      puts ' [x] Worker started!'
      channel.prefetch(1)
      puts ' [*] Waiting for events... Press CTRL+C to stop worker'
    end

    def process(event)
      ################################################
      #### spreadsheet processing code called here ###
      ################################################
      log(:info, " [x] Event '#{event}' has been processed!")
    end

    def acknowledge(tag)
      channel.ack(tag)
    end
  end
end
