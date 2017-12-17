class Api::V1::AddressesController < Api::V1::BaseController
  def show
    address = Address.where(id: params[:id].to_i)
    if address
      render json: address.first, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end
end