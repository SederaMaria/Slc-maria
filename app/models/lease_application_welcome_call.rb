# == Schema Information
#
# Table name: lease_application_welcome_calls
#
#  id                                  :bigint(8)        not null, primary key
#  lease_application_id                :integer
#  welcome_call_result_id              :integer
#  welcome_call_type_id                :integer
#  welcome_call_status_id              :integer
#  welcome_call_representative_type_id :integer
#  admin_id                            :integer
#  due_date                            :datetime
#  notes                               :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

class LeaseApplicationWelcomeCall < ApplicationRecord
  
  belongs_to :lease_application
  belongs_to :welcome_call_type
  belongs_to :welcome_call_result
  belongs_to :welcome_call_status
  belongs_to :welcome_call_representative_type
  
  belongs_to :admin_user, foreign_key: 'admin_id'
  has_many :comments, as: :resource, class_name: 'ActiveAdminComment'


  attr_accessor :lease_application_due_date
  attr_accessor :department
  def representative_full_name
    return self&.admin_user&.first_name.to_s + " " + self&.admin_user&.last_name.to_s
  end
  
end
