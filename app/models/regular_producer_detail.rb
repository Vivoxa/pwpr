class RegularProducerDetail < ActiveRecord::Base
  belongs_to :registration

  has_many :material_totals
  has_many :material_data
  has_many :target_totals
end
