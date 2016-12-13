module SpreadsheetWorker
  module SheetProcessor
    class TargetsHandler < BaseHandler
      def initialize
        @target = Target.new
      end

      def process
        @sheet_filename = './public/template_sheet.xls'
        @agency_template = get_agency_template

        targets.each do |row_array|
          @business = get_business(row_array)

          materials.each do |material|
            process_material_details(row_array, material)
            process_material_totals(row_array, material) unless material == 'other'
          end

          process_material_totals(row_array)
          process_target_totals(row_array)
        end
      end

      private

      def process_material_details(row, material)
        material = MaterialDetail.new
        material.regular_producer_detail = @business.registration.regular_producer_detail
        material.packaging_material = PackagingMaterial.where(name: material).first

        material.t1man = column_value(row, map['t1man'][material]['field']).to_f
        material.t1conv = column_value(row, map['t1conv'][material]['field']).to_f
        material.t1pf = column_value(row, map['t1pf'][material]['field']).to_f
        material.t1sell = column_value(row, map['t1sell'][material]['field']).to_f
        material.t2aman = column_value(row, map['t2aman'][material]['field']).to_f
        material.t2conv = column_value(row, map['t2conv'][material]['field']).to_f
        material.t2apf = column_value(row, map['t2apf'][material]['field']).to_f
        material.t2sell = column_value(row, map['t2sell'][material]['field']).to_f
        material.t2bman = column_value(row, map['t2bman'][material]['field']).to_f
        material.t2bconv = column_value(row, map['t2bconv'][material]['field']).to_f
        material.t2bp = column_value(row, map['t2bp'][material]['field']).to_f
        material.t2bsell = column_value(row, map['t2bsell'][material]['field']).to_f
        material.t3aconv = column_value(row, map['t3aconv'][material]['field']).to_f
        material.t3apf = column_value(row, map['t3apf'][material]['field']).to_f
        material.t3asell = column_value(row, map['t3asell'][material]['field']).to_f
        material.t3b = column_value(row, map['t3b'][material]['field']).to_f
        material.t3c = column_value(row, map['t3c'][material]['field']).to_f
        material.save!
      end

      def process_material_totals(row, material)
        material_total = MaterialTotal.new
        material_total.regular_producer_detail = @business.registration.regular_producer_detail
        material_total.packaging_material = PackagingMaterial.where(name: material).first
        material_total.recycling_obligation = column_value(row, map['obligation'][material]['field']).to_f
        material_total.save!
      end

      def process_target_totals(row)
        target_total = TargetTotal.new
        target_total.regular_producer_detail = @business.registration.regular_producer_detail
        target_total.total_recycling_obligation = column_value(row, map['total_obligation']['recycling']['field']).to_f
        target_total.total_recovery_obligation = column_value(row, map['total_obligation']['recovery']['field']).to_f
        target_total.total_material_specific_recycling_obligation = column_value(row, map['total_obligation']['material_specific']['field']).to_f
        target_total.adjusted_total_recovery_obligation = column_value(row, map['total_obligation']['adjusted_recovery']['field']).to_f
        target_total.ninetytwo_percent_min_recycling_target = column_value(row, map['total_obligation']['nintytwo_min']['field']).to_f
        target_total.save!
      end

      def targets
        spreadsheet.sheet(5)
      end

      def materials
        %w(paper glass aluminium steel plastic wood other)
      end
    end
  end
end
