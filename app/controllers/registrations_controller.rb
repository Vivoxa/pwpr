class RegistrationsController < ApplicationController
  # GET business/:id/registrations/new
  def new
    @business = Business.where(id: params[:business_id]).first
    @registration = Registration.new
  end

  # POST business/:id/registrations
  def create
    @business = Business.where(id: params[:business_id]).first

    error_redirect(@business, 'Invalid Sic Code!') and return unless formated_params[:sic_code]
    error_redirect(@business, 'Packaging Sector no provided!') and return unless formated_params[:packaging_sector_main_activity]

    registration = Registration.new(formated_params)
    registration.business = @business
    registration.save!

    if registration.allocation_method_used
      redirect_to new_business_small_producer_path(business_id: @business.id), notice: "Registration Details for #{@business.name} were successfully saved!"
    else
      redirect_to new_business_regular_producer_path(business_id: @business.id), notice: "Registration Details for #{@business.name} were successfully saved!"
    end
  end

  # GET business/:id/registrations/1/edit
  def edit
    @business = Business.where(id: params[:business_id]).first
    error_redirect(@business, 'No Registration Details where found for this business!') and return if @business.registrations.empty?
    @registration = @business.registrations.last
  end

  # PATCH/PUT business/:id/registrations/1
  def update
    @business = Business.where(id: params[:business_id]).first
    registration = @business.registrations.last

    error_redirect(@business, 'Invalid Sic Code!') and return unless formated_params[:sic_code]
    error_redirect(@business, 'Packaging Sector no provided!') and return unless formated_params[:packaging_sector_main_activity]

    registration.attributes = formated_params
    registration.save!

    redirect_to @business, notice: "Registration Details for #{@business.name} were successfully updated!"
  end

  def registration_params
    params.require(:registration).permit(:sic_code, :packaging_sector_main_activity, :submission_type,
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
