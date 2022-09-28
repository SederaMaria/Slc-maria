class BlackboxModel < ApplicationRecord

    scope :default_model, -> { where(default_model: true).first }
end
