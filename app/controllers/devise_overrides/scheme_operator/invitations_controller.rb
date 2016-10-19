module DeviseOverrides
  module SchemeOperator
    class InvitationsController < BaseInvitationsController
      before_filter :authenticate_scheme_operator, only: %i(new create)
      authorize_resource class: DeviseOverrides::SchemeOperator::InvitationsController

      include CommonHelpers::MultiUserTypesHelper

      def current_inviter
        current_admin || current_scheme_operator || current_company_operator
      end

      protected

      def authenticate_inviter!
        authenticate_admin!(force: true) if current_admin
        authenticate_scheme_operator! if current_scheme_operator
      end

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:invite) do |user_params|
          user_params.permit({scheme_ids: []}, :email, :name)
        end
      end

      protected

      def authenticate_inviter!
        return true if current_admin || current_scheme_operator
        authenticate_scheme_operator!
      end
    end
  end
end
