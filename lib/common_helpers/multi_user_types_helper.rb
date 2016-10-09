module CommonHelpers
  module MultiUserTypesHelper

    def current_user
      current_admin || current_scheme_operator || current_company_operator
    end

  end
end
