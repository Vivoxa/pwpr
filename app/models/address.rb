class Address < ActiveRecord::Base
  has_many :businesses
  has_many :addresses
end
