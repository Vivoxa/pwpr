module SpreadsheetWorker
  module SheetProcessor
    module SheetHandlers
      class SubleaversHandler < BaseHandler
        def initialize(agency_template_id)
          super
          @subleaver = Subleaver.new
        end

        def process
          @sheet_filename = './public/template_sheet.xls'

          subleavers.each do |row_array|
            @business = get_business(row_array)

            process_subleaver(row_array)
          end
        end

        private

        def process_subleaver(row)
          @subleaver.allocation_method_used = column_value(row, map['allocation_method_used']['field'])
          @subleaver.total_recovery_previous = column_value(row, map['total_recovery']['field']).to_f
          @subleaver.date = Date.parse(column_value(row, map['date_left']['field']))
          @subleaver.leaving_code = LeavingCode.where(code: column_value(row, map['leaving_reason']['field'])).first
          @subleaver.business = @business
          @subleaver.agency_tempalte_upload = @agency_template
          @subleaver.save!
        end

        def subleavers
          spreadsheet.sheet(7)
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
end
