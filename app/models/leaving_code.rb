class LeavingCode < ActiveRecord::Base
  has_many :leavers

  validates_presence_of :code, :reason

  extend CommonHelpers::LookupTableHelper

  def self.id_from_setting(setting_value)
    id_for_setting(:code, setting_value)
  end
end
