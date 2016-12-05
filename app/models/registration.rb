class Registration < ActiveRecord::Base
  belongs_to :agency_template_upload
  belongs_to :sic_code
  belongs_to :packaging_sector_main_activity

  has_one :small_producer_detail
  has_one :regular_producer_detail
end
