class EmailContentsController < ApplicationController
  before_action :set_email_content, only: %i(show edit update destroy)
  load_and_authorize_resource

  # GET /email_contents
  # GET /email_contents.json
  def index
    @email_contents_hash = email_content_to_scheme_hash
  end

  def email_content_to_scheme_hash
    hash = {}
    hash['System default'] =  EmailContent.where(email_content_type_id: EmailContentType.id_from_setting('default')) if current_admin
    current_user.schemes.each do |scheme|
      hash[scheme.name] = EmailContent.where(scheme_id: scheme.id)
    end
    hash
  end

  # GET /email_contents/1
  # GET /email_contents/1.json
  def show
    schemes = Scheme.where(id: @email_content.scheme_id)
    @scheme_name = schemes.any? ? schemes.first.name : nil
  end

  # GET /email_contents/new
  def new
    @email_content = EmailContent.new
  end

  # GET /email_contents/1/edit
  def edit
  end

  # POST /email_contents
  # POST /email_contents.json
  def create
    @email_content = EmailContent.new(email_content_params)

    respond_to do |format|
      if @email_content.save
        format.html { redirect_to @email_content, notice: 'Email content was successfully created.' }
        format.json { render :show, status: :created, location: @email_content }
      else
        format.html { render :new }
        format.json { render json: @email_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_contents/1
  # PATCH/PUT /email_contents/1.json
  def update
    respond_to do |format|
      if @email_content.update(email_content_params)
        format.html { redirect_to @email_content, notice: 'Email content was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_content }
      else
        format.html { render :edit }
        format.json { render json: @email_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_contents/1
  # DELETE /email_contents/1.json
  def destroy
    @email_content.destroy
    respond_to do |format|
      format.html { redirect_to email_contents_url, notice: 'Email content was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email_content
    @email_content = EmailContent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_content_params
    params.require(:email_content).permit(:scheme_id, :email_content_type_id, :email_name_id, :intro, :title, :body, :address, :footer)
  end
end
