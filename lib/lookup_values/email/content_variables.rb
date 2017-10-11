module LookupValues
  module Email
    class ContentVariables
      def self.for(email_name)
        email_settings = YAML.load_file(File.join(__dir__, './content_variables.yml'))
        email_settings[email_name]
      end
    end
  end
end
