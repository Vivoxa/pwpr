class Leaver < ActiveRecord::Base
  belongs_to :business
  belongs_to :leaving_code
  belongs_to :agency_template_upload
end
