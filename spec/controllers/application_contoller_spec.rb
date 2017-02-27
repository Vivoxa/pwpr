require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      if params[:missing_record]
        raise ActiveRecord::RecordNotFound.new('cannot find scheme with id: 33')
      elsif params[:unauthorised]
        raise CanCan::AccessDenied.new
      end
    end
  end
  let(:sc_operator) { SchemeOperator.new }
  before do
    sc_operator.email = 'jennifer@back_to_the_future.com'
    sc_operator.first_name = 'Jennifer'
    sc_operator.last_name = 'Smith'
    sc_operator.password = 'mypassword'
    sc_operator.confirmed_at = DateTime.now
    sc_operator.save
    sc_operator.add_role('sc_director')
    sc_operator.approved = true
    sc_operator.save
    PermissionsForRole::SchemeOperatorDefinitions.new.permissions_for_role(:sc_director).each do |permission, has|
      sc_operator.add_role permission if has[:checked]
    end
    sign_in sc_operator
  end

  after do
    sign_out sc_operator
  end

  context 'when an ActiveRecord::RecordNotFound exception is raised' do
    it 'expects the user is displayed an error' do
      get :index, missing_record: true
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end

    it 'expects the exception to be logged' do
      expect(Rails.logger).to receive(:error).with('ActiveRecord::RecordNotFound - Params: {"missing_record"=>true, "controller"=>"anonymous", "action"=>"index"}. Error: cannot find scheme with id: 33')
      get :index, missing_record: true
    end
  end

  context 'when an CanCan::AccessDenied exception is raised' do
    it 'expects the user is displayed an error' do
      get :index, unauthorised: true
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
    end
  end
end
