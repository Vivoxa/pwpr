class Scheme < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :businesses
  has_many :agency_template_uploads, dependent: :destroy

  has_many :scheme_operators_schemes
  has_many :scheme_operators, through: :scheme_operators_schemes

  validates_presence_of :scheme_country_code_id, :name

  def email_friendly_name
    "#{name.downcase.tr(' ', '')}@#{LookupValues::Email::EmailSettings.for('domain_name')}"
  end
end
