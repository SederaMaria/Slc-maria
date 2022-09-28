module Admins
  class ModelYearFacade
    def initialize
    end

    def recalculate_residuals
      model_years = ModelYear.active
      model_years.each do |model_year|
        RecalculateResidualsJob.perform_later(model_year_id: model_year.id)
      end
    end
  end
end
