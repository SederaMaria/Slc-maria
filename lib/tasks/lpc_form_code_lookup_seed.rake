namespace :lpc_form_code_lookup_167227998 do
  desc 'Seed lpc form code lookup'
  task seed: :environment do
    if LpcFormCodeLookup.all.empty?
      lpc_form_code_lookup_data.each do |d|
        LpcFormCodeLookup.create(d)
      end
    end
    
  end
  
  def lpc_form_code_lookup_data
    [
      { state_id: 2,	lpc_form_code_id: 0,	lpc_description: "TBD" },
      { state_id: 1,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 4,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 3,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 5,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 6,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 7,	lpc_form_code_id: 5,	lpc_description: "5% or $10.00 (whichever is less)" },
      { state_id: 8,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 10,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 11,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 12,	lpc_form_code_id: 0,	lpc_description: "TBD" },
      { state_id: 16,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 13,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 14,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 15,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 17,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 18,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 19,	lpc_form_code_id: 4,	lpc_description: "5% or $25.00 (whichever is greater)" },
      { state_id: 22,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 21,	lpc_form_code_id: 2,	lpc_description: "10% or $5.00 (whichever is greater)" },
      { state_id: 20,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 23,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 24,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 26,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 25,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 27,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 34,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 35,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 28,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 30,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 31,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 32,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 29,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 33,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 36,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 37,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 38,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 39,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 40,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 41,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 42,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 43,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 44,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 45,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 47,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 46,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 48,	lpc_form_code_id: 1,	lpc_description: "5%" },
      { state_id: 50,	lpc_form_code_id: 3,	lpc_description: "5% or $10.00 (whichever is less)" },
      { state_id: 49,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less)" },
      { state_id: 51,	lpc_form_code_id: 5,	lpc_description: "5% or $25.00 (whichever is less) "}
    ]
  end
  
end
