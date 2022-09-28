# == Schema Information
#
# Table name: dealerships
#
#  id                      :integer          not null, primary key
#  name                    :string
#  website                 :string
#  primary_contact_phone   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  state                   :string           not null
#  franchised              :boolean
#  franchised_new_makes    :boolean
#  legal_corporate_entity  :string
#  dealer_group            :string
#  active                  :boolean
#  address_id              :integer
#  agreement_signed_on     :date
#  executed_by_name        :string
#  executed_by_title       :string
#  executed_by_slc_on      :date
#  los_access_date         :date
#  notes                   :text
#  use_experian            :boolean          default(TRUE), not null
#  use_equifax             :boolean          default(FALSE), not null
#  use_transunion          :boolean          default(TRUE), not null
#  access_id               :integer
#  bank_name               :string
#  account_number          :bigint(8)
#  routing_number          :string
#  account_type            :integer
#  security_deposit        :integer          default(0), not null
#  enable_security_deposit :boolean          default(FALSE)
#  can_submit              :boolean          default(FALSE)
#  can_see_banner                 :boolean          default(TRUE)
#  employer_identification_number :string(9)
#  secretary_state_valid          :boolean
#  owner_first_name        :string
#  owner_last_name         :string
#  owner_address_id        :integer
#  business_description    :string
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

class Dealership < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true

  # FORM_PATH = "#{Rails.root}/app/assets/data/dealer_agreement/Brian Dealer Agreement 20200225.pdf"
  FORM_PATH = "#{Rails.root}/app/assets/data/dealer_agreement/Trilok_Dealer_Agreement.pdf"

  has_many :dealers

  has_and_belongs_to_many :dealer_representatives
  has_many :dealership_attachments
  has_many :lease_applications
  has_many :lease_calculators,
    through: :lease_applications

  validates :state, presence: true
  
  belongs_to :address
  accepts_nested_attributes_for :address,
    reject_if: :all_blank

  # To ransack new city and new state
  has_one :city, through: :address, source: :new_city

  belongs_to :remit_to_dealer_calculation
  has_many :dealership_approvals

  belongs_to :owner_address, class_name: 'Address', foreign_key: 'owner_address_id'
  accepts_nested_attributes_for :owner_address,
    reject_if: :all_blank  

  enum account_type: {checking: 1, savings: 2}


  scope :by_dealer_representative, ->(id) { where(id: [ DealerRepresentative.joins("JOIN dealer_representatives_dealerships AS drd ON dealer_representatives.id = drd.dealer_representative_id JOIN dealerships AS ds ON drd.dealership_id = ds.id JOIN dealers AS d ON ds.id = d.dealership_id  WHERE dealer_representatives.id IN(#{id})").select('ds.id').pluck('ds.id').uniq ]) }
  
  accepts_nested_attributes_for :dealer_representatives 

  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end


  def active_dealers
    dealers.active
  end


  def get_commission_audits
    Audit.where("audited_changes like ? AND audited_id = ?", "%Clawback%", id)
  end
  
  def self.ransackable_scopes(_auth_object = nil)
    %i[by_dealer_representative]
  end


  def dealership_approval(type)
    approval_type = get_approval_type(type)
    get_dealerhsip_approval(approval_type)
  end


  def prefilled_dealer_agreement
    return prefilled_doc_path
  end

  private 

  def save_dealer_agreement
    dea
  end


  def pdftk
    @pdftk ||= PdfForms.new(pdftk_path)
  end

  def pdftk_path
    PdftkConfig.executable_path
  end

  def prefilled_doc_path
      FileUtils::mkdir_p(File.join(Rails.root, 'tmp', 'dealer_agreement'))
      dest_doc_path   = File.join(Rails.root, 'tmp', 'dealer_agreement', "dealer-agreement-#{DateTime.now.to_i}.pdf")
      pdftk.fill_form FORM_PATH, dest_doc_path, fields, flatten: true
      return dest_doc_path
  end
  
  def fields
  {
      "Dealer Name"           => name,
      "DBA"                   => legal_corporate_entity,
      "Address"               => address.street1,
      "Address 2"             => address.street2,
      "City"                  => address.city,
      "State"                 => address.state,
      "Zip"                   => address.zipcode
  }
  end   


  def get_approval_type(description)
    DealershipApprovalType.find_by(description: description)
  end

  def get_dealerhsip_approval(approval_type)
    dealership_approvals.where(dealership_approval_type_id: approval_type.id).first unless dealership_approvals.empty?
  end
end