class PackagingMaterial < ActiveRecord::Base
  has_many :material_totals
  has_many :material_details
  has_many :material_targets

  validates_presence_of :name, :year_introduced
end
