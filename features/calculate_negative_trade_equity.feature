@lease_examples
Feature: Calculate a Lease for a 2016 FLSTC in Alachua County, Florida with a sales price of $16,000
  Background:
    Given a Lease Calculator
    And the Lessee Resides in "Florida"
    And a Minimum Dealer Participation of $200.00
    And an Acquisition Fee of $595.00
    And Dealer Participation Sharing is 50.00%
    And a NADA retail value of $16680.00
    And a sales tax percentage of 6.3000%
    And a State Upfront Tax Percentage of 6.00%
    And a County Upfront Tax Percentage of 0.30%
    And a dealer sales price of $16000.00
    And Title, Registration, and Lien is $0.00
    And Dealer Freight is $0.00
    And Documentation Fee is $0.00
    And GAP Insurance is $0.00
    And Prepaid Maintenance is $0.00
    And Extended Service Contract is $0.00
    And Tire & Wheel Warranty is $0.00
    And the Base Servicing Fee is $5.00

  Scenario Outline: Tier 1 (good FICO score), 36 month term, $1500 Trade In, 2.75% dealer participation
        Given a credit tier maximum backend advance of 20%
        And a maximum frontend advance percentage of 125.00%
        And a frontend advance haircut of 10.00%
        And an annual yield of 15.00%
        And a term of 48 months
        And a customer purchase option of $5521.00
        And a Trade-in Allowance of $2000.00
        And a Trade-in Payoff of $3000.00
        And a cash down payment of $0.00
        And a dealer participation of 0.00%
        Then "<attribute>" should be $<value>

    Examples:
      | attribute                   | value    |
      | maximum_backend_advance     | 3336.00  |
      | maximum_frontend_advance    | 19182.00 |
      | backend_total               | 0.00     |
      | Frontend Advance            | 16000.00 |
      | gross capitalized cost      | 16595.00 |
      | Adjusted Capitalized Cost   | 17595.00 | 
      | Monthly Depreciation Charge | 144.48   |
      | Monthly Lease Charge        | 251.54   |
      | Base Monthly Payment        | 400.04   |
      | Monthly Sales Tax           | 25.20    |
      | Total Monthly Payment       | 425.24   |
      | Total Sales Price           | 16000.00 |
      | Dealer Reserve              | 200.00   |
      | Remit To Dealer             | 16534.76 |
      | TOTAL CASH AT SIGNING       | 665.24   |
      | Upfront Tax                 | 0.00     |
      | Refundable Security Deposit | 0.00     |
      | Servicing Fee               | 240.00   |
      | net_trade_in_allowance      | -1000.00 |
      | cash_down_minimum           | -2182.00 |
