class Workflow < ApplicationRecord
    validates :workflow_name, presence: true, uniqueness: true
end
