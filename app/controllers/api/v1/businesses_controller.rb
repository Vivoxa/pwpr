class Api::V1::BusinessesController < Api::V1::BaseController
  def show
    business = Business.where(id: params[:id].to_i)
    if business
      render json: business.first, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end
end