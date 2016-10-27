class BaseController < ApplicationController
  # PATCH/PUT /object/1
  # PATCH/PUT /objects/1.json
  def update_object(object, url, params)
    respond_to do |format|
      if object.update(params)
        format.html { redirect_to url, notice: "#{object.class} was successfully updated." }
        format.json { render :show, status: :ok, location: object }
      else
        format.html { render :edit, alert: "Unable to update #{object.class}." }
        format.json { render json: object.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_business_or_scheme(object, url)
    object.destroy
    respond_to do |format|
      format.html { redirect_to url, notice: "#{object.class} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def destroy_operator(operator, url)
    object = operator.class.find(params[:id])
    object.destroy
    redirect_to url, notice: "#{operator.name} with email: #{operator.email} has been deleted."
  end

  def create_business_or_scheme(object)
    respond_to do |format|
      if object.save
        format.html { redirect_to object, notice: "#{object.class} was successfully created." }
        format.json { render :show, status: :created, location: object }
      else
        format.html { render :new }
        format.json { render json: object.errors, status: :unprocessable_entity }
      end
    end
  end
end
