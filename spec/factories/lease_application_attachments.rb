# == Schema Information
#
# Table name: lease_application_attachments
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  visible_to_dealers      :boolean          default(TRUE), not null
#  description             :string
#  lessee_id               :integer
#  merge_report_identifier :string
#  upload                  :string
#  uploader_type           :string
#  uploader_id             :bigint(8)
#
# Indexes
#
#  index_lease_application_attachments_on_lease_application_id  (lease_application_id)
#  index_lease_application_attachments_on_lessee_id             (lessee_id)
#  lease_app_uploader_idx                                       (uploader_id,uploader_type)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :lease_application_attachment do
    lease_application
    upload { fixture_file_upload('spec/data/attachment.jpg', Mime[:jpg]) }
    notes { FFaker::BaconIpsum.paragraph }

    trait :with_merge_report_identifier do
      merge_report_identifier { '112242075330000' }
    end
  end
end
