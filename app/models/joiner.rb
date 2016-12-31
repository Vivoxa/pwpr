class Joiner < ActiveRecord::Base
  belongs_to :business
  belongs_to :agency_template_upload

  validates_presence_of :business_id, :agency_template_upload_id, :joining_date, :total_recovery, :date_scheme_registered
end
