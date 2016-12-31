class Leaver < ActiveRecord::Base
  belongs_to :business
  belongs_to :leaving_code
  belongs_to :agency_template_upload
  belongs_to :leaving_business

  validates_presence_of :leaving_code_id, :agency_template_upload_id, :leaving_date

  before_destroy :delete_parents

  def delete_parents
    self.leaving_business.delete if self.leaving_business
  end
end
