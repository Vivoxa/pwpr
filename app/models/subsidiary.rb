class Subsidiary < ActiveRecord::Base
  belongs_to :business
  belongs_to :agency_template_upload
  belongs_to :change_detail
  belongs_to :packaging_sector_main_activity

  has_one :small_producer_detail, dependent: :delete

  validates_presence_of :business_id, :agency_template_upload_id, :packaging_sector_main_activity_id
end
