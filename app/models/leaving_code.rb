class LeavingCode < ActiveRecord::Base
  has_many :leavers

  validates_presence_of :code, :reason
end
