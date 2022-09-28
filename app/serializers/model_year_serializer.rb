class ModelYearSerializer < ApplicationSerializer
    attributes :id, :year, :make, :model

    def make
        object&.make&.name
    end

    def model
        object&.model_group&.name
    end

  end
  