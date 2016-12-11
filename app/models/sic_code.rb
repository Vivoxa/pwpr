class SicCode < ActiveRecord::Base
  has_many :businesses
  has_many :registrations

  validates_presence_of :year_introduced, :code
end
