namespace :states_167222962 do
  desc 'Load state_enum to state'
  task load_state_enum: :environment do
    State.all.order(:id).each do |s|
      s.state_enum = get_state_enum[s.id]
      s.save
    end
  end
  
  
  def get_state_enum
    { 
      1 => 22,
      2 => 49,
      3 => 48,
      4 => 25,
      5 => 31,
      6 => 38,
      7 => 5,
      8 => 1,
      9 => nil,	
      10 => 27,
      11 => 4,
      12 => 50,
      13 => 43,
      14 => 21,
      15 => 19,
      16 => 29,
      17 => 34,
      18 => 15,
      19 => 18,
      20 => 23,
      21 => 7,
      22 => 6,
      23 => 26,
      24 => 32,
      25 => 20,
      26 => 24,
      27 => 41,
      28 => 37,
      29 => 36,
      30 => 9,
      31 => 3,
      32 => 47,
      33 => 11,
      34 => 12,
      35 => 39,
      36 => 17,
      37 => 46,
      38 => 33,
      39 => 2,
      40 => 13,
      41 => 8,
      42 => 40,
      43 => 16,
      44 => 28,
      45 => 45,
      46 => 14,
      47 => 10,
      48 => 42,
      49 => 35,
      50 => 30,
      51 => 44  
    }
  end
  
end