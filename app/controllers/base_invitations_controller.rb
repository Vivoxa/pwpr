
  class BaseInvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters, if: :devise_controller?
    include CommonHelpers::MultiUserTypesHelper

    # GET /resource/invitation/new
    def new
      populate_schemes_and_businesses
      self.resource = resource_class.new
      render :new
    end

    # POST /resource/invitation
    def create
      populate_schemes_and_businesses
      self.resource = invite_resource
      resource_invited = resource.errors.empty?
      yield resource if block_given?

      if resource_invited
        if is_flashing_format? && resource.invitation_sent_at
          set_flash_message :notice, :send_instructions, email: resource.email
        end
        begin
          if method(:after_invite_path_for).arity == 1
            respond_with resource, location: after_invite_path_for(current_inviter)
          else
            respond_with resource, location: after_invite_path_for(current_inviter, resource)
          end
        rescue
          redirect_to scheme_operators_path, notice: "Invitation sent to #{resource.email}"
        end
      else
        respond_with_navigational(resource) { render :new }
      end
    end

    def current_inviter
      current_admin || current_scheme_operator || current_company_operator
    end

    protected

    def populate_schemes_and_businesses
      @schemes = if current_scheme_operator
                   current_scheme_operator&.schemes
                 elsif current_admin
                   Scheme.all
                 elsif current_company_operator
                   [current_company_operator.business.scheme]
                 else
                   []
                 end
      businesses = []
      if current_company_operator
        businesses << current_company_operator.business
      else
        @schemes.each do |scheme|
          scheme.businesses.each do |business|
            businesses << business
          end
        end
      end
      @businesses = businesses.flatten
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite) do |user_params|
        user_params.permit({scheme_ids: []}, :email, :name, :business_id)
      end
    end
  end
