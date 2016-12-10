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

  validates_presence_of :NPWD, :scheme_id, :trading_name, :company_number # , :business_type_id, :business_subtype_id,
  #:scheme_status_code_id, :registration_status_code_id, :sic_code_id, :submission_type_id,
  #:business_type_id, :business_subtype_id, :country_of_business_registration
end
