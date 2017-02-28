module Businesses
  module Registrations
    class RegularProducersController < ApplicationController
      load_and_authorize_resource :business
      load_and_authorize_resource :regular_producer_detail, through: :business

      def new
        @registration = Registration.where(id: params[:registration_id]).first
        @regular_producer = RegularProducerDetail.new
        @business = @registration.business

        error_redirect(business_registrations_path(business_id: @registration.business.id), 'Member is a Small Producer!') && return if @registration.small_producer?
      end

      # POST business/:id/regular_producer_details
      def create
        registration = Registration.where(id: params[:registration_id]).first

        regular_producer = RegularProducerDetail.new(regular_producer_params)
        regular_producer.registration = registration
        regular_producer.save!

        redirect_to new_registration_material_detail_path(registration_id: registration.id), notice: "Regular Producer Details for #{registration.business.name} were successfully saved!"
      end

      # GET business/:id/regular_producer_detail/1/edit
      def edit
        @registration = Registration.where(id: params[:registration_id]).first

        error_redirect(business_registrations_path(business_id: @registration.business.id), 'Member is a Small Producer!') && return if @registration.small_producer?
        @regular_producer = @registration.regular_producer_detail
      end

      # PATCH/PUT business/:id/regular_producer_detail/1
      def update
        registration = Registration.where(id: params[:registration_id]).first

        regular_producer = RegularProducerDetail.new(regular_producer_params)
        regular_producer.save!

        redirect_to business_registrations_path(business_id: registration.business.id), notice: "Regular Producer Details for #{registration.business.name} were successfully saved!"
      end

      def regular_producer_params
        params.require(:regular_producer_detail).permit(:calculation_method_supplier_data, :calculation_method_sample_weighing,
                                                        :calculation_method_sales_records, :calculation_method_trade_association_method_details,
                                                        :other_method_details, :data_system_used)
      end

      def format_field(field)
        field = super
        field.slice! 'Calculation Method '
        field
      end
    end
  end
end
