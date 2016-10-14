module CommonHelpers
  module MultiUserTypesHelper
    def current_user
      @current_user ||= current_admin || current_scheme_operator || current_company_operator
      @current_user
    end
  end
end
