# == Schema Information
#
# Table name: lease_document_requests
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  asset_make              :string
#  asset_model             :string
#  asset_year              :integer
#  asset_vin               :string
#  asset_color             :string
#  exact_odometer_mileage  :string
#  trade_in_make           :string
#  trade_in_model          :string
#  trade_in_year           :string
#  delivery_date           :date
#  gap_contract_term       :integer          default(0)
#  service_contract_term   :integer          default(0)
#  ppm_contract_term       :integer          default(0)
#  tire_contract_term      :integer          default(0)
#  equipped_with           :string
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  manual_vin_verification :boolean
#
# Indexes
#
#  index_lease_document_requests_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class LeaseDocumentRequestSerializer < ApplicationSerializer
    include Rails.application.routes.url_helpers
    attributes :id, :asset_make, :asset_model, :asset_year, :asset_vin, :asset_color, :vin_verified, :actions, 
      :created_at, :delivery_date

    def vin_verified
        object.vin_validation&.status&.titleize
    end

    def actions
        admins_lease_document_request_path(object)
    end

    def created_at
        object.created_at.strftime('%B %-d %Y at %r %Z')
    end

  end
  
