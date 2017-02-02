class RegularProducersController < ApplicationController
  def new
    @business = Business.where(id: params[:business_id]).first
    @regular_producer = RegularProducerDetail.new

    # error_redirect(@business, 'No Registrations where found for this business.') and return if @business.registrations.empty?
    #
    # @producer = @business.registrations.last.regular_producer_details.last
  end

  private

  def error_redirect(path, error_msg)
    flash[:error] = error_msg
    redirect_to path
  end
end
