module SpreadsheetWorker
  module Exceptions
    class InvalidMessageError < StandardError
      def initialize(message = 'Invalid Event.'.freeze)
        super(message)
      end
    end
  end
end
