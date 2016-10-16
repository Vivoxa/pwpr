class Business < ActiveRecord::Base
  belongs_to :scheme
  has_many :company_operators, dependent: :destroy
end
