module Businesses
  module Registrations
    class SmallProducersController < ApplicationController
      def new
        @business = Business.where(id: params[:business_id]).first
        @small_producer = SmallProducerDetail.new
        @registration = @business.registrations.last

        error_redirect(@business, 'No Registration Details where found for this business!') and return unless @registration
        error_redirect(@business, 'Member is a Regular Producer!') and return unless @business.registrations.last.small_producer?
      end

      # POST business/:id/small_producers
      def create
        @business = Business.where(id: params[:business_id]).first
        @registration = @business.registrations.last

        small_producer = SmallProducerDetail.new(small_producer_params)
        small_producer.registration = @registration
        small_producer.save!

        redirect_to @business, notice: "Small Producer Details for #{@business.name} were successfully saved!"
      end

      # GET business/:id/small_producer/1/edit
      def edit
        @business = Business.where(id: params[:business_id]).first
        @registration = @business.registrations.last

        error_redirect(@business, 'No Registration Details where found for this business!') and return unless @registration
        error_redirect(@business, 'Member is a Regular Producer!') and return unless @business.registrations.last.small_producer?
        @small_producer = @business.registrations.last.small_producer_detail
      end

      # PATCH/PUT business/:id/small_producer/1
      def update
        @business = Business.where(id: params[:business_id]).first
        @registration = @business.registrations.last

        regular_producer = SmallProducerDetail.new(small_producer_params)
        regular_producer.save!

        redirect_to @business, notice: "Small Producer Details for #{@business.name} were successfully saved!"
      end

      def small_producer_params
        params.require(:small_producer_detail).permit(:allocation_method_predominant_material, :allocation_method_obligation)
      end
    end
  end
end
