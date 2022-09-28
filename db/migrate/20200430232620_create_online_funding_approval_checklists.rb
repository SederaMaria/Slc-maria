class CreateOnlineFundingApprovalChecklists < ActiveRecord::Migration[5.1]
  def change
    create_table :online_funding_approval_checklists do |t|
      
      t.boolean :no_markups_or_erasure,               default: false
      t.boolean :lease_agreement_signed,              default: false
      t.boolean :motorcycle_condition_reported,       default: false
      t.boolean :credit_application_signed,           default: false
      t.boolean :four_references_present,             default: false
      t.boolean :valid_dl,                            default: false
      t.boolean :ach_form_completed,                  default: false
      t.boolean :insurance_requirements,              default: false
      t.boolean :valid_email_address,                 default: false
      t.boolean :registration_documents_with_slc,     default: false
      t.boolean :ods_signed_and_dated,                default: false
      t.boolean :proof_of_amounts_due,                default: false
      t.boolean :documentation_to_satisfy,            default: false
      t.boolean :warranty_products_purchased,         default: false
      t.boolean :signed_bos,                          default: false

      t.boolean :package_reviewed,                    default: false
      t.datetime :package_reviewed_on
      t.integer :reviewed_by

      t.references :lease_application, foreign_key: true,index: {name: 'index_lease_applications_on_funding_approval_checklist_id'}
      t.timestamps
    end
  end
end
