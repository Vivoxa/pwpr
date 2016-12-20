class Licensor < ActiveRecord::Base
  belongs_to :business
  belongs_to :agency_template_upload

  validates_presence_of :business_id, :agency_template_upload_id
end
