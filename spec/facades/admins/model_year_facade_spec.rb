require 'rails_helper'
=begin
RSpec.describe Admins::ModelYearFacade, type: :facade do
  subject { described_class.new }

  describe '#recalculate_residuals' do
    let!(:model_years) { create_list(:model_year, 2) }
    let!(:settings)   { create(:application_setting) }

    it 'shedules RecalculateResidualsJob for each model year' do
      expect { subject.recalculate_residuals }.to have_enqueued_job(RecalculateResidualsJob).exactly(:twice)
    end
  end
end
=end