class Target < ActiveRecord::Base
  belongs_to :annual_target_set
  belongs_to :target_field

  validates_presence_of :annual_target_set_id, :target_field_id, :year, :value
end
