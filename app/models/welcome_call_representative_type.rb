# == Schema Information
#
# Table name: welcome_call_representative_types
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WelcomeCallRepresentativeType < ApplicationRecord
end
