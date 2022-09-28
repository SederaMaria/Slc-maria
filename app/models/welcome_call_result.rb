# == Schema Information
#
# Table name: welcome_call_results
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

class WelcomeCallResult < ApplicationRecord
  class << self
    def update_sort_index(welcome_call_result_params, sort_index)
      welcome_call_result = WelcomeCallResult.find_by(id: welcome_call_result_params['id'])
      welcome_call_result.update(sort_index: sort_index) if welcome_call_result.present?
    end
  end
end
