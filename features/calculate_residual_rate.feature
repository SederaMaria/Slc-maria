@lease_examples
Feature: Calculate residual rate

  Background:
    Given a Residual Calculator

  Scenario Outline: Calculates Residual Rate accurately
        Given a NADA rough value of <nada_value>%
        Given a Residual Reduction Percentage of <residual_percentage>%
        Given a Model Group Reduction Percentage of <model_percentage>%
        Then residual value should be <expected_residual>%

    Examples:
      | nada_value | residual_percentage | model_percentage | expected_residual |
      | 15000      | 75                  | 50               | 5625              |
