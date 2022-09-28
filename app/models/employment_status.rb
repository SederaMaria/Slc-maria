# == Schema Information
#
# Table name: employment_statuses
#
#  id                      :bigint(8)        not null, primary key
#  employment_status_index :integer
#  definition              :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class EmploymentStatus < ApplicationRecord
  # belongs_to :lessee, foreign_key: "definition", :primary_key => 'employment_status'
  belongs_to :lessee, foreign_key: "employment_status_index", :primary_key => 'employment_status'
end
