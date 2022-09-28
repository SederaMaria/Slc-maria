namespace :update_us_state_id_in_lpc_form_code_lookup do
  desc 'Update US States id Into lpc_form_code_lookup Table'
  task update_us_state_id: :environment do
    all_states.each do |full_name, abbreviation|
      us_state = UsState.find_by_abbreviation(abbreviation)
      state_obj = State.find_by_abbreviation(abbreviation)
      lpc_obj = LpcFormCodeLookup.find_by_state_id(state_obj.id)
      if lpc_obj.present?
        lpc_obj.us_state_id = us_state.id
        lpc_obj.save!
      end
    end
  end

  desc 'Update US States name'
  task update_us_state_name: :environment do
    all_states.each do |full_name, abbreviation|
      us_state = UsState.find_by_abbreviation(abbreviation)
      state_obj = State.find_by_abbreviation(abbreviation)
      us_state.name = state_obj.name
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
end 