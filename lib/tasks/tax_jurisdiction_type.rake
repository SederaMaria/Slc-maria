namespace :tax_jurisdiction_type do
  desc "Seed Tax Jurisdiction Types"
  task :seed => :environment do
    data = {
      1 => "Customer's County/Town",
      2 => "Customer's ZIP Code",
      3 => "Dealership's ZIP Code",
      4 => "Dealership's County/Town",
      5 => "Custom"
    }

    data.each do |key, value|
      TaxJurisdictionType.where(name: value, sort_order: key).first_or_create
    end
  end

  desc "Update `us_states` to use `tax_jurisdiction_type_id`"
  task :migrate => :environment do
    lookup = TaxJurisdictionType.pluck(:name, :id).map do |data|
      [data[0].downcase, data[1]]
    end.to_h

    UsState.all.each do |record|
      record.update(tax_jurisdiction_type_id: lookup[record.tax_jurisdiction_label.downcase])
    end
  end

  desc "Update `us_states` to use `tax_jurisdiction_label`"
  task :rollback => :environment do
    lookup = TaxJurisdictionType.pluck(:id, :name).to_h

    UsState.all.each do |record|
      record.update(tax_jurisdiction_label: lookup[record.tax_jurisdiction_type_id])
    end
  end
end
