class MaterialTarget < ActiveRecord::Base
  belongs_to :packaging_material
  belongs_to :annual_target_set
end
