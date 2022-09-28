#Feature: Calculate an Amortization Schedule

#  Background:
#    Given an Amortization Calculator

#  @amort_test
#  Scenario: Calculates the Starting Balance Accurately
#    Then the Initial Starting Balance should be $11730.47

#  @amort_test
#  Scenario: Calculates a Rent Charge Accurately
#    Given an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the rent charge for period 1 should be $242.67

#  @amort_test
#  Scenario: Calculates Depreciation Accurately
#    Given we are at the monthly period 1
#    And an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the depreciation should be $66.71

#  @amort_test
#  Scenario: Receives a Pretax Payment Correctly
#    Given we are at the monthly period 1
#    And an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the pre-tax payment should be $309.38

#  @amort_test
#  Scenario: Calculates an Account Balance Accurately
#    Given we are at the monthly period 1
#    And an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the account balance should be $11663.76

#  @amort_test
#  Scenario: Calculates Total Rent Charge Accurately
#    Given an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the Total Rent Charge should be $10771.10

#  @amort_test
#  Scenario: Calculates Total Depreciation Accurately
#    Given an amortization term of 60
#    And an amortization annual yield of 26.0%
#    Then the Total Depreciation should be $7791.70

#  Scenario Outline: Calculates Amortization Schedule
#    Given we are at the monthly period <period>
#    And an amortization term of <term>
#    And an amortization annual yield of <annual_yield>%
#    Then the rent charge should be $<expected_rent_charge>
#    And the depreciation should be $<expected_depreciation>
#    And the pre-tax payment should be $<expected_pre_tax_payment>
#    And the account balance should be $<expected_account_balance>

#    Examples:
#      | period | term | annual_yield | expected_rent_charge | expected_depreciation | expected_pre_tax_payment | expected_account_balance |
#      | 1      | 60   | 26.0         | 242.67               | 66.71                 | 309.38                   | 11663.76                 |
#      | 2      | 60   | 26.0         | 241.29               | 68.09                 | 309.38                   | 11595.67                 |
#      | 3      | 60   | 26.0         | 239.88               | 69.50                 | 309.38                   | 11526.17                 |
#      | 10     | 60   | 26.0         | 229.17               | 80.21                 | 309.38                   | 10997.73                 |
#      | 20     | 60   | 26.0         | 210.95               | 98.43                 | 309.38                   | 10098.51                 |
#      | 30     | 60   | 26.0         | 188.58               | 120.80                | 309.38                   | 8994.95                  |
#      | 40     | 60   | 26.0         | 161.13               | 148.25                | 309.38                   | 7640.62                  |
#      | 55     | 60   | 26.0         | 107.83               | 201.55                | 309.38                   | 5010.81                  |
#      | 59     | 60   | 26.0         | 90.63                | 218.75                | 309.38                   | 4162.05                  |
#      | 60     | 60   | 26.0         | 86.10                | 4167.53               | 4253.63                  | 0.00                     |

# 2013 FLSTC Softail
#   Total Rent Charge   $10,771.10
#   Total Depreciation    $7,791.70

#   Rent Charge $10,771.10 
# Depreciation  $7,791.70 
# Residual Value  $3,944.25 

# Month Rent  Depreciation  Pre-Tax Pmt Payoff**
# May-18  $242.67   $66.71  $309.38   $11,663.76
# Mar-18  $241.29   $68.09  $309.38   $11,595.67
# Apr-18  $239.88   $69.50  $309.38   $11,526.17
# May-18  $238.45   $70.93  $309.38   $11,455.24
# Jun-18  $236.98   $72.40  $309.38   $11,382.84
# Jul-18  $235.48   $73.90  $309.38   $11,308.94
# Aug-18  $233.95   $75.43  $309.38   $11,233.51
# Sep-18  $232.39   $76.99  $309.38   $11,156.52
# Oct-18  $230.80   $78.58  $309.38   $11,077.94
# Nov-18  $229.17   $80.21  $309.38   $10,997.73
# Dec-18  $227.52   $81.86  $309.38   $10,915.87
# Jan-19  $225.82   $83.56  $309.38   $10,832.31
# Feb-19  $224.09   $85.29  $309.38   $10,747.02
# Mar-19  $222.33   $87.05  $309.38   $10,659.97
# Apr-19  $220.53   $88.85  $309.38   $10,571.12
# May-19  $218.69   $90.69  $309.38   $10,480.43
# Jun-19  $216.81   $92.57  $309.38   $10,387.86
# Jul-19  $214.90   $94.48  $309.38   $10,293.38
# Aug-19  $212.94   $96.44  $309.38   $10,196.94
# Sep-19  $210.95   $98.43  $309.38   $10,098.51
# Oct-19  $208.91   $100.47   $309.38   $9,998.04
# Nov-19  $206.83   $102.55   $309.38   $9,895.49
# Dec-19  $204.71   $104.67   $309.38   $9,790.82
# Jan-20  $202.55   $106.83   $309.38   $9,683.99
# Feb-20  $200.34   $109.04   $309.38   $9,574.95
# Mar-20  $198.08   $111.30   $309.38   $9,463.65
# Apr-20  $195.78   $113.60   $309.38   $9,350.05
# May-20  $193.43   $115.95   $309.38   $9,234.10
# Jun-20  $191.03   $118.35   $309.38   $9,115.75
# Jul-20  $188.58   $120.80   $309.38   $8,994.95
# Aug-20  $186.08   $123.30   $309.38   $8,871.65
# Sep-20  $183.53   $125.85   $309.38   $8,745.80
# Oct-20  $180.93   $128.45   $309.38   $8,617.35
# Nov-20  $178.27   $131.11   $309.38   $8,486.24
# Dec-20  $175.56   $133.82   $309.38   $8,352.42
# Jan-21  $172.79   $136.59   $309.38   $8,215.83
# Feb-21  $169.96   $139.42   $309.38   $8,076.41
# Mar-21  $167.08   $142.30   $309.38   $7,934.11
# Apr-21  $164.14   $145.24   $309.38   $7,788.87
# May-21  $161.13   $148.25   $309.38   $7,640.62
# Jun-21  $158.06   $151.32   $309.38   $7,489.30
# Jul-21  $154.93   $154.45   $309.38   $7,334.85
# Aug-21  $151.74   $157.64   $309.38   $7,177.21
# Sep-21  $148.48   $160.90   $309.38   $7,016.31
# Oct-21  $145.15   $164.23   $309.38   $6,852.08
# Nov-21  $141.75   $167.63   $309.38   $6,684.45
# Dec-21  $138.28   $171.10   $309.38   $6,513.35
# Jan-22  $134.74   $174.64   $309.38   $6,338.71
# Feb-22  $131.13   $178.25   $309.38   $6,160.46
# Mar-22  $127.44   $181.94   $309.38   $5,978.52
# Apr-22  $123.68   $185.70   $309.38   $5,792.82
# May-22  $119.84   $189.54   $309.38   $5,603.28
# Jun-22  $115.92   $193.46   $309.38   $5,409.82
# Jul-22  $111.92   $197.46   $309.38   $5,212.36
# Aug-22  $107.83   $201.55   $309.38   $5,010.81
# Sep-22  $103.66   $205.72   $309.38   $4,805.09
# Oct-22  $99.41  $209.97   $309.38   $4,595.12
# Nov-22  $95.06  $214.32   $309.38   $4,380.80
# Dec-22  $90.63  $218.75   $309.38   $4,162.05
# Jan-23  $86.10  $4,167.53 $4,253.63 $0/nil