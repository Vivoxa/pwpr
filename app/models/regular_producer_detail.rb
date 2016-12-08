class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals
  has_many :material_details
  has_many :target_totals

  validates_presence_of :registration_id
end
