namespace :lpc_form_code_167226656 do
  desc 'Seed lpc form code'
  task seed: :environment do
    if LpcFormCode.all.empty?
      data_seed.each do |ds|
        LpcFormCode.create(ds)
      end
    end
    
  end
  
  def data_seed
    [
      { lpc_form_code_id: 1,	lpc_form_code_abbrev: "PERC" },
      { lpc_form_code_id: 2,	lpc_form_code_abbrev: "PMIN" },
      { lpc_form_code_id: 3,	lpc_form_code_abbrev: "PMAX" },
      { lpc_form_code_id: 4,	lpc_form_code_abbrev: "PMIN" },
      { lpc_form_code_id: 5,	lpc_form_code_abbrev: "PMAX" }
    ]
  end
  
end
