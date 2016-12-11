class AddressType < ActiveRecord::Base
  has_many :addresses

  validates_presence_of :title

  extend CommonHelpers::LookupTableHelper

  def self.id_from_setting(setting_value)
    id_for_setting(:title, setting_value)
  end
end
