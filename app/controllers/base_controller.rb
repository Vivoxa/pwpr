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

  def approve
    object = SchemeOperator.find(params['scheme_operator_id'].to_i) if params['scheme_operator_id']
    object = SchemeOperator.find(params['company_operator_id'].to_i) if params['company_operator_id']
    object.approved = true

    respond_to do |format|
      if object.save
        format.html { redirect_to object, notice: "#{object.class} was successfully approved." }
        format.json { render :show, status: :ok, location: object }
      else
        format.html { render :new }
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
    redirect_to url, notice: "#{operator.first_name} with email: #{operator.email} has been deleted."
  end

  def pending_operators(unapproved_operators)
    pending_operators = []
    unapproved_operators.each do |op|
      pending_operators << op if op.confirmed_at.present?
    end
    pending_operators
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
