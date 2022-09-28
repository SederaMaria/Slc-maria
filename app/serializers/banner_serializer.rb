# == Schema Information
#
# Table name: banners
#
#  id                   :bigint(8)        not null, primary key
#  headline             :string
#  message              :string
#  active               :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  created_by_admin_id  :bigint
#  updated_by_admin_id  :bigint 
#

class BannerSerializer < ApplicationSerializer
  attributes :id, :headline, :message, :active, :active, :created_at, :updated_at, :created_by_admin_id, :updated_by_admin_id
end