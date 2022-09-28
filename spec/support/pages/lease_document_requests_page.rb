module Pages
  module LeaseDocumentRequests
    class NewPage < SitePrism::Page
      
      attr_reader :values

      def initialize(values)
        @values = values
      end
      
      set_url '/dealers/lease_applications/{id}/request_lease_documents'

      element :body, 'body'
      element :asset_make, 'select#lease_document_request_asset_make'
      element :asset_model, 'input#lease_document_request_asset_model'
      element :asset_year, 'select#lease_document_request_asset_year'
      element :asset_vin, 'input#lease_document_request_asset_vin'
      element :asset_color, 'input#lease_document_request_asset_color'
      element :exact_odometer_mileage, 'input#lease_document_request_exact_odometer_mileage'
      element :trade_in_make, 'input#lease_document_request_trade_in_make'
      element :trade_in_model, 'input#lease_document_request_trade_in_model'
      element :trade_in_year, 'input#lease_document_request_trade_in_year'
      element :delivery_date, 'input#lease_document_request_delivery_date'
      element :gap_contract_term, 'input#lease_document_request_gap_contract_term'
      element :service_contract_term, 'input#lease_document_request_service_contract_term'
      element :ppm_contract_term, 'input#lease_document_request_ppm_contract_term'
      element :tire_contract_term, 'input#lease_document_request_tire_contract_term'
      element :equipped_with, 'input#lease_document_request_equipped_with'
      element :notes, 'input#lease_document_request_notes'

      
    end
  end
end