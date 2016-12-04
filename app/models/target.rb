class Target < ActiveRecord::Base
  belongs_to :annual_target_set
  belongs_to :target_field
end
