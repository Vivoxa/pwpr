class SchemeCountryCode < ActiveRecord::Base
  has_many :schemes
  has_many :annual_target_sets

  validates_presence_of :country
end
