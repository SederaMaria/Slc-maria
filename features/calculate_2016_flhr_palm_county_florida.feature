@lease_examples
Feature: Calculate a Lease for a 2016 FLHR in Palm County, Florida with a sales price of $25,000
  Background:
    Given a Lease Calculator
    And the Lessee Resides in "Florida"
    And a Minimum Dealer Participation of $200.00
    And an Acquisition Fee of $595.00
    And Dealer Participation Sharing is 50.00%
    And a NADA retail value of $18945.00
    And a sales tax percentage of 6.0000%
    And a State Upfront Tax Percentage of 6.00%
    And a County Upfront Tax Percentage of 0.00%
    And a dealer sales price of $25000.00
    And Title, Registration, and Lien is $100.00
    And Dealer Freight is $200.00
    And Documentation Fee is $250.00
    And GAP Insurance is $450.00
    And Prepaid Maintenance is $500.00
    And Extended Service Contract is $550.00
    And Tire & Wheel Warranty is $125.00
    And the Base Servicing Fee is $5.00

  Scenario Outline: Tier 1 (good FICO score), 36 month term, $1500 Trade In, 2.75% dealer participation
        Given a credit tier maximum backend advance of 20%
        And a maximum frontend advance percentage of 125.00%
        And a frontend advance haircut of 10.00%
        And an annual yield of 15.00%
        And a term of 36 months
        And a customer purchase option of $6830.00
        And a Trade-in Allowance of $3000.00
        And a Trade-in Payoff of $1500.00
        And a cash down payment of $4048.63
        And a dealer participation of 2.75%
        Then "<attribute>" should be $<value>

    Examples:
      | attribute                   | value    |
      | maximum_backend_advance     | 3789.00  |
      | backend_total               | 1625.00  |
      | Frontend Advance            | 21786.75 |
      | Adjusted Capitalized Cost   | 22464.29 | 
      | Monthly Depreciation Charge | 216.66   |
      | Monthly Lease Charge        | 434.29   |
      | Base Monthly Payment        | 619.60   |
      | Monthly Sales Tax           | 37.18    |
      | Total Monthly Payment       | 656.78   |
      | Total Sales Price           | 27417.92 |
      | Dealer Reserve              | 891.96   |
      | Remit To Dealer             | 21924.47 |
      | TOTAL CASH AT SIGNING       | 4885.41  |
      | Upfront Tax                 | 242.92   |
      | Refundable Security Deposit | 0.00     |
      | Servicing Fee               | 180.00   |
      | net_trade_in_allowance      | 1500.00  |
      | cash_down_minimum           | 2408.07  |

  Scenario Outline: Global security deposit enabled, Tier 1 (good FICO score), 24 month term, $2000 Trade In, 2.75% dealer participation
    Given a credit tier maximum backend advance of 20%
    And a maximum frontend advance percentage of 125.00%
    And a frontend advance haircut of 10.00%
    And an annual yield of 15.00%
    And a term of 24 months
    And a customer purchase option of $6830.00
    And a Trade-in Allowance of $3000.00
    And a Trade-in Payoff of $2000.00
    And a cash down payment of $5000.00
    And a dealer participation of 2.75%
    And global security deposit is enabled
    Then "<attribute>" should be $<value>

    Examples:
      | attribute                   | value    |
      | maximum_backend_advance     | 3789.00  |
      | backend_total               | 1625.00  |
      | Frontend Advance            | 21786.75 |
      | Adjusted Capitalized Cost   | 22070.00 |
      | Monthly Depreciation Charge | 213.74   |
      | Monthly Lease Charge        | 635.00   |
      | Base Monthly Payment        | 814.13   |
      | Monthly Sales Tax           | 48.85    |
      | Total Monthly Payment       | 862.98   |
      | Total Sales Price           | 27475.00 |
      | Dealer Reserve              | 643.88   |
      | Remit To Dealer             | 19901.90 |
      | TOTAL CASH AT SIGNING       | 7216.98  |
      | Upfront Tax                 | 300.00   |
      | Refundable Security Deposit | 1234.00  |
      | Servicing Fee               | 120.00   |
      | net_trade_in_allowance      | 1000.00  |
      | cash_down_minimum           | 2940.07  |