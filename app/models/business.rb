class Business < ActiveRecord::Base
  belongs_to :scheme
  has_many :company_operators, dependent: :destroy

  validates_presence_of :NPWD, :SIC
end
