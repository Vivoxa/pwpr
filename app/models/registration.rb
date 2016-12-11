class Registration < ActiveRecord::Base
  belongs_to :sic_code
  belongs_to :submission_type
  belongs_to :agency_template_upload
  belongs_to :packaging_sector_main_activity
  belongs_to :resubmission_reason

  has_one :small_producer_detail
  has_one :regular_producer_detail

  validates_presence_of :agency_template_upload_id, :sic_code_id, :packaging_sector_main_activity, :turnover
end
