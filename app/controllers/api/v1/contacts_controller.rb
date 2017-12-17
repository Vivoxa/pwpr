class Api::V1::ContactsController < Api::V1::BaseController
  def show
    contact = Contact.where(id: params[:id].to_i)
    if contact
      render json: contact.first, status: :ok
    else
      render nothing: true, status: :not_found
    end
  end
end