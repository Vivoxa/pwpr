module CommonHelpers
  module LogHelper
    def tag_logs
      logger.tagged("#{params['controller']}::#{params['action']}") do
        yield
      end
    end
  end
end
