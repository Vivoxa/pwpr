class EmailNamesController < ApplicationController
  before_action :set_email_name, only: %i(show edit update destroy)
  load_and_authorize_resource

  # GET /email_names
  # GET /email_names.json
  def index
    @email_names = EmailName.all
  end

  # GET /email_names/1
  # GET /email_names/1.json
  def show
  end

  # GET /email_names/new
  def new
    @email_name = EmailName.new
  end

  # GET /email_names/1/edit
  def edit
  end

  # POST /email_names
  # POST /email_names.json
  def create
    @email_name = EmailName.new(email_name_params)

    respond_to do |format|
      if @email_name.save
        format.html { redirect_to @email_name, notice: 'Email name was successfully created.' }
        format.json { render :show, status: :created, location: @email_name }
      else
        format.html { render :new }
        format.json { render json: @email_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_names/1
  # PATCH/PUT /email_names/1.json
  def update
    respond_to do |format|
      if @email_name.update(email_name_params)
        format.html { redirect_to @email_name, notice: 'Email name was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_name }
      else
        format.html { render :edit }
        format.json { render json: @email_name.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_names/1
  # DELETE /email_names/1.json
  def destroy
    @email_name.destroy
    respond_to do |format|
      format.html { redirect_to email_names_url, notice: 'Email name was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email_name
    @email_name = EmailName.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_name_params
    params.require(:email_name).permit(:name)
  end
end
