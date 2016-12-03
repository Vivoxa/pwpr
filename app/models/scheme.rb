class Scheme < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :businesses, dependent: :destroy
  has_many :agency_template_uploads, dependent: :destroy

  has_and_belongs_to_many :scheme_operators
end
