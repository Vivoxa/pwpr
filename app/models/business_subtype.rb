class BusinessSubtype < ActiveRecord::Base
  has_many :businesses

  validates_presence_of :name, :description

  extend CommonHelpers::LookupTableHelper

  def self.id_from_setting(setting_value)
    id_for_setting(:name, setting_value)
  end
end
