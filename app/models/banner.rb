# == Schema Information
#
# Table name: banners
#
#  id         :bigint(8)        not null, primary key
#  headline   :string
#  message    :string
#  active     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Banner < ApplicationRecord
  
  validates :headline, :presence =>  true
  validates :message, :presence => true

end
