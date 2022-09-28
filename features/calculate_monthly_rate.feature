@lease_examples
Feature: Convert Annual Rate to Monthly Rate using specific formula from Excel Model

  Background: 
    Given a Lease Calculator

  Scenario Outline: Calculates Monthly Rate accurately Given Annual Rate
        Given an annual yield of <annual_rate>%
        Then the monthly yield should be <expected_monthly_rate>%

    Examples:
      | annual_rate | expected_monthly_rate |  
      | 15.0        | 1.17149169198534      |  
      | 20.0        | 1.53094704997312      |  
      | 23.0        | 1.74008417721816      |  
      | 25.0        | 1.87692651215061      |  
      | 27.0        | 2.01177634955232      |  
      | 28.0        | 2.07847284895002      |  
      | 29.0        | 2.14469340334986      |  
      | 30.0        | 2.21044505936159      |  
      | 40.0        | 2.84361557263613      |  
      | 45.0        | 3.14479891343082      |  
