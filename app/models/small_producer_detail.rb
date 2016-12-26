class SmallProducerDetail < ActiveRecord::Base
  belongs_to :registration
  belongs_to :subsidiary

  validates_presence_of :allocation_method_predominant_material, :allocation_method_obligation, :registration_id
end
