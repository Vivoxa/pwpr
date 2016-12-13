module SpreadsheetWorker
  module SheetProcessor
    class LeaversHandler < BaseHandler
      def initialize
        @leaver = Leaver.new
      end

      def process
        @sheet_filename = './public/template_sheet.xls'
        @agency_template = get_agency_template

        leavers.each do |row_array|
          @business = get_business(row_array)

          process_leaver(row_array)
        end
      end

      private

      def process_leaver(row)
        @leaver.allocation_method_used = column_value(row, map['allocation_method_used']['field'])
        @leaver.total_recovery_previous = column_value(row, map['total_recovery']['field']).to_f
        @leaver.date = Date.parse(column_value(row, map['date_left']['field']))
        @leaver.leaving_code = LeavingCode.where(code: column_value(row, map['leaving_reason']['field'])).first
        @leaver.business = @business
        @leaver.agency_tempalte_upload = @agency_template
        @leaver.save!
      end

      def leavers
        spreadsheet.sheet(6)
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
