module Businesses
  module Registrations
    class MaterialDetailsController < Businesses::RegistrationsController
      def new
        @registration = Registration.where(id: params[:registration_id]).first

        error_redirect(business_registrations_path(business_id: @registration.business.id), 'Member is a Small Producer!') and return if @registration.small_producer?
        error_redirect(business_registrations_path(business_id: @registration.business.id), 'No Regular Producer Details found for this business!') and return unless @registration.regular_producer_detail

        @material_details = []
        PackagingMaterial.all.each do |material|
          next if material.excluded_materials.include? material.name
          @material_details << MaterialDetail.new(packaging_material: material, regular_producer_detail: @registration.regular_producer_detail)
        end
      end

      # POST business/:id/material_details
      def create
        registration = Registration.where(id: params[:registration_id]).first

        material_detail_params.each do |key, value|
          value.each do |k,v|
            value[k] = v.to_f
          end

          detail = MaterialDetail.new(value)
          detail.packaging_material = PackagingMaterial.where(name: key.to_s).first
          detail.regular_producer_detail = registration.regular_producer_detail

          detail.save!
        end

        redirect_to business_registrations_path(business_id: registration.business.id), notice: "Material Details for #{registration.business.name} were successfully saved!"
      end

      # GET business/:id/material_detail/1/edit
      def edit
        @registration = Registration.where(id: params[:registration_id]).first

        error_redirect(business_registrations_path(business_id: @registration.business.id), 'Member is a Small Producer!') and return if @registration.small_producer?
        error_redirect(business_registrations_path(business_id: @registration.business.id), 'No Regular Producer Details found for this business!') and return unless @registration.regular_producer_detail

        @material_details = MaterialDetail.where(regular_producer_detail: @registration.regular_producer_detail).last(7)
      end

      # PATCH/PUT business/:id/material_detail/1
      def update
        registration = Registration.where(id: params[:registration_id]).first
        material_details = MaterialDetail.where(regular_producer_detail: registration.regular_producer_detail).last(7)

        material_detail_params.each do |key, value|
          value.each do |k,v|
            value[k] = v.to_f
          end
          material = PackagingMaterial.where(name: key.to_s)
          detail = MaterialDetail.where(regular_producer_detail: registration.regular_producer_detail, packaging_material: material).last
          detail.update_attributes(value)

          detail.save!
        end

        redirect_to business_registrations_path(business_id: registration.business.id), notice: "Material Details for #{registration.business.name} were successfully udated!"
      end

      def material_detail_params
        params.require(:material_detail).permit(paper: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                glass: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                aluminium: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                steel: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                plastic: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                wood: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c],
                                                other: [:t1man, :t1conv, :t1pf, :t1sell, :t2aman, :t2aconv, :t2apf, :t2asell, :t2bman, :t2bconv, :t2bpf, :t2bsell, :t3aconv, :t3apf, :t3asell, :t3b, :t3c])
      end
    end
  end
end
