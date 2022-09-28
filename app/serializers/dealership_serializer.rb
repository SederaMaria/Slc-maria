# == Schema Information
#
# Table name: dealerships
#
#  id                              :integer          not null, primary key
#  name                           :string
#  website                        :string
#  primary_contact_phone          :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  state                          :string           not null
#  franchised                     :boolean
#  franchised_new_makes           :boolean
#  legal_corporate_entity         :string
#  dealer_group                   :string
#  active                         :boolean
#  address_id                     :integer
#  agreement_signed_on            :date
#  executed_by_name               :string
#  executed_by_title              :string
#  executed_by_slc_on             :date
#  los_access_date                :date
#  notes                          :text
#  use_experian                   :boolean          default(TRUE), not null
#  use_equifax                    :boolean          default(FALSE), not null
#  use_transunion                 :boolean          default(TRUE), not null
#  access_id                      :integer
#  bank_name                      :string
#  account_number                 :bigint(8)
#  routing_number                 :string
#  account_type                   :integer
#  security_deposit               :integer          default(0), not null
#  enable_security_deposit        :boolean          default(FALSE)
#  can_submit                     :boolean          default(FALSE)
#  can_see_banner                 :boolean          default(TRUE)
#  employer_identification_number :string(9)
#  secretary_state_valid          :boolean
#  owner_first_name               :string
#  owner_last_name                :string
#  owner_address_id               :integer
#  business_description           :string
#  dealer_license_number          :string
#  license_expiration_date        :date
#  pct_ownership                  :decimal
#
# Indexes
#
#  index_dealerships_on_address_id  (address_id)
#  index_dealerships_ownership_address_id_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (owner_address_id => addresses.id)
#

class DealershipSerializer < ApplicationSerializer
    attributes :id, :name, :website, :primary_contact_phone, :state, :franchised, :franchised_new_makes, :legal_corporate_entity,
               :dealer_group, :dealer_group, :active, :agreement_signed_on, :executed_by_name, :executed_by_title, :executed_by_slc_on,
               :los_access_date, :notes, :use_experian, :use_equifax, :use_transunion, :access_id, :bank_name, :account_number, :routing_number,
               :account_type, :security_deposit, :enable_security_deposit, :can_submit, :can_see_banner, :deal_fee, :year_incorporated_or_control_year,
               :years_in_business, :previously_approved_dealership, :previous_transactions_submitted, :previous_transactions_closed, :previous_default_rate,
               :city, :cityName, :stateAbbrev, :representatives, :sales_approval, :underwriting_approval, :credit_committee_approval, 
               :remit_to_dealer_calculation_id, :for_table_active, :for_table_can_submit, :for_table_can_see_banner, :employer_identification_number, 
               :secretary_state_valid, :secretary_of_state_website, :owner_first_name, :owner_last_name, :owner_address, :business_description,
               :notification_email, :dealer_license_number, :license_expiration_date, :pct_ownership

    belongs_to :address
    has_many :dealer_representatives
    has_many :dealership_attachments, serializer: DealershipAttachmentSerializer

    def deal_fee
        object&.deal_fee.to_s
    end

    def city # Deprecated
        object&.address&.city
    end

    def cityName
      object&.address&.new_city_value
    end

    def stateAbbrev
      object&.address&.new_city&.us_state&.abbreviation
    end

    def representatives
        object&.dealer_representatives&.map(&:full_name).join(', ')
    end

  def sales_approval
    approval_type = approval_type_model.sales
    approval = get_dealerhsip_approval(approval_type)
    approval_events(approval, :sales)
  end

  def underwriting_approval
    approval_type = approval_type_model.underwriting
    approval = get_dealerhsip_approval(approval_type)
    approval_events(approval, :underwriting)
  end

  def credit_committee_approval
    approval_type = approval_type_model.dealership_credit_committee
    approval = get_dealerhsip_approval(approval_type)
    approval_events(approval, :credit_committee)
  end

  def secretary_of_state_website
    get_secretary_of_state_website(object&.address)
  end

  def owner_address
    get_owner_address
  end

  def for_table_active
    yes_no(object&.active)
  end


  def for_table_can_submit
    yes_no(object&.can_submit)
  end


  def for_table_can_see_banner
    yes_no(object&.can_see_banner)
  end

  private 

    def approval_type_model
        ::DealershipApprovalType
    end

    def get_dealerhsip_approval(approval_type)
        object&.dealership_approvals.where(dealership_approval_type_id: approval_type.id).first unless object&.dealership_approvals.empty?
    end

    def approval_events(approval, approval_type)
        approved = approval&.dealership_approval_events&.last&.approved
        if approval_type == :credit_committee
          last_two_approved = approval&.events_by_admin_users&.last(2)
          has_two_approved = last_two_approved&.count.to_i >= 2
          is_all_approved = last_two_approved&.pluck(:approved)&.all?
          is_truly_approved = last_two_approved&.pluck(:approved)&.compact&.first
          approved = (has_two_approved && is_all_approved && is_truly_approved)
        end
        {
            approved: approved,
            events: ActiveModelSerializers::SerializableResource.new(approval&.dealership_approval_events&.order(id: :desc))
        }
    end

    def yes_no(yesno)
      yesno ? "Yes" : "No"
    end

    def get_secretary_of_state_website(address)
      return nil if address.nil?
      address&.new_city&.county&.us_state&.secretary_of_state_website
    end

    def get_owner_address
      if object&.owner_address_id        
        #object&.owner_address
        {
          id: object&.owner_address&.id,
          cityId: object&.owner_address&.city_id,
          street1: object&.owner_address&.street1,
          street2: object&.owner_address&.street2,
          zipCode: object&.owner_address&.zipcode,
          county: object&.owner_address&.county,
          state: object&.owner_address&.state
        }        
      end
    end 

end
