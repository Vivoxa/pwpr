# frozen_string_literal: true
module SchemeOperators
  class RegistrationsController < BaseRegistrationsController
    authorize_resource class: SchemeOperators::RegistrationsController
  end
end
