namespace :us_states do
  # bundle exec rake us_states:import_from_csv
  task import_from_csv: :environment do 
    file_path = "#{Rails.root}/db/us_states.csv"
    contents = Roo::CSV.new(file_path,
                            csv_options: { encoding: Encoding::ISO_8859_1 })
    header = contents.row(1)
    (2..contents.last_row).each do |i|
      row = Hash[[header, contents.row(i)].transpose]
      state = UsState.where(name: row['name']).first_or_initialize
      state.abbreviation = row['abbreviation']
      state.sum_of_payments_state = row['sum_of_payments_state']
      state.active_on_calculator = row['active_on_calculator']
      state.tax_jurisdiction_type = lookup_tax_jurisdiction_type(row['tax_jurisdiction_label'])
      state.save

      p "#{state.id} - #{state.name}"

    end
  end

  desc 'Update All US States Abbreviations Into Us_States Table'
  task import: :environment do
    all_states.each do |full_name, abbreviation|
      us_state = UsState.where(name: full_name.to_s&.gsub(/_/, ' ').upcase)&.first_or_initialize
      state_obj = State.find_by_name(full_name)
      us_state.abbreviation = abbreviation
      us_state.active_on_calculator = state_obj.active_on_calculator
      us_state.sum_of_payments_state = state_obj.sum_of_payments_state
      us_state.tax_jurisdiction_type = lookup_tax_jurisdiction_type(state_obj.tax_jurisdiction_label)
      us_state.save!
    end
  end

  def all_states
      {
        alabama:              'AL',
        alaska:               'AK',
        arizona:              'AZ',
        arkansas:             'AR',
        california:           'CA',
        colorado:             'CO',
        connecticut:          'CT',
        delaware:             'DE',
        district_of_columbia: 'DC',
        florida:              'FL',
        georgia:              'GA',
        hawaii:               'HI',
        idaho:                'ID',
        illinois:             'IL',
        indiana:              'IN',
        iowa:                 'IA',
        kansas:               'KS',
        kentucky:             'KY',
        louisiana:            'LA',
        maine:                'ME',
        maryland:             'MD',
        massachusetts:        'MA',
        michigan:             'MI',
        minnesota:            'MN',
        mississippi:          'MS',
        missouri:             'MO',
        montana:              'MT',
        nebraska:             'NE',
        nevada:               'NV',
        new_hampshire:        'NH',
        new_jersey:           'NJ',
        new_mexico:           'NM',
        new_york:             'NY',
        north_carolina:       'NC',
        north_dakota:         'ND',
        ohio:                 'OH',
        oklahoma:             'OK',
        oregon:               'OR',
        pennsylvania:         'PA',
        rhode_island:         'RI',
        south_carolina:       'SC',
        south_dakota:         'SD',
        tennessee:            'TN',
        texas:                'TX',
        utah:                 'UT',
        vermont:              'VT',
        virginia:             'VA',
        washington:           'WA',
        west_virginia:        'WV',
        wisconsin:            'WI',
        wyoming:              'WY'
      }
  end

  def lookup_tax_jurisdiction_type(name)
    TaxJurisdictionType.where("name ILIKE ?", name)&.first
  end

  desc 'Update all US States with a geo_code_state'
  task update_us_states_with_geo_codes: :environment do
    ActiveRecord::Base.connection.execute(<<-SQL)
      UPDATE us_states SET geo_code_state = '01' WHERE id = 1;
      UPDATE us_states SET geo_code_state = '02' WHERE id = 2;
      UPDATE us_states SET geo_code_state = '03' WHERE id = 3;
      UPDATE us_states SET geo_code_state = '13' WHERE id = 4;
      UPDATE us_states SET geo_code_state = '04' WHERE id = 5;
      UPDATE us_states SET geo_code_state = '05' WHERE id = 6;
      UPDATE us_states SET geo_code_state = '06' WHERE id = 7;
      UPDATE us_states SET geo_code_state = '07' WHERE id = 8;
      UPDATE us_states SET geo_code_state = '08' WHERE id = 9;
      UPDATE us_states SET geo_code_state = '09' WHERE id = 10;
      UPDATE us_states SET geo_code_state = '16' WHERE id = 11;
      UPDATE us_states SET geo_code_state = '10' WHERE id = 12;
      UPDATE us_states SET geo_code_state = '11' WHERE id = 13;
      UPDATE us_states SET geo_code_state = '12' WHERE id = 14;
      UPDATE us_states SET geo_code_state = '14' WHERE id = 15;
      UPDATE us_states SET geo_code_state = '15' WHERE id = 16;
      UPDATE us_states SET geo_code_state = '17' WHERE id = 17;
      UPDATE us_states SET geo_code_state = '18' WHERE id = 18;
      UPDATE us_states SET geo_code_state = '20' WHERE id = 19;
      UPDATE us_states SET geo_code_state = '36' WHERE id = 20;
      UPDATE us_states SET geo_code_state = '19' WHERE id = 21;
      UPDATE us_states SET geo_code_state = '21' WHERE id = 22;
      UPDATE us_states SET geo_code_state = '22' WHERE id = 23;
      UPDATE us_states SET geo_code_state = '23' WHERE id = 24;
      UPDATE us_states SET geo_code_state = '24' WHERE id = 25;
      UPDATE us_states SET geo_code_state = '44' WHERE id = 26;
      UPDATE us_states SET geo_code_state = '25' WHERE id = 27;
      UPDATE us_states SET geo_code_state = '26' WHERE id = 28;
      UPDATE us_states SET geo_code_state = '27' WHERE id = 29;
      UPDATE us_states SET geo_code_state = '28' WHERE id = 30;
      UPDATE us_states SET geo_code_state = '29' WHERE id = 31;
      UPDATE us_states SET geo_code_state = '30' WHERE id = 32;
      UPDATE us_states SET geo_code_state = '31' WHERE id = 33;
      UPDATE us_states SET geo_code_state = '32' WHERE id = 34;
      UPDATE us_states SET geo_code_state = '45' WHERE id = 35;
      UPDATE us_states SET geo_code_state = '33' WHERE id = 36;
      UPDATE us_states SET geo_code_state = '34' WHERE id = 37;
      UPDATE us_states SET geo_code_state = '35' WHERE id = 38;
      UPDATE us_states SET geo_code_state = '37' WHERE id = 39;
      UPDATE us_states SET geo_code_state = '38' WHERE id = 40;
      UPDATE us_states SET geo_code_state = '39' WHERE id = 41;
      UPDATE us_states SET geo_code_state = '40' WHERE id = 42;
      UPDATE us_states SET geo_code_state = '41' WHERE id = 43;
      UPDATE us_states SET geo_code_state = '42' WHERE id = 44;
      UPDATE us_states SET geo_code_state = '43' WHERE id = 45;
      UPDATE us_states SET geo_code_state = '46' WHERE id = 46;
      UPDATE us_states SET geo_code_state = '47' WHERE id = 47;
      UPDATE us_states SET geo_code_state = '48' WHERE id = 48;
      UPDATE us_states SET geo_code_state = '49' WHERE id = 49;
      UPDATE us_states SET geo_code_state = '50' WHERE id = 50;
      UPDATE us_states SET geo_code_state = '51' WHERE id = 51;
    SQL
  end

  desc 'Set state enums'
  task load_state_enum: :environment do
    UsState.all.order(:abbreviation).each do |us|
      us.state_enum = get_us_state_enum[us.abbreviation]
      us.save
    end
  end

  def get_us_state_enum
    { 
      'AK' => 49,
      'AL' => 22,
      'AR' => 25,
      'AZ' => 48,
      'CA' => 31,
      'CO' => 38,
      'CT' => 5,
      'DE' => 1,
      'FL' => 27,
      'GA' => 4,
      'HI' => 50,
      'IA' => 29,
      'ID' => 43,
      'IL' => 21,
      'IN' => 19,
      'KS' => 34,
      'KY' => 15,
      'LA' => 18,
      'MA' => 6,
      'MD' => 7,
      'ME' => 23,
      'MI' => 26,
      'MN' => 32,
      'MO' => 24,
      'MS' => 20,
      'MT' => 41,
      'NC' => 12,
      'ND' => 39,
      'NE' => 37,
      'NH' => 9,
      'NJ' => 3,
      'NM' => 47,
      'NV' => 36,
      'NY' => 11,
      'OH' => 17,
      'OK' => 46,
      'OR' => 33,
      'PA' => 2,
      'RI' => 13,
      'SC' => 8,
      'SD' => 40,
      'TN' => 16,
      'TX' => 28,
      'UT' => 45,
      'VA' => 10,
      'VT' => 14,
      'WA' => 42,
      'WI' => 30,
      'WV' => 35,
      'WY' => 44
    }
  end  

end 
