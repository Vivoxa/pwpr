module Api
  module V1
    class BusinessesController < Api::V1::BaseController
      def show
        business = Business.where(id: params[:id].to_i)
        if business.any?
          render json: business.first, status: :ok
        else
          render nothing: true, status: :not_found
        end
      end
    end
  end
end
