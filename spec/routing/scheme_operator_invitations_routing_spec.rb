require "rails_helper"

RSpec.describe SchemeOperatorInvitationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/scheme_operator_invitations").to route_to("scheme_operator_invitations#index")
    end

    it "routes to #new" do
      expect(:get => "/scheme_operator_invitations/new").to route_to("scheme_operator_invitations#new")
    end

    it "routes to #show" do
      expect(:get => "/scheme_operator_invitations/1").to route_to("scheme_operator_invitations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/scheme_operator_invitations/1/edit").to route_to("scheme_operator_invitations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/scheme_operator_invitations").to route_to("scheme_operator_invitations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/scheme_operator_invitations/1").to route_to("scheme_operator_invitations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/scheme_operator_invitations/1").to route_to("scheme_operator_invitations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/scheme_operator_invitations/1").to route_to("scheme_operator_invitations#destroy", :id => "1")
    end

  end
end
