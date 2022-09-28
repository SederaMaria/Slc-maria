Feature: Up-Front Lease Tax in Florida

  Background:
    Given a Lease Calculator
    
  @california
  Scenario Outline: State Tax Based off of Cash Down and Gross Trade In
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "California"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the County Upfront Tax Amount should be $<expected_county_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate  | county_tax_rate  | local_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_county_tax_amount | expected_total_tax_amount |
      | 7.25            | 0.50             |  0.00          | 0.00           | 6000.00   | 465.00                    | 0.00                       | 465.00                    |
      | 7.25            | 1.25             |  1.00          | 1500.00        | 4048.63   | 527.12                    | 0.00                       | 527.12                    |
        
  @florida
  Scenario Outline: State Tax Based off of Cash Down and Net Trade In, County only the Cash Down with a Tax Base Max of $5000
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "Florida"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the County Upfront Tax Amount should be $<expected_county_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | county_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_county_tax_amount | expected_total_tax_amount |
      | 6.0            | 1.0             | 0.00           | 6000.00   | 360.00                    | 50.00                      | 410.00                    |
      | 6.0            | 0.5             | 1500.00        | 4048.63   | 242.92                    | 20.24                      | 263.16                    |

  @mississippi
  Scenario Outline: State Tax Based off of Cash Down
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "Mississippi"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_total_tax_amount |
      | 7.0            | 0.00           | 6000.00   | 420.00                    | 420.00                    |
      | 7.0            | 1500.00        | 4048.63   | 283.40                    | 283.40                    |

  @new_mexico
  Scenario Outline: Tax Based off of Cash Down, no tax on Trade In
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "New Mexico"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the Local Upfront Tax Amount should be $<expected_local_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | county_tax_rate | local_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_local_tax_amount | expected_total_tax_amount |
      | 5.125          | 1.40            | 2.25           | 0.00           | 6000.00   | 307.50                    | 135.00                    | 526.50                    |
      | 5.125          | 1.40            | 2.25           | 1500.00        | 4048.63   | 207.49                    | 91.09                     | 355.26                    |

  @nevada
  Scenario Outline: Tax Based off of Cash Down, no tax on Trade In
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "Nevada"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the County Upfront Tax Amount should be $<expected_county_tax_amount>
    And the Local Upfront Tax Amount should be $<expected_local_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | county_tax_rate | local_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_county_tax_amount | expected_local_tax_amount | expected_total_tax_amount |
      | 4.60           | 2.50            | 0.00           | 0.00           | 6000.00   | 276.00                    | 150.00                       | 0.00                      | 426.00                    |
      | 4.60           | 2.50            | 0.00           | 1500.00        | 4048.63   | 186.24                    | 101.22                       | 0.00                      | 287.46                    |

  @pennsylvania
  Scenario Outline: Tax Based off of Cash Down, no tax on Trade In
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "Pennsylvania"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the Local Upfront Tax Amount should be $<expected_local_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | county_tax_rate | local_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_local_tax_amount | expected_total_tax_amount |
      | 9.00           | 0.00            | 2.00           | 0.00           | 6000.00   | 540.00                    | 120.00                    | 660.00                    |
      | 9.00           | 0.00            | 1.00           | 1500.00        | 4048.63   | 364.38                    | 40.49                     | 404.87                    |

  #For the Zip 85173 State 5.6%, County 1.10%, and local 4%. Tax on $1000 should be $107. Staging comes up with $67.
  @arizona
  Scenario Outline: State County and Local Tax Based off of Cash Down and Net Trade In
    Given a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "Arizona"
    Then the State Upfront Tax Amount should be $<expected_state_tax_amount>
    And the County Upfront Tax Amount should be $<expected_county_tax_amount>
    And the Local Upfront Tax Amount should be $<expected_local_tax_amount>
    And the Total Upfront Tax Amount should be $<expected_total_tax_amount>

    Examples:
      | state_tax_rate | county_tax_rate | local_tax_rate | gross_trade_in | cash_down | expected_state_tax_amount | expected_county_tax_amount | expected_local_tax_amount | expected_total_tax_amount |
      | 5.6            | 1.1             | 4.0            | 2000.00        | 1000.00   | 56.00                     | 11.00                      | 40.00                     | 107.00                    |
      | 5.6            | 1.1             | 4.0            | 1000.00        | 0.00      | 0.00                      | 0.00                       | 0.00                      | 0.00                      |

  @north_carolina
  Scenario Outline: State Level Tax Based off of Cash Down and Net Trade In
    Given a State Upfront Tax Percentage of <tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Cash Down Payment of $<cash_down>
    And the Lessee Resides in "North Carolina"
    Then the Total Upfront Tax Amount should be $<expected_tax_amount>

    Examples:
      | tax_rate | gross_trade_in | cash_down | expected_tax_amount |
      | 3.0      | 1500.00        | 4048.63   | 121.46              |

  @south_carolina
  Scenario Outline: State Level Tax
    Given a Dealer Sales Price of $<sale_price>
    And the Lessee Resides in "South Carolina"
    Given a State Upfront Tax Percentage of 5.00%
    And Documentation Fee is $<dealer_documentation_fee>
    Then the Total Upfront Tax Amount should be $<expected_tax_amount>

    Examples:
      | dealer_documentation_fee | sale_price | expected_tax_amount |
      | 0.00                     | 20000.00   | 500.00              |
      | 0.00                     | 10010.00   | 500.00              |
      | 0.00                     | 10000.00   | 500.00              |
      | 0.00                     | 6000.00    | 300.00              |
      | 0.00                     | 6001.00    | 300.05              |
      | 0.00                     | 5999.80    | 299.99              |
      | 0.00                     | 3000.00    | 150.00              |
      | 500.00                   | 3000.00    | 175.00              |
      | 500.00                   | 10000.00   | 500.00              |

  @texas
  Scenario Outline: State Level Tax, Sale Price less Trade In
    Given a State Upfront Tax Percentage of <tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Dealer Sales Price of $<sale_price>
    And the Lessee Resides in "Texas"
    Then the Total Upfront Tax Amount should be $<expected_tax_amount>

    Examples:
      | tax_rate | gross_trade_in | sale_price | expected_tax_amount |
      | 6.25     | 1500.00        | 25000.00   | 1468.75             |

  @georgia
  Scenario Outline: State Level Tax, Sale Price less Trade In
    Given a State Upfront Tax Percentage of <tax_rate>%
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a GA TAVT Value of $<ga_tavt_value>
    And the Lessee Resides in "Georgia"
    Then the Total Upfront Tax Amount should be $<expected_tax_amount>

    Examples:
      | tax_rate | gross_trade_in | ga_tavt_value | expected_tax_amount |
      | 7.00     | 5000.00        | 15000.00      | 10000.00            |

  @oklahoma
  Scenario Outline: Used Vehicle: $20.00 on the 1st $1500.00 of value + 4.5% (3.25 + sales tax rate) of the remainder
    Given a State Upfront Tax Percentage of <tax_rate>%
    And a Dealer Freight and Setup Fee of $<dealer_freight_and_setup>
    And a Dealer Sales Price of $<sale_price>
    And the Lessee Resides in "Oklahoma"
    Then the Total Upfront Tax Amount should be $<expected_tax_amount>

    Examples:
      | tax_rate | dealer_freight_and_setup | sale_price | expected_tax_amount |
      | 4.5      | 0.00                     | 1499.99    | 20.00               |
      | 4.5      | 0.00                     | 10000.00   | 402.50              |
      | 4.5      | 1234.56                  | 25353.89   | 1148.98             |


  @tennessee
  Scenario Outline: Tennessee taxes upfront tax normally on Cash Down Payment and applies an additional "Single Item" tax on the bike price too.  The rates for both are not the same!
    Given the Lessee Resides in "Tennessee"
    And a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Dealer Sales Price of $<sale_price>
    And a Cash Down Payment of $<cash_down>
    Then the State Upfront Tax Amount should be $<expected_state_tax>
    And the State Single Item Tax Amount should be $<expected_state_single_item_tax>
    And the County Upfront Tax Amount should be $<expected_county_tax>
    And the County Single Item Tax Amount should be $<expected_county_single_item_tax>
    And the Total Upfront Tax Amount should be $<expected_total_tax>

    Examples:
      | state_tax_rate | county_tax_rate | sale_price | cash_down | expected_state_tax | expected_state_single_item_tax | expected_county_tax | expected_county_single_item_tax | expected_total_tax |
      | 7.0            | 2.75            | 10000.00   | 1000.00   | 70.00              | 44.00                          | 27.50               | 44.00                           | 185.50             |

  @ohio
  Scenario Outline: Ohio is a Sum of Payments tax state with local rates dictated by Zip Code. State tax rate is 5.75%. Upfront tax is also assessed on Cash Down and Gross Trade-in. Should negative tax be present it should be offset by Gross Trade-in before calculating tax. There should never tax on Cash and Trade-in.
    Given the Lessee Resides in "Ohio"
    And a State Upfront Tax Percentage of <state_tax_perc>%
    And a County Upfront Tax Percentage of <county_tax_perc>%
    And a term of <term> months
    And a Dealer Sales Price of $<sale_price>
    And a Dealer Freight and Setup Fee of $<dealer_freight_and_setup>
    And an annual yield of <annual_yield>%
    And a customer purchase option of $<purchase_option>
    And the Documentation Fee is $<dealer_documentation_fee>
    And GAP Insurance is $<gap>
    And Title, Registration, and Lien is $<title_reg_lien>
    And Prepaid Maintenance is $<prepaid_maintenance>
    And a Cash Down Payment of $<cash_down>
    And Extended Service Contract is $<extended_service>
    And Tire & Wheel Warranty is $<tire_and_wheel>
    And an Acquisition Fee of $<acquisition_fee>
    And a Gross Trade-in Allowance of $<gross_trade_in>
    And a Trade-in Payoff of $<trade_in_payoff>
    Then the SOP Depreciation Amount should be $<expected_depreciation>
    And the SOP Lease Charge Amount should be $<expected_lease_charge>
    And the SOP Amount should be $<expected_sum_of_payments>
    And the SOP Tax On Payments Amount should be $<expected_tax_on_payments>
    And the SOP Tax On Cash Amount should be $<expected_tax_on_cash>
    And the Total Upfront Tax Amount should be $<expected_upfront_tax>

    Examples:
      | state_tax_perc | county_tax_perc | term | sale_price | purchase_option | annual_yield | dealer_freight_and_setup | dealer_documentation_fee | title_reg_lien | gap    | prepaid_maintenance | extended_service | tire_and_wheel | acquisition_fee | gross_trade_in | trade_in_payoff | cash_down | expected_depreciation | expected_lease_charge | expected_sum_of_payments | expected_tax_on_payments | expected_tax_on_cash | expected_upfront_tax |
      #Scenario 1 - Positive Trade Equity
      | 5.75           | 0.75            | 48   | 10000.00   | 3500.00         | 26.0         | 500.00                   | 50.00                    | 200.00         | 500.00 | 1000.00             | 1500.00          | 500.00         | 595.00          | 5000.00        | 2500.00         | 500.00    | 173.85                | 166.24                | 21824.32                 | 1061.08                  | 357.50               | 1418.58              |
      | 5.75           | 0.75            | 48   | 10000.00   | 3882.78         | 26.0         | 500.00                   | 50.00                    | 200.00         | 500.00 | 1000.00             | 1500.00          | 500.00         | 595.00          | 5000.00        | 2500.00         | 500.00    | 165.88                | 170.38                | 21640.48                 | 1049.13                  | 357.50               | 1406.63              |
      #Scenario 2 - Negative Trade Equity
      | 5.75           | 0.75            | 48   | 10000.00   | 3882.78         | 26.0         | 500.00                   | 50.00                    | 200.00         | 500.00 | 1000.00             | 1500.00          | 500.00         | 595.00          | 2500.00        | 5000.00         | 500.00    | 270.05                | 224.55                | 26740.80                 | 1543.15                  | 195.00               | 1738.15              |
      #Scenario 3 - No Trade, Negative Cash
      | 5.75           | 0.75            | 48   | 10000.00   | 3882.78         | 26.0         | 500.00                   | 50.00                    | 200.00         | 500.00 | 1000.00             | 1500.00          | 500.00         | 595.00          | 0.00           | 0.00            | -500.00   | 238.80                | 208.30                | 21460.80                 | 1394.95                  | 0.0                  | 1394.95              |
      #Scenario 4
      | 5.75           | 0.75            | 48   | 10000.00   | 3922.91         | 26.0         | 500.00                   | 50.00                    | 200.00         | 500.00 | 1000.00             | 1500.00          | 500.00         | 595.00          | 5000.00        | 2500.00         | 500.00    | 165.04                | 170.82                | 21621.28                 | 1047.88                  | 357.50               | 1405.38              |

  @alabama
  Scenario Outline: Upfront tax is assessed on Cash Down and Gross Trade-in.
    Given the Lessee Resides in "Alabama"
    And a State Upfront Tax Percentage of <state_tax_rate>%
    And a County Upfront Tax Percentage of <county_tax_rate>%
    And a Local Upfront Tax Percentage of <local_tax_rate>%
    And a Dealer Sales Price of $<sale_price>
    And a Cash Down Payment of $<cash_down>
    And a Gross Trade-in Allowance of $<gross_trade_in>
    Then the State Upfront Tax Amount should be $<expected_state_tax>
    And the County Upfront Tax Amount should be $<expected_county_tax>
    And the Total Upfront Tax Amount should be $<expected_total_tax>

    Examples:
      | state_tax_rate | county_tax_rate | local_tax_rate | sale_price | cash_down | gross_trade_in | expected_state_tax | expected_county_tax | expected_total_tax |
      | 1.5            | 1.75            | 0.0            | 10000.00   | 1000.00   | 2500.00        | 52.50              | 61.25               | 113.75             |
      | 1.5            | 1.5             | 1.0            | 10000.00   | 1000.00   | 5000.00        | 90.00              | 90.00               | 240.00             |

  @illinois
  Scenario Outline: State Level Tax, Sale Price less Trade In
    Given a Dealer Sales Price of $<sale_price>
    And a Dealer Freight and Setup Fee of $<dealer_freight_and_setup>
    And the Documentation Fee is $<dealer_documentation_fee>
    And a Local Upfront Tax Percentage of <local_tax_perc>%
    And the Lessee Resides in "Illinois"
    Then the Total Upfront Tax Amount should be $<expected_upfront_tax>

    Examples:
      | sale_price | dealer_freight_and_setup | dealer_documentation_fee | local_tax_perc | expected_upfront_tax |
      | 8900.00    | 1000.00                  | 100.00                   | 0.09           | 9.00                 |