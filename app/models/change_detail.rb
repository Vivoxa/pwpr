class ChangeDetail < ActiveRecord::Base
  has_many :subsidiaries
  has_many :registrations
end
