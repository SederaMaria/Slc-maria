namespace :lease_applications do
  desc "Submitted lease applications expire after 30 days"
  task expire_lease_applications: :environment do
    ExpireLeaseApplicationService.new().expire!
  end

  namespace :recalculate do
    desc "Recalculate Calculator Values within a Background Job"
    task :no_documents, [:days_to_go_back] => [:environment] do |task, args|

      days_to_go_back = args.fetch(:days_to_go_back).to_i { 36_524 } #100 year default + 24 leap year days of course

      calc_ids = LeaseCalculator.joins(:lease_application).
        merge(LeaseApplication.no_documents).
        merge(LeaseApplication.submitted_since(days_to_go_back.days.ago.beginning_of_day)).
        where(asset_year: ApplicationSetting.instance.model_year_range_ascending).
        pluck(:id)
      calc_ids.each {|id| RecalculateLeaseCalculatorsJob.perform_later(lease_calculator_id: id) }
    end

    desc "Recalculate Documents Issued Leases Values within the given time range within a Background Job"
    task :documents_issued, [:days_to_go_back] => [:environment] do |task, args|

      days_to_go_back = args.fetch(:days_to_go_back).to_i { 36_524 } #100 year default + 24 leap year days of course

      calc_ids = LeaseCalculator.joins(:lease_application).
        merge(LeaseApplication.documents_issued).
        merge(LeaseApplication.submitted_since(days_to_go_back.days.ago.beginning_of_day)).
        where(asset_year: ApplicationSetting.instance.model_year_range_ascending).
        pluck(:id)

      puts "Found #{calc_ids.length} Leases to Recalculate!"
      calc_ids.each {|id| RecalculateLeaseCalculatorsJob.perform_later(lease_calculator_id: id) }
    end

    desc 'Recalculate All Adjusted Capitalized Costs using Lease Calculator attributes'
    task adjusted_capitalized_costs: :environment do
      LeaseCalculator.submittable.find_each do |lc|
        puts("Processing LeaseCalculator ID: #{lc.id}...")
        calculated_cap_cost = lc.total_dealer_price +
          lc.upfront_tax +
          lc.title_license_and_lien_fee +
          lc.dealer_documentation_fee +
          lc.guaranteed_auto_protection_cost +
          lc.prepaid_maintenance_cost +
          lc.extended_service_contract_cost +
          lc.tire_and_wheel_contract_cost +
          lc.acquisition_fee -
          lc.net_trade_in_allowance -
          lc.cash_down_payment
        puts("...Calculated New Adjusted Cap Cost: #{calculated_cap_cost}")
        lc.update_attribute(:adjusted_capitalized_cost, calculated_cap_cost)
      end
    end
  end
end
