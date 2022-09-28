namespace :fake_model_years do

  desc 'Generate Fake Model Years'
  task :generate => :environment do
    model_group = ModelGroup.first
    #Generate 20 years worth of random Model Years
    20.times do |model_years_ago|
      ModelYear.create({
        model_group: model_group,
        original_msrp_cents: 1_000_000,
        nada_avg_retail_cents: 1_000_000,
        nada_rough_cents: 1_000_000,
        name: "FAKE HARLEY #{Time.now.to_i}",
        year: model_years_ago.years.ago.year,
        residual_24_cents: 800_000,
        residual_36_cents: 600_000,
        residual_48_cents: 400_000,
        residual_60_cents: 200_000,
      })
    end
  end
end