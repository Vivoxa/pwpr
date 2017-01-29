class ContactsController < ApplicationController
  load_and_authorize_resource :business
  load_and_authorize_resource :contact, through: :business

  before_action :set_contact, only: %i(show edit update destroy)

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.active.where(business_id: params[:business_id]).order(:last_name)
    @business = Business.where(id: params[:business_id]).first
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @business = Business.where(id: params[:business_id]).first
    contact_titles
  end

  # GET /contacts/1/edit
  def edit
    contact_titles
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        deactivate_existing_contacts_of_type(@contact)
        format.html { redirect_to business_contact_path(id: @contact.id), notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: business_contact_path(id: @contact.id) }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to business_contact_path(id: @contact.id), notice: 'Contact was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to business_contacts_path(business_id: params[:business_id]), notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def contact_titles
    @contact_titles ||= AddressType.all - AddressType.where(title: 'Contact')
  end

  def deactivate_existing_contacts_of_type(contact)
    existing_contacts = Contact.active.where(business_id:     contact.business_id,
                                             address_type_id: contact.address_type_id).where('id != ?', contact.id)
    existing_contacts.update_all(active: false) if existing_contacts.any?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.active.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:address_type_id, :title, :first_name, :last_name, :email, :telephone_1, :telephone_2, :fax, :business_id)
  end
end
