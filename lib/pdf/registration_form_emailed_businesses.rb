require 'prawn'

module Pdf
  class RegistrationFormEmailedBusinesses
    def self.pdf(businesses, year)
      filename = file_path(businesses.first.scheme, year)

      Prawn::Document.generate(filename) do
        text "The following businesses received a Registration Form for year #{year}:"
        businesses.each do |business|
          text business.name
        end
      end
      file_path(businesses.first.scheme, year)
    end

    def self.file_path(scheme, year)
      "public/regForm_#{scheme.id}_#{year}.pdf"
    end

    def self.cleanup(scheme, year)
      FileUtils.rm file_path(scheme, year)
    end
  end
end
