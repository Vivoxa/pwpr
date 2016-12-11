class TargetTotal < ActiveRecord::Base
  belongs_to :regular_producer_detail

  validates_presence_of :regular_producer_detail_id, :total_recycling_obligation,
                        :total_recovery_obligation, :total_material_specific_recycling_obligation,
                        :adjusted_total_recovery_obligation, :ninetytwo_percent_min_recycling_target
end
