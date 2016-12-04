class SicCode < ActiveRecord::Base
  has_many :businesses
  has_many :registrations
end
