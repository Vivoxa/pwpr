class EmailedStatus < ActiveRecord::Base
  extend CommonHelpers::LookupTableHelper

  def self.id_from_setting(setting_value)
    id_for_setting(:status, setting_value)
  end
end
