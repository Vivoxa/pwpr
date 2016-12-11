class MaterialTotal < ActiveRecord::Base
  belongs_to :regular_producer_detail
  belongs_to :packaging_material

  validates_presence_of :regular_producer_detail_id, :packaging_material_id, :recycling_obligation
end
