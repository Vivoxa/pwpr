class SubmissionType < ActiveRecord::Base
  has_many :registrations
end
