class Leaver < ActiveRecord::Base
  belongs_to :business
  belongs_to :leaving_code
  belongs_to :agency_template_upload

  validates_presence_of :business_id, :leaving_code_id, :agency_template_upload_id, :leaving_date
end
