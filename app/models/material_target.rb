class MaterialTarget < ActiveRecord::Base
  belongs_to :packaging_material
  belongs_to :annual_target_set

  validates_presence_of :packaging_material_id, :annual_target_set_id, :year, :value
end
