module Logging
  # This is the magical bit that gets mixed into your classes
  def logger
    Logging.logger
  end

  # Global, memoized, lazy initialized instance of a logger
  def self.logger
    @logger ||= initialize_logger
  end

  def self.initialize_logger
    tl = Logger.new("log/#{Rails.env}.log")
    tl.formatter = Logger::Formatter.new
    ActiveSupport::TaggedLogging.new(tl)
  end
end
