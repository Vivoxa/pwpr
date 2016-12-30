module LookupValues
  module Reports
    class ValidReports

      def self.for(entity)
        valid_reports = YAML.load_file(File.join(__dir__, './valid_reports.yml'))
        valid_reports[entity.downcase]
      end
    end
  end
end