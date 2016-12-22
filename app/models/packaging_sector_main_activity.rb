class PackagingSectorMainActivity < ActiveRecord::Base
  has_many :registrations
  has_many :subsidiary

  validates_presence_of :material
end
