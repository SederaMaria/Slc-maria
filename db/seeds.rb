## There is nothing stopping you from running this on production.
## Everything is isolated and dealers should not see any of the seed data due to access rights restrictions.

## THIS FILE SHOULD ALWAYS BE IDEMPOTENT
## https://en.wikipedia.org/wiki/Idempotence#Computer_science_meaning
## TL;DR - when you run `rake db:seed` multiple times, you shouldn't create more than 1 set of data.

## Technical Notes
## This file does not use FFaker or FactoryBot on purpose.
## We don't want to include those gems in the production gem bundle
## so they aren't loaded into memory on the production system.

### ADMINS ###
AdminUser.where(email: "alcidesr@speedleasing.com").first_or_create({
  password: "Sp33dL3@$ing",
  first_name: 'Alcides',
  last_name: 'Ruiz',
})
AdminUser.where(email: "brianc@speedleasing.com").first_or_create({
  password: "Sp33dL3@$ing",
  first_name: 'Brian',
  last_name: 'Cramer',
})

## STIPULATIONS

Stipulation.where(:abbreviation => Stipulation::PROOF_OF_INCOME).first_or_create({
  description: 'Proof of Income'
})
Stipulation.where(:abbreviation => Stipulation::FOUR_REFERENCES).first_or_create({
  description: 'Requires Four References'
})
Stipulation.where(:abbreviation => Stipulation::PROOF_SOCIAL_SEC).first_or_create({
  description: 'Proof of Social Security Number'
})
Stipulation.where(:abbreviation => Stipulation::PROOF_RESIDENCE).first_or_create({
  description: 'Proof of Residence'
})
Stipulation.where(:abbreviation => Stipulation::MISCELLANEOUS).first_or_create({
  description: 'Miscellaneous'
})

['Maximum Monthly Payment Limited to $[ENTER AMOUNT]',
'Proof of Bankruptcy Discharge',
'Payoff(s) of Existing Speed Lease(s) - Please send payment with this funding package',
'Proof of Payoff – Eaglemark / HDFS',
'Proof of Payoff – Chrome Capital',
'Proof of Payoff – Motolease',
'Proof of Payoff – Headwaters Financial',
'Proof of Payoff – Freedom Road',
'Proof of Payoff – MB Financial',
'First Time Rider',
'Limited Credit',
'Provide Applicant photo ID before contracts can be issued',
'Provide Co-Applicant photo ID before contracts can be issued',
'Other – [ENTER REQUIREMENT]',
'Poor performance with Speed Leasing Company',
'Valid local employer phone number',
'Proof of Account(s) Paid Current – [ENTER ACCOUNT NAME(S)]',
'3 Most Recent Personal Bank Statements - All Pages',
'Most recent Personal Federal Tax Return – All Pages'].each do |stip|
  Stipulation.where(:description => stip).first_or_create({
    abbreviation: 'Default'
  })
end

### STATES ###

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
}.each do |full_name, abbreviation|
  State.where(name: full_name).first_or_create({
    abbreviation: abbreviation,
    tax_jurisdiction_label: 'Customer\'s County/Town'
})
end

active_states = %w(SC VA NC FL TX AZ MD MI)
State.where(abbreviation: active_states).update_all(active_on_calculator: true)

### DEALERS ##

dealership = Dealership.where(name: 'Speed Leasing').first_or_create({
  website: 'http://powersportsfinance.com/tag/speed-leasing/',
  primary_contact_phone: '222-222-2222',
  state: 'FL',
  address: Address.create({
      :street1 => '123 Main Street',
      :street2 => 'Suite 1',
      :city => 'Miami',
      :state => 'FL',
      :zipcode => '35434',
      :county => 'Miami-Dade',
    })
})

dealer1 = Dealer.where(email: "alcidesr@speedleasing.com").first_or_create({
  password: "Sp33dL3@$ing",
  first_name: 'Alcides',
  last_name: 'Ruiz',
  dealership: dealership,
})

dealer2 = Dealer.where(email: "brianc@speedleasing.com").first_or_create({
  password: "Sp33dL3@$ing",
  first_name: 'Brian',
  last_name: 'Cramer',
  dealership: dealership,
})

### MAKE / MODEL YEARS ###

make = Make.where(name: 'Harley-Davidson').first_or_create({
  vin_starts_with: '1HD'
})

model_group = ModelGroup.where(name: 'Default').first_or_create({
  make: make,
  minimum_dealer_participation_cents: 10_000,
  residual_reduction_percentage: 100.00,
})

touring_group = ModelGroup.where(name: 'Touring').first_or_create({
  make: make,
  minimum_dealer_participation_cents: 20_000,
  residual_reduction_percentage: 75.00,
})

ModelYear.where(name: 'FLHR', year: 2016).first_or_create({
  model_group: touring_group,
  original_msrp: Money.from_amount(19949),
  nada_avg_retail: Money.from_amount(19220),
  nada_rough: Money.from_amount(13765),
  residual_24: Money.from_amount(10323.75),
  residual_36: Money.from_amount(9635.50),
  residual_48: Money.from_amount(8947.25),
})

application_settings = ApplicationSetting.new
application_settings.model_year_range_ascending.each do |year|
  %w(FLHX FXDC FXDF FXSTS).each_with_index do |model_year_name, index|
    ModelYear.where(name: model_year_name, year: year).first_or_create({
      model_group: model_group,
      original_msrp: Money.from_amount(10000+year+(index * 100)),
      nada_avg_retail: Money.from_amount(10000+year+(index * 100)),
      nada_rough: Money.from_amount(10000+year+(index * 100)),
      residual_24: Money.from_amount(9000+year+(index * 100)),
      residual_36: Money.from_amount(8000+year+(index * 100)),
      residual_48: Money.from_amount(7000+year+(index * 100)),
    })
  end
end

### MAKE CREDIT TIERS ###
unless CreditTier.exists?
  credit_tier_one = CreditTier.where(make: make, description: 'Tier 1 (FICO 740 or better)').first_or_create({
    :irr_value => 5.50,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 20.00,
    :maximum_advance_percentage => 125.00,
  })

  credit_tier_two = CreditTier.where(make: make, description: 'Tier 2 (FICO 700 - 739)').first_or_create({
    :irr_value => 6.50,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 20.00,
    :maximum_advance_percentage => 125.00,
  })

  credit_tier_three = CreditTier.where(make: make, description: 'Tier 3 (FICO 670 - 699)').first_or_create({
    :irr_value => 11.00,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 20.00,
    :maximum_advance_percentage => 120.00,
  })

  credit_tier_four = CreditTier.where(make: make, description: 'Tier 4 (FICO 640 - 669)').first_or_create({
    :irr_value => 12.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 15.00,
    :maximum_advance_percentage => 115.00,
  })

  credit_tier_five = CreditTier.where(make: make, description: 'Tier 5 (FICO 610 - 639)').first_or_create({
    :irr_value => 14.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 15.00,
    :maximum_advance_percentage => 105.00,
  })

  credit_tier_six = CreditTier.where(make: make, description: 'Tier 6 (FICO 580 - 609)').first_or_create({
    :irr_value => 20.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 10.00,
    :maximum_advance_percentage => 100.00,
  })

  credit_tier_seven = CreditTier.where(make: make, description: 'Tier 7 (FICO 550 - 579)').first_or_create({
    :irr_value => 26,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 10.00,
    :maximum_advance_percentage => 90.00,
  })

  credit_tier_eight = CreditTier.where(make: make, description: 'Tier 8 (FICO 520 - 549)').first_or_create({
    :irr_value => 32.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 10.00,
    :maximum_advance_percentage => 80.00,
  })

  credit_tier_nine = CreditTier.where(make: make, description: 'Tier 9 (FICO 490 - 519)').first_or_create({
    :irr_value => 36.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 10.00,
    :maximum_advance_percentage => 75.00,
  })

  credit_tier_ten = CreditTier.where(make: make, description: 'Tier 10 (FICO 460 - 489)').first_or_create({
    :irr_value => 36.0,
    :required_down_payment_percentage => 0.00,
    :maximum_fi_advance_percentage => 10.00,
    :maximum_advance_percentage => 70.00,
  })
end

### MAKE MILEAGE TIERS ###

# Age               0   1   2   3   4   5   6   7   8   9   10
# 0 to 9,999        0%  0%  0%  0%  0%  0%  0%  0%  0%  0%  0%
# 10,000 to 19,999  10% 10% 0%  0%  0%  0%  0%  0%  0%  0%  0%
# 20,000 to 29,999  15% 15% 10% 0%  0%  0%  0%  0%  0%  0%  0%
# 30,000 to 39,000  25% 25% 15% 10% 0%  0%  0%  0%  0%  0%  0%
# 40,000 and over   30% 30% 25% 15% 10% 0%  0%  0%  0%  0%  0%

unless MileageTier.exists?
  MileageTier.create(lower: 0,     upper: 9999)
  MileageTier.create(lower: 10000, upper: 19999, maximum_frontend_advance_haircut_0: 10.0, maximum_frontend_advance_haircut_1: 10.0)
  MileageTier.create(lower: 20000, upper: 29999, maximum_frontend_advance_haircut_0: 15.0, maximum_frontend_advance_haircut_1: 15.0, maximum_frontend_advance_haircut_2: 10.0)
  MileageTier.create(lower: 30000, upper: 39999, maximum_frontend_advance_haircut_0: 25.0, maximum_frontend_advance_haircut_1: 25.0, maximum_frontend_advance_haircut_2: 15.0, maximum_frontend_advance_haircut_3: 10.0)
  MileageTier.create(lower: 40000, upper: 49999, maximum_frontend_advance_haircut_0: 30.0, maximum_frontend_advance_haircut_1: 30.0, maximum_frontend_advance_haircut_2: 25.0, maximum_frontend_advance_haircut_3: 15.0, maximum_frontend_advance_haircut_4: 10.0)
end

### MAKE TAX SETTINGS ###

nc_state_rule = TaxRule.where(name: 'North Carolina').first_or_create({
  sales_tax_percentage: 3.00,
  up_front_tax_percentage: 3.00,
  cash_down_tax_percentage: 3.00,
  rule_type: :state
})

sc_state_rule = TaxRule.where(name: 'South Carolina').first_or_create({
  sales_tax_percentage: 0.00,
  up_front_tax_percentage: 5.0,
  cash_down_tax_percentage: 0.00,
  rule_type: :state
})

ga_state_rule = TaxRule.where(name: 'Georgia').first_or_create({
  sales_tax_percentage: 0.00,
  up_front_tax_percentage: 7.0,
  cash_down_tax_percentage: 0.00,
  rule_type: :state
})

TaxJurisdiction.where(name: 'State of Georgia TAVT').first_or_create({
  us_state: :georgia,
  state_tax_rule: ga_state_rule,
})

md_state_rule = TaxRule.where(name: 'Maryland').first_or_create({
  sales_tax_percentage: 0.00,
  up_front_tax_percentage: 6.0,
  cash_down_tax_percentage: 0.00,
  rule_type: :state
})

TaxJurisdiction.where(name: 'Maryland').first_or_create({
  us_state: :maryland,
  state_tax_rule: md_state_rule,
})

mi_state_rule = TaxRule.where(name: 'Michigan').first_or_create({
  sales_tax_percentage: 0.00,
  up_front_tax_percentage: 6.0,
  cash_down_tax_percentage: 0.00,
  rule_type: :state
})

TaxJurisdiction.where(name: 'Michigan').first_or_create({
  us_state: :michigan,
  state_tax_rule: mi_state_rule,
})

in_state_rule = TaxRule.where(name: 'Indiana').first_or_create({
  sales_tax_percentage: 7.0,
  up_front_tax_percentage: 7.0,
  cash_down_tax_percentage: 0.0,
  rule_type: :state
})

TaxJurisdiction.where(name: 'Indiana').first_or_create({
  us_state: :indiana,
  state_tax_rule: in_state_rule,

})

TaxJurisdiction.where(name: 'North Carolina').first_or_create({
  us_state: :north_carolina,
  state_tax_rule: nc_state_rule,

})

TaxJurisdiction.where(name: 'South Carolina').first_or_create({
  us_state: :south_carolina,
  state_tax_rule: sc_state_rule,

})


##### State Rule Only #####

texas_state_rule = TaxRule.where(name: 'Texas').first_or_create({
  sales_tax_percentage: 0.0,
  up_front_tax_percentage: 6.25,
  rule_type: :state
})

TaxJurisdiction.where(name: 'Texas').first_or_create({
  us_state: :texas,
  state_tax_rule: texas_state_rule,

})

##### State + County #####

fl_state_rule = TaxRule.where(name: 'Florida').first_or_create({
  sales_tax_percentage: 6.00,
  up_front_tax_percentage: 6.00,
  cash_down_tax_percentage: 6.00,
  rule_type: :state
})

walton_county_rule = TaxRule.where(name: 'Walton County').first_or_create({
  sales_tax_percentage: 1.00,
  up_front_tax_percentage: 1.00,
  cash_down_tax_percentage: 1.00,
  rule_type: :county
})

st_lucie_county_rule = TaxRule.where(name: 'St. Lucie County').first_or_create({
  sales_tax_percentage: 0.50,
  up_front_tax_percentage: 0.50,
  cash_down_tax_percentage: 0.50,
  rule_type: :county
})

TaxJurisdiction.where(name: 'Walton County').first_or_create({
  us_state: :florida,
  state_tax_rule: fl_state_rule,
  county_tax_rule: walton_county_rule,
})

TaxJurisdiction.where(name: 'St. Lucie County').first_or_create({
  us_state: :florida,
  state_tax_rule: fl_state_rule,
  county_tax_rule: st_lucie_county_rule,
})

##### All levels (most complex) #####

### TEMPORARILY COMMENTED OUT WHILE ALABAMA IS NOT A CONFIGURED STATE.  SEE TaxJurisdiction's `us_state` Enum.

# al_state_rule = TaxRule.where(name: 'Alabama').first_or_create({
#   sales_tax_percentage: 1.5,
#   up_front_tax_percentage: 1.50,
#   cash_down_tax_percentage: 1.50,
#   rule_type: :state
# })

# walker_county_rule = TaxRule.where(name: 'Walker County').first_or_create({
#   sales_tax_percentage: 1.0,
#   up_front_tax_percentage: 1.00,
#   cash_down_tax_percentage: 1.00,
#   rule_type: :county
# })

# cordova_city_rule = TaxRule.where(name: 'Cordova, Alabama').first_or_create({
#   sales_tax_percentage: 2.0,
#   up_front_tax_percentage: 2.0,
#   cash_down_tax_percentage: 2.0,
#   rule_type: :local

# })

# TaxJurisdiction.where(name: 'Walker County-Cordova').first_or_create({
#   us_state: :alabama,
#   state_tax_rule: al_state_rule,
#   county_tax_rule: walker_county_rule,
#   local_tax_rule: cordova_city_rule,
# })

# TaxJurisdiction.where(name: 'Walker County').first_or_create({
#   us_state: :alabama,
#   state_tax_rule: al_state_rule,
#   county_tax_rule: walker_county_rule,
# })

### MAKE LEASE APPLICATIONS ###

lessee = Lessee.where(first_name: 'Billy', last_name: 'Perfect').first_or_create({
  middle_name: 'R',
  ssn: '123-45-6789',
  date_of_birth: Date.new(1969, 10, 31),
  email_address: 'billy@example.com',
  home_address_attributes: {
    street1: '123 Peachtree Street',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  mailing_address_attributes: {
    street1: 'PO BOX 1234',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  employment_address_attributes: {
    street1: '3525 Piedmont Road',
    street2: 'Suite 5-205',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30305',
  },
})

colessee = Lessee.where(first_name: 'John', last_name: 'Doe').first_or_create({
  middle_name: 'A',
  ssn: '987-65-4321',
  date_of_birth: Date.new(1974, 1, 15),
  email_address: 'johndoe@example.com',
  home_address_attributes: {
    street1: '123 Peachtree Street',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  mailing_address_attributes: {
    street1: 'PO BOX 1234',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  employment_address_attributes: {
    street1: '3525 Piedmont Road',
    street2: 'Suite 5-205',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30305',
  },
})

LeaseApplication.where({
  lessee_id: lessee.id,
  colessee_id: colessee.id,
  dealer_id: dealer1.id,
}).first_or_create({
  lease_calculator_id: LeaseCalculator.create.id
})

LeaseApplication.where({
  lessee_id: colessee.id,
  colessee_id: lessee.id,
  dealer_id: dealer1.id,
}).first_or_create({
  lease_calculator_id: LeaseCalculator.create.id
})

miley = Lessee.where(first_name: 'Miley', last_name: 'Cyrus').first_or_create({
  middle_name: 'R',
  ssn: '123-45-6789',
  date_of_birth: Date.new(1969, 10, 31),
  email_address: 'miley@example.com',
  home_address_attributes: {
    street1: '123 Peachtree Street',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  mailing_address_attributes: {
    street1: 'PO BOX 1234',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  employment_address_attributes: {
    street1: '3525 Piedmont Road',
    street2: 'Suite 5-205',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30305',
  },
})

elvis = Lessee.where(first_name: 'Elvis', last_name: 'Presley').first_or_create({
  middle_name: 'A',
  ssn: '987-65-4321',
  date_of_birth: Date.new(1974, 1, 15),
  email_address: 'elvis@example.com',
  home_address_attributes: {
    street1: '123 Peachtree Street',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  mailing_address_attributes: {
    street1: 'PO BOX 1234',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30303',
  },
  employment_address_attributes: {
    street1: '3525 Piedmont Road',
    street2: 'Suite 5-205',
    city: 'Atlanta',
    state: 'GA',
    zipcode: '30305',
  },
})

LeaseApplication.where({
  lessee_id: miley.id,
  colessee_id: elvis.id,
  dealer_id: dealer2.id,
}).first_or_create({
  lease_calculator_id: LeaseCalculator.create.id
})

LeaseApplication.where({
  lessee_id: elvis.id,
  colessee_id: miley.id,
  dealer_id: dealer2.id,
}).first_or_create({
  lease_calculator_id: LeaseCalculator.create.id
})

### CREDCO TEST APPLICATIONS

#TESTCO  TODD  000-61-5460   11 PRINCETON AV, TRENTON, NJ 08848  19  5 1 0 0 0 25  0 0 0 0 0 0 "747
# 756
# 732"  "Beacon 5.0
# FICO II
# Classic 04"                                                                                                                                                 
[
  ["Todd", "Testco", "000-61-5460", "11 PRINCETON AV", "TRENTON", "NJ", "08848"],
  ["Carol", "Credco", "000-05-7119", "4326 JENINGS CT", "MADERA", "CA", "93637"]
].each do |credco_lessee|
  lessee_record = Lessee.where(first_name: credco_lessee[0], last_name: credco_lessee[1]).first_or_create({
    middle_name: 'R',
    ssn: credco_lessee[2],
    date_of_birth: Date.new(1969, 10, 31),
    email_address: "#{credco_lessee[0]}.#{credco_lessee[1]}@example.com",
    home_address_attributes: {
      street1: credco_lessee[3],
      city: credco_lessee[4],
      state: credco_lessee[5],
      zipcode: credco_lessee[6],
    },
    mailing_address_attributes: {
      street1: 'PO BOX 1234',
      city: 'Atlanta',
      state: 'GA',
      zipcode: '30303',
    },
    employment_address_attributes: {
      street1: '3525 Piedmont Road',
      street2: 'Suite 5-205',
      city: 'Atlanta',
      state: 'GA',
      zipcode: '30305',
    }
  })

  LeaseApplication.where({
    lessee_id: lessee_record.id, 
    dealer_id: dealer1.id
  }).first_or_create({
    lease_calculator_id: LeaseCalculator.create.id
  })
end

lease_pack_lessee = Lessee.where(first_name: 'Billy', last_name: 'Lease Pack').first_or_create({
  middle_name: 'R',
  ssn: '123-45-6789',
  date_of_birth: Date.new(1969, 10, 31),
  email_address: 'billy@example.com',
  home_address_attributes: {
    street1: '3275 NW 24th Street Rd',
    city: 'Miami',
    state: 'FL',
    zipcode: '33142',
  }
})

lease_pack_colessee = Lessee.where(first_name: 'John', last_name: 'Lease Pack').first_or_create({
  middle_name: 'R',
  ssn: '987-65-4321',
  date_of_birth: Date.new(1969, 10, 30),
  email_address: 'johndoe@example.com',
  home_address_attributes: {
    street1: '3275 NW 24th Street Rd',
    city: 'Miami',
    state: 'FL',
    zipcode: '33142',
  }
})

lease_pack_app = LeaseApplication.where({
  lessee_id: lease_pack_lessee.id, 
  colessee_id: lease_pack_colessee.id, 
  dealer_id: dealer1.id
}).first_or_create({
  credit_status: :approved,
  document_status: :documents_requested,
  application_identifier: '1708300001',
  lease_calculator_id: LeaseCalculator.create.id,
  lease_document_requests: [LeaseDocumentRequest.create({
    :asset_make => 'Harley-Davidson',
    :asset_model => 'FLHX',
    :asset_year => '2016',
    :asset_vin => '1HDABCDFGHTYRJFKD',
    :asset_color => 'BLACK',
    :exact_odometer_mileage => '12,345',
    :trade_in_make => 'NISSAN',
    :trade_in_model => 'TERRA-X',
    :trade_in_year => '2005',
    :delivery_date => Date.today,
    :gap_contract_term => 36,
    :service_contract_term => 36,
    :ppm_contract_term => 36,
    :tire_contract_term => 36,
    :equipped_with => 'Sidecar',
    :notes => 'Indiana Jones\' escape motorcycle', #=> https://www.youtube.com/watch?v=jIRxsCHViPk
  })],
})


###########################
# LEASE PACKAGE TEMPLATES #
###########################

# == Schema Information
#
# Table name: lease_package_templates
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  lease_package_template :string
#  document_type          :integer          not null
#  us_states              :string           default([]), not null, is an Array
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  position               :integer
#
# Indexes
#
#  index_lease_package_templates_on_name  (name) UNIQUE
#

LeasePackageTemplate.where(name: 'Florida Customer Lease Package 1').first_or_create({
  document_type: :customer,
  us_states: ['florida'],
  lease_package_template: File.open(File.join(Rails.root, 'lib', 'data', 'CustomerTemplate1.pdf'))
})

LeasePackageTemplate.where(name: 'Florida Customer Lease Package 2').first_or_create({
  document_type: :customer,
  us_states: ['florida'],
  lease_package_template: File.open(File.join(Rails.root, 'lib', 'data', 'CustomerTemplate2.pdf'))
})

LeasePackageTemplate.where(name: 'Florida Dealership Lease Package 1').first_or_create({
  document_type: :customer,
  us_states: ['florida'],
  lease_package_template: File.open(File.join(Rails.root, 'lib', 'data', 'DealershipTemplate1.pdf'))
})

LeasePackageTemplate.where(name: 'Florida Dealership Lease Package 2').first_or_create({
  document_type: :customer,
  us_states: ['florida'],
  lease_package_template: File.open(File.join(Rails.root, 'lib', 'data', 'DealershipTemplate2.pdf'))
})

FundingDelayReason.create(reason: 'Missing Stipulations')









