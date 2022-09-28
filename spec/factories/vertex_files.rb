# == Schema Information
#
# Table name: vertex_files
#
#  id                :bigint(8)        not null, primary key
#  filename          :string
#  processed_date    :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  last_changed_date :string
#  update_number     :string
#

FactoryBot.define do
  factory :vertex_file do
    filename { "MyString" }
    processed_date { "2019-02-12" }
  end
end
