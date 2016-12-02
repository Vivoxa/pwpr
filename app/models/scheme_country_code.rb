class SchemeCountryCode < ActiveRecord::Base
  has_many :schemes
  has_many :annual_target_sets
end
