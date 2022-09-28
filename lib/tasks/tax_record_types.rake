namespace :tax_record_type do
  desc 'Seed Tax Record Types'
  task seed: :environment do
    if TaxRecordType.all.empty?
      tax_record_types.each do |record_type|
        TaxRecordType.create(record_type)
      end
    end
    
  end
  
  def tax_record_types
    [
      { vertex_record_type: 1,	record_type_desc: "State" },
      { vertex_record_type: 2,	record_type_desc: "County" },
      { vertex_record_type: 3,	record_type_desc: "City" },
      { vertex_record_type: 8,	record_type_desc: "Additional city record (vanity name, postal name, or additional ZIP code)" }
    ]
  end
end