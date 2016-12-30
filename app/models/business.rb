class Business < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :business_type
  belongs_to :business_subtype
  belongs_to :scheme_status_code
  belongs_to :registration_status_code
  belongs_to :sic_code
  belongs_to :business_subtype
  belongs_to :business_type
  belongs_to :country_of_business_registration

  has_many :company_operators, dependent: :destroy
  has_many :addresses
  has_many :contacts
  has_many :registrations
  has_many :subsidiaries
  has_many :joiners
  has_many :leavers
  has_many :licensors

  belongs_to :holding_business, class_name: 'Business'
  has_many :businesses, class_name: 'Business', foreign_key: :holding_business_id

  validates_presence_of :NPWD, :scheme_id, :name, :company_number # , :business_type_id, :business_subtype_id,
  #:scheme_status_code_id, :registration_status_code_id, :sic_code_id, :submission_type_id,
  #:business_type_id, :business_subtype_id, :country_of_business_registration
  validate :year_first_reg_format, if: 'year_first_reg.present?'

  def correspondence_contact
    contact = contacts.where(title: 'Correspondence')
    return contact.first if contact.any?
  end

  def year_first_reg_format
    errors.add('Year must be in the format YYYY') unless is_i?(year_first_reg)
  end

  def is_i?(value)
    !!(value =~ /\A[-+]?[0-9]+\z/)
  end
end
