class Business < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :business_type
  belongs_to :business_subtype
  belongs_to :scheme_status_code
  belongs_to :registration_status_code

  has_many :company_operators, dependent: :destroy
  has_many :addresses

  validates_presence_of :NPWD, :SIC, :scheme_id#, :business_type_id, :business_subtype_id,
                        #:scheme_status_code_id, :registration_status_code_id
end
