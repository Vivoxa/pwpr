class EmailContentTypesController < ApplicationController
  before_action :set_email_content_type, only: %i(show edit update destroy)

  # GET /email_content_types
  # GET /email_content_types.json
  def index
    @email_content_types = EmailContentType.all
  end

  # GET /email_content_types/1
  # GET /email_content_types/1.json
  def show
  end

  # GET /email_content_types/new
  def new
    @email_content_type = EmailContentType.new
  end

  # GET /email_content_types/1/edit
  def edit
  end

  # POST /email_content_types
  # POST /email_content_types.json
  def create
    @email_content_type = EmailContentType.new(email_content_type_params)

    respond_to do |format|
      if @email_content_type.save
        format.html { redirect_to @email_content_type, notice: 'Email content type was successfully created.' }
        format.json { render :show, status: :created, location: @email_content_type }
      else
        format.html { render :new }
        format.json { render json: @email_content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_content_types/1
  # PATCH/PUT /email_content_types/1.json
  def update
    respond_to do |format|
      if @email_content_type.update(email_content_type_params)
        format.html { redirect_to @email_content_type, notice: 'Email content type was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_content_type }
      else
        format.html { render :edit }
        format.json { render json: @email_content_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_content_types/1
  # DELETE /email_content_types/1.json
  def destroy
    @email_content_type.destroy
    respond_to do |format|
      format.html { redirect_to email_content_types_url, notice: 'Email content type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email_content_type
    @email_content_type = EmailContentType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_content_type_params
    params.require(:email_content_type).permit(:name)
  end
end
