class SmallProducerDetail < ActiveRecord::Base
  belongs_to :registration

  validates_presence_of :registration_id, :allocation_method_predominant_material, :allocation_method_obligation
end
