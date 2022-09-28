@lease_examples
Feature: Calculate a Lease for a Tier 10 2016 FLSTC in Palm Beach County, Florida with a sales price of $16,000

  Background:
    Given a Lease Calculator
    And the Lessee Resides in "Florida"
    And a Minimum Dealer Participation of $200.00
    And an Acquisition Fee of $595.00
    And Dealer Participation Sharing is 50.00%
    And a NADA retail value of $12017.00
    And a sales tax percentage of 6.5000%
    And a State Upfront Tax Percentage of 6.00%
    And a County Upfront Tax Percentage of 0.50%
    And a dealer sales price of $12500.00
    And Title, Registration, and Lien is $0.00
    And Dealer Freight is $0.00
    And Documentation Fee is $0.00
    And GAP Insurance is $0.00
    And Prepaid Maintenance is $0.00
    And Extended Service Contract is $0.00
    And Tire & Wheel Warranty is $0.00

  Scenario Outline: Tier 10 (low FICO score), 36 month term, $0 Trade In, 0.00% dealer participation
    Given a credit tier maximum backend advance of 10%
    And a maximum frontend advance percentage of 60.00%
    And a frontend advance haircut of 0.00%
    And an annual yield of 45.00%
    And a term of 36 months
    And a customer purchase option of $10017.00 
    And a Trade-in Allowance of $0.00
    And a Trade-in Payoff of $0.00
    And a cash down payment of $<cash_down_payment>
    And a dealer participation of 0.00%
    Then "Cash Down Minimum" should be $<cash_down_minimum>

    Examples:
      | cash_down_payment | cash_down_minimum |  
      | 0.00              | 5654.04           |  
      | 5654.04           | 5654.04           |  
