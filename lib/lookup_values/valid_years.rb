module LookupValues
  class ValidYears

    def self.for(key)
      years = YAML.load_file(File.join(__dir__, './valid_years.yml'))
      years[key]
    end
  end
end
