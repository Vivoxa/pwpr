class Joiner < ActiveRecord::Base
  belongs_to :business
  belongs_to :agency_template_upload
end
