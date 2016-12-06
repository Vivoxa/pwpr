class AddressType < ActiveRecord::Base
  has_many :addresses

  validates_presence_of :title
end
