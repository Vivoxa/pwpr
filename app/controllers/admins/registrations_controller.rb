# frozen_string_literal: true
module Admins
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :require_no_authentication
    authorize_resource class: Admins::RegistrationsController
  end
end