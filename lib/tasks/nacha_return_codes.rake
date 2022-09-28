namespace :nacha_return_codes do
  desc 'Seed'
  task seed: :environment do
    if NachaReturnCode.all.empty?
      nacha_return_code_seed_val.each do |nacha|
        NachaReturnCode.create(nacha)
      end
    end
  end

  def nacha_return_code_seed_val
    [
      { code: 'R01', 	description: 'Insufficient Funds'},
      { code: 'R02', 	description: 'Account Closed'},
      { code: 'R03', 	description: 'No Account/Unable to Locate Account'},
      { code: 'R04', 	description: 'Invalid Account Number'},
      { code: 'R05', 	description: 'Unauthorized Debit Entry'},
      { code: 'R06', 	description: 'Returned per ODFI’s Request'},
      { code: 'R07', 	description: 'Authorization Revoked by Customer (adjustment entries)'},
      { code: 'R08', 	description: 'Payment Stopped or Stop Payment on Item'},
      { code: 'R09', 	description: 'Uncollected Funds'},
      { code: 'R10', 	description: 'Customer Advises Not Authorized; Item Is Ineligible, Notice Not Provided, Signatures Not Genuine, or Item Altered (adjustment entries)'},
      { code: 'R11', 	description: 'Check Truncation Entry Return'},
      { code: 'R12', 	description: 'Branch Sold to Another DFI'},
      { code: 'R13', 	description: 'RDFI not qualified to participate'},
      { code: 'R14', 	description: 'Representative Payee Deceased or Unable to Continue in that Capacity'},
      { code: 'R15', 	description: 'Beneficiary or Account Holder (Other Than a Representative Payee) Deceased'},
      { code: 'R16', 	description: 'Account Frozen'},
      { code: 'R17', 	description: 'File Record Edit Criteria (Specify)'},
      { code: 'R20', 	description: 'Non-Transaction Account'},
      { code: 'R21', 	description: 'Invalid Company Identification'},
      { code: 'R22', 	description: 'Invalid Individual ID Number'},
      { code: 'R23', 	description: 'Credit Entry Refused by Receiver'},
      { code: 'R24', 	description: 'Duplicate Entry'},
      { code: 'R29', 	description: 'Corporate Customer Advises Not Authorized'},
      { code: 'R31', 	description: 'Permissible Return Entry (CCD and CTX only)'},
      { code: 'R33', 	description: 'Return of XCK Entry'},
      { code: 'R34', 	description: 'Limited Participation D.F.I.'},
      { code: 'R35', 	description: 'Return of Improper Debit Entry'},
      { code: 'R36', 	description: 'Return of Improper Credit Entry'},
      { code: 'R37', 	description: 'Source Document Presented for Payment (adjustment entries) (A.R.C.)'},
      { code: 'R38', 	description: 'Stop Payment on Source Document (adjustment entries)'},
      { code: 'R39', 	description: 'Improper Source Document'},
      { code: 'R40', 	description: 'Non Participant in E.N.R. Program'},
      { code: 'R41', 	description: 'Invalid Transaction Code (E.N.R. only)'},
      { code: 'R42', 	description: 'Routing Number/Check Digit Error'},
      { code: 'R43', 	description: 'Invalid D.F.I. Account Number'},
      { code: 'R44', 	description: 'Invalid Individual I.D. Number'},
      { code: 'R45', 	description: 'Invalid Individual Name'},
      { code: 'R46', 	description: 'Invalid Representative Payee Indicator'},
      { code: 'R47', 	description: 'Duplicate Enrollment'},
      { code: 'R50', 	description: 'State Law Prohibits Truncated Checks'},
      { code: 'R51', 	description: 'Notice not Provided/Signature not Authentic/Item Altered/Ineligible for Conversion'},
      { code: 'R52', 	description: 'Stop Pay on Item'},
      { code: 'R53', 	description: 'Item and A.C.H. Entry Presented for Payment'},
      { code: 'R61', 	description: 'Misrouted Return'},
      { code: 'R67', 	description: 'Duplicate Return'},
      { code: 'R68', 	description: 'Untimely Return'},
      { code: 'R69', 	description: 'Field Errors'},
      { code: 'R70', 	description: 'Permissible Return Entry Not Accepted'},
      { code: 'R71', 	description: 'Misrouted Dishonor Return'},
      { code: 'R72', 	description: 'Untimely Dishonored Return'},
      { code: 'R73', 	description: 'Timely Original Return'},
      { code: 'R74', 	description: 'Corrected Return'},
      { code: 'R75', 	description: 'Original Return not a Duplicate'},
      { code: 'R76', 	description: 'No Errors Found'},
      { code: 'R80', 	description: 'Cross-Border Payment Coding Error'},
      { code: 'R81', 	description: 'Non-Participant in Cross-Border Program'},
      { code: 'R82', 	description: 'Invalid Foreign Receiving D.F.I. Identification'},
      { code: 'R83', 	description: 'Foreign Receiving D.F.I. Unable to Settle'},
      { code: 'R84', 	description: 'Entry Not Processed by O.G.O.'}
    ]
  end
end

