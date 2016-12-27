class Scheme < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :businesses, dependent: :delete_all
  has_many :agency_template_uploads, dependent: :delete_all

  has_and_belongs_to_many :scheme_operators

  validates_presence_of :scheme_country_code_id, :name
end
