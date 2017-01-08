module CommonHelpers
  module MultiUserTypesHelper
    include Logging

    def current_user
      logger.tagged('MultiUserTypesHelper(Mod)') do
        @current_user ||= current_admin || current_scheme_operator || current_company_operator
        logger.info "current_user() - #{@current_user}"
        reset_session if @current_user.nil?
        @current_user
      end
    end
  end
end
