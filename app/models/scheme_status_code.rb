class SchemeStatusCode < ActiveRecord::Base
  has_many :businesses

  validates_presence_of :status, :description
end
