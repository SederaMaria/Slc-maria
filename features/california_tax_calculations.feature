Feature: Calculate California Tax

  Background:
    Given a Lease Calculator
    And the Lessee Resides in "California"
    And a Minimum Dealer Participation of $200.00
    And an Acquisition Fee of $595.00
    And Dealer Participation Sharing is 50.00%
    And a NADA retail value of $16680.00
    And a sales tax percentage of 6.3000%
    And a State Upfront Tax Percentage of 6.00%
    And a County Upfront Tax Percentage of 0.30%
    And a Local Upfront Tax Percentage of 2.25%
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
    And a Trade-in Allowance of $0.00
    And a Trade-in Payoff of $0.00
    And a cash down payment of $0.00
    And a dealer participation of 0.00%
    Then "<attribute>" should be $<value>

    Examples:
      | attribute                   | value    |
      | pre_tax_payments_sum        | 17882.40 |
      | sales_tax_rate              | 0.063    |
      | gross_capitalized_cost      | 16595.00 |
      | maximum_backend_advance     | 3336.00  |
      | backend_total               | 0.00     |
      | Frontend Advance            | 16000.00 |
      | Adjusted Capitalized Cost   | 16595.00 |
      | Monthly Depreciation Charge | 138.23   |
      | Monthly Lease Charge        | 230.71   |
      | Base Monthly Payment        | 372.55   |
      | Monthly Sales Tax           | 23.47    |
      | Total Monthly Payment       | 396.02   |
      | Total Sales Price           | 16000.00 |
      | Dealer Reserve              | 200.00   |
      | Remit To Dealer             | 15563.98 |
      | TOTAL CASH AT SIGNING       | 636.02   |
      | Upfront Tax                 | 0.00     |
      | Refundable Security Deposit | 0.00     |
      | Servicing Fee               | 240.00   |
      | net_trade_in_allowance      | 0.00     |
      
      
      