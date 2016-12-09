class ResubmissionReason < ActiveRecord::Base
  has_many :registrations
end
