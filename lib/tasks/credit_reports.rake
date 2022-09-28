namespace :credit_reports do
  desc "Migrate :credit_score_average by rounding up floats to integer"
  task :migrate_credit_score_average => [:environment] do
    # Round off specs
    # up: value > 0.50 (eg. 0.51, 0.52 and so on will be 1)
    # down: value =< 0.50 (eg. 0.50, 0.49, 0.48 will be 0)
    def round_up(value)
      if value.respond_to?(:-)
        (value - 0.01).round
      end
    rescue FloatDomainError
      nil
    end

    # First clear out NaN values into nil
    CreditReport.where(credit_score_average: Float::NAN).update_all(credit_score_average: nil)

    # Then query the rest and perform round up
    CreditReport.where.not(credit_score_average: nil).find_in_batches(batch_size: 5_000) do |group|
      group.each do |credit_report|
        credit_report.update(credit_score_average: round_up(credit_report.credit_score_average))
      end
    end
  end
end
