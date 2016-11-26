module SpreadsheetWorker
  module Exceptions
    class InvalidEventError < StandardError
      def initialize(message = 'Invalid Event.'.freeze)
        super(message)
      end
    end
  end
end
