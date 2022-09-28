# == Schema Information
#
# Table name: email_templates
#
#  id              :bigint(8)        not null, primary key
#  template        :string
#  enable_template :boolean          default(TRUE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class EmailTemplateSerializer < ApplicationSerializer
  attributes :id , :template, :enable_template, :name
end
