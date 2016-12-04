class MaterialDetail < ActiveRecord::Base
  belongs_to :regular_producer_detail
  belongs_to :packaging_material
end
