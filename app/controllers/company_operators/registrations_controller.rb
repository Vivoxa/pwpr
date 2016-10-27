# frozen_string_literal: true
module CompanyOperators
  class RegistrationsController < BaseRegistrationsController
    authorize_resource class: CompanyOperators::RegistrationsController
  end
end
