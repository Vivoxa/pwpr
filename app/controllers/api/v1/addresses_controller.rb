module Api
  module V1
    class AddressesController < Api::V1::BaseController
      def show
        address = Address.where(id: params[:id].to_i)
        if address.any?
          render json: address.first, status: :ok
        else
          render nothing: true, status: :not_found
        end
      end
    end
  end
end
