class SchemeOperatorsController < ApplicationController
  before_filter :authenticate_scheme_operator
  load_and_authorize_resource

  def index
    # TODO: this needs scoping to a scheme
    @scheme_operators = SchemeOperator.all
  end

  def show
    # We need to figure a scope to search for users dynamically based on the category
    # in order to be able to search for the one clicked on in the right table
    @scheme_operator = SchemeOperator.find(params[:id])
  end

  def update
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.update_attributes(secure_params)
  end

  def destroy
    @scheme_operator = SchemeOperator.find(params[:id])
    @scheme_operator.destroy
  end

  private

  def secure_params
    # We need to pull the params and handle company_operator as well maybe?

    params.require(:scheme_operator).permit(:role)
  end
end
