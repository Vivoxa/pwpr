module SpreadsheetWorker
  module SheetProcessor
    class JoinersHandler < BaseHandler
      def initialize
        @joiner = Joiner.new
      end

      def process
        @sheet_filename = './public/template_sheet.xls'
        @agency_template = get_agency_template

        joiners.each do |row_array|
          @business = get_business(row_array)

          process_joiner(row_array)
        end
      end

      private

      def process_joiner(row)
        @joiner.allocation_method_used = column_value(row, map['allocation_method_used']['field'])
        @joiner.total_recovery = column_value(row, map['total_recovery']['field']).to_f
        @joiner.previously_registered_at = column_value(row, map['previously_registered_at']['field'])
        @joiner.joined_date = Date.parse(column_value(row, map['date_joined']['field']))
        # @joiner.date_scheme_registered = Date.parse(column_value(row, map['date_scheme_registered']['field']))
        @joiner.business = @business
        @joiner.agency_tempalte_upload = @agency_template
        @joiner.save!
      end

      def joiners
        spreadsheet.sheet(8)
      end

      def create_business(row, npwd)
        business = Business.new
        business.trading_name = column_value(row, map['company_name']['field'])
        business.company_number = column_value(row, map['company_house_no']['field'])
        business.NPWD = npwd
        business.scheme = @agency_template.scheme
        business.scheme_ref = column_value(row, map['scheme_ref']['field'])
        # business.business_type = BusinessType.where(name: column_value(row, map['company_type']['field'])).first
        # business.business_subtype = BusinessSubtype.where(name: column_value(row, map['company_subtype']['field'])).first
        business.year_first_reg = Date.today.year
        business.year_last_reg = Date.today.year
        business.save!
        business
      end
    end
  end
end
