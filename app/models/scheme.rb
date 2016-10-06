class Scheme < ActiveRecord::Base
  has_and_belongs_to_many :scheme_operators
  has_many :company_operators
end
