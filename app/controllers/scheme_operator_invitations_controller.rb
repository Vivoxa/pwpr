class SchemeOperatorInvitationsController < ApplicationController
  before_filter :authenticate_scheme_operator

  # GET /scheme_operator_invitations
  # GET /scheme_operator_invitations.json
  def index
    query = 'invitation_sent_at IS NOT NULL AND invitation_accepted_at IS NULL'
    @scheme_operator_invitations = []
    current_user.schemes.each do |scheme|
      scheme.scheme_operators.where(query).each do |scheme_operator|
        @scheme_operator_invitations << scheme_operator
      end
    end
  end
end
