class RegularProducersController < ApplicationController
  def new
    @business = Business.where(id: params[:business_id]).first
    @regular_producer = RegularProducerDetail.new

    error_redirect(@business, 'No Registration Details where found for this business!') and return if @business.registrations.empty?
    error_redirect(@business, 'Member is a Small Producer!') and return if @business.registrations.last.allocation_method_used
  end

  # POST business/:id/regular_producer_details
  def create
    @business = Business.where(id: params[:business_id]).first

    regular_producer = RegularProducerDetail.new(regular_producer_params)
    regular_producer.registration = @business.registrations.last
    regular_producer.save!

    redirect_to new_business_material_detail_path(business_id: @business.id), notice: "Regular Producer Details for #{@business.name} were successfully saved!"
  end

  # GET business/:id/regular_producer_detail/1/edit
  def edit
    @business = Business.where(id: params[:business_id]).first
    error_redirect(@business, 'No Registration Details where found for this business!') and return if @business.registrations.empty?
    error_redirect(@business, 'Member is a Small Producer!') and return if @business.registrations.last.allocation_method_used
    @regular_producer = @business.registrations.last.regular_producer_detail
  end

  # PATCH/PUT business/:id/regular_producer_detail/1
  def update
    @business = Business.where(id: params[:business_id]).first

    regular_producer = RegularProducerDetail.new(regular_producer_params)
    regular_producer.save!

    redirect_to @business, notice: "Regular Producer Details for #{@business.name} were successfully saved!"
  end

  def regular_producer_params
    params.require(:regular_producer_detail).permit(:calculation_method_supplier_data, :calculation_method_sample_weighing,
                                                    :calculation_method_sales_records, :calculation_method_trade_association_method_details,
                                                    :other_method_details, :data_system_used)
  end
end
