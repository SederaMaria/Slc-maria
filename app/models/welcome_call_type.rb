# == Schema Information
#
# Table name: welcome_call_types
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

class WelcomeCallType < ApplicationRecord
  class << self
    def update_sort_index(welcome_call_type_params, sort_index)
      welcome_call_type = WelcomeCallType.find_by(id: welcome_call_type_params['id'])
      welcome_call_type.update(sort_index: sort_index) if welcome_call_type.present?
    end
  end
end
