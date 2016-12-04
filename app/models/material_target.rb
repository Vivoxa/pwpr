class MaterialTarget < ActiveRecord::Base
  belongs_to :packaging_material
  belongs_to :material_targets
end
