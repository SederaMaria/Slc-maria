module States
  NAMES_TO_ABBREVIATIONS ||= {
    alabama: 'AL',
    alaska: 'AK',
    arizona: 'AZ',
    arkansas: 'AR',
    california: 'CA',
    colorado: 'CO',
    connecticut: 'CT',
    delaware: 'DE',
    district_of_columbia: 'DC',
    florida: 'FL',
    georgia: 'GA',
    hawaii: 'HI',
    idaho: 'ID',
    illinois: 'IL',
    indiana: 'IN',
    iowa: 'IA',
    kansas: 'KS',
    kentucky: 'KY',
    louisiana: 'LA',
    maine: 'ME',
    maryland: 'MD',
    massachusetts: 'MA',
    michigan: 'MI',
    minnesota: 'MN',
    mississippi: 'MS',
    missouri: 'MO',
    montana: 'MT',
    nebraska: 'NE',
    nevada: 'NV',
    new_hampshire: 'NH',
    new_jersey: 'NJ',
    new_mexico: 'NM',
    new_york: 'NY',
    north_carolina: 'NC',
    north_dakota: 'ND',
    ohio: 'OH',
    oklahoma: 'OK',
    oregon: 'OR',
    pennsylvania: 'PA',
    rhode_island: 'RI',
    south_carolina: 'SC',
    south_dakota: 'SD',
    tennessee: 'TN',
    texas: 'TX',
    utah: 'UT',
    vermont: 'VT',
    virginia: 'VA',
    washington: 'WA',
    west_virginia: 'WV',
    wisconsin: 'WI',
    wyoming: 'WY'
  }.with_indifferent_access.freeze

  NAMES ||= NAMES_TO_ABBREVIATIONS.keys.freeze
  ABBREVIATIONS ||= NAMES_TO_ABBREVIATIONS.values.freeze

  SELECT2_ABBREVIATED_ALL ||= States::NAMES_TO_ABBREVIATIONS.
    inject([]) do |memo, (state_name,abbreviation)| #create a new array
      memo << ["#{NAMES_TO_ABBREVIATIONS[state_name]} - #{state_name.titleize}", NAMES_TO_ABBREVIATIONS[state_name]] #create the drop down collection
    end.sort {|a,b| a[1] <=> b[1]}.freeze #sort alphabetically for good measure and freeze for safe keeping

  SELECT2_FULL_NAME_ALL ||= States::NAMES_TO_ABBREVIATIONS.
    inject([]) do |memo, (state_name,abbreviation)| #create a new array
      memo << ["#{NAMES_TO_ABBREVIATIONS[state_name]} - #{state_name.titleize}", state_name] #create the drop down collection
    end.sort {|a,b| a[1] <=> b[1]}.freeze #sort alphabetically for good measure and freeze for safe keeping

  def self.abbreviation_for(name:)
    NAMES_TO_ABBREVIATIONS[name]
  end

  def self.name_from(abbreviation:)
    NAMES_TO_ABBREVIATIONS.invert[abbreviation]
  end
end
