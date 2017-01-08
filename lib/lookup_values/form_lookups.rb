module LookupValues
  class FormLookups
    def self.for(key)
      values = YAML.load_file(File.join(__dir__, './form_lookups.yml'))
      values[key]
    end
  end
end
