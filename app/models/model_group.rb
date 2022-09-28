# == Schema Information
#
# Table name: model_groups
#
#  id                                 :integer          not null, primary key
#  name                               :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  make_id                            :integer
#  minimum_dealer_participation_cents :integer          default(0), not null
#  residual_reduction_percentage      :decimal(, )      default(0.0), not null
#  maximum_term_length                :integer          default(60), not null
#  backend_advance_minimum_cents      :integer          default(0), not null
#  maximum_haircut_0                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_1                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_2                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_3                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_4                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_5                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_6                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_7                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_8                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_9                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_10                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_11                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_12                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_13                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_14                 :decimal(4, 2)    default(1.0), not null
#  sort_index                         :integer
#
# Indexes
#
#  index_model_groups_on_make_id  (make_id)
#
# Foreign Keys
#
#  fk_rails_...  (make_id => makes.id)
#

class ModelGroup < ApplicationRecord
  has_many :model_years
  belongs_to :make
  
  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end  
  
  validates :name, :make_id, :maximum_term_length, 
    presence: true

  validates :residual_reduction_percentage, 
    presence: true,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  validates :minimum_dealer_participation, :backend_advance_minimum,
    'money_rails/active_model/money' => { 
      greater_than_or_equal_to: 0,
      message: "must be greater than $0"
    },
    presence: true

  # TODO: Validate `maximum_term_length_per_year` with `json-schema`

  class << self    
    def update_sort_index(id, sort_index)      
      model_group = ModelGroup.find_by(id: id)  
      model_group.update(sort_index: sort_index) if model_group.present?
    end
  end
end
