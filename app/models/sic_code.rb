class SicCode < ActiveRecord::Base
  has_many :businesses
  has_many :registrations

  validates_presence_of :year_introduced, :code

  extend CommonHelpers::LookupTableHelper

  def self.id_from_setting(setting_value)
    id_for_setting(:code, setting_value)
  end
end
