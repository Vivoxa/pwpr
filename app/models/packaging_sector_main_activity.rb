class PackagingSectorMainActivity < ActiveRecord::Base
  has_many :registrations

  validates_presence_of :material
end
