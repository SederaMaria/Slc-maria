namespace :states do
  desc 'Import All States Into States Table'
  task import: :environment do
    all_states.each do |full_name, abbreviation|
      State.create(
        name:         full_name,
        abbreviation: abbreviation,
        tax_jurisdiction_label: State::TAX_JURISDICTION_LABELS.first
      )
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
