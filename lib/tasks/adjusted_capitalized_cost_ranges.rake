namespace :adjusted_capitalized_cost_ranges do
  desc "TODO"
  task run: :environment do
    Rails.logger.info "Task started at #{DateTime.now}"
    AdjustedCapitalizedCostRange.destroy_all
    file_path = "#{Rails.root}/db/adjusted_capitalized_cost_ranges_data.xlsx"
    workbook = Roo::Spreadsheet.open(file_path)
    worksheet = workbook.sheets.first
    workbook.sheet(worksheet).each_row_streaming(offset: 1) do |row|
      start_range =  (row[0].value.split("to").first.split("$").last.to_f * 100).to_i #cents
      end_range =  (row[0].value.split("to").last.split("$").last.to_f * 100).to_i
      Make.all.each do |make|
        make.credit_tiers.sort.each_with_index do |credit_tier, index|
          index += 1
          credit_tier.adjusted_capitalized_cost_ranges.create(
            acquisition_fee_cents: row[index].value * 100,
            adjusted_cap_cost_lower_limit: start_range,
            adjusted_cap_cost_upper_limit: end_range,
            effective_date: DateTime.now.utc,
            end_date: DateTime.now.utc + 980.years
            )
        end
      end
    end
    Rails.logger.info "Task ended at #{DateTime.now}"
  end

  desc "Mark column as zero"
  task update_column_zero: :environment do
    CreditTier.update_all(acquisition_fee_cents: 0)
    ApplicationSetting.update_all(acquisition_fee_cents: 0)
  end

end

