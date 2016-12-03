class Address < ActiveRecord::Base
  belongs_to :business
  belongs_to :address_type
end
