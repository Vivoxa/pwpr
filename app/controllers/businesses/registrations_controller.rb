module Businesses
  class RegistrationsController < ApplicationController
    include Registrations
    # GET business/:id/registrations
    def index
      @business = Business.where(id: params[:business_id]).first
      @registrations = @business.registrations
    end

    # GET business/:id/registrations/new
    def new
      @business = Business.where(id: params[:business_id]).first
      @registration = Registration.new
    end

    # POST business/:id/registrations
    def create
      business = Business.where(id: registration_params[:business_id]).first

      error_redirect(business, 'Invalid Sic Code!') and return unless formated_params[:sic_code]
      error_redirect(business, 'Packaging Sector no provided!') and return unless formated_params[:packaging_sector_main_activity]

      registration = Registration.new(formated_params)
      registration.business = business
      registration.save!

      if registration.small_producer?
        redirect_to new_registration_small_producer_path(registration_id: registration.id), notice: "Registration Details for #{business.name} were successfully saved!"
      else
        redirect_to new_registration_regular_producer_path(registration_id: registration.id), notice: "Registration Details for #{business.name} were successfully saved!"
      end
    end

    # GET business/:id/registrations/1/edit
    def edit
      @registration = Registration.where(id: params[:id]).first
    end

    # PATCH/PUT business/:id/registrations/1
    def update
      registration = Registration.where(id: params[:id]).first

      error_redirect(registration.business, 'Invalid Sic Code!') and return unless formated_params[:sic_code]
      error_redirect(registration.business, 'Packaging Sector no provided!') and return unless formated_params[:packaging_sector_main_activity]

      registration.attributes = formated_params
      registration.save!

      redirect_to business_registrations_path(business_id: registration.business.id), notice: "Registration Details for #{registration.business.name} were successfully updated!"
    end

    def registration_params
      params.require(:registration).permit(:business_id, :sic_code, :packaging_sector_main_activity, :submission_type,
                                            :resubmission_reason, :turnover, :allocation_method_used)
    end

    private

    def formated_params
      reg_params = registration_params
      reg_params[:sic_code] = SicCode.where(code: reg_params[:sic_code]).first
      reg_params[:packaging_sector_main_activity] = PackagingSectorMainActivity.where(material: reg_params[:packaging_sector_main_activity]).first
      reg_params[:submission_type] = SubmissionType.where(code: reg_params[:submission_type]).first
      reg_params[:resubmission_reason] = ResubmissionReason.where(reason: reg_params[:resubmission_reason]).first
      reg_params
    end
  end
end
