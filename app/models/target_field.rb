class TargetField < ActiveRecord::Base
  has_many :targets

  validates_presence_of :name, :year_introduced
end
