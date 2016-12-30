module LookupValues
  module Email
    class EmailSettings

      def self.for(email_name)
        email_settings = YAML.load_file(File.join(__dir__, './email_settings.yml'))
        email_settings[email_name]
      end
    end
  end
end