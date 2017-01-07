class LeavingBusiness < ActiveRecord::Base
  has_many :leavers

  validates_presence_of :scheme_ref, :npwd, :company_name, :company_number, :subsidiaries_number
end
