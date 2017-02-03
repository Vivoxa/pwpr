class SmallProducersController < ApplicationController
  def new
    @business = Business.where(id: params[:business_id]).first
    @small_producer = SmallProducerDetail.new

    error_redirect(@business, 'No Registration Details where found for this business!') and return if @business.registrations.empty?
    error_redirect(@business, 'Member is a Regular Producer!') and return if @business.registrations.last.small_producer_details.empty?
    #
    # @producer = @business.registrations.last.regular_producer_details.last
  end

  # POST business/:id/registrations
  def create
  end

  # GET business/:id/registrations/1/edit
  def edit
    @business = Business.where(id: params[:business_id]).first
    error_redirect(@business, 'No Registration Details where found for this business!') and return if @business.registrations.empty?
  end

  # PATCH/PUT business/:id/registrations/1
  def update
  end
end
