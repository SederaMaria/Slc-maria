@lease_examples
Feature: Calculate Backend Advance Minimums
  Background:
    Given a Lease Calculator

  Scenario Outline: Calculate Backend Advance Minimums
    Given a backend advance minimum of $<bam>
    And a credit tier maximum backend advance of <mbp>%
    And a NADA retail value of $<nada>
    Then "maximum_backend_advance" should be $<calc_backend>

    Examples:
      | bam     | mbp | nada     | calc_backend |  
      | 0.00    | 20  | 16680.00 | 3336.00      |  
      | 200.34  | 20  | 16680.00 | 3336.00      |
      | 3336.01 | 20  | 16680.00 | 3336.01      |  
      | 4000.00 | 20  | 16680.00 | 4000.00      |
      | 0.00    | 5   | 20000.00 | 1000.00      |  
      | 200.34  | 5   | 20000.00 | 1000.00      |
      | 1000.01 | 5   | 20000.00 | 1000.01      |  
      | 4000.00 | 5   | 20000.00 | 4000.00      |
      

      