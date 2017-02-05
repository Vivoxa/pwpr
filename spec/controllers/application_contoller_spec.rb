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
  let(:sc_operator) { FactoryGirl.create(:scheme_operator_with_director) }
  before do
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
