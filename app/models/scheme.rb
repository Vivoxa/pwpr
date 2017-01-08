class Scheme < ActiveRecord::Base
  belongs_to :scheme_country_code

  has_many :businesses
  has_many :agency_template_uploads, dependent: :destroy

  has_and_belongs_to_many :scheme_operators

  validates_presence_of :scheme_country_code_id, :name

  def email_friendly_name
    "#{name.downcase.tr(' ', '_')}@#{LookupValues::Email::EmailSettings.for('domain_name')}"
  end
end
