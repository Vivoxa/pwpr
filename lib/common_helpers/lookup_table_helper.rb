module CommonHelpers
  module LookupTableHelper
    def id_for_setting(field_name, value)
      setting = where(field_name.to_sym => value)
      setting.first if setting.any?
    end
  end
end
