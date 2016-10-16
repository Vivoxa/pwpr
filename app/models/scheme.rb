class Scheme < ActiveRecord::Base
  has_and_belongs_to_many :scheme_operators
  has_many :businesses, dependent: :destroy
  # scope :company_operators, -> { joins(:scheme_operators).where() }
end
