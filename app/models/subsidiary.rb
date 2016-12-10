class Subsidiary < ActiveRecord::Base
  belongs_to :business
  belongs_to :agency_template_upload
  belongs_to :change_detail

  validates_presence_of :business_id, :agency_template_upload_id
end
