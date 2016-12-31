module SpreadsheetWorker
  class Worker < QueueHelpers::RabbitMq::Worker
    def process(event)
      processor = SpreadsheetWorker::SheetProcessor::Processor.new(event.to_i)
      processor.process_spreadsheet

      @queue_manager.log(:info, " [x] Event '#{event}' has been processed!")
    end
  end
end
